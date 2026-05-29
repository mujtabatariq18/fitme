import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/fit_card.dart';
import '../application/health_service.dart';

enum _CardState { idle, loading, unavailable, connected }

class HealthCard extends StatefulWidget {
  const HealthCard({super.key});

  @override
  State<HealthCard> createState() => _HealthCardState();
}

class _HealthCardState extends State<HealthCard> {
  _CardState _state = _CardState.idle;
  HealthSummary? _summary;

  Future<void> _connect() async {
    setState(() => _state = _CardState.loading);

    final available = await HealthService.instance.isAvailable();
    if (!available) {
      if (mounted) setState(() => _state = _CardState.unavailable);
      return;
    }

    final granted = await HealthService.instance.requestAuthorization();
    if (!granted) {
      if (mounted) setState(() => _state = _CardState.idle);
      return;
    }

    final summary = await HealthService.instance.today();
    if (mounted) {
      setState(() {
        _summary = summary;
        _state = _CardState.connected;
      });
    }
  }

  Future<void> _refresh() async {
    if (_state == _CardState.loading) return;
    setState(() => _state = _CardState.loading);
    final summary = await HealthService.instance.today();
    if (mounted) {
      setState(() {
        _summary = summary;
        _state = _CardState.connected;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FitCard(
      padding: const EdgeInsets.all(Insets.lg),
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    switch (_state) {
      case _CardState.idle:
        return _ConnectPrompt(onTap: _connect);
      case _CardState.loading:
        return const _LoadingView();
      case _CardState.unavailable:
        return const _UnavailableView();
      case _CardState.connected:
        return _StatsView(
          summary: _summary ?? HealthSummary.zero,
          onRefresh: _refresh,
        );
    }
  }
}

// ── Connect prompt ────────────────────────────────────────────────────────────

class _ConnectPrompt extends StatelessWidget {
  const _ConnectPrompt({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fit = context.fit;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            const Icon(Icons.favorite_rounded, color: AppColors.pink, size: 20),
            const SizedBox(width: Insets.sm),
            Text(
              'Health Data',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
        const SizedBox(height: Insets.sm),
        Text(
          'Sync your steps, calories, heart rate and sleep.',
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: fit.textSecondary),
        ),
        const SizedBox(height: Insets.lg),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: onTap,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.pink,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Radii.pill),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: Insets.md,
                horizontal: Insets.lg,
              ),
            ),
            icon: const Icon(Icons.link_rounded, size: 18),
            label: const Text('Connect Apple Health / Google Fit'),
          ),
        ),
      ],
    );
  }
}

// ── Loading ───────────────────────────────────────────────────────────────────

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 80,
      child: Center(
        child: CircularProgressIndicator(
          color: AppColors.pink,
          strokeWidth: 2.5,
        ),
      ),
    );
  }
}

// ── Unavailable ───────────────────────────────────────────────────────────────

class _UnavailableView extends StatelessWidget {
  const _UnavailableView();

  @override
  Widget build(BuildContext context) {
    final fit = context.fit;
    return Row(
      children: [
        const Icon(Icons.health_and_safety_outlined,
            color: AppColors.ink300, size: 28),
        const SizedBox(width: Insets.md),
        Expanded(
          child: Text(
            'Health data is not available on this device.',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: fit.textSecondary),
          ),
        ),
      ],
    );
  }
}

// ── Stats view ────────────────────────────────────────────────────────────────

class _StatsView extends StatelessWidget {
  const _StatsView({required this.summary, required this.onRefresh});

  final HealthSummary summary;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            const Icon(Icons.favorite_rounded, color: AppColors.pink, size: 20),
            const SizedBox(width: Insets.sm),
            Text(
              'Today',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const Spacer(),
            GestureDetector(
              onTap: onRefresh,
              child: const Icon(
                Icons.refresh_rounded,
                size: 18,
                color: AppColors.ink300,
              ),
            ),
          ],
        ),
        const SizedBox(height: Insets.lg),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _StatChip(
              icon: Icons.directions_walk_rounded,
              iconColor: AppColors.blue,
              label: 'Steps',
              value: _formatSteps(summary.steps),
            ),
            _StatChip(
              icon: Icons.local_fire_department_rounded,
              iconColor: AppColors.calories,
              label: 'Active',
              value: '${summary.activeKcal} kcal',
            ),
            _StatChip(
              icon: Icons.monitor_heart_rounded,
              iconColor: AppColors.danger,
              label: 'HR',
              value: summary.heartRate != null
                  ? '${summary.heartRate} bpm'
                  : '--',
            ),
            _StatChip(
              icon: Icons.bedtime_rounded,
              iconColor: AppColors.sleep,
              label: 'Sleep',
              value: _formatSleep(summary.sleepMinutes),
            ),
          ],
        ),
      ],
    );
  }

  static String _formatSteps(int steps) {
    if (steps >= 1000) {
      return '${(steps / 1000).toStringAsFixed(1)}k';
    }
    return '$steps';
  }

  static String _formatSleep(int minutes) {
    if (minutes == 0) return '--';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    if (h == 0) return '${m}m';
    return '${h}h ${m}m';
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final fit = context.fit;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(height: Insets.xs),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .labelSmall
              ?.copyWith(color: fit.textSecondary),
        ),
      ],
    );
  }
}
