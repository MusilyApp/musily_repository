import 'package:musily_repository/core/domain/enums/source.dart';
import 'package:musily_repository/core/domain/entities/simplified_album_entity.dart';
import 'package:musily_repository/core/domain/entities/simplified_artist_entity.dart';
import 'package:musily_repository/core/domain/entities/track_entity.dart';

class TrackEntityImpl implements TrackEntity {
  @override
  final String id;
  @override
  final String hash;
  @override
  final String title;
  @override
  final String? lyrics;
  @override
  final SimplifiedArtistEntity artist;
  @override
  final SimplifiedAlbumEntity album;
  @override
  final String? lowResImg;
  @override
  final String? highResImg;
  @override
  final Source source;

  TrackEntityImpl({
    required this.id,
    required this.hash,
    required this.title,
    required this.lyrics,
    required this.artist,
    required this.album,
    required this.lowResImg,
    required this.highResImg,
    required this.source,
  });
}
