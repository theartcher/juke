import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:juke/constants.dart';
import 'package:juke/stores/homepage_store.dart';
import 'package:juke/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class CreateSubScreen extends StatefulWidget {
  const CreateSubScreen({super.key});

  static const headerTextSize = 50.0;

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
    String? clipboardText = clipboardData?.text;

    if (clipboardText == null || clipboardText.isEmpty) {
      return;
    }

    musicLinkController.text = clipboardText;
  }

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
              text: 'Build a new ',
              style: TextStyle(
                fontFamily: antonFamily,
                color: secondaryColor,
                fontSize: CreateSubScreen.headerTextSize,
              ),
              children: [
                TextSpan(
                  text: 'deck',
                  style: TextStyle(
                    fontFamily: antonFamily,
                    color: primaryColor,
                    fontSize: CreateSubScreen.headerTextSize,
                  ),
                ),
              ],
            ),
          ),
          Text(
            'Paste your Spotify playlist and Juke turns it into printable cards.',
            style: TextStyle(fontFamily: jetBrainsMonoFamily, fontSize: 20.0),
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
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.zero),
                  borderSide: BorderSide(width: 20),
                ),
              ),
            ),
          ),
          CustomButton(
            text: "make my cards",
            onPress: () => {},
            type: ButtonType.primary,
          ),
        ],
      ),
    );
  }
}
