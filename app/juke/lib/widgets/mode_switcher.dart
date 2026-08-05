import 'package:flutter/material.dart';
import 'package:juke/stores/homepage_store.dart';

enum ModeOption { create, scan }

class ModeSwitcher extends StatelessWidget {
  const ModeSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final store = HomePageNotifier();
    final currentModeIndex = store.currentMode == ModeOption.create ? 0 : 1;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFE8E5E0),
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: const Color(0x0F000000),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ToggleButtons(
        isSelected: [currentModeIndex == 0, currentModeIndex == 1],
        onPressed: (int index) {
          final nextMode = index == 0 ? ModeOption.create : ModeOption.scan;
          store.changeMode(nextMode);
        },
        borderRadius: BorderRadius.circular(999),
        borderColor: Colors.transparent,
        selectedBorderColor: Colors.transparent,
        fillColor: const Color(0xFFF8F6F2),
        selectedColor: Colors.black,
        color: const Color(0xFFACACAC),
        splashColor: Colors.transparent,
        renderBorder: false,
        constraints: const BoxConstraints(minHeight: 44, minWidth: 64),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Text(
              'CREATE',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Text(
              'SCAN',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
    ;
  }
}
