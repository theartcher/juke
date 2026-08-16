import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:go_router/go_router.dart';
import 'package:juke/constants.dart';
import 'package:juke/stores/track_store.dart';
import 'package:juke/widgets/custom_button.dart';
import 'package:juke/widgets/track_card.dart';
import 'package:juke/widgets/header.dart';
import 'package:provider/provider.dart';

class CheckScreen extends StatefulWidget {
  const CheckScreen({super.key});

  @override
  State<CheckScreen> createState() => _CheckScreenState();
}

class _CheckScreenState extends State<CheckScreen> {
  final CardSwiperController _swiperController = CardSwiperController();

  @override
  void dispose() {
    _swiperController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<TrackStore>();
    final unverifiedTracks = store.unverifiedTracks;
    final hasTracks = unverifiedTracks.isNotEmpty;

    const dividerPadding = 12.0;

    void setStatusFromSwipe(int previousIndex, CardSwiperDirection direction) {
      if (!mounted ||
          previousIndex < 0 ||
          previousIndex >= unverifiedTracks.length) {
        return;
      }

      final swipedTrack = unverifiedTracks[previousIndex];

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted) return;

        switch (direction) {
          case CardSwiperDirection.left:
            store.setStatusForTrack(
              swipedTrack,
              TrackStatus.modificationRequired,
            );
            break;
          case CardSwiperDirection.right:
            store.setStatusForTrack(swipedTrack, TrackStatus.approved);
            break;
          default:
            return;
        }

        if (context.read<TrackStore>().unverifiedTracks.isNotEmpty) {
          _swiperController.moveTo(0);
        }

        if (store.currentUnverifiedTrack == null && store.totalTracks > 0) {
          context.go(repairRoute);
        }
      });
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Header(showModeSwitcher: false),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...headerText,
                      const SizedBox(height: dividerPadding * 2),
                      Text(
                        '${store.tracksChecked}/${store.totalTracks} tracks checked',
                        style: TextStyle(
                          fontFamily: jetBrainsMonoFamily,
                          fontSize: subHeaderTextSize,
                        ),
                      ),
                      const SizedBox(height: dividerPadding * 2),
                      if (hasTracks)
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final cardHeight = (constraints.maxWidth * 0.5)
                                .clamp(200.0, 350.0);

                            return SizedBox(
                              height: cardHeight,
                              width: double.infinity,
                              child: ClipRect(
                                child: CardSwiper(
                                  controller: _swiperController,
                                  padding: EdgeInsets.zero,
                                  cardsCount: unverifiedTracks.length,
                                  duration: Duration(milliseconds: 120),
                                  isLoop: false,
                                  numberOfCardsDisplayed:
                                      unverifiedTracks.length > 1 ? 2 : 1,
                                  allowedSwipeDirection:
                                      const AllowedSwipeDirection.only(
                                        left: true,
                                        right: true,
                                      ),
                                  cardBuilder:
                                      (
                                        context,
                                        index,
                                        percentThresholdX,
                                        percentThresholdY,
                                      ) {
                                        return TrackCard(
                                          track: unverifiedTracks[index],
                                        );
                                      },
                                  onSwipe:
                                      (previousIndex, currentIndex, direction) {
                                        setStatusFromSwipe(
                                          previousIndex,
                                          direction,
                                        );
                                        return true;
                                      },
                                ),
                              ),
                            );
                          },
                        )
                      else
                        AspectRatio(
                          aspectRatio: 1.28,
                          child: TrackCard(track: null),
                        ),
                      const SizedBox(height: dividerPadding * 2),
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              text: 'wrong',
                              onPress: hasTracks
                                  ? () => _swiperController.swipe(
                                      CardSwiperDirection.left,
                                    )
                                  : null,
                              type: ButtonType.secondary,
                            ),
                          ),
                          const SizedBox(width: dividerPadding),
                          Expanded(
                            child: CustomButton(
                              text: 'correct',
                              onPress: hasTracks
                                  ? () => _swiperController.swipe(
                                      CardSwiperDirection.right,
                                    )
                                  : null,
                              type: ButtonType.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: dividerPadding),
                      GestureDetector(
                        onTap: () {
                          store.approveAllTracks();
                          context.go(homeRoute);
                          //todo navigate to printing page
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
  ];
}
