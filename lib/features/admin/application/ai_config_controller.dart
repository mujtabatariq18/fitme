import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/local_store.dart';
import '../domain/ai_provider_config.dart';

/// Drives the admin "AI Settings" panel: CRUD over providers and the
/// task→provider routing table. Persisted locally for now (production keeps
/// secrets server-side; see [AiProvider.toMap] note).
class AiConfigController extends Notifier<AiConfig> {
  late final LocalStore _store;
  int _seq = 0;

  @override
  AiConfig build() {
    _store = ref.read(localStoreProvider);
    final raw = _store.getAiConfig();
    if (raw != null) {
      try {
        return AiConfig.fromJson(raw);
      } catch (_) {}
    }
    return const AiConfig();
  }

  void _set(AiConfig next) {
    state = next;
    _store.setAiConfig(next.toJson());
  }

  String _newId() {
    // Deterministic, monotonic id (Date.now is unavailable in some contexts;
    // a sequence + provider count is unique within a config).
    _seq++;
    return 'prov_${state.providers.length}_$_seq';
  }

  void addProvider(AiVendor vendor, {String? name}) {
    final provider = AiProvider(
      id: _newId(),
      name: name ?? vendor.label,
      vendor: vendor,
    );
    _set(state.copyWith(providers: [...state.providers, provider]));
  }

  void updateProvider(AiProvider updated) {
    _set(state.copyWith(
      providers: [
        for (final p in state.providers)
          if (p.id == updated.id) updated else p
      ],
    ));
  }

  void removeProvider(String id) {
    final bindings = Map<AiTask, String>.from(state.taskBindings)
      ..removeWhere((_, v) => v == id);
    _set(state.copyWith(
      providers: state.providers.where((p) => p.id != id).toList(),
      taskBindings: bindings,
    ));
  }

  void bindTask(AiTask task, String? providerId) {
    final bindings = Map<AiTask, String>.from(state.taskBindings);
    if (providerId == null) {
      bindings.remove(task);
    } else {
      bindings[task] = providerId;
    }
    _set(state.copyWith(taskBindings: bindings));
  }
}

final aiConfigProvider =
    NotifierProvider<AiConfigController, AiConfig>(AiConfigController.new);
