import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:juke/constants.dart';
import 'package:juke/stores/track_store.dart';
import 'package:juke/widgets/custom_button.dart';
import 'package:juke/widgets/header.dart';
import 'package:juke/widgets/messenger.dart';
import 'package:juke/widgets/repair_tile.dart';
import 'package:provider/provider.dart';

class RepairScreen extends StatefulWidget {
  const RepairScreen({super.key});

  @override
  State<RepairScreen> createState() => _RepairScreenState();
}

class _RepairScreenState extends State<RepairScreen> {
  Future<void> _showPrintConfirmationDialog(
    BuildContext context,
    TrackStore store,
  ) async {
    final shouldContinue = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          title: const Text('Continue to printing?'),
          content: const Text(
            'Your changes were saved but not all cards were marked as corrected. Do you want to continue to printing anyway?',
            style: TextStyle(
              fontFamily: jetBrainsMonoFamily,
              color: secondaryColor,
              fontSize: 14,
            ),
          ),
          actions: [
            CustomButton(
              onPress: () => Navigator.of(dialogContext).pop(true),
              text: 'Continue to printing',
              type: ButtonType.secondary,
              size: ButtonSize.small,
            ),
            SizedBox(height: 8),
            CustomButton(
              onPress: () => Navigator.of(dialogContext).pop(false),
              text: 'Stay and fix cards',
              type: ButtonType.primary,
              size: ButtonSize.small,
            ),
          ],
        );
      },
    );

    if (!context.mounted || !mounted) {
      return;
    }

    if (shouldContinue == true) {
      context.go(homeRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<TrackStore>();

    const dividerPadding = 12.0;

    String _getActionText() {
      if (store.markedTracks.isEmpty) {
        return "No cards require attention, continue to printing";
      }

      return "${store.markedTracks.length} flagged cards - need action";
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Header(),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: dividerPadding * 2,
                    children: [
                      ...headerText,
                      Text(
                        _getActionText().toUpperCase(),
                        style: TextStyle(
                          fontFamily: jetBrainsMonoFamily,
                          fontSize: 18,
                          color: primaryColor,
                        ),
                      ),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: store.markedTracks.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final track = store.markedTracks[index];
                          return RepairTile(
                            track: track,
                            onDelete: () {
                              store.deleteTrack(track.id);
                              MessengerService().showMessage(
                                message: "Card removed successfully",
                                closeMessage: "OK",
                                type: MessageType.info,
                              );
                            },
                            onTrackUpdated: (updatedTrack) {
                              store.updateTrack(updatedTrack);
                            },
                            onMark: () {
                              store.markTrackAsCorrect(track.id);
                              MessengerService().showMessage(
                                message: "Card marked as corrected",
                                closeMessage: "OK",
                                type: MessageType.info,
                              );
                            },
                          );
                        },
                      ),
                      CustomButton(
                        text: 'go to printing',
                        onPress: () {
                          if (store.hasPendingCorrections) {
                            _showPrintConfirmationDialog(context, store);
                            return;
                          }

                          context.go(homeRoute);
                        },
                        type: ButtonType.primary,
                      ),
                      CustomButton(
                        text: "DEBUG",
                        onPress: () {
                          store.debugTracks();
                        },
                        type: ButtonType.destructive,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  final headerText = [
    RichText(
      text: TextSpan(
        text: 'Repair ',
        style: TextStyle(
          fontFamily: antonFamily,
          color: primaryColor,
          fontSize: headerTextSize,
        ),
        children: [
          TextSpan(
            text: 'or ',
            style: TextStyle(
              fontFamily: antonFamily,
              color: secondaryColor,
              fontSize: headerTextSize,
            ),
          ),
          TextSpan(
            text: 'remove ',
            style: TextStyle(
              fontFamily: antonFamily,
              color: primaryColor,
              fontSize: headerTextSize,
            ),
          ),
          TextSpan(
            text: 'bad cards',
            style: TextStyle(
              fontFamily: antonFamily,
              color: secondaryColor,
              fontSize: headerTextSize,
            ),
          ),
        ],
      ),
    ),
    Text(
      'Make the last changes before moving on to the printing phase.',
      style: TextStyle(
        fontFamily: jetBrainsMonoFamily,
        fontSize: subHeaderTextSize,
      ),
    ),
  ];
}
