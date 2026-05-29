import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/fit_card.dart';
import '../../../core/widgets/primary_button.dart';
import '../../onboarding/application/profile_controller.dart';
import '../application/weight_log_controller.dart';

class ProgressScreen extends ConsumerStatefulWidget {
  const ProgressScreen({super.key});

  @override
  ConsumerState<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends ConsumerState<ProgressScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final p = ref.read(profileProvider);
      ref
          .read(weightLogProvider.notifier)
          .seedIfEmpty(p.currentWeightKg ?? 70);
    });
  }

  @override
  Widget build(BuildContext context) {
    final entries = ref.watch(weightLogProvider);
    final log = ref.read(weightLogProvider.notifier);
    final profile = ref.watch(profileProvider);
    final target = profile.targetWeightKg ?? 0;
    final current = log.latest ?? profile.currentWeightKg ?? 0;
    final left = (current - target).abs();

    return Scaffold(
      appBar: AppBar(title: const Text('Progress')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
            Insets.screenH, Insets.sm, Insets.screenH, Insets.huge),
        children: [
          FitCard(
            color: AppColors.blue,
            padding: const EdgeInsets.all(Insets.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Weight trend',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: Colors.white)),
                    if (entries.length > 1)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Insets.sm, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(Radii.pill),
                        ),
                        child: Text(
                          '${log.change >= 0 ? '+' : ''}${log.change.toStringAsFixed(1)} kg',
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: Insets.lg),
                SizedBox(height: 180, child: _Chart(entries: entries)),
              ],
            ),
          ),
          const SizedBox(height: Insets.lg),
          FitCard(
            child: Row(
              children: [
                _Stat(label: 'Current', value: current, unit: 'kg'),
                _divider(context),
                _Stat(label: 'Target', value: target, unit: 'kg'),
                _divider(context),
                _Stat(label: 'Left', value: left, unit: 'kg'),
              ],
            ),
          ),
          const SizedBox(height: Insets.xl),
          PrimaryButton(
            label: 'Add weight',
            icon: Icons.add_rounded,
            gradient: AppGradients.progress,
            glowColor: AppColors.blue,
            onPressed: () => _addWeightDialog(context, current),
          ),
        ],
      ),
    );
  }

  Widget _divider(BuildContext c) =>
      Container(width: 1, height: 36, color: c.fit.border);

  Future<void> _addWeightDialog(BuildContext context, double current) async {
    var value = current;
    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setLocal) => AlertDialog(
          title: const Text('Log weight'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${value.toStringAsFixed(1)} kg',
                  style: Theme.of(context).textTheme.displaySmall),
              Slider(
                value: value.clamp(35, 200),
                min: 35,
                max: 200,
                activeColor: AppColors.blue,
                onChanged: (v) => setLocal(() => value = v),
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel')),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: AppColors.blue),
              onPressed: () {
                ref.read(weightLogProvider.notifier).add(value);
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Chart extends StatelessWidget {
  const _Chart({required this.entries});
  final List<WeightEntry> entries;

  @override
  Widget build(BuildContext context) {
    if (entries.length < 2) {
      return Center(
        child: Text('Add another entry to see your trend',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.85))),
      );
    }
    final spots = [
      for (final e in entries) FlSpot(e.index.toDouble(), e.kg),
    ];
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineTouchData: const LineTouchData(enabled: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Colors.white,
            barWidth: 4,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.white.withValues(alpha: 0.18),
            ),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value, required this.unit});
  final String label;
  final double value;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(label, style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 2),
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.titleLarge,
              children: [
                TextSpan(text: value.toStringAsFixed(value % 1 == 0 ? 0 : 1)),
                TextSpan(
                    text: ' $unit',
                    style: Theme.of(context).textTheme.labelMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
