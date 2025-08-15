import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:xml/xml.dart' as xml;
import 'dart:io';
import 'package:crypto/crypto.dart';

abstract class YandexMusicException implements Exception {
  final String message;
  final int? code;

  YandexMusicException(this.message, {this.code});

  @override
  String toString() =>
      'YandexMusicException: $message${code != null ? ' (Code: $code)' : ''}';
}

class YandexMusicNetworkException extends YandexMusicException {
  YandexMusicNetworkException(super.message, {super.code});
}

class YandexMusicRequestException extends YandexMusicException {
  YandexMusicRequestException(super.message, {super.code});
}

class YandexMusicInitalizationError extends YandexMusicException {
  YandexMusicInitalizationError(super.message);
}

class ParseException extends YandexMusicException {
  ParseException(super.message);
}

class YandexMusicApiAsync {
  final String token;

  static const baseUrl = 'https://api.music.yandex.net';

  final dio = Dio(BaseOptions(validateStatus: (status) => true));

  YandexMusicApiAsync({required this.token});

  /// Provides full information about the user account
  Future<Map<String, dynamic>> getAccountInformation() async {
    try {
      final response = await dio.get(
        '$baseUrl/account/status',
        options: Options(
          headers: {
            'Authorization': 'OAuth $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode != 200) {
        throw YandexMusicRequestException(
          'Request Failed. Error: ${response.statusMessage}',
          code: response.statusCode,
        );
      } else {
        return response.data;
      }
    } on DioException catch (e) {
      throw YandexMusicNetworkException(
        'Request Failed. Network Error: ${e.message}',
        code: e.response?.statusCode,
      );
    }
  }

  Future<Map<String, dynamic>> getAccountSettings() async {
    try {
      final response = await dio.get(
        '$baseUrl/account/settings',
        options: Options(
          headers: {
            'Authorization': 'OAuth $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode != 200) {
        throw YandexMusicRequestException(
          'Request Failed. Error: ${response.statusMessage}',
          code: response.statusCode,
        );
      } else {
        return response.data;
      }
    } on DioException catch (e) {
      throw YandexMusicNetworkException(
        'Request Failed. Network Error: ${e.message}',
        code: e.response?.statusCode,
      );
    }
  }

  Future<dynamic> getUsersPlaylists(int userId) async {
    try {
      final response = await dio.get(
        '$baseUrl/users/$userId/playlists/list',
        options: Options(
          headers: {
            'Authorization': 'OAuth $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode != 200) {
        throw YandexMusicRequestException(
          'Request Failed. Error: ${response.statusMessage}',
          code: response.statusCode,
        );
      } else {
        return response.data;
      }
    } on DioException catch (e) {
      throw YandexMusicNetworkException(
        'Request Failed. Network Error: ${e.message}',
        code: e.response?.statusCode,
      );
    }
  }

  Future<dynamic> getUsersDislikedTracks(int userId) async {
    try {
      final response = await dio.get(
        '$baseUrl/users/$userId/dislikes/tracks',
        options: Options(
          headers: {
            'Authorization': 'OAuth $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode != 200) {
        throw YandexMusicRequestException(
          'Request Failed. Error: ${response.statusMessage}',
          code: response.statusCode,
        );
      } else {
        return response.data;
      }
    } on DioException catch (e) {
      throw YandexMusicNetworkException(
        'Request Failed. Network Error: ${e.message}',
        code: e.response?.statusCode,
      );
    }
  }

  Future<dynamic> getPlaylist(int userId, int playlistKind) async {
    try {
      final response = await dio.get(
        '$baseUrl/users/$userId/playlists/$playlistKind',
        options: Options(
          headers: {
            'Authorization': 'OAuth $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode != 200) {
        throw YandexMusicRequestException(
          'Request Failed. Error: ${response.statusMessage}',
          code: response.statusCode,
        );
      } else {
        return response.data;
      }
    } on DioException catch (e) {
      throw YandexMusicNetworkException(
        'Request Failed. Network Error: ${e.message}',
        code: e.response?.statusCode,
      );
    }
  }

  Future<dynamic> getMultiplePlaylists(int userId, List kinds) async {
    try {
      final response = await dio.get(
        '$baseUrl/users/$userId/playlists',
        queryParameters: {
          'userId': userId,
          'kinds': kinds.join(','),
          'mixed': true,
          'rich-tracks': false,
        },
        options: Options(
          headers: {
            'Authorization': 'OAuth $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode != 200) {
        throw YandexMusicRequestException(
          'Request Failed. Error: ${response.statusMessage}',
          code: response.statusCode,
        );
      } else {
        return response.data;
      }
    } on DioException catch (e) {
      throw YandexMusicNetworkException(
        'Request Failed. Network Error: ${e.message}',
        code: e.response?.statusCode,
      );
    }
  }

  Future<dynamic> getPlaylistRecommendations(int userId, int playlistKind) async {
    try {
      final response = await dio.get(
        '$baseUrl/users/$userId/playlists/$playlistKind/recommendations',
        options: Options(
          headers: {
            'Authorization': 'OAuth $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode != 200) {
        throw YandexMusicRequestException(
          'Request Failed. Error: ${response.statusMessage}',
          code: response.statusCode,
        );
      } else {
        return response.data;
      }
    } on DioException catch (e) {
      throw YandexMusicNetworkException(
        'Request Failed. Network Error: ${e.message}',
        code: e.response?.statusCode,
      );
    }
  }

  Future<dynamic> getUsersLikedTracks(int userId) async {
    try {
      final response = await dio.get(
        '$baseUrl/users/$userId/likes/tracks',
        options: Options(
          headers: {
            'Authorization': 'OAuth $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode != 200) {
        throw YandexMusicRequestException(
          'Request Failed. Error: ${response.statusMessage}',
          code: response.statusCode,
        );
      } else {
        return response.data;
      }
    } on DioException catch (e) {
      throw YandexMusicNetworkException(
        'Request Failed. Network Error: ${e.message}',
        code: e.response?.statusCode,
      );
    }
  }

  Future<dynamic> getTrackDownloadInfo(int userId, String trackID) async {
    try {
      final response = await dio.get(
        '$baseUrl/tracks/$trackID/download-info',
        options: Options(
          headers: {
            'Authorization': 'OAuth $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode != 200) {
        throw YandexMusicRequestException(
          'Request Failed. Error: ${response.statusMessage}',
          code: response.statusCode,
        );
      } else {
        return response.data;
      }
    } on DioException catch (e) {
      throw YandexMusicNetworkException(
        'Request Failed. Network Error: ${e.message}',
        code: e.response?.statusCode,
      );
    }
  }

  Future<dynamic> getTrackDownloadLink(String downloadInfoUrl) async {
    try {
      final response = await dio.get(
        downloadInfoUrl,
        options: Options(
          headers: {
            'Authorization': 'OAuth $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode != 200) {
        throw YandexMusicRequestException(
          'Request Failed. Error: ${response.statusMessage}',
          code: response.statusCode,
        );
      } else {
        final xmlDoc = xml.XmlDocument.parse(response.data);

        final host = xmlDoc.findAllElements('host').first.text;
        final path = xmlDoc.findAllElements('path').first.text;
        final ts = xmlDoc.findAllElements('ts').first.text;
        final s = xmlDoc.findAllElements('s').first.text;

        const signSalt = 'XGRlBW9FXlekgbPrRHuSiA';
        final signData = signSalt + path.substring(1) + s;
        final signBytes = utf8.encode(signData);
        final sign = md5.convert(signBytes).toString();

        final directLink = 'https://$host/get-mp3/$sign/$ts$path';
        return directLink;
      }
      
    } on DioException catch (e) {
      throw YandexMusicNetworkException(
        'Request Failed. Network Error: ${e.message}',
        code: e.response?.statusCode,
      );
    }
  }

  Future<void> downloadTrack(File trackFile, String downloadLink) async {
    try {
      final response = await dio.get(
        downloadLink,
        options: Options(
          headers: {
            'Authorization': 'OAuth $token',
          },
          responseType: ResponseType.bytes,
        ),
      );

      if (response.statusCode != 200) {
        throw YandexMusicRequestException(
          'Request Failed. Error: ${response.statusMessage}',
          code: response.statusCode,
        );
      } else {
        await trackFile.writeAsBytes(response.data);
      }
    } on DioException catch (e) {
      throw YandexMusicNetworkException(
        'Request Failed. Network Error: ${e.message}',
        code: e.response?.statusCode,
      );
    }
  }

  Future<dynamic> getAdditionalInformationOfTrack(int userId, String trackID) async {
    try {
      final response = await dio.get(
        '$baseUrl/tracks/$trackID/supplement',
        options: Options(
          headers: {
            'Authorization': 'OAuth $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode != 200) {
        throw YandexMusicRequestException(
          'Request Failed. Error: ${response.statusMessage}',
          code: response.statusCode,
        );
      } else {
        return response.data;
      }
    } on DioException catch (e) {
      throw YandexMusicNetworkException(
        'Request Failed. Network Error: ${e.message}',
        code: e.response?.statusCode,
      );
    }
  }

  Future<dynamic> getSimilarTracks(int userId, String trackID) async {
    try {
      final response = await dio.get(
        '$baseUrl/tracks/$trackID/similar',
        options: Options(
          headers: {
            'Authorization': 'OAuth $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode != 200) {
        throw YandexMusicRequestException(
          'Request Failed. Error: ${response.statusMessage}',
          code: response.statusCode,
        );
      } else {
        return response.data;
      }
    } on DioException catch (e) {
      throw YandexMusicNetworkException(
        'Request Failed. Network Error: ${e.message}',
        code: e.response?.statusCode,
      );
    }
  }

  Future<dynamic> getTracks(int userId, List trackIds) async {
    try {
      final response = await dio.get(
        '$baseUrl/tracks',
        queryParameters: {
          'track-ids': trackIds,
          'with-positions': 'false'
                  },
        options: Options(
          headers: {
            'Authorization': 'OAuth $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode != 200) {
        throw YandexMusicRequestException(
          'Request Failed. Error: ${response.statusMessage}',
          code: response.statusCode,
        );
      } else {
        return response.data;
      }
    } on DioException catch (e) {
      throw YandexMusicNetworkException(
        'Request Failed. Network Error: ${e.message}',
        code: e.response?.statusCode,
      );
    }
  }

  Future<dynamic> search(String query, int page, String type, bool noCorrect) async {
    try {
      final response = await dio.get(
        '$baseUrl/search',
        queryParameters: {
          'text': query,
          'page': page,
          'type': type,
          'nocorrect': noCorrect,
                  },
        options: Options(
          headers: {
            'Authorization': 'OAuth $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode != 200) {
        throw YandexMusicRequestException(
          'Request Failed. Error: ${response.statusMessage}',
          code: response.statusCode,
        );
      } else {
        return response.data;
      }
    } on DioException catch (e) {
      throw YandexMusicNetworkException(
        'Request Failed. Network Error: ${e.message}',
        code: e.response?.statusCode,
      );
    }
  }


}