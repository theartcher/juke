import 'package:flutter/material.dart';
import 'package:juke/constants.dart';
import 'package:juke/stores/track_store.dart';
import 'package:juke/widgets/custom_button.dart';

class DeckCheckSubScreen extends StatelessWidget {
  final TrackStore store;
  final VoidCallback onContinue;

  const DeckCheckSubScreen({
    super.key,
    required this.store,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: 'Check your ',
              style: TextStyle(
                fontFamily: antonFamily,
                color: secondaryColor,
                fontSize: headerTextSize,
              ),
              children: [
                TextSpan(
                  text: 'deck ',
                  style: TextStyle(
                    fontFamily: antonFamily,
                    color: primaryColor,
                    fontSize: headerTextSize,
                  ),
                ),
                TextSpan(
                  text: 'before you ',
                  style: TextStyle(
                    fontFamily: antonFamily,
                    color: secondaryColor,
                    fontSize: headerTextSize,
                  ),
                ),
                TextSpan(
                  text: 'play',
                  style: TextStyle(
                    fontFamily: antonFamily,
                    color: primaryColor,
                    fontSize: headerTextSize,
                  ),
                ),
              ],
            ),
          ),
          Text(
            'Make sure the artists, title and year are correct before moving on.',
            style: TextStyle(
              fontFamily: jetBrainsMonoFamily,
              fontSize: subHeaderTextSize,
            ),
          ),
          const SizedBox(height: 24),
          _TrackPreviewCard(store: store),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: 'wrong',
                  onPress: onContinue,
                  type: ButtonType.secondary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomButton(
                  text: 'correct',
                  onPress: () {
                    //todo: implement correct button functionality
                  },
                  type: ButtonType.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TrackPreviewCard extends StatelessWidget {
  final TrackStore store;

  const _TrackPreviewCard({required this.store});

  @override
  Widget build(BuildContext context) {
    final track = store.unverifiedTracks.isNotEmpty
        ? store.unverifiedTracks.first
        : null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: secondaryColor,
        border: Border.all(width: 2, color: secondaryColor),
        boxShadow: const [
          BoxShadow(
            blurRadius: 8,
            offset: Offset(0, 4),
            color: Color.fromARGB(40, 0, 0, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            track?.releaseYear?.toString() ?? '----',
            style: TextStyle(
              fontFamily: antonFamily,
              fontSize: 28,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            track?.title ?? 'No track loaded yet',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: jetBrainsMonoFamily,
              fontSize: 18,
              color: onSecondaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            track?.primaryArtist ?? 'Add tracks to preview them here',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: jetBrainsMonoFamily,
              fontSize: 16,
              color: onSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
