import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/foundation.dart';

/// The app's three primary navigation destinations.
class AppBottomNavigationBar extends AdaptiveBottomNavigationBar {
  const new({required int selectedIndex, required ValueChanged<int> onSelected})
    : super(
        useNativeBottomBar: true,
        items: const [
          AdaptiveNavigationDestination(icon: 'house.fill', label: 'Home'),
          AdaptiveNavigationDestination(
            icon: 'list.bullet.rectangle',
            label: 'History',
          ),
          AdaptiveNavigationDestination(icon: 'person.fill', label: 'Profile'),
        ],
        selectedIndex: selectedIndex,
        onTap: onSelected,
      );
}
