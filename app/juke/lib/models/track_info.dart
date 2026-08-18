class TrackInfo {
  final String id;
  final String title;
  final String primaryArtist;
  final List<String> secondaryArtists; // max 2
  final int? releaseYear;
  final String directLink;

  const TrackInfo({
    required this.id,
    required this.title,
    required this.primaryArtist,
    required this.secondaryArtists,
    required this.releaseYear,
    required this.directLink,
  });

  TrackInfo copyWith({
    String? id,
    String? title,
    String? primaryArtist,
    List<String>? secondaryArtists,
    int? releaseYear,
    String? directLink,
  }) {
    return TrackInfo(
      id: id ?? this.id,
      title: title ?? this.title,
      primaryArtist: primaryArtist ?? this.primaryArtist,
      secondaryArtists: secondaryArtists ?? this.secondaryArtists,
      releaseYear: releaseYear ?? this.releaseYear,
      directLink: directLink ?? this.directLink,
    );
  }

  @override
  String toString() =>
      '$title — $primaryArtist${secondaryArtists.isNotEmpty ? ' feat. ${secondaryArtists.join(', ')}' : ''} ($releaseYear)';
}
