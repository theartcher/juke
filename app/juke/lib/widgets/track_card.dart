import 'package:flutter/material.dart';
import 'package:juke/constants.dart';
import 'package:juke/models/track_info.dart';

class TrackCard extends StatelessWidget {
  final TrackInfo track;

  const TrackCard({super.key, required this.track});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      decoration: BoxDecoration(
        color: secondaryColor,
        boxShadow: const [
          BoxShadow(
            blurRadius: 12,
            offset: Offset(4, 4),
            color: Color.fromARGB(40, 0, 0, 0),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            track.releaseYear.toString(),
            style: TextStyle(
              fontFamily: jetBrainsMonoFamily,
              fontSize: 28,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            track.title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: jetBrainsMonoFamily,
              fontSize: 18,
              color: onSecondaryColor,
            ),
          ),
          const SizedBox(height: 12),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: track.primaryArtist,
                  style: TextStyle(
                    fontFamily: jetBrainsMonoFamily,
                    color: onSecondaryColor,
                    fontSize: 14,
                  ),
                ),
                if (track.secondaryArtists.isNotEmpty)
                  TextSpan(
                    text: ' (feat. ${track.secondaryArtists.join(', ')})',
                    style: TextStyle(
                      fontFamily: jetBrainsMonoFamily,
                      color: onSecondaryColor,
                      fontSize: 14,
                    ),
                  ),
              ],
            ),
            softWrap: true,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
