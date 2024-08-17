import 'package:musily_repository/core/domain/enums/source.dart';
import 'package:musily_repository/core/domain/entities/album_entity.dart';
import 'package:musily_repository/core/domain/entities/simplified_artist_entity.dart';
import 'package:musily_repository/core/domain/entities/track_entity.dart';

class AlbumEntityImpl implements AlbumEntity {
  @override
  final String id;
  @override
  final String title;
  @override
  final SimplifiedArtistEntity artist;
  @override
  final int year;
  @override
  final String? lowResImg;
  @override
  final String? highResImg;
  @override
  final List<TrackEntity> tracks;
  @override
  final Source source;

  AlbumEntityImpl({
    required this.id,
    required this.title,
    required this.artist,
    required this.year,
    required this.lowResImg,
    required this.highResImg,
    required this.tracks,
    required this.source,
  });
}
