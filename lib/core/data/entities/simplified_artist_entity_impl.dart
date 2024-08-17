import 'package:musily_repository/core/domain/enums/source.dart';
import 'package:musily_repository/core/domain/entities/simplified_artist_entity.dart';

class SimplifiedArtistEntityImpl implements SimplifiedArtistEntity {
  @override
  final String? id;
  @override
  final String? name;
  @override
  final Source source;
  @override
  final String? highResImg;
  @override
  final String? lowResImg;

  SimplifiedArtistEntityImpl({
    required this.id,
    required this.name,
    required this.source,
    required this.highResImg,
    required this.lowResImg,
  });
}
