import 'dart:convert';

enum UserRole { user, admin }

/// An authenticated account. Role drives access to the admin panel.
class AppUser {
  const AppUser({
    required this.id,
    required this.email,
    required this.name,
    this.role = UserRole.user,
    this.enabled = true,
  });

  final String id;
  final String email;
  final String name;
  final UserRole role;
  final bool enabled;

  bool get isAdmin => role == UserRole.admin;

  AppUser copyWith({String? name, UserRole? role, bool? enabled}) => AppUser(
        id: id,
        email: email,
        name: name ?? this.name,
        role: role ?? this.role,
        enabled: enabled ?? this.enabled,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'email': email,
        'name': name,
        'role': role.name,
        'enabled': enabled,
      };

  factory AppUser.fromMap(Map<String, dynamic> m) => AppUser(
        id: m['id'],
        email: m['email'],
        name: m['name'] ?? '',
        role: UserRole.values.byName(m['role'] ?? 'user'),
        enabled: m['enabled'] ?? true,
      );

  String toJson() => jsonEncode(toMap());
  factory AppUser.fromJson(String s) =>
      AppUser.fromMap(jsonDecode(s) as Map<String, dynamic>);
}
