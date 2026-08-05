import 'package:flutter/material.dart';
import 'package:juke/constants.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: const Row(
        children: [
          Text("J"),
          Text("U", style: TextStyle(color: primaryColor)),
          Text("KE"),
        ],
      ),
    );
  }
}
