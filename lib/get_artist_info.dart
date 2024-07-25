import 'package:dart_ytmusic_api/yt_music.dart';
import 'package:musily_repository/generate_track_hash.dart';

Future<Map<String, dynamic>> getArtistInfo(String id) async {
  final ytMusic = YTMusic();
  await ytMusic.initialize();
  final artist = await ytMusic.getArtist(id);
  return {
    'id': artist.artistId,
    'name': artist.name,
    'lowResImg': artist.thumbnails[0].url.replaceAll('w540-h225', 'w100-h100'),
    'highResImg': artist.thumbnails[0].url.replaceAll('w540-h225', 'w600-h600'),
    'topTracks': artist.topSongs
        .map(
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
            'lowResImg':
                track.thumbnails[0].url.replaceAll('w60-h60', 'w100-h100'),
            'highResImg':
                track.thumbnails[0].url.replaceAll('w60-h60', 'w600-h600'),
            'source': 'YouTube'
          },
        )
        .toList(),
    'topAlbums': artist.topAlbums
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
        .toList(),
    'topSingles': artist.topSingles
        .map(
          (single) => {
            'id': single.albumId,
            'title': single.name,
            'year': single.year,
            'artist': {
              'id': single.artist.artistId,
              'name': single.artist.name,
            },
            'tracks': [],
            'lowResImg':
                single.thumbnails[0].url.replaceAll('w60-h60', 'w100-h100'),
            'highResImg':
                single.thumbnails[0].url.replaceAll('w60-h60', 'w600-h600'),
            'source': 'YouTube',
          },
        )
        .toList(),
    'similarArtists': artist.similarArtists
        .map(
          (similarArtist) => {
            'id': similarArtist.artistId,
            'name': similarArtist.name,
            'lowResImg': similarArtist.thumbnails[0].url
                .replaceAll('w60-h60', 'w60-h60'),
            'highResImg': similarArtist.thumbnails[0].url
                .replaceAll('w60-h60', 'w600-h600'),
          },
        )
        .toList(),
  };
}
