import 'package:data_model/data_model.dart';

import 'module_group.dart';

/// Модуль приложения
///
/// Определяет фиксированный набор констант модулей приложения
class AppModule implements JsonEncodable {
  static const specs =
      AppModule._('specs', ModuleGroup.agentsServices, 'Спецификации');
  static const agentsBf =
      AppModule._('agentsBf', ModuleGroup.directories, 'Агенты ДО');
  static const legalPersons =
      AppModule._('legalPersons', ModuleGroup.directories, 'Юридические лица');

  /// Идентификатор модуля
  final String id;

  /// Группа модуля
  final ModuleGroup group;

  /// Название модуля
  final String name;

  const AppModule._(this.id, this.group, this.name);

  /// Создает модуль по идентификатору
  ///
  /// [id] идентификатор модуля
  ///
  /// Если идентификатор совпадает с одним из предопределенных модулей, то
  /// возвращает этот модуль, иначе `null`
  factory AppModule(String id) =>
      values.firstWhere((m) => m.id == id, orElse: () => null);

  /// JSON-представление модуля
  ///
  /// Используется для передачи по сети и сохранении в БД.
  ///
  /// Каждый модуль однозначно определяется его идентификатором
  String get json => id;

  /// Список всех модулей приложения
  static const values = <AppModule>[
    specs,
    agentsBf,
    legalPersons,
  ];
}
