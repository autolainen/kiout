import 'package:data_model/data_model.dart';

import 'exceptions/data_mismatch_exception.dart';
import 'work_category.dart';
import 'work_type.dart';

/// Структура каталога
class CatalogStructure implements JsonEncodable {
  /// Виды работ по категории Кладбище
  static final CatalogStructure cemeteryStructure =
      CatalogStructure(type: WorkCategory.cemetery, subtypes: [
    WorkType.removal,
    WorkType.installation,
    WorkType.burial,
    WorkType.columbarium,
    WorkType.fence,
    WorkType.monuments,
    WorkType.accomplishment,
    WorkType.cemeteryGoods,
    WorkType.higherService,
    WorkType.singumator
  ]);

  /// Виды работ по категории Крематорий
  static final CatalogStructure crematoryStructure = CatalogStructure(
      type: WorkCategory.crematory,
      subtypes: [
        WorkType.cremation,
        WorkType.urnAssembly,
        WorkType.crematoryAshGiveOut
      ]);

  /// Виды работ по категории Прощальный зал
  static final CatalogStructure farewellStructure =
      CatalogStructure(type: WorkCategory.farewellHall, subtypes: [
    WorkType.ritualGoods,
    WorkType.ritualService,
    WorkType.sanitaryService,
    WorkType.registrationService,
    WorkType.ashGiveOut,
    WorkType.farewell,
    WorkType.vipHallFarewell,
    WorkType.embalming,
    WorkType.corpseStorage
  ]);

  /// Виды работ по категории Транспорт
  static final CatalogStructure transportStructure =
      CatalogStructure(type: WorkCategory.transport, subtypes: [
    WorkType.passengerTransport,
    WorkType.catafalTransport,
    WorkType.corpseTransfer,
    WorkType.ashTransfer
  ]);

  /// Виды работ по категории Агентские услуги
  static final CatalogStructure agentServiceStructure = CatalogStructure(
      type: WorkCategory.agentService, subtypes: [WorkType.collectDocuments]);

  /// Виды работ по категории Услуги ДО
  static final CatalogStructure serviceBeforeStructure = CatalogStructure(
      type: WorkCategory.serviceBefore, subtypes: [WorkType.exclusive]);

  /// Категория верхнего уровня
  final WorkCategory type;

  /// Подкатегории
  final List<WorkType> subtypes;

  /// Иформация о количестве нарядов в подкатегориях
  List<WorkTypeCount> subtypesCount;

  CatalogStructure({
    this.type,
    List<WorkType> subtypes,
    this.subtypesCount,
  }) : this.subtypes = List.unmodifiable(subtypes);

  factory CatalogStructure.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    if (json['type'] == null || json['type'] is! String) {
      throw DataMismatchException(
          'Неверный формат категории верхнего уровня ("${json['type']}" - требуется String)\nУ стуктуры каталога');
    }
    if (json['subtypes'] == null || json['subtypes'] is! List) {
      throw DataMismatchException(
          'Неверный формат подкатегорий ("${json['subtypes']}" - требуется List)\nУ стуктуры каталога');
    }
    var _subtypes = List<WorkType>.from(
        json['subtypes'].map((subtype) => WorkType(subtype)).toList());

    if (json['subtypes_count'] != null && json['subtypes_count'] is! List) {
      throw DataMismatchException(
          'Неверный формат количества нарядов в подкатегориях ("${json['subtypes_count']}" - требуется List)\nУ стуктуры каталога');
    }

    List<WorkTypeCount> _subtypesCount = [];
    WorkTypeCount _subtypeCount;
    try {
      if (json['subtypes_count'] != null) {
        (json['subtypes_count'] as List).forEach((si) {
          _subtypeCount = WorkTypeCount.fromJson(si);
          if (_subtypeCount != null) _subtypesCount.add(_subtypeCount);
        });
      }
    } catch (e) {
      throw DataMismatchException(
          e is Error ? e.toString() : e.message + '\nУ стуктуры каталога');
    }

    return CatalogStructure(
      type: WorkCategory(json['type']),
      subtypes: _subtypes,
      subtypesCount: _subtypesCount.isEmpty ? null : _subtypesCount,
    );
  }

  @override
  String toString() => json.toString();

  /// Возвращает данные структуры каталога в JSON-формате (Map)
  @override
  dynamic get json {
    Map<String, dynamic> json = {
      'type': type.json,
      'subtypes': subtypes.map((subtype) => subtype.json).toList(),
      'subtypes_count': subtypesCount?.map((sc) => sc.json)?.toList(),
    }..removeWhere((key, value) => value == null);

    return json;
  }
}

/// Информация о количестве нарядов по виду работы
class WorkTypeCount implements JsonEncodable {
  /// Вид работы
  final WorkType type;

  /// Количество
  final int count;

  const WorkTypeCount({
    this.type,
    this.count,
  });

  factory WorkTypeCount.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    if (json['type'] == null || json['type'] is! String) {
      throw DataMismatchException(
          'Неверный формат вида работ ("${json['type']}" - требуется String)\nУ информации о количестве нарядов по виду работы');
    }
    if (json['count'] == null || json['count'] is! int) {
      throw DataMismatchException(
          'Неверное количество ("${json['count']}" - требуется int)\nУ информации о количестве нарядов по виду работы');
    }

    return WorkTypeCount(
      type: WorkType(json['type']),
      count: json['count'],
    );
  }

  @override
  String toString() => json.toString();

  /// Возвращает данные структуры каталога в JSON-формате (Map)
  @override
  dynamic get json {
    Map<String, dynamic> json = {'type': type.json, 'count': count};

    return json;
  }
}
