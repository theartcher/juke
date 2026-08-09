import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:juke/constants.dart';
import 'package:juke/models/fetch_results.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:juke/models/track_info.dart';

class SpotifyUtils {
  static final _clientId = dotenv.get(spotifyClientId);
  static final _androidRedirectUrl = dotenv.get(spotifyAndroidRedirectUrl);
  static final _webRedirectUrl = dotenv.get(spotifyWebRedirectUrl);

  static String get _redirectUrl =>
      kIsWeb ? _webRedirectUrl : _androidRedirectUrl;

  static const _scope = 'playlist-read-private,playlist-read-collaborative';
  static final _playlistIdRegex = RegExp(r'playlist/([a-zA-Z0-9]+)');

  static Future<SpotifyFetchResult> fetchPlaylist(String playlistUrl) async {
    print("starting playlist check for url: $playlistUrl");
    final playlistId = _extractPlaylistId(playlistUrl);
    print("extracted playlistId: $playlistId");

    if (playlistId == null) {
      print("playlistId is null — invalid link");
      return SpotifyFetchResult.invalidLink();
    }

    final String accessToken;
    try {
      accessToken = await SpotifySdk.getAccessToken(
        clientId: _clientId,
        redirectUrl: _redirectUrl,
        scope: _scope,
      );
      print(
        "got access token (len ${accessToken.length}): ${accessToken.substring(0, 10)}...",
      );
    } on PlatformException catch (e) {
      print("getAccessToken failed: ${e.code} — ${e.message}");
      return SpotifyFetchResult.needsLogin();
    }

    final uri = Uri.https('api.spotify.com', '/v1/playlists/$playlistId', {
      'fields':
          'items(items(item(name,album(release_date),artists(name),track)))',
    });

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    print("status: ${response.statusCode}");
    print(
      "raw body: ${response.body}",
    ); // full body — remove once this is fixed, playlists can be huge

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

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    print("decoded top-level keys: ${decoded.keys}");
    print("tracks key present: ${decoded.containsKey('tracks')}");
    print("items raw: ${decoded['tracks']?['items']}");

    final tracks = _parseTracks(decoded);
    print("parsed ${tracks.length} TrackInfo objects");

    debugLogTracks(tracks);

    return SpotifyFetchResult.success(tracks);
  }

  static String? _extractPlaylistId(String url) {
    return _playlistIdRegex.firstMatch(url)?.group(1);
  }

  static List<TrackInfo> _parseTracks(Map<String, dynamic> json) {
    final entries = (json['items']?['items'] as List<dynamic>?) ?? [];
    print("raw entries count: ${entries.length}");

    final tracks = <TrackInfo>[];

    for (final entry in entries) {
      final item = entry['item'] as Map<String, dynamic>?;

      if (item == null || item['track'] != true) {
        print(
          "skipping non-track entry: ${item?['name'] ?? 'null item (local file?)'}",
        );
        continue;
      }

      final artists = (item['artists'] as List<dynamic>? ?? [])
          .map((a) => a['name'] as String)
          .toList();
      final releaseDate = item['album']?['release_date'] as String? ?? '';
      final releaseYear = releaseDate.isNotEmpty
          ? int.tryParse(releaseDate.split('-').first)
          : null;

      tracks.add(
        TrackInfo(
          title: item['name'] as String,
          primaryArtist: artists.isNotEmpty ? artists.first : 'Unknown Artist',
          secondaryArtists: artists.length > 1
              ? artists.sublist(1, min(artists.length, 3))
              : const [],
          releaseYear: releaseYear,
        ),
      );
    }

    return tracks;
  }

  static void debugLogTracks(List<TrackInfo> tracks) {
    print('--- Fetched ${tracks.length} tracks ---');
    for (final t in tracks) {
      // ignore: avoid_print
      print(t);
    }
  }
}
