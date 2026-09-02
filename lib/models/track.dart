class Track {
  final String id;
  final String name;
  final String artistName;
  final String albumImage;
  final String audioUrl;
  final int duration;

  Track({
    required this.id,
    required this.name,
    required this.artistName,
    required this.albumImage,
    required this.audioUrl,
    required this.duration,
  });

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown Track',
      artistName: json['artist_name'] ?? 'Unknown Artist',
      albumImage: json['image'] ?? 'https://via.placeholder.com/150',
      audioUrl: json['audio'] ?? '',
      duration: json['duration'] ?? 0,
    );
  }
}