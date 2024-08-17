import 'package:musily_repository/core/domain/enums/source.dart';
import 'package:musily_repository/core/domain/entities/simplified_artist_entity.dart';
import 'package:musily_repository/core/domain/entities/playlist_entity.dart';
import 'package:musily_repository/core/domain/entities/track_entity.dart';

class PlaylistEntityImpl implements PlaylistEntity {
  @override
  final String id;
  @override
  final String title;
  @override
  final SimplifiedArtistEntity artist;
  @override
  final List<TrackEntity> tracks;
  @override
  final String? lowResImg;
  @override
  final String? highResImg;
  @override
  final Source source;

  PlaylistEntityImpl({
    required this.id,
    required this.title,
    required this.artist,
    required this.tracks,
    required this.lowResImg,
    required this.highResImg,
    required this.source,
  });
}
