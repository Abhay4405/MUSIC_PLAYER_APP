import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../models/track.dart';
import '../services/api_service.dart';

class MusicProvider extends ChangeNotifier {
  final AudioPlayer audioPlayer = AudioPlayer();

  List<Track> _tracks = [];
  List<Track> get tracks => _tracks;

  int _currentIndex = -1;
  Track? get currentTrack => _currentIndex >= 0 && _currentIndex < _tracks.length ? _tracks[_currentIndex] : null;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _hasMore = true;
  bool get hasMore => _hasMore;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String _searchQuery = '';
  int _offset = 0;
  final int _limit = 20;

  MusicProvider() {
    fetchTracks();
    audioPlayer.playerStateStream.listen((_) => notifyListeners());
    audioPlayer.positionStream.listen((_) => notifyListeners());
    audioPlayer.durationStream.listen((_) => notifyListeners());
    
    // Auto next track on completion
    audioPlayer.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        playNext();
      }
    });
  }

  Future<void> fetchTracks({bool isRefresh = false}) async {
    if (_isLoading) return; // Prevent duplicate requests
    if (isRefresh) {
      _offset = 0;
      _tracks.clear();
      _hasMore = true;
    }
    if (!_hasMore) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newTracks = await ApiService.getTracks(
        offset: _offset,
        limit: _limit,
        query: _searchQuery,
      );

      if (newTracks.length < _limit) {
        _hasMore = false; // End of list handled
      }

      _tracks.addAll(newTracks);
      _offset += newTracks.length;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void search(String query) {
    _searchQuery = query.trim();
    fetchTracks(isRefresh: true);
  }

  Future<void> playTrack(int index) async {
    if (index < 0 || index >= _tracks.length) return;
    _currentIndex = index;
    notifyListeners();

    try {
      await audioPlayer.stop();
      await audioPlayer.setUrl(_tracks[_currentIndex].audioUrl);
      audioPlayer.play();
    } catch (e) {
      _errorMessage = "Playback failed: $e";
      notifyListeners();
    }
  }

  void togglePlayPause() {
    if (audioPlayer.playing) {
      audioPlayer.pause();
    } else {
      audioPlayer.play();
    }
  }

  void playNext() {
    if (_currentIndex + 1 < _tracks.length) {
      playTrack(_currentIndex + 1);
    }
  }

  void playPrevious() {
    if (_currentIndex - 1 >= 0) {
      playTrack(_currentIndex - 1);
    }
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }
}