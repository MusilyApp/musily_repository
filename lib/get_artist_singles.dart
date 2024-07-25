import 'package:dart_ytmusic_api/yt_music.dart';

Future<List<Map<String, dynamic>>> getArtistSingles(String artistId) async {
  final ytMusic = YTMusic();
  await ytMusic.initialize();
  final singles = await ytMusic.getArtistSingles(artistId);
  return [
    ...singles.map(
      (album) => {
        'id': album.albumId,
        'title': album.name,
        'year': album.year,
        'artist': {
          'id': album.artist.artistId,
          'name': album.artist.name,
        },
        'tracks': [],
        'lowResImg': album.thumbnails[0].url.replaceAll('w60-h60', 'w100-h100'),
        'highResImg':
            album.thumbnails[0].url.replaceAll('w60-h60', 'w600-h600'),
        'source': 'YouTube',
      },
    ),
  ];
}
