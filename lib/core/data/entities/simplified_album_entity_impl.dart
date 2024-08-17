import 'package:musily_repository/core/domain/enums/source.dart';
import 'package:musily_repository/core/domain/entities/simplified_album_entity.dart';
import 'package:musily_repository/core/domain/entities/simplified_artist_entity.dart';

class SimplifiedAlbumEntityImpl implements SimplifiedAlbumEntity {
  @override
  final String id;
  @override
  final String title;
  @override
  final SimplifiedArtistEntity artist;
  @override
  final String? lowResImg;
  @override
  final String? highResImg;
  @override
  final Source source;

  SimplifiedAlbumEntityImpl({
    required this.id,
    required this.title,
    required this.artist,
    required this.lowResImg,
    required this.highResImg,
    required this.source,
  });
}
