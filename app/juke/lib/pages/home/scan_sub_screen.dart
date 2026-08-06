import 'package:flutter/material.dart';
import 'package:juke/widgets/custom_button.dart';

class ScanSubScreen extends StatelessWidget {
  const ScanSubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomButton(
            text: "open camera",
            onPress: () => {},
            type: ButtonType.primary,
          ),
          SizedBox(height: 16),
          CustomButton(
            text: "open spotify",
            onPress: () => {},
            type: ButtonType.secondary,
          ),
        ],
      ),
    );
  }
}
