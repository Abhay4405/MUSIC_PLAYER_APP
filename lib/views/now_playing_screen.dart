import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import '../providers/music_provider.dart';

class NowPlayingScreen extends StatelessWidget {
  const NowPlayingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MusicProvider>();
    final track = provider.currentTrack;

    if (track == null) return const Scaffold();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Now Playing', style: TextStyle(fontSize: 18)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CachedNetworkImage(
                imageUrl: track.albumImage,
                width: 280,
                height: 280,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => const Icon(Icons.music_note, size: 100),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              track.name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              track.artistName,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            ProgressBar(
              progress: provider.audioPlayer.position,
              total: provider.audioPlayer.duration ?? Duration(seconds: track.duration),
              onSeek: (duration) => provider.audioPlayer.seek(duration),
              baseBarColor: Colors.grey[700],
              progressBarColor: Colors.deepPurpleAccent,
              thumbColor: Colors.deepPurpleAccent,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  iconSize: 36,
                  icon: const Icon(Icons.skip_previous),
                  onPressed: provider.playPrevious,
                ),
                CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.deepPurpleAccent,
                  child: IconButton(
                    iconSize: 32,
                    color: Colors.white,
                    icon: Icon(provider.audioPlayer.playing ? Icons.pause : Icons.play_arrow),
                    onPressed: provider.togglePlayPause,
                  ),
                ),
                IconButton(
                  iconSize: 36,
                  icon: const Icon(Icons.skip_next),
                  onPressed: provider.playNext,
                ),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}