import 'package:dart_ytmusic_api/dart_ytmusic_api.dart';

Future<List<Map<String, dynamic>>> getAlbums(String query) async {
  try {
    final ytMusic = YTMusic();
    await ytMusic.initialize();
    final albums = await ytMusic.searchAlbums(query);
    return albums
        .map(
          (album) => {
            'id': album.albumId,
            'title': album.name,
            'year': album.year,
            'artist': {
              'id': album.artist.artistId,
              'name': album.artist.name,
            },
            'tracks': [],
            'lowResImg':
                album.thumbnails[0].url.replaceAll('w60-h60', 'w100-h100'),
            'highResImg':
                album.thumbnails[0].url.replaceAll('w60-h60', 'w600-h600'),
            'source': 'YouTube',
          },
        )
        .toList();
  } catch (e) {
    return [];
  }
}
