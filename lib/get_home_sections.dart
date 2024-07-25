import 'package:dart_ytmusic_api/types.dart';
import 'package:dart_ytmusic_api/yt_music.dart';
import 'package:musily_repository/musily_repository.dart';

Future<List<Map<String, dynamic>>> getHomeSections() async {
  final ytMusic = YTMusic();
  await ytMusic.initialize();

  final sections = await ytMusic.getHomeSections();

  return sections
      .map(
        (section) => {
          'id': generateTrackHash(
            title: section.title,
            artist: section.title,
          ),
          'title': section.title,
          'content': section.contents.map(
            (content) {
              if (content is AlbumDetailed) {
                return {
                  'type': 'album',
                  'id': content.albumId,
                  'title': content.name,
                  'year': content.year,
                  'artist': {
                    'id': content.artist.artistId,
                    'name': content.artist.name,
                  },
                  'tracks': [],
                  'lowResImg': content.thumbnails[0].url
                      .replaceAll('w60-h60', 'w100-h100'),
                  'highResImg': content.thumbnails[0].url
                      .replaceAll('w60-h60', 'w600-h600'),
                  'source': 'YouTube',
                };
              }
              if (content is PlaylistDetailed) {
                return {
                  'type': 'playlist',
                  'id': content.playlistId,
                  'title': content.name,
                  'artist': {
                    'id': content.artist.artistId,
                    'name': content.artist.name,
                  },
                  'tracks': [],
                  'lowResImg': content.thumbnails[0].url
                      .replaceAll('w60-h60', 'w100-h100'),
                  'highResImg': content.thumbnails[0].url
                      .replaceAll('w60-h60', 'w600-h600'),
                  'source': 'YouTube',
                };
              }
            },
          ).toList()
        },
      )
      .toList();
}
