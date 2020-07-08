import 'module_permissions.dart';

/// Разрешения для модуля спецификаций
class SpecsPermissions extends ModulePermissions {
  /// Фильтры и сортировка в таблице
  bool sortAndFilterTable;

  /// Добавление спецификации
  bool addSpec;

  /// Добавление агента ДО
  bool addAgentBefore;

  /// Аннулирование спецификации
  bool cancelSpec;

  /// Редактирование спецификации
  bool editSpec;

  /// Подтверждение спецификации
  bool confirmSpec;

  SpecsPermissions(
      {this.sortAndFilterTable,
      this.addSpec,
      this.addAgentBefore,
      this.cancelSpec,
      this.confirmSpec});

  factory SpecsPermissions.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return SpecsPermissions(
        sortAndFilterTable: json['sortAndFilterTable'],
        addSpec: json['addSpec'],
        addAgentBefore: json['addAgent'],
        cancelSpec: json['cancelSpec'],
        confirmSpec: json['confirmSpec']);
  }

  Map<String, bool> get json => {
        'sortAndFilterTable': sortAndFilterTable,
        'addSpec': addSpec,
        'addAgent': addAgentBefore,
        'cancelSpec': cancelSpec,
        'confirmSpec': confirmSpec
      }..removeWhere((key, value) => value == null);
}
