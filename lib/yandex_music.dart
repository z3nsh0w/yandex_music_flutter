import 'src/lower_level.dart' as main_library;

// This file is a header for the main API which is located in lower_level.dart

/// Asynchronous library based on the official Yandex Music API.
///
/// Usage example:
///```dart
/// import 'package:yandex_music/yandex_music.dart';
///
/// YandexMusic ymInstance = YandexMusic(token: ‘’)
///
/// await ymInstance.init();
/// // Usage eg
/// int accountID = ymInstance.account.getAccountID();
/// List playlists = ymInstance.playlists.getUsersPlaylists();
///```
///
///---
///
/// Attention! The library is not ready at this time. Currently, you can only access all the basic methods. It is not possible to create or modify playlists, tracks, etc.
///
/// Unfortunately, I am unable to complete it at this time. Release in September.

class YandexMusic {
  final String _token;

  YandexMusic({required String token}) : _token = token;

  bool _initalize = false;

  late final _api;
  late final Map<String, dynamic> _userInfo;
  late final int _accountID;

  late final _YandexMusicAccount account;
  late final _YandexMusicPlaylists playlists;
  late final _YandexMusicTracks usertracks;
  late final _YandexMusicTrack tracks;
  late final _YandexMusicSearch search;

  Future<dynamic> init() async {
    _api = main_library.YandexMusicApiAsync(token: _token);
    _userInfo = await _api.getAccountInformation();
    try {
      _accountID = _userInfo['result']['account']['uid'];
      _initalize = true;
    } on TypeError {
      throw main_library.YandexMusicRequestException(
        'Account ID was not found, but it is required. The token is most likely invalid. Server raw: $_userInfo',
      );
    }
    account = _YandexMusicAccount(this);
    playlists = _YandexMusicPlaylists(this);
    usertracks = _YandexMusicTracks(this);
    tracks = _YandexMusicTrack(this);
    search = _YandexMusicSearch(this);
  }

  Future<void> checkInit() async {
    if (!_initalize) {throw _api.YandexMusicInitalizationError('The class was not initialized before it was used!');}
  }
}

class _YandexMusicAccount {
  final YandexMusic _parentClass;
  _YandexMusicAccount(this._parentClass);

  /// Provides the user ID of the account
  Future<int> getAccountID() async {
    return _parentClass._accountID;
  }

  /// Provides user login
  Future<String> getLogin() async {
    return _parentClass._userInfo['result']['account']['login'];
  }

  /// Provides user full name (First and Last Name)
  Future<String> getFullName() async {
    return _parentClass._userInfo['result']['account']['fullName'];
  }

  /// Provides user display name (nickname)
  Future<String> getDisplayName() async {
    return _parentClass._userInfo['result']['account']['displayName'];
  }

  /// Provides all account information
  Future<Map<String, dynamic>> getAllAccountInformation() async {
    return _parentClass._userInfo['result'];
  }

  /// Provides plus subscription info
  Future<bool> hasPlusSubscription() async {
    return _parentClass._userInfo['result']['plus']['hasPlus'];
  }

  /// Provides user email adress
  Future<String> getUserEmail() async {
    return _parentClass._userInfo['result']['defaultEmail'];
  }

  /// Provides user's account settings
  Future<Map<String, dynamic>> getUserAccountSettings() async {
    var a = await _parentClass._api.getAccountSettings();
    return a['result'];
  }
}

class _YandexMusicPlaylists {
  final YandexMusic _parentClass;
  _YandexMusicPlaylists(this._parentClass);

  /// Returns the playlist's cover art (specifically, the custom cover art if it has one, or the cover art of the last track inside the playlist).
  ///
  /// You can choose the size of the cover. By default, it is 300x300. The cover size is specified in square format, multiple of 10 (50x50, 300x300, 1000x1000, etc.).
  Future<String> getPlaylistCoverArtUrl(
    int kind, [
    String imageSize = '300x300',
  ]) async {
    var playlistInfo = await _parentClass._api.getPlaylist(
      _parentClass._accountID,
      kind,
    );
    var cover = playlistInfo['result']['cover'];

    if (cover == null) return '';

    String? type = cover['type'];

    if (type == 'pic' && cover['uri'] != null) {
      String uri = cover['uri'].toString();
      return 'https://${uri.replaceAll('%%', imageSize)}';
    } else if (type == 'mosaic' && cover['itemsUri'] != null) {
      List<dynamic> itemsUri = cover['itemsUri'];
      if (itemsUri.isNotEmpty) {
        String firstUri = itemsUri[0].toString();
        return 'https://${firstUri.replaceAll('%%', imageSize)}';
      }
    }

    return '';
  }

  /// Provides user's playlist from kind number
  Future<Map<String, dynamic>> getPlaylist(int kind) async {
    var playlistInfo = await _parentClass._api.getPlaylist(
      _parentClass._accountID,
      kind,
    );
    return playlistInfo['result'];
  }

  /// Provides all user's playlists
  ///
  /// Warning! It doesn't provides user's liked tracks!
  Future<List<dynamic>> getUsersPlaylists() async {
    var playlists = await _parentClass._api.getUsersPlaylists(
      _parentClass._accountID,
    );
    return playlists['result'];
  }

