import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:juke/constants.dart';
import 'package:juke/stores/track_store.dart';
import 'package:juke/widgets/custom_button.dart';
import 'package:juke/widgets/header.dart';
import 'package:juke/widgets/repair_tile.dart';
import 'package:provider/provider.dart';

class RepairScreen extends StatefulWidget {
  const RepairScreen({super.key});

  @override
  State<RepairScreen> createState() => _RepairScreenState();
}

class _RepairScreenState extends State<RepairScreen> {
  @override
  Widget build(BuildContext context) {
    final store = context.watch<TrackStore>();

    //DEBUG  ONLY FOR TESTING
    store.debugTracks();

    const dividerPadding = 12.0;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Header(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...headerText,
                    const SizedBox(height: dividerPadding * 2),
                    Text(
                      "${store.markedTracks.length} flagged cards - need action"
                          .toUpperCase(),
                      style: TextStyle(
                        fontFamily: jetBrainsMonoFamily,
                        fontSize: 18,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: dividerPadding * 2),
                    Expanded(
                      child: ListView.builder(
                        itemCount: store.markedTracks.length,
                        itemBuilder: (context, index) {
                          final track = store.markedTracks[index];
                          return RepairTile(track: track);
                        },
                      ),
                    ),
                    CustomButton(
                      text: 'go to printing',
                      onPress: store.markedTracks.isNotEmpty
                          ? null
                          : () {
                              context.go(
                                homeRoute,
                              ); //todo navigate to printing screen
                            },
                      type: ButtonType.primary,
                    ),
                  ],
                ),
              ),
            ),

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
