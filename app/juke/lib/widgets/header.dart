import 'package:flutter/material.dart';
import 'package:juke/constants.dart';
import 'package:juke/widgets/mode_switcher.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  static const titleTextSize = 28.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(width: 1.5, color: secondaryColor)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text("J", style: TextStyle(fontSize: titleTextSize)),
                Text(
                  "U",
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: titleTextSize,
                  ),
                ),
                Text("KE", style: TextStyle(fontSize: titleTextSize)),
              ],
            ),
            ModeSwitcher(),
          ],
        ),
      ),
    );
  }
}
