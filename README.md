# Jamendo Music Player App

A Flutter music player application built using the Jamendo Music API featuring track browsing, search, pagination, and synchronized audio playback.

## Features
* **Music Listing & Search**: Browse tracks with album art, artist info, and dynamic search querying[cite: 1].
* **Pagination**: Offset-based lazy loading with duplicate request prevention and end-of-list handling[cite: 1].
* **Audio Playback**: Persistent Mini Player, dedicated Now Playing screen, seek bar, and full controls (Play/Pause, Next/Prev)[cite: 1].
* **UI States**: Clean handling of loading, error, and empty result states[cite: 1].

## Architecture & State Management
* **Architecture**: Layered design separating Models, Services (API), State, and UI Widgets[cite: 1].
* **State Management**: `Provider` (`ChangeNotifier`) for reactive UI updates and decoupled `just_audio` stream management[cite: 1].

## API Configuration
* **Base URL**: `https://api.jamendo.com/v3.0`[cite: 1]
* Configure your Jamendo Client ID in `lib/services/api_service.dart`[cite: 1]:
```dart
static const String clientId = 'YOUR_JAMENDO_CLIENT_ID';