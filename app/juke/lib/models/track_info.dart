class TrackInfo {
  final String title;
  final String primaryArtist;
  final List<String> secondaryArtists; // max 2
  final int? releaseYear;

  const TrackInfo({
    required this.title,
    required this.primaryArtist,
    required this.secondaryArtists,
    required this.releaseYear,
  });

  @override
  String toString() =>
      '$title — $primaryArtist${secondaryArtists.isNotEmpty ? ' feat. ${secondaryArtists.join(', ')}' : ''} ($releaseYear)';
}
