import 'package:juke/models/track_info.dart';

enum SpotifyFetchStatus { success, invalidLink, needsLogin, error }

class SpotifyFetchResult {
  final SpotifyFetchStatus status;
  final List<TrackInfo> tracks;
  final String? errorMessage;

  const SpotifyFetchResult._(this.status, this.tracks, this.errorMessage);

  factory SpotifyFetchResult.success(List<TrackInfo> tracks) =>
      SpotifyFetchResult._(SpotifyFetchStatus.success, tracks, null);

  factory SpotifyFetchResult.invalidLink() => const SpotifyFetchResult._(
    SpotifyFetchStatus.invalidLink,
    [],
    'This playlist link is invalid.',
  );

  factory SpotifyFetchResult.needsLogin() => const SpotifyFetchResult._(
    SpotifyFetchStatus.needsLogin,
    [],
    "You need to log in to access this private playlist.",
  );

  factory SpotifyFetchResult.error(String message) =>
      SpotifyFetchResult._(SpotifyFetchStatus.error, [], message);
}