  /// Provides multiple user's playlists from kind's number
  ///
  /// Example: getMultiplePlaylists([1011, 1009]);
  Future<List<dynamic>> getMultiplePlaylists(List kinds) async {
    var playlists = await _parentClass._api.getMultiplePlaylists(
      _parentClass._accountID,
      kinds,
    );
    return playlists['result'];
  }

  /// Provides a list of tracks that fit this playlist
  Future<List<dynamic>> getRecomendationsForPlaylist(int kind) async {
    var recomendations = await _parentClass._api.getPlaylistRecommendations(
      _parentClass._accountID,
      kind,
    );
    return recomendations['result']['tracks'];
  }
}

class _YandexMusicTracks {
  final YandexMusic _parentClass;

  _YandexMusicTracks(this._parentClass);

  /// Provides user's disliked tracks
  Future<List<dynamic>> getUsersDislikedTracks() async {
    var dislikedTracks = await _parentClass._api.getUsersDislikedTracks(
      _parentClass._accountID,
    );
    return dislikedTracks['result']['library']['tracks'];
  }

  /// Provides a list of user's liked tracks
  Future<List<dynamic>> getUsersLikedTracks() async {
    var likedTracks = await _parentClass._api.getUsersLikedTracks(
      _parentClass._accountID,
    );
    return likedTracks['result']['library']['tracks'];
  }
}

class _YandexMusicTrack {
  final YandexMusic _parentClass;
  _YandexMusicTrack(this._parentClass);

  /// Provides track's download info
  ///
  /// The link is stored in downloadInfoUrl
  ///
  /// Warning! The link is available for viewing only once. After that it becomes unavailable
  Future<List<dynamic>> getTrackDownloadInfo(String trackID) async {
    var downloadInfo = await _parentClass._api.getTrackDownloadInfo(
      _parentClass._accountID,
      trackID,
    );
    return downloadInfo['result'];
  }

  /// Provides download link of track
  ///
  /// To use you need to use the getTrackDownloadInfo method, inside which, based on the quality you have chosen, you will receive downloadInfoUrl which you need to pass here
  Future<String> getTrackDownloadLink(String downloadInfoURL) async {
    var downloadLink = await _parentClass._api.getTrackDownloadLink(
      downloadInfoURL,
    );
    return downloadLink;
  }

  // Downloads track automatically in highest quality
  //
  // Example:
  // ```dart
  // final file = File('track.mp3');
  // await yandexMusicInstance.tracks.downloadTrack('12345', file);
  // ```
  //
  // Throws [YandexMusicRequestException] if track not found
  // Throws [YandexMusicNetworkException] if network error occurs
  //
  // To download a track in a different quality or format, use the getTrackDownloadInfo function (with which you will get information about available download formats) and getTrackDownloadLink (to get a link to download the track)
  // Future<dynamic> downloadTrack(String trackID, File trackFile) async {
  //   var downloadInfo = await _parentClass.api.getTrackDownloadInfo(
  //     _parentClass.accountID,
  //     trackID,
  //   );
  //   var downloadLink = await _parentClass.api.getTrackDownloadLink(
  //     downloadInfo['result'][0]['downloadInfoUrl'],
  //   );
  //   await _parentClass.api.downloadTrack(trackFile, downloadLink);
  // }

  /// Provides additional information about the track (for example, microvideo, lyrics, etc.)
  Future<Map<String, dynamic>> getAdditionalTrackInfo(String trackId) async {
    var info = await _parentClass._api.getAdditionalInformationOfTrack(
      _parentClass._accountID,
      trackId,
    );
    return info['result'];
  }

  /// Provides similar tracks for a specific track
  Future<List<dynamic>> getSimilarTracks(String trackId) async {
    var similar = await _parentClass._api.getSimilarTracks(
      _parentClass._accountID,
      trackId,
    );
    return similar['result']['similarTracks'];
  }

  /// Provides information about multiple tracks in one request.
  ///
  /// Requires a list with clean track IDs
  Future<List<dynamic>> getTracks(List trackIds) async {
    var tracks = await _parentClass._api.getTracks(
      _parentClass._accountID,
      trackIds,
    );
    return tracks['result'];
  }
}

class _YandexMusicSearch {
  final YandexMusic _parentClass;
  _YandexMusicSearch(this._parentClass);

  /// Provides a track search by a custom query.
  ///
  /// Accepts a query string, page number (from 0 to *) and correction.
  ///
  /// ---
  ///
  /// Returns:
  ///
  /// number of found tracks       : search.tracks()['total']
  ///
  /// number of tracks per page    : search.tracks()['perPage']
  ///
  /// query result (found tracks)  : search.tracks()['results']
  Future<dynamic> tracks(String query, int page, [noCorrent = false]) async {
    var result = await _parentClass._api.search(query, page, 'track', noCorrent);
    return result['result']['tracks'];
  }

