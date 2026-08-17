import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:juke/constants.dart';
import 'package:juke/models/fetch_results.dart';
import 'package:juke/utility/string_utils.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:juke/models/track_info.dart';
import 'package:uuid/uuid.dart';

class SpotifyUtils {
  static final _clientId = dotenv.get(spotifyClientId);
  static final _androidRedirectUrl = dotenv.get(spotifyAndroidRedirectUrl);
  static final _webRedirectUrl = dotenv.get(spotifyWebRedirectUrl);

  static String get _redirectUrl =>
      kIsWeb ? _webRedirectUrl : _androidRedirectUrl;

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
    } on PlatformException catch (error) {
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

    switch (response.statusCode) {
      case 200:
        break;
      case 401:
      case 403:
        return SpotifyFetchResult.needsLogin();
      case 404:
        return SpotifyFetchResult.invalidLink();
      default:
        return SpotifyFetchResult.error(
          'Spotify returned ${response.statusCode}',
        );
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final tracks = _parseTracks(decoded);

    return SpotifyFetchResult.success(tracks);
  }

  static String? _extractPlaylistId(String url) {
    return _playlistIdRegex.firstMatch(url)?.group(1);
  }

  static List<TrackInfo> _parseTracks(Map<String, dynamic> json) {
    final entries = (json['items']?['items'] as List<dynamic>?) ?? [];
    final tracks = <TrackInfo>[];

    for (final entry in entries) {
      final item = entry['item'] as Map<String, dynamic>?;

      if (item == null || item['track'] != true) {
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
          id: Uuid().v4(),
          title: StringUtils.truncateToWord(item['name'] as String, 25),
          primaryArtist: StringUtils.truncateToWord(
            artists.isNotEmpty ? artists.first : 'Unknown Artist',
            20,
          ),
          secondaryArtists: artists.length > 1
              ? artists
                    .sublist(1, min(artists.length, 3))
                    .map((artist) => StringUtils.truncateToWord(artist, 20))
                    .toList()
              : const [],
          releaseYear: releaseYear,
        ),
      );
    }

    return tracks;
  }
}
