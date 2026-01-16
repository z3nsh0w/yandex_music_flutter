import 'package:yandex_music/yandex_music.dart';

final String token = '';
void main() async {
  final YandexMusic ym = YandexMusic(token: token);
  await ym.init();
  final result2 = await ym.usertracks.getLiked();
  final List<String?> artists = result2
      .map((toElement) => toElement.albumID)
      .toList();
  print(artists);
  for (var varr in artists) {
    if (varr != null) {
      print(varr);
      try {
        await ym.artists.getStudioAlbums(varr);
      } on YandexMusicException catch (e) {
        if (e.type != YandexMusicExceptionType.notFound) {
       
          throw e;
        }
      }
      print('success');
      print('---' * 50);
    }
  }
  // final result = await ym.artists.getInfo(4622993);
  // print(result);
}
