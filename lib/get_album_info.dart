import 'package:dart_ytmusic_api/dart_ytmusic_api.dart';
import 'package:musily_repository/generate_track_hash.dart';

Future<Map<String, dynamic>> getAlbumInfo(String albumId) async {
  final ytMusic = YTMusic();
  await ytMusic.initialize();
  final album = await ytMusic.getAlbum(albumId);
  return {
    'id': album.albumId,
    'title': album.name,
    'artist': {
      'id': album.artist.artistId,
      'name': album.artist.name,
    },
    'year': album.year,
    'lowResImg': album.thumbnails[0].url.replaceAll('w60-h60', 'w100-h100'),
    'highResImg': album.thumbnails[0].url.replaceAll('w60-h60', 'w600-h600'),
    'tracks': album.songs
        .map(
          (item) => {
            'id': item.videoId,
            'title': item.name,
            'hash': generateTrackHash(
              title: item.name,
              artist: item.artist.name,
              albumTitle: item.album?.name,
            ),
            'artist': {
              'id': item.artist.artistId,
              'name': item.artist.name,
            },
            'album': {
              'id': item.album?.albumId,
              'title': item.album?.name,
            },
            'lowResImg':
                item.thumbnails[0].url.replaceAll('w60-h60', 'w100-h100'),
            'highResImg':
                item.thumbnails[0].url.replaceAll('w60-h60', 'w600-h600'),
            'source': 'YouTube'
          },
        )
        .toList(),
    'source': 'YouTube',
  };
}
