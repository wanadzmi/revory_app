import 'package:flutter_riverpod/flutter_riverpod.dart';

final mainControllerProvider = NotifierProvider<MainController, int>(
  MainController.new,
);

class MainController extends Notifier<int> {
  @override
  int build() => 0;

  void selectTab(int index) => state = index;
}
