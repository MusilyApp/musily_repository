import 'package:dart_ytmusic_api/yt_music.dart';
import 'package:musily_repository/generate_track_hash.dart';

Future<List<Map<String, dynamic>>> getArtistTracks(String artistId) async {
  final ytMusic = YTMusic();
  await ytMusic.initialize();
  final tracks = await ytMusic.getArtistSongs(artistId);
  return [
    ...tracks.map(
      (track) => {
        'id': track.videoId,
        'title': track.name,
        'hash': generateTrackHash(
          title: track.name,
          artist: track.artist.name,
          albumTitle: track.album?.name,
        ),
        'artist': {
          'id': track.artist.artistId,
          'name': track.artist.name,
        },
        'album': {
          'id': track.album?.albumId,
          'title': track.album?.name,
        },
        'lowResImg': track.thumbnails[0].url.replaceAll('w60-h60', 'w100-h100'),
        'highResImg':
            track.thumbnails[0].url.replaceAll('w60-h60', 'w600-h600'),
        'source': 'YouTube'
      },
    ),
  ];
}
