import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:revory/controllers/main_controller.dart';
import 'package:revory/pages/history_page.dart';
import 'package:revory/pages/home_page.dart';
import 'package:revory/pages/profile_page.dart';
import 'package:revory/widgets/app_bottom_navigation_bar.dart';

/// Composes primary navigation and preserves each tab's widget state.
class MainPage extends ConsumerWidget {
  /// Creates the primary navigation page.
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tab = ref.watch(mainControllerProvider);
    return AdaptiveScaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      extendBody: true,
      minimizeBehavior: TabBarMinimizeBehavior.never,
      body: Material(
        color: Colors.transparent,
        child: SafeArea(
          child: IndexedStack(
            index: tab,
            children: const [HomePage(), HistoryPage(), ProfilePage()],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        selectedIndex: tab,
        onSelected: (index) =>
            ref.read(mainControllerProvider.notifier).selectedTab = index,
      ),
    );
  }
}
