import 'package:dart_ytmusic_api/yt_music.dart';

Future<String?> getTrackLyrics(String trackId) async {
  final ytMusic = YTMusic();
  await ytMusic.initialize();
  try {
    final lyrics = await ytMusic.getLyrics(trackId);
    return lyrics;
  } catch (e) {
    return null;
  }
}
