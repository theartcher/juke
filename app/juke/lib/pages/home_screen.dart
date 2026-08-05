import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:juke/constants.dart';
import 'package:juke/stores/homepage_store.dart';
import 'package:juke/widgets/header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const headerTextSize = 50.0;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final musicLinkController = TextEditingController();

  @override
  void dispose() {
    musicLinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = HomePageNotifier();

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Header(),
          Padding(
            padding: EdgeInsets.all(16.0),
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
                      fontSize: HomeScreen.headerTextSize,
                    ),
                    children: [
                      TextSpan(
                        text: 'deck',
                        style: TextStyle(
                          fontFamily: antonFamily,
                          color: primaryColor,
                          fontSize: HomeScreen.headerTextSize,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  'Paste your Spotify playlist and Juke turns it into printable cards.',
                  style: TextStyle(
                    fontFamily: jetBrainsMonoFamily,
                    fontSize: 20.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32.0),
                  child: TextField(
                    controller: musicLinkController,
                    autocorrect: false,
                    autofocus: true,
                    decoration: InputDecoration(
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
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.zero),
                        borderSide: BorderSide(width: 20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
