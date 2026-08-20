import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:juke/constants.dart';
import 'package:juke/utility/spotify_utils.dart';
import 'package:juke/widgets/custom_button.dart';
import 'package:juke/widgets/messenger.dart';
import 'package:spotify_sdk/models/connection_status.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

class ScanSubScreen extends StatefulWidget {
  const ScanSubScreen({super.key});

  @override
  State<ScanSubScreen> createState() => _ScanSubScreenState();
}

class _ScanSubScreenState extends State<ScanSubScreen> {
  bool _isPlaying = false;
  bool _isConnected = false;
  bool _isConnecting = false;
  bool _hasScannedTrack = false;
  bool _loadingPlaybackState = false;
  StreamSubscription<ConnectionStatus>? _connectionStatusSubscription;
  StreamSubscription<PlayerState>? _playerStateSubscription;

  Future<void> _connectSpotify() async {
    setState(() {
      _isConnecting = true;
    });

    try {
      await SpotifyUtils.connect();
      final isPlaying = await SpotifyUtils.isPlaying();

      if (!mounted) {
        return;
      }

      setState(() {
        _isConnected = true;
        _isPlaying = isPlaying;
      });
      _subscribeToRemoteEvents();
    } catch (error) {
      if (!mounted) return;

      MessengerService().showMessage(
        message: 'Could not connect to Spotify: $error',
        closeMessage: 'OK',
        type: MessageType.error,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isConnecting = false;
        });
      }
    }
  }

  void _subscribeToRemoteEvents() {
    _connectionStatusSubscription?.cancel();
    _connectionStatusSubscription = SpotifySdk.subscribeConnectionStatus()
        .listen((status) {
          if (!mounted) {
            return;
          }

          setState(() {
            _isConnected = status.connected;
            if (!status.connected) {
              _hasScannedTrack = false;
              SpotifyUtils.clearRemoteConnection();
            }
          });
        });

    _playerStateSubscription?.cancel();
    _playerStateSubscription = SpotifySdk.subscribePlayerState().listen((
      state,
    ) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isPlaying = !state.isPaused;
      });
    });
  }

  Future<void> _togglePlayback() async {
    setState(() {
      _loadingPlaybackState = true;
    });

    try {
      await SpotifyUtils.togglePlayback();
    } catch (error) {
      if (!mounted) {
        return;
      }

      MessengerService().showMessage(
        message: 'Could not control Spotify: $error',
        closeMessage: 'OK',
        type: MessageType.error,
      );
    } finally {
      if (mounted) {
        setState(() {
          _loadingPlaybackState = false;
        });
      }
    }
  }

  Future<void> _openScanner() async {
    final result = await context.push<String>(scanRoute);

    if (!mounted || result == null) {
      return;
    }

    try {
      await SpotifyUtils.playTrack(result);

      if (!mounted) {
        return;
      }

      setState(() {
        _hasScannedTrack = true;
      });
    } catch (error) {
      MessengerService().showMessage(
        message: 'Could not play the Spotify track: $error',
        closeMessage: "OK",
        type: MessageType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Center(child: _buildPlaybackButton())),
                if (!_isConnected)
                  CustomButton(
                    text: _isConnecting
                        ? 'connecting to spotify...'
                        : 'connect spotify',
                    onPress: _isConnecting ? null : _connectSpotify,
                    type: ButtonType.primary,
                  )
                else
                  CustomButton(
                    text: 'open camera',
                    onPress: _openScanner,
                    type: ButtonType.primary,
                  ),
              ],
            ),
          ),
          Positioned(top: 16, right: 16, child: _buildConnectionStatus()),
        ],
      ),
    );
  }

  Widget _buildConnectionStatus() {
    final color = _isConnected ? Colors.green : Colors.grey;
    final label = _isConnected ? 'Connected' : 'Disconnected';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontFamily: antonFamily,
            color: secondaryColor,
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _connectionStatusSubscription?.cancel();
    _playerStateSubscription?.cancel();
    super.dispose();
  }

  Widget _buildPlaybackButton() {
    return SizedBox(
      width: 120,
      height: 120,
      child: FilledButton(
        onPressed: _hasScannedTrack && !_loadingPlaybackState
            ? _togglePlayback
            : null,
        style: FilledButton.styleFrom(
          backgroundColor: primaryColor,
          disabledBackgroundColor: primaryColor.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          padding: EdgeInsets.zero,
        ),
        child: Icon(
          _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
          size: 52,
        ),
      ),
    );
  }
}
