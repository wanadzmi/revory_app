import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:revory/features/settings/constants/appearance_constants.dart';
import 'package:revory/features/settings/controllers/settings_controller.dart';

/// Displays appearance, service reminders, and local sync status.
class SettingsPage extends ConsumerWidget {
  /// Creates the application settings page.
  const new({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsControllerProvider);
    final themeMode = settings.themeMode;
    final remindersEnabled = settings.remindersEnabled;
    final onToggleReminders = ref
        .read(settingsControllerProvider.notifier)
        .setRemindersEnabled;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.brightness_6_outlined),
                  title: const Text('Appearance'),
                  subtitle: Text(themeModeLabels[themeMode]!),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _pick(context, ref),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.notifications_outlined),
                  title: const Text('Service reminders'),
                  subtitle: const Text(
                    'Notify one week before service',
                    maxLines: 1,
                  ),
                  value: remindersEnabled,
                  onChanged: (enabled) => onToggleReminders(enabled: enabled),
                ),
                const Divider(height: 1),
                const ListTile(
                  leading: Icon(Icons.cloud_done_outlined),
                  title: Text('Sync status'),
                  subtitle: Text('Saved on this device'),
                  trailing: Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pick(BuildContext context, WidgetRef ref) async {
    final themeMode = ref.read(settingsControllerProvider).themeMode;
    final selected = await showModalBottomSheet<ThemeMode>(
      context: context,
      showDragHandle: true,
      builder: (sheet) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final mode in ThemeMode.values)
              ListTile(
                title: Text(themeModeLabels[mode]!),
                trailing: mode == themeMode
                    ? const Icon(Icons.check_circle)
                    : null,
                onTap: () => Navigator.pop(sheet, mode),
              ),
          ],
        ),
      ),
    );
    if (selected != null) {
      await ref
          .read(settingsControllerProvider.notifier)
          .setThemeMode(selected);
    }
  }
}
