import 'package:flutter/material.dart';
import 'package:juke/models/link_type.dart';
import 'package:juke/models/mode_option.dart';
import 'package:juke/widgets/mode_switcher.dart';

class HomePageNotifier extends ChangeNotifier {
  ModeOption _currentMode = ModeOption.scan;
  ModeOption get currentMode => _currentMode;

  String _musicLink = "";
  String get musicLink => _musicLink;

  LinkType _linkType = LinkType.Unsupported;
  LinkType get linkType => _linkType;

  void changeMode(ModeOption option) {
    _currentMode = option;
    notifyListeners();
  }

  void setMusicLink(String newLink) {
    if (!isLinkSupported(newLink)) {
      _linkType = LinkType.Unsupported;
    }

    _linkType = LinkType.Spotify;
    _musicLink = newLink;
  }

  bool isLinkSupported(String link) {
    //currently we only support Spotify, normally we'd check compatibility
    return link.startsWith("https://open.spotify.com/playlist");
  }
}
