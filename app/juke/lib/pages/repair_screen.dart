import 'package:flutter/material.dart';
import 'package:juke/constants.dart';
import 'package:juke/stores/track_store.dart';
import 'package:juke/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class RepairScreen extends StatelessWidget {
  const RepairScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<TrackStore>();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // RichText(
          //   text: TextSpan(
          //     text: 'Repair or remove ',
          //     style: TextStyle(
          //       fontFamily: antonFamily,
          //       color: secondaryColor,
          //       fontSize: headerTextSize,
          //     ),
          //     children: [
          //       TextSpan(
          //         text: 'bad cards',
          //         style: TextStyle(
          //           fontFamily: antonFamily,
          //           color: secondaryColor,
          //           fontSize: headerTextSize,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // Text(
          //   'Review the flagged cards before moving on to printing.',
          //   style: TextStyle(
          //     fontFamily: jetBrainsMonoFamily,
          //     fontSize: subHeaderTextSize,
          //   ),
          // ),
          // const SizedBox(height: 24),
          // Text(
          //   flaggedTracks.isEmpty
          //       ? 'No cards are flagged yet.'
          //       : '${flaggedTracks.length} flagged cards need attention.',
          //   style: TextStyle(
          //     fontFamily: jetBrainsMonoFamily,
          //     fontSize: 18,
          //     color: primaryColor,
          //   ),
          // ),
          // const SizedBox(height: 24),
          // Expanded(
          //   child: Container(
          //     width: double.infinity,
          //     padding: const EdgeInsets.all(16),
          //     decoration: BoxDecoration(
          //       border: Border.all(width: 2, color: secondaryColor),
          //       color: Colors.transparent,
          //     ),
          //     child: flaggedTracks.isEmpty
          //         ? Center(
          //             child: Text(
          //               'Flagged tracks will show up here.',
          //               style: TextStyle(
          //                 fontFamily: jetBrainsMonoFamily,
          //                 fontSize: 16,
          //                 color: secondaryColor,
          //               ),
          //             ),
          //           )
          //         : ListView.separated(
          //             itemCount: flaggedTracks.length,
          //             separatorBuilder: (context, index) =>
          //                 const SizedBox(height: 12),
          //             itemBuilder: (context, index) {
          //               final track = flaggedTracks[index];

          //               return ListTile(
          //                 contentPadding: EdgeInsets.zero,
          //                 title: Text(
          //                   track.title,
          //                   style: TextStyle(
          //                     fontFamily: jetBrainsMonoFamily,
          //                     fontSize: 16,
          //                   ),
          //                 ),
          //                 subtitle: Text(
          //                   track.primaryArtist,
          //                   style: TextStyle(
          //                     fontFamily: jetBrainsMonoFamily,
          //                     fontSize: 14,
          //                   ),
          //                 ),
          //                 trailing: const Icon(Icons.chevron_right),
          //               );
          //             },
          //           ),
          //   ),
          // ),
          // const SizedBox(height: 16),
          // Row(
          //   children: [
          //     Expanded(
          //       child: CustomButton(
          //         text: 'back',
          //         onPress: onBack,
          //         type: ButtonType.secondary,
          //       ),
          //     ),
          //     const SizedBox(width: 12),
          //     Expanded(
          //       child: CustomButton(
          //         text: 'go to printing',
          //         onPress: flaggedTracks.isEmpty ? null : () {},
          //         type: ButtonType.primary,
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
