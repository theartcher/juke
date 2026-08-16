import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:juke/constants.dart';
import 'package:juke/models/fetch_results.dart';
import 'package:juke/models/link_type.dart';
import 'package:juke/stores/homepage_store.dart';
import 'package:juke/stores/track_store.dart';
import 'package:juke/utility/spotify_utils.dart';
import 'package:juke/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class CreateSubScreen extends StatefulWidget {
  const CreateSubScreen({super.key});

  @override
  State<CreateSubScreen> createState() => _CreateSubScreenState();
}

class _CreateSubScreenState extends State<CreateSubScreen> {
  final musicLinkController = TextEditingController();

  @override
  void dispose() {
    musicLinkController.dispose();
    super.dispose();
  }

  void _pasteClipboard() async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    final clipboardText = clipboardData?.text;
    if (clipboardText == null || clipboardText.isEmpty) {
      return;
    }

    musicLinkController.text = clipboardText;
    context.read<HomePageNotifier>().setMusicLink(clipboardText);
  }

  @override
  Widget build(BuildContext context) {
    final linkType = context.watch<HomePageNotifier>().linkType;
    final musicLink = context.watch<HomePageNotifier>().musicLink;
    final trackStore = context.watch<TrackStore>();

    final hasInput = musicLink.isNotEmpty;
    final isValid = linkType != LinkType.Unsupported;

    Future<void> handleFetchResults(SpotifyFetchResult results) async {
      switch (results.status) {
        case SpotifyFetchStatus.success:
          trackStore.initializeTracks(results.tracks);
          context.go(checkRoute);
          break;
        case SpotifyFetchStatus.invalidLink:
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('This is not a valid Spotify playlist link.'),
            ),
          );
          break;
        case SpotifyFetchStatus.needsLogin:
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Please log in to your Spotify account to access this playlist.',
              ),
            ),
          );
          break;

        case SpotifyFetchStatus.error:
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'An unexpected error occurred while fetching the playlist',
              ),
            ),
          );
      }
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: 'Build a new ',
              style: TextStyle(
                fontFamily: antonFamily,
                color: secondaryColor,
                fontSize: headerTextSize,
              ),
              children: [
                TextSpan(
                  text: 'deck',
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
            'Paste your Spotify playlist and Juke turns it into printable cards.',
            style: TextStyle(
              fontFamily: jetBrainsMonoFamily,
              fontSize: subHeaderTextSize,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 32.0, 0.0, 16),
            child: TextField(
              controller: musicLinkController,
              autocorrect: false,
              autofocus: true,
              onChanged: (value) =>
                  context.read<HomePageNotifier>().setMusicLink(value),
              style: TextStyle(fontFamily: jetBrainsMonoFamily, fontSize: 18.0),
              decoration: InputDecoration(
                suffix: GestureDetector(
                  onTap: () => _pasteClipboard(),
                  child: Icon(Icons.content_paste),
                ),
                labelText: "PLAYLIST LINK",
                labelStyle: TextStyle(
                  fontFamily: jetBrainsMonoFamily,
                  fontSize: 20.0,
                ),
                hintText:
                    "https://open.spotify.com/playlist/37i9dQZF1DZ06evO05tE88?si=ccc9920b762d4840",
                hintStyle: TextStyle(
                  fontFamily: jetBrainsMonoFamily,
                  fontSize: 20.0,
                ),
                focusColor: secondaryColor,
                errorText: hasInput && !isValid
                    ? "This link must be a valid Spotify playlist"
                    : null,
                errorMaxLines: 2,
                errorStyle: TextStyle(
                  fontFamily: jetBrainsMonoFamily,
                  fontSize: 14.0,
                ),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.zero),
                  borderSide: BorderSide(width: 20),
                ),
              ),
            ),
          ),
          CustomButton(
            text: "make my cards",
            onPress: isValid
                ? () async {
                    final results = await SpotifyUtils.fetchPlaylist(
                      musicLinkController.value.text,
                    );

                    handleFetchResults(results);
                  }
                : null,
            type: ButtonType.primary,
          ),
        ],
      ),
    );
  }
}
