import 'package:flutter/material.dart';
import 'package:juke/constants.dart';

enum ButtonType { primary, secondary, destructive }

enum ButtonSize { small, large }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPress;
  final ButtonType type;
  final ButtonSize size;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPress,
    this.type = ButtonType.primary,
    this.size = ButtonSize.large,
  });

  static const disabledAlpha = 0.4;

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPress == null;
    final borderColor = _getBorderColor(type, isDisabled);
    final textColor = _getTextColor(type, isDisabled);
    final fillColor = _getFillColor(type, isDisabled);

    return InkWell(
      onTap: onPress,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: borderColor),
          color: fillColor,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: _getPadding()),
          child: Center(
            child: Text(
              text.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: jetBrainsMonoFamily,
                fontSize: _getFontSize(),
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  double _getFontSize() {
    switch (size) {
      case ButtonSize.small:
        return 16.0;
      case ButtonSize.large:
        return 20.0;
    }
  }

  double _getPadding() {
    switch (size) {
      case ButtonSize.small:
        return 8.0;
      case ButtonSize.large:
        return 16.0;
    }
  }

  Color _getFillColor(ButtonType type, bool isDisabled) {
    if (type == ButtonType.primary) {
      return isDisabled
          ? secondaryColor.withValues(alpha: disabledAlpha)
          : secondaryColor;
    }

    return Colors.transparent;
  }

  Color _getBorderColor(ButtonType type, bool isDisabled) {
    switch (type) {
      case ButtonType.primary:
        return isDisabled
            ? Color.alphaBlend(
                secondaryColor.withValues(alpha: disabledAlpha),
                surfaceColor,
              )
            : secondaryColor;
      case ButtonType.secondary:
        return isDisabled
            ? secondaryColor.withValues(alpha: disabledAlpha)
            : secondaryColor;
      case ButtonType.destructive:
        return isDisabled
            ? secondaryColor.withValues(alpha: disabledAlpha)
            : errorColor;
    }
  }

  Color _getTextColor(ButtonType type, bool isDisabled) {
    if (isDisabled) {
      switch (type) {
        case ButtonType.primary:
          return surfaceColor;
        case ButtonType.secondary:
        case ButtonType.destructive:
          return secondaryColor.withValues(alpha: disabledAlpha);
      }
    }

    switch (type) {
      case ButtonType.primary:
        return surfaceColor;
      case ButtonType.secondary:
        return secondaryColor;
      case ButtonType.destructive:
        return errorColor;
    }
  }
}
