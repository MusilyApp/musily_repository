import 'package:dart_ytmusic_api/yt_music.dart';

Future<List<Map<String, dynamic>>> getArtists(String query) async {
  try {
    final ytMusic = YTMusic();
    await ytMusic.initialize();
    final artists = await ytMusic.searchArtists(query);
    return artists
        .map(
          (artist) => {
            'id': artist.artistId,
            'name': artist.name,
            'lowResImg':
                artist.thumbnails[0].url.replaceAll('w60-h60', 'w100-h100'),
            'highResImg':
                artist.thumbnails[0].url.replaceAll('w60-h60', 'w600-h600'),
          },
        )
        .toList();
  } catch (e) {
    return [];
  }
}
