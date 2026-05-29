import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/local_store.dart';

class WeightEntry {
  const WeightEntry({required this.index, required this.kg, this.label});
  final int index; // ordered position
  final double kg;
  final String? label; // e.g. "Week 1"

  Map<String, dynamic> toMap() => {'index': index, 'kg': kg, 'label': label};
  factory WeightEntry.fromMap(Map<String, dynamic> m) => WeightEntry(
        index: m['index'],
        kg: (m['kg'] as num).toDouble(),
        label: m['label'],
      );
}

/// Persisted weight history powering the progress chart.
class WeightLogController extends Notifier<List<WeightEntry>> {
  late final LocalStore _store;

  @override
  List<WeightEntry> build() {
    _store = ref.read(localStoreProvider);
    final raw = _store.getWeightLog();
    if (raw == null) return [];
    try {
      return (jsonDecode(raw) as List)
          .map((e) => WeightEntry.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  void _persist() =>
      _store.setWeightLog(jsonEncode(state.map((e) => e.toMap()).toList()));

  /// Ensure there's at least a starting point (called with the onboarding weight).
  void seedIfEmpty(double startKg) {
    if (state.isEmpty) {
      state = [WeightEntry(index: 0, kg: startKg, label: 'Start')];
      _persist();
    }
  }

  void add(double kg) {
    final next = state.length;
    state = [
      ...state,
      WeightEntry(index: next, kg: kg, label: 'Entry ${next + 1}'),
    ];
    _persist();
  }

  double? get latest => state.isEmpty ? null : state.last.kg;
  double? get start => state.isEmpty ? null : state.first.kg;
  double get change => (latest ?? 0) - (start ?? 0);
}

final weightLogProvider =
    NotifierProvider<WeightLogController, List<WeightEntry>>(
        WeightLogController.new);
