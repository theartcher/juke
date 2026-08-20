import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:juke/constants.dart';
import 'package:juke/widgets/mode_switcher.dart';

class Header extends StatelessWidget {
  final bool showModeSwitcher;

  const Header({super.key, this.showModeSwitcher = false});

  static const titleTextSize = 28.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(width: 1.5, color: secondaryColor)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                context.go(homeRoute);
              },
              child: Row(
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
            ),
            if (showModeSwitcher) ...[ModeSwitcher()],
          ],
        ),
      ),
    );
  }
}
