import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/music_provider.dart';
import '../widgets/mini_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      context.read<MusicProvider>().fetchTracks();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MusicProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jamendo Explorer'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search songs or artists...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          provider.search('');
                        },
                      )
                    : null,
                filled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
              onSubmitted: (val) => provider.search(val),
            ),
          ),
          Expanded(
            child: Builder(builder: (context) {
              if (provider.isLoading && provider.tracks.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (provider.errorMessage != null && provider.tracks.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(provider.errorMessage!),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () => provider.fetchTracks(isRefresh: true),
                        child: const Text('Retry'),
                      )
                    ],
                  ),
                );
              }

              if (provider.tracks.isEmpty) {
                return const Center(child: Text('No tracks found'));
              }

              return RefreshIndicator(
                onRefresh: () => provider.fetchTracks(isRefresh: true),
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: provider.tracks.length + (provider.hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == provider.tracks.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final track = provider.tracks[index];
                    final isSelected = provider.currentTrack?.id == track.id;

                    return ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: CachedNetworkImage(
                          imageUrl: track.albumImage,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorWidget: (_, __, ___) => const Icon(Icons.music_note),
                        ),
                      ),
                      title: Text(
                        track.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isSelected ? Colors.deepPurpleAccent : null,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      subtitle: Text(track.artistName, maxLines: 1),
                      trailing: Text(
                        '${(track.duration ~/ 60)}:${(track.duration % 60).toString().padLeft(2, '0')}',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      onTap: () => provider.playTrack(index),
                    );
                  },
                ),
              );
            }),
          ),
          const MiniPlayer(),
        ],
      ),
    );
  }
}