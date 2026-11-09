import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:revory/features/garage/controllers/garage_controller.dart';
import 'package:revory/features/maintenance/controllers/history_controller.dart';
import 'package:revory/features/navigation/pages/main_page.dart';
import 'package:revory/features/profile/controllers/profile_controller.dart';
import 'package:revory/features/settings/controllers/settings_controller.dart';
import 'package:revory/shared/theme/app_theme.dart';

/// Root application with provider-backed appearance and primary navigation.
class RevoryApp extends ConsumerStatefulWidget {
  /// Creates the root application.
  const new({super.key});
  @override
  ConsumerState<RevoryApp> createState() => _RevoryAppState();
}

class _RevoryAppState extends ConsumerState<RevoryApp> {
  @override
  void initState() {
    super.initState();
    unawaited(ref.read(garageControllerProvider.notifier).restore());
    unawaited(ref.read(historyControllerProvider.notifier).restore());
    unawaited(ref.read(profileControllerProvider.notifier).restore());
    unawaited(ref.read(settingsControllerProvider.notifier).restore());
  }

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(settingsControllerProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Revory',
      themeMode: appState.themeMode,
      theme: appTheme(Brightness.light),
      darkTheme: appTheme(Brightness.dark),
      home: const MainPage(),
    );
  }
}
