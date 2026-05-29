import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/fit_card.dart';
import '../application/ai_config_controller.dart';
import '../domain/ai_provider_config.dart';

/// Admin panel: configure AI providers (multiple vendors / keys) and route
/// each task to a chosen provider. This is the "dynamic AI settings" surface.
class AiSettingsScreen extends ConsumerWidget {
  const AiSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(aiConfigProvider);
    final ctrl = ref.read(aiConfigProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('AI Settings')),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.pink,
        foregroundColor: Colors.white,
        onPressed: () => _addProviderSheet(context, ctrl),
        icon: const Icon(Icons.add),
        label: const Text('Add provider'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
            Insets.screenH, Insets.lg, Insets.screenH, 96),
        children: [
          Text('Providers', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: Insets.xs),
          Text('Add any number of AI providers. Each task below can use a '
              'different one.',
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: Insets.md),
          if (config.providers.isEmpty)
            FitCard(
              child: Column(
                children: [
                  const Icon(Icons.smart_toy_outlined,
                      size: 36, color: AppColors.pink),
                  const SizedBox(height: Insets.sm),
                  Text('No providers yet',
                      style: Theme.of(context).textTheme.titleMedium),
                  Text('Tap “Add provider” to connect Claude, OpenAI, Gemini…',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
          for (final p in config.providers)
            _ProviderCard(provider: p, ctrl: ctrl),

          if (config.providers.isNotEmpty) ...[
            const SizedBox(height: Insets.xl),
            Text('Task routing',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: Insets.xs),
            Text('Choose which provider handles each AI feature.',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: Insets.md),
            for (final task in AiTask.values)
              _TaskBindingCard(task: task, config: config, ctrl: ctrl),
          ],
        ],
      ),
    );
  }

  void _addProviderSheet(BuildContext context, AiConfigController ctrl) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(Insets.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Choose a vendor',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: Insets.md),
            for (final v in AiVendor.values)
              ListTile(
                leading: const Icon(Icons.bolt_rounded, color: AppColors.pink),
                title: Text(v.label),
                subtitle: Text(v.supportsVision
                    ? 'Supports vision'
                    : 'Text only'),
                onTap: () {
                  ctrl.addProvider(v);
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _ProviderCard extends StatelessWidget {
  const _ProviderCard({required this.provider, required this.ctrl});
  final AiProvider provider;
  final AiConfigController ctrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Insets.md),
      child: FitCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: (provider.isConfigured
                            ? AppColors.success
                            : AppColors.warning)
                        .withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(Radii.sm),
                  ),
                  child: Icon(
                    provider.isConfigured
                        ? Icons.check_circle_rounded
                        : Icons.warning_rounded,
                    color: provider.isConfigured
                        ? AppColors.success
                        : AppColors.warning,
                    size: 20,
                  ),
                ),
                const SizedBox(width: Insets.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(provider.name,
                          style: Theme.of(context).textTheme.titleMedium),
                      Text(provider.vendor.label,
                          style: Theme.of(context).textTheme.labelMedium),
                    ],
                  ),
                ),
                Switch(
                  value: provider.enabled,
                  activeThumbColor: AppColors.pink,
                  onChanged: (v) =>
                      ctrl.updateProvider(provider.copyWith(enabled: v)),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded,
                      color: AppColors.danger),
                  onPressed: () => ctrl.removeProvider(provider.id),
                ),
              ],
            ),
            const SizedBox(height: Insets.sm),
            _field(context, 'API key', provider.apiKey, obscure: true,
                (v) => ctrl.updateProvider(provider.copyWith(apiKey: v))),
            const SizedBox(height: Insets.sm),
            _field(context, 'Model', provider.model,
                (v) => ctrl.updateProvider(provider.copyWith(model: v))),
            const SizedBox(height: Insets.sm),
            _field(context, 'Base URL', provider.baseUrl,
                (v) => ctrl.updateProvider(provider.copyWith(baseUrl: v))),
          ],
        ),
      ),
    );
  }

  Widget _field(BuildContext context, String label, String value,
      ValueChanged<String> onChanged,
      {bool obscure = false}) {
    return TextFormField(
      initialValue: value,
      obscureText: obscure,
      onChanged: onChanged,
      style: Theme.of(context).textTheme.bodyMedium,
      decoration: InputDecoration(
        labelText: label,
        isDense: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Radii.sm),
        ),
      ),
    );
  }
}

class _TaskBindingCard extends StatelessWidget {
  const _TaskBindingCard(
      {required this.task, required this.config, required this.ctrl});
  final AiTask task;
  final AiConfig config;
  final AiConfigController ctrl;

  @override
  Widget build(BuildContext context) {
    // Vision tasks can only bind to vision-capable, enabled providers.
    final eligible = config.providers.where((p) =>
        p.enabled && (!task.requiresVision || p.vendor.supportsVision));
    final current = config.taskBindings[task];

    return Padding(
      padding: const EdgeInsets.only(bottom: Insets.md),
      child: FitCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(task.label,
                      style: Theme.of(context).textTheme.titleMedium),
                ),
                if (task.requiresVision)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Insets.sm, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.blueTint,
                      borderRadius: BorderRadius.circular(Radii.pill),
                    ),
                    child: const Text('vision',
                        style: TextStyle(
                            fontSize: 11,
                            color: AppColors.blueDark,
                            fontWeight: FontWeight.w700)),
                  ),
              ],
            ),
            Text(task.description,
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: Insets.sm),
            DropdownButtonFormField<String?>(
              initialValue:
                  eligible.any((p) => p.id == current) ? current : null,
              isExpanded: true,
              decoration: InputDecoration(
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Radii.sm),
                ),
              ),
              hint: const Text('Not configured'),
              items: [
                const DropdownMenuItem(value: null, child: Text('— None —')),
                for (final p in eligible)
                  DropdownMenuItem(
                      value: p.id, child: Text('${p.name} · ${p.model}')),
              ],
              onChanged: (v) => ctrl.bindTask(task, v),
            ),
          ],
        ),
      ),
    );
  }
}
