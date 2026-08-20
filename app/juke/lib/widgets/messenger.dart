import 'package:flutter/material.dart';
import 'package:juke/constants.dart';

enum MessagePosition { top, bottom }

enum MessageType { success, error, info }

class MessengerService {
  static final MessengerService _instance = MessengerService._internal();
  factory MessengerService() => _instance;
  MessengerService._internal();

  static GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  void showMessage({
    required String message,
    required String closeMessage,
    MessagePosition position = MessagePosition.bottom,
    MessageType type = MessageType.info,
    Duration duration = const Duration(seconds: 2),
    VoidCallback? onClose,
  }) {
    final messenger = messengerKey.currentState;

    if (messenger == null) {
      return;
    }

    messenger.hideCurrentSnackBar();

    _showSnackBar(
      message: message,
      type: type,
      duration: duration,
      onClose: onClose,
      position: position,
      closeText: closeMessage,
    );
  }

  void clearCurrentMessage() {
    final messenger = messengerKey.currentState;
    if (messenger == null) {
      return;
    }

    messenger.hideCurrentSnackBar();
  }

  void _showSnackBar({
    required String message,
    required MessageType type,
    required Duration duration,
    required String closeText,
    VoidCallback? onClose,
    MessagePosition position = MessagePosition.bottom,
  }) {
    final context = messengerKey.currentContext!;

    final snackBar = SnackBar(
      persist: false,
      content: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          spacing: 12.0,
          children: [
            _getIcon(type, _getForegroundColor(type)),
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: _getForegroundColor(type)),
              ),
            ),
          ],
        ),
      ),
      actionOverflowThreshold: 0.5,
      backgroundColor: _getBackgroundColor(type),
      duration: duration,
      behavior: SnackBarBehavior.floating,
      margin: position == MessagePosition.top
          ? EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height - 100,
              left: 8,
              right: 8,
            )
          : const EdgeInsets.all(10),
      action: SnackBarAction(
        label: closeText,
        textColor: _getForegroundColor(type),
        onPressed: () {
          messengerKey.currentState?.hideCurrentSnackBar();
          onClose?.call();
        },
      ),
    );

    messengerKey.currentState?.showSnackBar(snackBar);
  }

  Color _getForegroundColor(MessageType type) {
    switch (type) {
      case MessageType.info:
      case MessageType.success:
        return onSecondaryColor;
      case MessageType.error:
        return onErrorColor;
    }
  }

  Color _getBackgroundColor(MessageType type) {
    switch (type) {
      case MessageType.info:
      case MessageType.success:
        return secondaryColor;
      case MessageType.error:
        return errorColor;
    }
  }

  Icon _getIcon(MessageType type, Color color) {
    switch (type) {
      case MessageType.success:
        return Icon(Icons.check_circle, color: color);
      case MessageType.error:
        return Icon(Icons.error, color: color);
      case MessageType.info:
        return Icon(Icons.info, color: color);
    }
  }
}
