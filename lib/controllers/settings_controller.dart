import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:revory/controllers/reminder_controller.dart';
import 'package:revory/repositories/local_app_repository.dart';

/// Provides appearance and service-notification preferences.
final settingsControllerProvider =
    NotifierProvider<SettingsController, SettingsState>(SettingsController.new);

/// Saved appearance mode and service-reminder preference.
class SettingsState {
  /// Creates settings with light appearance and reminders enabled by default.
  const new({this.themeMode = ThemeMode.light, this.remindersEnabled = true});

  /// Appearance mode used by the root application.
  final ThemeMode themeMode;

  /// Whether upcoming-service notifications are enabled.
  final bool remindersEnabled;
}

/// Manages settings persistence and reminder preference changes.
class SettingsController extends Notifier<SettingsState> {
  @override
  SettingsState build() => const SettingsState();

  /// Restores settings with support for the legacy darkMode preference.
  Future<void> restore() async {
    final prefs = await ref.read(localAppRepositoryProvider).preferences;
    state = SettingsState(
      themeMode: switch (prefs.getString('themeMode')) {
        'dark' => ThemeMode.dark,
        'system' => ThemeMode.system,
        _ =>
          prefs.getBool('darkMode') == true ? ThemeMode.dark : ThemeMode.light,
      },
      remindersEnabled: prefs.getBool('remindersEnabled') ?? true,
    );
  }

  /// Publishes and persists the chosen appearance mode.
  Future<void> setThemeMode(ThemeMode mode) async {
    state = SettingsState(
      themeMode: mode,
      remindersEnabled: state.remindersEnabled,
    );
    await ref
        .read(localAppRepositoryProvider)
        .writeString('themeMode', mode.name);
  }

  /// Persists the reminder preference and synchronizes notifications.
  Future<void> setRemindersEnabled({required bool enabled}) async {
    state = SettingsState(
      themeMode: state.themeMode,
      remindersEnabled: enabled,
    );
    await ref
        .read(localAppRepositoryProvider)
        .writeBool('remindersEnabled', value: enabled);
    await ref.read(reminderControllerProvider).synchronize();
  }
}
