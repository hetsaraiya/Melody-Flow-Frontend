class Search {
  final String title;
  final String? subTitle;
  final String? thumbnail;
  final String type;
  final String? videoId;
  final String? playlistId;

  Search({
    required this.title,
    this.subTitle,
    this.thumbnail,
    required this.type,
    this.videoId,
    this.playlistId,
  });

  factory Search.fromJson(Map<String, dynamic> json) {
    return Search(
      title: json['title'],
      subTitle: json['subTitle'],
      thumbnail: json['thumbnail'],
      type: json['type'],
      videoId: json['videoId'],
      playlistId: json['playlist_id'],
    );
  }

  get artistName => null;
}
