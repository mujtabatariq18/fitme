import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../application/notification_service.dart';

// Unique notification IDs
const int _kIdBreakfast = 100;
const int _kIdLunch = 101;
const int _kIdDinner = 102;
const int _kIdWorkout = 103;
const int _kIdWater = 104;

// SharedPreferences keys
const String _kKeyBreakfast = 'reminder_breakfast';
const String _kKeyLunch = 'reminder_lunch';
const String _kKeyDinner = 'reminder_dinner';
const String _kKeyWorkout = 'reminder_workout';
const String _kKeyWater = 'reminder_water';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  bool _breakfast = false;
  bool _lunch = false;
  bool _dinner = false;
  bool _workout = false;
  bool _water = false;

  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _prefs = prefs;
      _breakfast = prefs.getBool(_kKeyBreakfast) ?? false;
      _lunch = prefs.getBool(_kKeyLunch) ?? false;
      _dinner = prefs.getBool(_kKeyDinner) ?? false;
      _workout = prefs.getBool(_kKeyWorkout) ?? false;
      _water = prefs.getBool(_kKeyWater) ?? false;
    });
  }

  Future<void> _toggle({
    required String key,
    required bool enabled,
    required int id,
    required int hour,
    required int minute,
    required String title,
    required String body,
    required void Function(bool) onSet,
  }) async {
    await _prefs?.setBool(key, enabled);
    if (enabled) {
      await NotificationService.instance.scheduleDaily(
        id: id,
        hour: hour,
        minute: minute,
        title: title,
        body: body,
      );
    } else {
      await NotificationService.instance.cancel(id);
    }
    if (mounted) setState(() => onSet(enabled));
  }

  Future<void> _requestPermissions() async {
    final granted =
        await NotificationService.instance.requestPermissions();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          granted
              ? 'Notifications enabled!'
              : 'Permission denied. Please enable notifications in Settings.',
        ),
        backgroundColor: granted ? AppColors.success : AppColors.danger,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminders'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: Insets.screenH,
          vertical: Insets.lg,
        ),
        children: [
          // Enable notifications button
          FilledButton(
            onPressed: _requestPermissions,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.pink,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Radii.md),
              ),
              padding: const EdgeInsets.symmetric(vertical: Insets.md),
            ),
            child: const Text('Enable notifications'),
          ),

          const SizedBox(height: Insets.xl),

          Text(
            'Daily Reminders',
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.ink700,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: Insets.sm),

          Card(
            shape: const RoundedRectangleBorder(
              borderRadius: Radii.cardRadius,
            ),
            child: Column(
              children: [
                _ReminderTile(
                  title: 'Breakfast',
                  subtitle: '8:00 AM',
                  value: _breakfast,
                  onChanged: (v) => _toggle(
                    key: _kKeyBreakfast,
                    enabled: v,
                    id: _kIdBreakfast,
                    hour: 8,
                    minute: 0,
                    title: 'Breakfast time!',
                    body: 'Time for a healthy breakfast to fuel your day.',
                    onSet: (val) => _breakfast = val,
                  ),
                ),
                const Divider(height: 1, indent: Insets.lg),
                _ReminderTile(
                  title: 'Lunch',
                  subtitle: '1:00 PM',
                  value: _lunch,
                  onChanged: (v) => _toggle(
                    key: _kKeyLunch,
                    enabled: v,
                    id: _kIdLunch,
                    hour: 13,
                    minute: 0,
                    title: 'Lunch time!',
                    body: 'Take a break and enjoy a nutritious lunch.',
                    onSet: (val) => _lunch = val,
                  ),
                ),
                const Divider(height: 1, indent: Insets.lg),
                _ReminderTile(
                  title: 'Dinner',
                  subtitle: '7:00 PM',
                  value: _dinner,
                  onChanged: (v) => _toggle(
                    key: _kKeyDinner,
                    enabled: v,
                    id: _kIdDinner,
                    hour: 19,
                    minute: 0,
                    title: 'Dinner time!',
                    body: 'End your day with a balanced meal.',
                    onSet: (val) => _dinner = val,
                  ),
                ),
                const Divider(height: 1, indent: Insets.lg),
                _ReminderTile(
                  title: 'Workout',
                  subtitle: '5:30 PM',
                  value: _workout,
                  onChanged: (v) => _toggle(
                    key: _kKeyWorkout,
                    enabled: v,
                    id: _kIdWorkout,
                    hour: 17,
                    minute: 30,
                    title: 'Workout time!',
                    body: 'Time to get moving and crush your fitness goals.',
                    onSet: (val) => _workout = val,
                  ),
                ),
                const Divider(height: 1, indent: Insets.lg),
                _ReminderTile(
                  title: 'Water',
                  subtitle: '11:00 AM — daily',
                  value: _water,
                  onChanged: (v) => _toggle(
                    key: _kKeyWater,
                    enabled: v,
                    id: _kIdWater,
                    hour: 11,
                    minute: 0,
                    title: 'Stay hydrated!',
                    body: 'Remember to drink water throughout the day.',
                    onSet: (val) => _water = val,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReminderTile extends StatelessWidget {
  const _ReminderTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: AppColors.ink900,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: AppColors.ink500,
          fontSize: 13,
        ),
      ),
      value: value,
      onChanged: onChanged,
      activeThumbColor: AppColors.pink,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: Insets.lg,
        vertical: Insets.xs,
      ),
    );
  }
}
