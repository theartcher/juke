import 'package:flutter/material.dart';
import 'package:juke/models/track_info.dart';

enum TrackStatus { unverified, approved, marked }

class TrackWithStatus {
  final TrackInfo track;
  final TrackStatus status;

  TrackWithStatus({required this.track, required this.status});
}

class TrackStore extends ChangeNotifier {
  List<TrackWithStatus> _tracks = List<TrackWithStatus>.empty();

  List<TrackInfo> get unverifiedTracks => _tracks
      .where((track) => track.status == TrackStatus.unverified)
      .map((track) => track.track)
      .toList();

  List<TrackInfo> get verifiedTracks => _tracks
      .where((track) => track.status == TrackStatus.approved)
      .map((track) => track.track)
      .toList();

  List<TrackInfo> get markedTracks => _tracks
      .where((track) => track.status == TrackStatus.marked)
      .map((track) => track.track)
      .toList();

  void initializeTracks(List<TrackInfo> tracks) {
    if (tracks.isNotEmpty) {
      return;
    }

    _tracks = tracks
        .map(
          (track) =>
              TrackWithStatus(track: track, status: TrackStatus.unverified),
        )
        .toList();
    notifyListeners();
  }

  void setStatusForTrack(TrackInfo track, TrackStatus status) {
    int index = _tracks.indexWhere(
      (t) =>
          t.track.title == track.title &&
          t.track.primaryArtist == track.primaryArtist,
    );

    if (index != -1) {
      _tracks[index] = TrackWithStatus(track: track, status: status);
    }

    notifyListeners();
  }

  void markAllCorrect() {
    _tracks = _tracks
        .map(
          (track) =>
              TrackWithStatus(track: track.track, status: TrackStatus.approved),
        )
        .toList();

    notifyListeners();
  }

  void deleteTrack(TrackInfo track) {
    _tracks.removeWhere(
      (t) =>
          t.track.title == track.title &&
          t.track.primaryArtist == track.primaryArtist,
    );
    notifyListeners();
  }
}
