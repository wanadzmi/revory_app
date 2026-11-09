import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides the selected primary navigation tab.
final mainControllerProvider = NotifierProvider<MainController, int>(
  MainController.new,
);

/// Owns the selected tab index for primary navigation.
class MainController extends Notifier<int> {
  @override
  int build() => 0;

  /// Zero-based index of the currently selected primary navigation tab.
  int get selectedTab => state;

  /// Sets the zero-based primary navigation tab index.
  set selectedTab(int index) => state = index;
}
