import 'package:dart_ytmusic_api/dart_ytmusic_api.dart';
import 'package:musily_repository/generate_track_hash.dart';

Future<List<Map<String, dynamic>>> searchInMusics(
  YTMusic ytMusic,
  String query,
) async {
  final tracks = await ytMusic.searchSongs(query);
  return tracks
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
      .toList();
}

Future<List<Map<String, dynamic>>> searchInVideos(
  YTMusic ytMusic,
  String query,
) async {
  final tracks = await ytMusic.searchVideos(query);
  getHash(VideoDetailed item) => generateTrackHash(
        title: item.name,
        artist: item.artist.name,
        albumTitle: null,
      );
  return tracks
      .map(
        (item) => {
          'id': item.videoId,
          'hash': getHash(item),
          'title': item.name,
          'artist': {
            'id': null,
            'name': item.artist.name,
          },
          'album': {
            'id': getHash(item),
            'name': null,
          },
          'lowResImg': item.thumbnails[0].url,
          'highResImg': item.thumbnails[0].url,
          'source': 'YouTube'
        },
      )
      .toList();
}

Future<List<Map<String, dynamic>>> getTracks(String query) async {
  final ytMusic = YTMusic();
  await ytMusic.initialize();

  try {
    final musics = await searchInMusics(ytMusic, query);
    final videos = await searchInVideos(ytMusic, query);

    final tracks = [...musics, ...videos];

    final seenHashes = <String>{};
    final uniqueTracks = tracks.where((track) {
      final hash = track['hash'] as String;
      return seenHashes.add(hash);
    }).toList();

    return uniqueTracks;
  } catch (e) {
    return [];
  }
}
