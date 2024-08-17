import 'package:musily_repository/core/domain/enums/source.dart';
import 'package:musily_repository/core/domain/mappers/base_mapper.dart';
import 'package:musily_repository/core/data/entities/simplified_artist_entity_impl.dart';
import 'package:musily_repository/core/domain/entities/simplified_artist_entity.dart';

class SimplifiedArtistMapper implements BaseMapper<SimplifiedArtistEntity> {
  @override
  SimplifiedArtistEntity fromMap(Map<String, dynamic> map) {
    return SimplifiedArtistEntityImpl(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      highResImg: map['highResImg'],
      lowResImg: map['lowResImg'],
      source: Source.values.byName(map['source']),
    );
  }

  @override
  Map<String, dynamic> toMap(SimplifiedArtistEntity item) {
    return <String, dynamic>{
      'id': item.id,
      'name': item.name,
      'source': item.source.name,
    };
  }
}
