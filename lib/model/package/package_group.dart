import 'package:data_model/data_model.dart';
import 'package:quiver_hashcode/hashcode.dart';

import '../exceptions/data_mismatch_exception.dart';
import 'package_type.dart';

/// Группа пакетов
///
/// Например:
/// - Захоронение гробом в новый участок
/// - Захоронение урной в родственный участок
/// и т.д.
class PackageGroup implements JsonEncodable {
  static final burialCoffin = PackageGroup(
      'Захоронение гробом в новый участок', [
    PackageType.main,
    PackageType.atCemetery,
    PackageType.burial,
    PackageType.coffin
  ]);

  static final subBurialCoffin =
      PackageGroup('Захоронение гробом в родственный участок', [
    PackageType.main,
    PackageType.atCemetery,
    PackageType.subburial,
    PackageType.coffin
  ]);

  static final burialUrn = PackageGroup('Захоронение урной в новый участок', [
    PackageType.main,
    PackageType.atCemetery,
    PackageType.burial,
    PackageType.urn
  ]);

  static final subBurialUrn = PackageGroup(
      'Захоронение урной в родственный участок', [
    PackageType.main,
    PackageType.atCemetery,
    PackageType.subburial,
    PackageType.urn
  ]);

  static final burialUrnInNiche =
      PackageGroup('Захоронений урной в новую нишу', [
    PackageType.main,
    PackageType.atCemetery,
    PackageType.burial,
    PackageType.urn,
    PackageType.columbarium
  ]);

  static final subBurialUrnInNiche =
      PackageGroup('Захоронение урной в родственную нишу', [
    PackageType.main,
    PackageType.atCemetery,
    PackageType.subburial,
    PackageType.urn,
    PackageType.columbarium
  ]);

  static final cremation =
      PackageGroup('Пакеты кремации', [PackageType.cremation]);

  static final agentSevice = PackageGroup('Агентские услуги',
      [PackageType.agentService, PackageType.collectDocuments]);

  /// Название группы пакетов
  final String name;

  /// Список типов пакетов, соответствующий данной группе
  List<PackageType> types;

  /// Иформация о количестве нарядов в пакетах
  int count;

  /// Создает группу пакетов
  PackageGroup(this.name, List<PackageType> types, {this.count})
      : this.types =
            List.unmodifiable(types..sort((a, b) => a.json.compareTo(b.json))) {
    if (name == null) throw ArgumentError.notNull('PackageGroup#name');
  }

  factory PackageGroup.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    if (json['count'] != null && json['count'] is! int) {
      throw DataMismatchException(
          'Неверный формат количества нарядов ("${json['count']}" - требуется int)\nУ группы пакетов');
    }

    return PackageGroup(json['name'],
        List<PackageType>.from(json['types'].map((type) => PackageType(type))),
        count: json['count']);
  }

  @override
  int get hashCode => hashObjects(types);

  @override
  bool operator ==(other) {
    if (other is! PackageGroup) return false;
    return hashCode == other.hashCode;
  }

  Map<String, dynamic> get json => {
        'name': name,
        'types': types.map((type) => type.json).toList(),
        'count': count,
      }..removeWhere((key, value) => value == null);

  static final values = <PackageGroup>[
    burialCoffin,
    burialUrn,
    subBurialCoffin,
    subBurialUrn,
    burialUrnInNiche,
    subBurialUrnInNiche,
    cremation,
    agentSevice
  ];
}

/// Структура пакетов
class PackageStructure implements JsonEncodable {
  /// Пакеты захоронений
  static final PackageStructure burialStructure =
      PackageStructure(name: 'Пакеты захоронений', groups: [
    PackageGroup.burialCoffin,
    PackageGroup.burialUrn,
    PackageGroup.subBurialCoffin,
    PackageGroup.subBurialUrn,
    PackageGroup.burialUrnInNiche,
    PackageGroup.subBurialUrnInNiche
  ]);

  /// Пакеты кремации
  static final PackageStructure cremationStructure =
      PackageStructure(name: 'Пакеты кремации', groups: [
    PackageGroup.cremation,
  ]);

  /// Пакеты агентских услуг
  static final PackageStructure agentServiceStructure =
      PackageStructure(name: 'Пакеты агентских услуг', groups: [
    PackageGroup.agentSevice,
  ]);

  /// Название
  final String name;

  /// Группы пакетов
  final List<PackageGroup> groups;

  PackageStructure({
    this.name,
    List<PackageGroup> groups,
  }) : this.groups = List.unmodifiable(groups);

  factory PackageStructure.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    if (json['name'] == null || json['name'] is! String) {
      throw DataMismatchException(
          'Неверный формат названия ("${json['name']}" - требуется String)\nУ стуктуры пакетов');
    }
    if (json['groups'] == null || json['groups'] is! List) {
      throw DataMismatchException(
          'Неверный формат групп пакетов ("${json['groups']}" - требуется List)\nУ стуктуры пакетов');
    }

    List<PackageGroup> _groups = [];
    PackageGroup _group;
    try {
      if (json['groups'] != null) {
        (json['groups'] as List).forEach((group) {
          _group = PackageGroup.fromJson(group);
          if (_group != null) _groups.add(_group);
        });
      }
    } catch (e) {
      throw DataMismatchException(
          e is Error ? e.toString() : e.message + '\nУ стуктуры пакетов');
    }

    return PackageStructure(
      name: json['name'],
      groups: _groups.isEmpty ? null : _groups,
    );
  }

  @override
  String toString() => json.toString();

  /// Возвращает данные структуры пакетов в JSON-формате (Map)
  @override
  dynamic get json {
    Map<String, dynamic> json = {
      'name': name,
      'groups': groups?.map((group) => group.json)?.toList(),
    }..removeWhere((key, value) => value == null);

    return json;
  }
}
