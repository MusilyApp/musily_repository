import 'package:musily_repository/core/domain/enums/source.dart';
import 'package:musily_repository/core/domain/entities/simplified_album_entity.dart';
import 'package:musily_repository/core/domain/entities/simplified_artist_entity.dart';

class TrackEntity {
  final String id;
  final String hash;
  final String title;
  final String? lyrics;
  final SimplifiedArtistEntity artist;
  final SimplifiedAlbumEntity album;
  final String? lowResImg;
  final String? highResImg;
  final Source source;

  TrackEntity({
    required this.id,
    required this.hash,
    required this.title,
    required this.artist,
    required this.album,
    required this.lowResImg,
    required this.highResImg,
    required this.source,
    required this.lyrics,
  });
}
