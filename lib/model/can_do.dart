import 'package:data_model/data_model.dart';

import 'catalog_structure.dart';
import 'cemetery.dart';
import 'exceptions/data_mismatch_exception.dart';
import 'hall.dart';
import 'work_type.dart';

/// Доступный вид работ
class CanDo implements JsonEncodable {
  /// Вид работ
  WorkType category;

  /// Является ли услугой по умолчанию
  bool isDefault;

  CanDo({this.category, this.isDefault});

  factory CanDo.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    if (json['category'] != null && json['category'] is! String) {
      throw DataMismatchException(
          'Неверный формат вида работ ("${json['category']}" - требуется String)\n');
    }
    if (json['default'] != null && json['default'] is! bool) {
      throw DataMismatchException(
          'Неверный формат признака услуги по умолчанию ("${json['default']}" - требуется bool)\n');
    }

    var _category = json['category'] ?? '';

    if (CatalogStructure.cemeteryStructure.subtypes
        .contains(WorkType(_category))) {
      return CemeteryCanDo.fromJson(json);
    }

    if (CatalogStructure.farewellStructure.subtypes
        .contains(WorkType(_category))) {
      return HallCanDo.fromJson(json);
    }

    return CanDo(
        category: WorkType(json['category']), isDefault: json['default']);
  }

  get workplace => null;

  @override
  Map<String, dynamic> get json => {
        'category': category?.json,
        'default': isDefault,
      }..removeWhere((key, value) => value == null);

  @override
  String toString() => json.toString();
}

/// Доступный вид работ на кладбище
class CemeteryCanDo extends CanDo {
  /// Кладбище
  CemeteryId cemetery;

  CemeteryCanDo({this.cemetery, WorkType category, bool isDefault})
      : super(category: category, isDefault: isDefault);

  factory CemeteryCanDo.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    if (json['cemetery'] != null && json['cemetery'] is! String) {
      throw DataMismatchException(
          'Неверный формат кладбища ("${json['cemetery']}" - требуется String)\n');
    }

    return CemeteryCanDo(
        cemetery: CemeteryId(json['cemetery']),
        category: WorkType(json['category']),
        isDefault: json['default']);
  }

  @override
  get workplace => cemetery;

  @override
  Map<String, dynamic> get json => super.json
    ..addAll({'cemetery': cemetery?.json})
    ..removeWhere((key, value) => value == null);
}

/// Доступный вид работ в прощальном зале
class HallCanDo extends CanDo {
  /// Прощальный зал
  HallId hall;

  HallCanDo({this.hall, WorkType category, bool isDefault})
      : super(category: category, isDefault: isDefault);

  factory HallCanDo.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    if (json['hall'] != null && json['hall'] is! String) {
      throw DataMismatchException(
          'Неверный формат прощального зала ("${json['hall']}" - требуется String)\n');
    }

    return HallCanDo(
        hall: HallId(json['hall']),
        category: WorkType(json['category']),
        isDefault: json['default']);
  }

  @override
  get workplace => hall;

  @override
  Map<String, dynamic> get json => super.json
    ..addAll({'hall': hall?.json})
    ..removeWhere((key, value) => value == null);
}
