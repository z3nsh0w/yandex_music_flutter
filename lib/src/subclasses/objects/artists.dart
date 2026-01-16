import 'package:yandex_music/yandex_music.dart';
import 'package:yandex_music/src/lower_level.dart';

class YandexMusicArtists {
  final YandexMusicApiAsync _api;

  YandexMusicArtists(this._api);

  /// Allows you to get all tracks of the artist
  Future<ArtistInfo> getInfo(dynamic artistId) async {
    if (artistId is UGCArtist) {
      throw YandexMusicException.argumentError(
        "Artist's class methods cannot be used with UGCArtist",
      );
    }
    if (artistId is Artist) {
      artistId = (artistId as OfficialArtist).id;
    }
    artistId = artistId.toString();

    final result = await _api.getArtistInfo('/artists/$artistId/info');
    return ArtistInfo(result);
  }

  /// Allows you to get all tracks of the artist
  Future<List<Track>> getTracks(dynamic artistId) async {
    if (artistId is UGCArtist) {
      throw YandexMusicException.argumentError(
        "Artist's class methods cannot be used with UGCArtist",
      );
    }
    if (artistId is Artist) {
      artistId = (artistId as OfficialArtist).id;
    }
    artistId = artistId.toString();

    final result = await _api.getArtistInfo('/artists/$artistId/tracks');
    return result != null
        ? (result['result']['tracks'] as List).map((t) => Track(t)).toList()
        : <Track>[];
  }

  /// Returns the recent release (Album object) of the artist
  Future<Album> getNewRelease(
    dynamic artistId, {
    CancelToken? cancelToken,
  }) async {
    if (artistId is UGCArtist) {
      throw YandexMusicException.argumentError(
        "Artist's class methods cannot be used with UGCArtist",
      );
    }
    if (artistId is Artist) {
      artistId = (artistId as OfficialArtist).id;
    }
    artistId = artistId.toString();

    final result = await _api.getArtistInfo(
      '/artists/$artistId/blocks/artist-release',
      cancelToken: cancelToken,
    );
    final rzt = await _api.getAlbum(
      result['release']['album']['id'],
      cancelToken: cancelToken,
    );
    return Album(rzt['result']);
  }

  /// Returns all studio albums of the artist
  Future<List<AlbumInfo>> getStudioAlbums(
    dynamic artistId, {
    CancelToken? cancelToken,
  }) async {
    if (artistId is UGCArtist) {
      throw YandexMusicException.argumentError(
        "Artist's class methods cannot be used with UGCArtist",
      );
    }
    if (artistId is Artist) {
      artistId = (artistId as OfficialArtist).id;
    }
    artistId = artistId.toString();

    final result = await _api.getArtistInfo(
      '/artists/$artistId/blocks/artist-studio-albums',
      cancelToken: cancelToken,
    );

    return (result['items'] as List).map((t) => AlbumInfo(t['data'])).toList();
  }

  /// Returns all studio albums of the artist
  Future<List<AlbumInfo>> getAlbums(
    dynamic artistId, {
    CancelToken? cancelToken,
  }) async {
    if (artistId is UGCArtist) {
      throw YandexMusicException.argumentError(
        "Artist's class methods cannot be used with UGCArtist",
      );
    }
    if (artistId is Artist) {
      artistId = (artistId as OfficialArtist).id;
    }
    artistId = artistId.toString();

    final result = await _api.getArtistInfo(
      '/artists/$artistId/blocks/artist-albums',
      cancelToken: cancelToken,
    );

    return (result['items'] as List).map((t) => AlbumInfo(t['data'])).toList();
  }
}
