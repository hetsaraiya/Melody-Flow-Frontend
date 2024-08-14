class Song {
  final String artistName;
  final String imageUrl;
  final String title;
  final String songUrl;
  final String duration;

  Song({
    required this.artistName,
    required this.imageUrl,
    required this.title,
    required this.songUrl,
    required this.duration,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      artistName: json['author'],
      imageUrl: json['thumbnail'] ?? '',
      title: json['title'],
      songUrl: json['audio_url'],
      duration: json['duration'],
    );
  }
}
