import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:juke/constants.dart';
import 'package:juke/models/fetch_results.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:juke/models/track_info.dart';

class SpotifyUtils {
  static final _clientId = dotenv.get(spotifyClientId);
  static const _redirectUrl = 'juke://callback';
  static const _scope = 'playlist-read-private,playlist-read-collaborative';

  static final _playlistIdRegex = RegExp(r'playlist/([a-zA-Z0-9]+)');

  static Future<SpotifyFetchResult> fetchPlaylist(String playlistUrl) async {
    final playlistId = _extractPlaylistId(playlistUrl);

    if (playlistId == null) {
      return SpotifyFetchResult.invalidLink();
    }

    final String accessToken;
    try {
      accessToken = await SpotifySdk.getAccessToken(
        clientId: _clientId,
        redirectUrl: _redirectUrl,
        scope: _scope,
      );
    } on PlatformException {
      // user cancelled login, or Spotify app not installed/reachable
      return SpotifyFetchResult.needsLogin();
    }

    final response = await http.get(
      Uri.parse(
        'https://api.spotify.com/v1/playlists/$playlistId'
        '?fields=tracks.items(track(name,album(release_date),artists(name)))',
      ),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    switch (response.statusCode) {
      case 200:
        break;
      case 404:
        return SpotifyFetchResult.invalidLink();
      case 401:
      case 403:
        return SpotifyFetchResult.needsLogin();
      default:
        return SpotifyFetchResult.error(
          'Spotify returned ${response.statusCode}',
        );
    }

    final tracks = _parseTracks(
      jsonDecode(response.body) as Map<String, dynamic>,
    );

    //todo REMOVE AND CONTINUE IMPLEMENTATION
    debugLogTracks(tracks);

    return SpotifyFetchResult.success(tracks);
  }

  static String? _extractPlaylistId(String url) {
    return _playlistIdRegex.firstMatch(url)?.group(1);
  }

  static List<TrackInfo> _parseTracks(Map<String, dynamic> json) {
    final items = (json['tracks']?['items'] as List<dynamic>?) ?? [];

    return items.map((item) {
      final track = item['track'] as Map<String, dynamic>;
      final artists = (track['artists'] as List<dynamic>)
          .map((a) => a['name'] as String)
          .toList();
      final releaseDate = track['album']?['release_date'] as String? ?? '';
      final releaseYear = releaseDate.isNotEmpty
          ? int.tryParse(releaseDate.split('-').first)
          : null;

      return TrackInfo(
        title: track['name'] as String,
        primaryArtist: artists.isNotEmpty ? artists.first : 'Unknown Artist',
        secondaryArtists: artists.length > 1
            ? artists.sublist(1, min(artists.length, 3))
            : const [],
        releaseYear: releaseYear,
      );
    }).toList();
  }

  static void debugLogTracks(List<TrackInfo> tracks) {
    print('--- Fetched ${tracks.length} tracks ---');
    for (final t in tracks) {
      // ignore: avoid_print
      print(t);
    }
  }
}
