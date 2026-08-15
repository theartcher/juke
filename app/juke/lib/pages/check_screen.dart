import 'package:flutter/material.dart';
import 'package:juke/constants.dart';
import 'package:juke/stores/track_store.dart';
import 'package:juke/widgets/custom_button.dart';
import 'package:juke/widgets/header.dart';
import 'package:provider/provider.dart';

class CheckScreen extends StatelessWidget {
  const CheckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<TrackStore>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Header(showModeSwitcher: false),
            Padding(
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
                  // _TrackPreviewCard(),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: 'wrong',
                          onPress: () => {
                            //todo implement
                          },
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
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {
                      store.approveAllTracks();
                    },
                    child: Center(
                      child: Text(
                        'skip deck check and go to printing'.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: jetBrainsMonoFamily,
                          fontSize: subHeaderTextSize,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class _TrackPreviewCard extends StatelessWidget {

//   const _TrackPreviewCard({});

//   @override
//   Widget build(BuildContext context) {

//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: secondaryColor,
//         border: Border.all(width: 2, color: secondaryColor),
//         boxShadow: const [
//           BoxShadow(
//             blurRadius: 8,
//             offset: Offset(0, 4),
//             color: Color.fromARGB(40, 0, 0, 0),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Text(
//             track?.releaseYear?.toString() ?? '----',
//             style: TextStyle(
//               fontFamily: antonFamily,
//               fontSize: 28,
//               color: primaryColor,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             track?.title ?? 'No track loaded yet',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontFamily: jetBrainsMonoFamily,
//               fontSize: 18,
//               color: onSecondaryColor,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             track?.primaryArtist ?? 'Add tracks to preview them here',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontFamily: jetBrainsMonoFamily,
//               fontSize: 16,
//               color: onSecondaryColor,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
