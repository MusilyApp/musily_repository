import 'package:musily_repository/core/domain/enums/source.dart';
import 'package:musily_repository/core/domain/entities/simplified_album_entity.dart';
import 'package:musily_repository/core/domain/entities/artist_entity.dart';
import 'package:musily_repository/core/domain/entities/track_entity.dart';

class ArtistEntityImpl implements ArtistEntity {
  @override
  final String id;
  @override
  final String name;
  @override
  final String? lowResImg;
  @override
  final String? highResImg;
  @override
  final List<TrackEntity> topTracks;
  @override
  final List<SimplifiedAlbumEntity> topAlbums;
  @override
  final List<SimplifiedAlbumEntity> topSingles;
  @override
  final List<ArtistEntity> similarArtists;
  @override
  final Source source;

  ArtistEntityImpl({
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
