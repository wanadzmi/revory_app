import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:revory/controllers/reminder_controller.dart';
import 'package:revory/repositories/local_app_repository.dart';

final settingsControllerProvider =
    NotifierProvider<SettingsController, SettingsState>(SettingsController.new);

class SettingsState {
  const SettingsState({
    this.themeMode = ThemeMode.light,
    this.remindersEnabled = true,
  });
  final ThemeMode themeMode;
  final bool remindersEnabled;
}

class SettingsController extends Notifier<SettingsState> {
  @override
  SettingsState build() => const SettingsState();
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

  Future<void> setThemeMode(ThemeMode mode) async {
    state = SettingsState(
      themeMode: mode,
      remindersEnabled: state.remindersEnabled,
    );
    await ref
        .read(localAppRepositoryProvider)
        .writeString('themeMode', mode.name);
  }

  Future<void> setRemindersEnabled(bool enabled) async {
    state = SettingsState(
      themeMode: state.themeMode,
      remindersEnabled: enabled,
    );
    await ref
        .read(localAppRepositoryProvider)
        .writeBool('remindersEnabled', enabled);
    await ref.read(reminderControllerProvider).synchronize();
  }
}
