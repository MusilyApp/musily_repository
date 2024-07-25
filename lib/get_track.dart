import 'package:dart_ytmusic_api/dart_ytmusic_api.dart';
import 'package:musily_repository/generate_track_hash.dart';

Future<Map<String, dynamic>> getTrack(String trackId) async {
  final YTMusic ytMusic = YTMusic();
  await ytMusic.initialize();
  final track = await ytMusic.getSong(trackId);
  return {
    'id': track.videoId,
    'title': track.name,
    'hash': generateTrackHash(
      title: track.name,
      artist: track.artist.name,
      albumTitle: null,
    ),
    'artist': {
      'id': track.artist.artistId,
      'name': track.artist.name,
    },
    'album': {
      'id': null,
      'title': null,
    },
    'lowResImg': track.thumbnails[0].url.replaceAll('w60-h60', 'w100-h100'),
    'highResImg': track.thumbnails[0].url.replaceAll('w60-h60', 'w600-h600'),
    'source': 'YouTube'
  };
}
