import 'package:flutter/material.dart';
import 'package:juke/constants.dart';

enum ButtonType { primary, secondary, destructive }

class _DisabledPalette {
  static const border = Color.fromARGB(255, 150, 145, 145);

  static const filled = Color.fromARGB(168, 150, 145, 145);
  static const onFilled = Color.fromARGB(175, 53, 52, 52);

  static const onOutlined = Color.fromARGB(255, 150, 145, 145);
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPress;
  final ButtonType type;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPress,
    this.type = ButtonType.primary,
  });

  static const disabledOpacity = 0.7;

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPress == null;
    final borderColor = _getBorderColor(type, isDisabled);
    final textColor = _getTextColor(type, isDisabled);
    final fillColor = _getFillColor(type, isDisabled);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: borderColor),
        color: fillColor,
      ),
      child: GestureDetector(
        onTap: onPress,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Center(
            child: Text(
              text.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: jetBrainsMonoFamily,
                fontSize: 20.0,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getFillColor(ButtonType type, bool isDisabled) {
    if (type == ButtonType.primary) {
      return isDisabled ? _DisabledPalette.filled : secondaryColor;
    }
    // secondary & destructive are outlined — stay transparent, disabled or not
    return Colors.transparent;
  }

  Color _getBorderColor(ButtonType type, bool isDisabled) {
    if (isDisabled) return _DisabledPalette.border;

    switch (type) {
      case ButtonType.primary:
      case ButtonType.secondary:
        return secondaryColor;
      case ButtonType.destructive:
        return errorColor;
    }
  }

  Color _getTextColor(ButtonType type, bool isDisabled) {
    if (isDisabled) {
      switch (type) {
        case ButtonType.primary:
          return _DisabledPalette.onFilled;
        case ButtonType.secondary:
        case ButtonType.destructive:
          return _DisabledPalette.onOutlined;
      }
    }

    switch (type) {
      case ButtonType.primary:
        return onSecondaryColor;
      case ButtonType.secondary:
        return secondaryColor;
      case ButtonType.destructive:
        return errorColor;
    }
  }
}
