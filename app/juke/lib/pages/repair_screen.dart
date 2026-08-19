import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:juke/constants.dart';
import 'package:juke/models/track_info.dart';
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
  final GlobalKey<AnimatedListState> _animatedListKey =
      GlobalKey<AnimatedListState>();

  void _dismissTrack(
    int index,
    TrackInfo track,
    TrackStore store, {
    required VoidCallback onAfterAnimation,
  }) {
    final animatedList = _animatedListKey.currentState;
    if (animatedList == null) {
      onAfterAnimation();
      return;
    }

    animatedList.removeItem(index, (context, animation) {
      final fadeAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOutCubic,
        reverseCurve: Curves.easeInOutCubic,
      );

      return FadeTransition(
        opacity: fadeAnimation,
        child: SizeTransition(
          sizeFactor: fadeAnimation,
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: RepairTile(
              key: ValueKey(track.id),
              track: track,
              onDelete: () {},
              onTrackUpdated: (_) {},
              onMark: () {},
            ),
          ),
        ),
      );
    }, duration: const Duration(milliseconds: 220));

    Future.delayed(const Duration(milliseconds: 220), () {
      if (!mounted) return;
      onAfterAnimation();
    });
  }

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
              text: 'Skip repair and print',
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
      store.approveAllTracks();
      context.go(printRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<TrackStore>();

    const dividerPadding = 12.0;

    void restoreTrack(int index, TrackInfo track) {
      final animatedList = _animatedListKey.currentState;
      if (animatedList == null) {
        return;
      }

      store.addTrack(track, status: TrackStatus.modificationRequired);

      animatedList.insertItem(
        index,
        duration: const Duration(milliseconds: 220),
      );
    }

    String getActionText() {
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
                        getActionText().toUpperCase(),
                        style: TextStyle(
                          fontFamily: jetBrainsMonoFamily,
                          fontSize: 18,
                          color: primaryColor,
                        ),
                      ),
                      AnimatedList(
                        key: _animatedListKey,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        initialItemCount: store.markedTracks.length,
                        itemBuilder: (context, index, animation) {
                          final track = store.markedTracks[index];

                          return FadeTransition(
                            opacity: CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeInOutCubic,
                              reverseCurve: Curves.easeInOutCubic,
                            ),
                            child: SizeTransition(
                              sizeFactor: animation,
                              alignment: Alignment.center,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  bottom: index == store.markedTracks.length - 1
                                      ? 0
                                      : 16,
                                ),
                                child: RepairTile(
                                  key: ValueKey(track.id),
                                  track: track,
                                  onDelete: () {
                                    _dismissTrack(
                                      index,
                                      track,
                                      store,
                                      onAfterAnimation: () {
                                        store.deleteTrack(track.id);
                                        MessengerService().showMessage(
                                          message: "Card removed successfully",
                                          closeMessage: "UNDO",
                                          onClose: () {
                                            restoreTrack(index, track);
                                          },
                                          type: MessageType.info,
                                          duration: const Duration(seconds: 3),
                                        );
                                      },
                                    );
                                  },
                                  onTrackUpdated: (updatedTrack) {
                                    store.updateTrack(updatedTrack);
                                  },
                                  onMark: () {
                                    _dismissTrack(
                                      index,
                                      track,
                                      store,
                                      onAfterAnimation: () {
                                        store.markTrackAsCorrect(track.id);
                                        MessengerService().showMessage(
                                          message: "Card marked as corrected",
                                          closeMessage: "UNDO",
                                          onClose: () {
                                            restoreTrack(index, track);
                                          },
                                          duration: const Duration(seconds: 3),
                                          type: MessageType.info,
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
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
                          context.go(printRoute);
                        },
                        type: ButtonType.primary,
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
