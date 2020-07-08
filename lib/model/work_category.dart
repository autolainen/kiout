import 'package:data_model/data_model.dart';

/// Категория работ подрядчика
///
/// возможные категории работ подрядчика:
/// * agentService - агентские услуги
/// * cemetery - кладбище
/// * crematory - крематорий
/// * farewellHall - прощальный зал
/// * transport - транспорт
class WorkCategory implements JsonEncodable {
  /// Агентские услуги
  static const WorkCategory agentService = WorkCategory._('агентские услуги');

  /// Кладбище
  static const WorkCategory cemetery = WorkCategory._('кладбище');

  /// Крематорий
  static const WorkCategory crematory = WorkCategory._('крематорий');

  /// Прощальный зал
  static const WorkCategory farewellHall = WorkCategory._('прощальный зал');

  /// Транспорт
  static const WorkCategory transport = WorkCategory._('транспорт');

  /// Услуги ДО
  static const WorkCategory serviceBefore = WorkCategory._('услуги до');

  final String _category;

  // Создает тип подрядчика
  const WorkCategory._(String category) : _category = category;

  factory WorkCategory(String category) {
    if (category == null) return null;
    WorkCategory _curCategory = WorkCategory._(category);
    if (values.contains(_curCategory)) {
      return _curCategory;
    } else {
      throw ArgumentError('Unknown work category: ${category}.');
    }
  }

  String get value => _category;
  static List get values => [
        cemetery,
        crematory,
        transport,
        farewellHall,
        agentService,
        serviceBefore
      ];

  @override
  bool operator ==(dynamic other) {
    if (other is WorkCategory) {
      return other._category == _category;
    }
    return false;
  }

  @override
  int get hashCode => _category.hashCode;

  String get json => _category;

  @override
  String toString() => _category;
}
