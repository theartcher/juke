import 'package:flutter/material.dart';
import 'package:juke/widgets/mode_switcher.dart';

class HomePageNotifier extends ChangeNotifier {
  ModeOption _currentMode = ModeOption.scan;
  ModeOption get currentMode => _currentMode;

  void changeMode(ModeOption option) {
    _currentMode = option;
    notifyListeners();
  }
}
