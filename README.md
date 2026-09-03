# Jamendo Music Player App

A Flutter music player application built using the Jamendo Music API featuring track browsing, search, pagination, and synchronized audio playback.

## Features
* **Music Listing & Search**: Browse tracks with album art, artist info, and dynamic search querying.
* **Pagination**: Offset-based lazy loading with duplicate request prevention and end-of-list handling.
* **Audio Playback**: Persistent Mini Player, dedicated Now Playing screen, seek bar, and full controls (Play/Pause, Next/Prev).
* **UI States**: Clean handling of loading, error, and empty result states.

## Architecture & State Management
* **Architecture**: Layered design separating Models, Services (API), State, and UI Widgets.
* **State Management**: `Provider` (`ChangeNotifier`) for reactive UI updates and decoupled `just_audio` stream management.

## API Configuration
* **Base URL**: `https://api.jamendo.com/v3.0`
* Copy `.env.example` to `.env` and set `JAMENDO_CLIENT_ID` to your Jamendo client ID.
* Keep `.env` private; it is excluded by `.gitignore`.
