import 'package:musily_repository/core/domain/enums/source.dart';
import 'package:musily_repository/core/domain/entities/home_section_entity.dart';

class HomeSectionEntityImpl implements HomeSectionEntity {
  @override
  final String id;
  @override
  final String title;
  @override
  final List<dynamic> content;
  @override
  final Source source;

  HomeSectionEntityImpl({
    required this.id,
    required this.title,
    required this.content,
    required this.source,
  });
}
