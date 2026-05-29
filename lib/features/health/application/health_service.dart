import 'package:health/health.dart';

/// Lightweight summary of today's health data.
class HealthSummary {
  const HealthSummary({
    required this.steps,
    required this.activeKcal,
    this.heartRate,
    required this.sleepMinutes,
  });

  final int steps;
  final int activeKcal;
  final int? heartRate;
  final int sleepMinutes;

  static const zero = HealthSummary(steps: 0, activeKcal: 0, sleepMinutes: 0);
}

/// Singleton service wrapping the `health` plugin (^13.3).
///
/// All public methods are defensive — they never throw; callers can safely
/// `await` without a try/catch.
class HealthService {
  HealthService._();

  static final HealthService instance = HealthService._();

  final Health _health = Health();

  /// Data types we request READ access to.
  static const List<HealthDataType> _types = [
    HealthDataType.STEPS,
    HealthDataType.HEART_RATE,
    HealthDataType.ACTIVE_ENERGY_BURNED,
    HealthDataType.SLEEP_ASLEEP,
  ];

  static const List<HealthDataAccess> _permissions = [
    HealthDataAccess.READ,
    HealthDataAccess.READ,
    HealthDataAccess.READ,
    HealthDataAccess.READ,
  ];

  bool _authorized = false;
  bool get isAuthorized => _authorized;

  /// Returns whether health data is available on this platform.
  /// (Configuring the plugin succeeds on supported platforms.)
  Future<bool> isAvailable() async {
    try {
      await _health.configure();
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Configures the Health plugin and requests READ permissions.
  ///
  /// Returns `true` if authorization was granted, `false` otherwise.
  Future<bool> requestAuthorization() async {
    try {
      await _health.configure();
      final granted = await _health.requestAuthorization(
        _types,
        permissions: _permissions,
      );
      _authorized = granted;
      return granted;
    } catch (_) {
      _authorized = false;
      return false;
    }
  }

  /// Fetches today's health totals.
  ///
  /// Returns [HealthSummary.zero] on any error or if data is unavailable.
  Future<HealthSummary> today() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);

    int steps = 0;
    int activeKcal = 0;
    int? heartRate;
    int sleepMinutes = 0;

    // Steps ─────────────────────────────────────────────────────────────────
    try {
      final s = await _health.getTotalStepsInInterval(startOfDay, now);
      steps = s ?? 0;
    } catch (_) {
      steps = 0;
    }

    // Active energy ─────────────────────────────────────────────────────────
    try {
      final energyData = await _health.getHealthDataFromTypes(
        startTime: startOfDay,
        endTime: now,
        types: [HealthDataType.ACTIVE_ENERGY_BURNED],
      );
      double totalKcal = 0;
      for (final point in energyData) {
        final v = point.value;
        if (v is NumericHealthValue) {
          totalKcal += v.numericValue.toDouble();
        }
      }
      activeKcal = totalKcal.round();
    } catch (_) {
      activeKcal = 0;
    }

    // Heart rate (latest reading) ────────────────────────────────────────────
    try {
      final hrData = await _health.getHealthDataFromTypes(
        startTime: startOfDay,
        endTime: now,
        types: [HealthDataType.HEART_RATE],
      );
      if (hrData.isNotEmpty) {
        // Sort descending by date, take latest
        hrData.sort((a, b) => b.dateTo.compareTo(a.dateTo));
        final v = hrData.first.value;
        if (v is NumericHealthValue) {
          heartRate = v.numericValue.toInt();
        }
      }
    } catch (_) {
      heartRate = null;
    }

    // Sleep (minutes asleep since midnight, or previous night window) ────────
    try {
      // Use a wider window to capture overnight sleep ending this morning.
      final sleepStart = startOfDay.subtract(const Duration(hours: 12));
      final sleepData = await _health.getHealthDataFromTypes(
        startTime: sleepStart,
        endTime: now,
        types: [HealthDataType.SLEEP_ASLEEP],
      );
      int totalMs = 0;
      for (final point in sleepData) {
        totalMs += point.dateTo.difference(point.dateFrom).inMilliseconds;
      }
      sleepMinutes = (totalMs / 60000).round();
    } catch (_) {
      sleepMinutes = 0;
    }

    return HealthSummary(
      steps: steps,
      activeKcal: activeKcal,
      heartRate: heartRate,
      sleepMinutes: sleepMinutes,
    );
  }
}