  /// Provides a track search by a custom query.
  ///
  /// Accepts a query string, page number (from 0 to *) and correction.
  ///
  /// ---
  ///
  /// Returns:
  ///
  /// number of found podcasts       : search.podcasts()['total']
  ///
  /// number of podcasts per page    : search.podcasts()['perPage']
  ///
  /// query result (found podcasts)  : search.podcasts()['results']
  Future<dynamic> podcasts(String query, int page, [noCorrent = false]) async {
    var result = await _parentClass._api.search(
      query,
      page,
      'podcast',
      noCorrent,
    );
    return result['result']['podcasts'];
  }

  /// Provides a track search by a custom query.
  ///
  /// Accepts a query string, page number (from 0 to *) and correction.
  ///
  /// ---
  ///
  /// Returns:
  ///
  /// number of found artists      : search.artists()['total']
  ///
  /// number of artists per page    : search.artists()['perPage']
  ///
  /// query result (found artists)  : search.artists()['results']
  Future<dynamic> artists(String query, int page, [noCorrent = false]) async {
    var result = await _parentClass._api.search(
      query,
      page,
      'artist',
      noCorrent,
    );
    return result['result']['artists'];
  }

  /// Provides a track search by a custom query.
  ///
  /// Accepts a query string, page number (from 0 to *) and correction.
  ///
  /// ---
  ///
  /// Returns:
  ///
  /// number of found albums       : search.albums()['total']
  ///
  /// number of albums per page    : search.albums()['perPage']
  ///
  /// query result (found albums)  : search.albums()['results']
  Future<dynamic> albums(String query, int page, [noCorrent = false]) async {
    var result = await _parentClass._api.search(query, page, 'album', noCorrent);
    return result['result']['albums'];
  }

  /// Combines all search classes (tracks, podcasts, artists, albums)
  ///
  /// ---
  ///
  /// Returns:
  /// best - the most relevant search result with type track
  ///
  /// search.all()['best']['type'] - type of the best result ('track' in this case)
  ///
  /// search.all()['best']['result'] - complete track data (id, title, artists, albums, coverUri, duration, etc.)
  ///
  /// search.all()['best']['result']['albums'] - array of albums containing this track
  ///
  /// ---
  ///
  /// Other search results:
  ///
  /// search.all()['artists'] - array of found artists
  ///
  /// search.all()['artists']['total'] - total number of found artists
  ///
  /// search.all()['artists']['perPage'] - number per page
  ///
  /// search.all()['artists']['results'] - array of artists with data (name, genres, counts, ratings, etc.)
  ///
  /// search.all()['podcast_episodes'] - array of found podcast episodes
  ///
  /// search.all()['podcast_episodes']['total'] - total number of found episodes
  ///
  /// search.all()['podcast_episodes']['perPage'] - number per page
  ///
  /// search.all()['podcast_episodes']['results'] - array of episodes with data (title, duration, description, etc.)
  ///
  ///  ---
  /// Raises
  ///
  /// YandexMusicRequestException - Error related to request.
  /// The error code can be obtained using the method Error.code
  /// The error code is the state of the html request
  /// 
  ///
  ///  YandexMusicNetworkException - Request failed. Network problem.
  /// 
  ///  /// Eg. 
  /// ```dart
  /// try {
  ///   Map result = await YandexMusicInstance.search.all(''); // This request will return error code 400
  /// } on YandexMusicRequestException catch (error) {
  ///   switch (error.code) {
  ///   case 400:
  ///     logger.e('Bad request. The request was not completed correctly.');
  ///
  ///   case 404:
  ///     logger.e('But nobody came...');
  /// }
  /// // You can also get the message returned by the library
  ///   logger.e(error.message);
  /// } on YandexMusicNetworkException catch (error) {
  ///   logger.e('Request failed. Network problem.');
  ///   logger.e('${error.message} ${error.code}');
  /// }
  /// ``` 
  ///
  Future<dynamic> all(String query, int page, [noCorrent = false]) async {
    var result = await _parentClass._api.search(query, page, 'all', noCorrent);
    return result['result'];
  }
}

// GETTING TRACK LYRICS
// POST REQUESTS
// CREATING PLAYLISTS, ADDING TRACKS ETC
// UPLOADING CUSTOM TRACKS ON YM SERVERS
// MORE DETAILED ERRORS (
// YandexMusicInvalidTokenException
// YandexMusicUnauthorizedException
// YandexMusicNotFoundException
// YandexMusicBadRequestException etc. 
// Maybe errors like this: YandexMusicException.InvalidToken, YandexMusicException.BadRequest ETC
//)
// 
// MORE CORRECT IMPLEMENTAION OF LOWER_LEVEL
// REVISED RETURN FORMAT (
// There will no longer be raw returns from the server. All results will be rewritten and accessible by class.
// EG Instance.account.getUserAccountSettings().theme or Instance.account.settings.theme
//)
// AND MORE, AND MORE, AND MORE
// Provides full lyrics with timecodes for a specific trac
// Will be implemented later
// Future<dynamic> getTrackLyrics(String trackId) async {
//   var lyrics = await api.getTrackLyrics(trackId);
//   return lyrics;
// }