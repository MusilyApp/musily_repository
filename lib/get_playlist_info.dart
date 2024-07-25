import 'package:dart_ytmusic_api/yt_music.dart';
import 'package:musily_repository/generate_track_hash.dart';

Future<Map<String, dynamic>> getPlaylistInfo(String id) async {
  final ytMusic = YTMusic();
  await ytMusic.initialize();

  final playlist = await ytMusic.getPlaylist(id);
  final tracks = await ytMusic.getPlaylistVideos(id);
  return {
    'type': 'playlist',
    'id': playlist.playlistId,
    'title': playlist.name,
    'artist': {
      'id': playlist.artist.artistId,
      'name': playlist.artist.name,
    },
    'tracks': [
      ...tracks.map(
        (track) => {
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
          'lowResImg':
              track.thumbnails[0].url.replaceAll('w60-h60', 'w100-h100'),
          'highResImg':
              track.thumbnails[0].url.replaceAll('w60-h60', 'w600-h600'),
          'source': 'YouTube'
        },
      ),
    ],
    'lowResImg': playlist.thumbnails[0].url.replaceAll('w60-h60', 'w100-h100'),
    'highResImg': playlist.thumbnails[0].url.replaceAll('w60-h60', 'w600-h600'),
    'source': 'YouTube',
  };
}
