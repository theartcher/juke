import 'package:flutter/material.dart';
import 'package:juke/models/track_info.dart';
import 'package:uuid/uuid.dart';

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
  bool get hasPendingCorrections =>
      _tracks.any((track) => track.status == TrackStatus.modificationRequired);

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
    int index = _tracks.indexWhere((t) => t.track.id == track.id);

    if (index != -1) {
      _tracks[index] = TrackWithStatus(track: track, status: status);
    }

    notifyListeners();
  }

  void updateTrack(TrackInfo track) {
    final index = _tracks.indexWhere((t) => t.track.id == track.id);

    if (index == -1) return;

    final currentStatus = _tracks[index].status;
    _tracks[index] = TrackWithStatus(
      track: track,
      status: currentStatus == TrackStatus.approved
          ? TrackStatus.approved
          : TrackStatus.modificationRequired,
    );

    notifyListeners();
  }

  void markTrackAsCorrect(String trackId) {
    final index = _tracks.indexWhere((t) => t.track.id == trackId);

    if (index == -1) return;

    final track = _tracks[index].track;
    _tracks[index] = TrackWithStatus(
      track: track,
      status: TrackStatus.approved,
    );
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

  void deleteTrack(String trackId) {
    _tracks.removeWhere((t) => t.track.id == trackId);

    notifyListeners();
  }

  void replaceTrack(TrackInfo track) {
    int index = _tracks.indexWhere((t) => t.track.id == track.id);

    if (index != -1) {
      final currentStatus = _tracks[index].status;
      _tracks[index] = TrackWithStatus(track: track, status: currentStatus);
    }

    notifyListeners();
  }

  void addTrack(
    TrackInfo track, {
    TrackStatus status = TrackStatus.unverified,
  }) {
    _tracks.add(TrackWithStatus(track: track, status: status));
    notifyListeners();
  }
}
