# yandex_music

An unofficial Dart library for interacting with the Yandex Music API. This package provides asynchronous access to user data, playlists, tracks, and search functionality.

## Features

- **Account Management**: Access user account information, subscription status, and settings
- **Playlist Operations**: Retrieve user playlists, playlist details, and cover art
- **Track Management**: Get liked/disliked tracks, download tracks, and access track metadata
- **Search Functionality**: Search for tracks, albums, artists, and podcasts
- **Track Downloads**: Download tracks in highest available quality
- **Recommendations**: Get playlist recommendations and similar tracks

### Installation

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  yandex_music: ^0.0.3
```

```bash
flutter pub get
```

## Usage

### Basic Setup

```dart
import 'package:yandex_music/yandex_music.dart';

void main() async {
  final ymInstance = YandexMusic(token: 'your_api_token_here');
  
  // Initialize the instance
  await ymInstance.init();
}
```

### Account Information

```dart
// Get account ID
int accountId = await ymInstance.account.getAccountID();

// Get user information
String login = await ymInstance.account.getLogin();
String displayName = await ymInstance.account.getDisplayName();
bool hasPlus = await ymInstance.account.hasPlusSubscription();

// Get all account information
Map<String, dynamic> accountInfo = await ymInstance.account.getAllAccountInformation();
```

### Working with Playlists

```dart
// Get all user playlists
List<dynamic> playlists = await ymInstance.playlists.getUsersPlaylists();

// Get specific playlist
Map<String, dynamic> playlist = await ymInstance.playlists.getPlaylist(1001);

// Get playlist cover art URL
String coverUrl = await ymInstance.playlists.getPlaylistCoverArtUrl(1001);

// Or with custom resolution 
String coverUrl = await ymInstance.playlists.getPlaylistCoverArtUrl(1001, '1000x1000');

// Get recommendations for playlist
List<dynamic> recommendations = await ymInstance.playlists.getRecomendationsForPlaylist(1001);
```

### Track Operations

```dart
// Get user's liked tracks
List<dynamic> likedTracks = await ymInstance.usertracks.getUsersLikedTracks();

// Get track download information
List<dynamic> downloadInfo = await ymInstance.tracks.getTrackDownloadInfo('trackID');

// Download track automatically
final file = File('track.mp3');
await ymInstance.tracks.downloadTrack('trackID', file);

// Get similar tracks
List<dynamic> similarTracks = await ymInstance.tracks.getSimilarTracks('trackID');
```

### Search

```dart
// Search for tracks
var trackResults = await ymInstance.search.tracks('query', 0);
print('Found ${trackResults['total']} tracks');

// Search for artists
var artistResults = await ymInstance.search.artists('artist name', 0);

// Search for albums
var albumResults = await ymInstance.search.albums('album name', 0);

// Universal search
var allResults = await ymInstance.search.all('query', 0);
```

### Error Handling

```dart
try {
  var result = await ymInstance.search.all('');
} on YandexMusicRequestException catch (error) {
  switch (error.code) {
    case 400:
      print('Bad request');
      break;
    case 404:
      print('Not found');
      break;
  }
  print('Error message: ${error.message}');
} on YandexMusicNetworkException catch (error) {
  print('Network error: ${error.message}');
}
```

## Current Limitations

This library is currently in development. The following features are not yet implemented:

- Creating or modifying playlists
- Adding/removing tracks from playlists
- Track lyrics retrieval
- Uploading custom tracks
- Advanced error handling with specific exception types

## API Token

To use this library, you need a valid Yandex Music API token. You can obtain it by:

https://yandex-music.readthedocs.io/en/main/token.html

## Contributing

This project is open for contributions. Please feel free to:

- Report bugs by creating issues
- Suggest new features
- Submit pull requests

## License

This project is licensed under the GNUv3.

## Disclaimer

This is an unofficial library and is not affiliated with Yandex. 
Use at your own risk and ensure compliance with Yandex Music's terms of service.
