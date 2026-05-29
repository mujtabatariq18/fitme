import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/local_store.dart';
import '../domain/app_user.dart';

class AuthState {
  const AuthState({
    this.user,
    this.accounts = const [],
    this.loading = false,
    this.error,
  });

  final AppUser? user;
  final List<AppUser> accounts;
  final bool loading;
  final String? error;

  bool get isAuthenticated => user != null;
  bool get isAdmin => user?.isAdmin ?? false;

  AuthState copyWith({
    AppUser? user,
    bool clearUser = false,
    List<AppUser>? accounts,
    bool? loading,
    String? error,
    bool clearError = false,
  }) =>
      AuthState(
        user: clearUser ? null : (user ?? this.user),
        accounts: accounts ?? this.accounts,
        loading: loading ?? this.loading,
        error: clearError ? null : (error ?? this.error),
      );
}

/// Local credential-backed auth. Swappable for Supabase later — the UI only
/// depends on this controller's surface. Passwords are kept on-device for the
/// local/offline build only; production auth lives in Supabase.
class AuthController extends Notifier<AuthState> {
  late final LocalStore _store;
  final Map<String, String> _passwords = {}; // email -> password

  // Seed accounts created on first run.
  static const _seed = [
    ({'id': 'admin', 'email': 'admin@fitme.app', 'name': 'Coach Admin', 'role': 'admin', 'password': 'admin123'}),
    ({'id': 'demo', 'email': 'demo@fitme.app', 'name': 'Demo User', 'role': 'user', 'password': 'demo123'}),
  ];

  @override
  AuthState build() {
    _store = ref.read(localStoreProvider);
    final accounts = _loadAccounts();
    final sessionId = _store.getSession();
    AppUser? current;
    for (final a in accounts) {
      if (a.id == sessionId) current = a;
    }
    return AuthState(user: current, accounts: accounts);
  }

  List<AppUser> _loadAccounts() {
    final raw = _store.getAccounts();
    if (raw == null) {
      // Seed.
      final accounts = <AppUser>[];
      for (final s in _seed) {
        _passwords[s['email']!] = s['password']!;
        accounts.add(AppUser(
          id: s['id']!,
          email: s['email']!,
          name: s['name']!,
          role: UserRole.values.byName(s['role']!),
        ));
      }
      _persist(accounts);
      return accounts;
    }
    final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
    final accounts = <AppUser>[];
    for (final m in list) {
      _passwords[m['email']] = m['password'] ?? '';
      accounts.add(AppUser.fromMap(m));
    }
    return accounts;
  }

  void _persist(List<AppUser> accounts) {
    final list = accounts
        .map((a) => {...a.toMap(), 'password': _passwords[a.email] ?? ''})
        .toList();
    _store.setAccounts(jsonEncode(list));
  }

  String _norm(String e) => e.trim().toLowerCase();

  Future<bool> login(String email, String password) async {
    state = state.copyWith(loading: true, clearError: true);
    await Future.delayed(const Duration(milliseconds: 350)); // UX: feel real
    final e = _norm(email);
    AppUser? match;
    for (final a in state.accounts) {
      if (_norm(a.email) == e) match = a;
    }
    if (match == null || _passwords[match.email] != password) {
      state = state.copyWith(loading: false, error: 'Invalid email or password');
      return false;
    }
    if (!match.enabled) {
      state = state.copyWith(loading: false, error: 'This account is disabled');
      return false;
    }
    _store.setSession(match.id);
    state = state.copyWith(user: match, loading: false, clearError: true);
    return true;
  }

  Future<bool> signUp(String name, String email, String password) async {
    state = state.copyWith(loading: true, clearError: true);
    await Future.delayed(const Duration(milliseconds: 350));
    final e = _norm(email);
    if (state.accounts.any((a) => _norm(a.email) == e)) {
      state = state.copyWith(loading: false, error: 'Email already registered');
      return false;
    }
    final user = AppUser(
      id: 'u${state.accounts.length}_${e.hashCode.toUnsigned(20)}',
      email: email.trim(),
      name: name.trim(),
    );
    _passwords[user.email] = password;
    final accounts = [...state.accounts, user];
    _persist(accounts);
    _store.setSession(user.id);
    state = state.copyWith(user: user, accounts: accounts, loading: false);
    return true;
  }

  void logout() {
    _store.clearSession();
    state = state.copyWith(clearUser: true);
  }

  // ── Admin: account management ────────────────────────────────────────────
  void setRole(String id, UserRole role) =>
      _mutate(id, (a) => a.copyWith(role: role));
  void setEnabled(String id, bool enabled) =>
      _mutate(id, (a) => a.copyWith(enabled: enabled));

  void _mutate(String id, AppUser Function(AppUser) fn) {
    final accounts = state.accounts.map((a) => a.id == id ? fn(a) : a).toList();
    _persist(accounts);
    // Keep current session user in sync if it changed.
    final cur = state.user;
    final updated = cur == null
        ? null
        : accounts.firstWhere((a) => a.id == cur.id, orElse: () => cur);
    state = state.copyWith(accounts: accounts, user: updated);
  }
}

final authProvider =
    NotifierProvider<AuthController, AuthState>(AuthController.new);
