import 'package:flutter/material.dart';
import 'package:juke/models/track_info.dart';

enum TrackStatus { unverified, approved, modificationRequired }

class TrackWithStatus {
  final TrackInfo track;
  final TrackStatus status;

  TrackWithStatus({required this.track, required this.status});
}

class TrackStore extends ChangeNotifier {
  List<TrackWithStatus> _tracks = List<TrackWithStatus>.empty();

  int get totalTracks => _tracks.length;
  int get tracksChecked =>
      _tracks.where((track) => track.status != TrackStatus.unverified).length;
  TrackInfo? get currentUnverifiedTrack => unverifiedTracks.firstOrNull;

  List<TrackInfo> get unverifiedTracks => _tracks
      .where((track) => track.status == TrackStatus.unverified)
      .map((track) => track.track)
      .toList();

  List<TrackInfo> get verifiedTracks => _tracks
      .where((track) => track.status == TrackStatus.approved)
      .map((track) => track.track)
      .toList();

  List<TrackInfo> get markedTracks => _tracks
      .where((track) => track.status == TrackStatus.modificationRequired)
      .map((track) => track.track)
      .toList();

  void initializeTracks(List<TrackInfo> tracks) {
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

  void approveAllTracks() {
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
