import 'package:musily_repository/core/domain/enums/source.dart';
import 'package:musily_repository/core/domain/entities/simplified_album_entity.dart';
import 'package:musily_repository/core/domain/entities/track_entity.dart';

abstract class ArtistEntity {
  final String id;
  final String name;
  final String? lowResImg;
  final String? highResImg;
  final List<TrackEntity> topTracks;
  final List<SimplifiedAlbumEntity> topAlbums;
  final List<SimplifiedAlbumEntity> topSingles;
  final List<ArtistEntity> similarArtists;
  final Source source;

  ArtistEntity({
    required this.id,
    required this.name,
    required this.lowResImg,
    required this.highResImg,
    required this.topTracks,
    required this.topAlbums,
    required this.topSingles,
    required this.similarArtists,
    required this.source,
  });
}
