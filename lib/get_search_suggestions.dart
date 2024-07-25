import 'package:dart_ytmusic_api/yt_music.dart';

Future<List<String>> getSearchSuggestions(String query) async {
  final ytMusic = YTMusic();
  await ytMusic.initialize();
  final suggestions = await ytMusic.getSearchSuggestions(query);
  return suggestions;
}
