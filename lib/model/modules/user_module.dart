import 'package:kiouttest/model/modules/legal_persons/legal_persons_module_permissions.dart';
import 'package:data_model/data_model.dart';

import './app_module.dart';
import './module_permissions.dart';
import './specifications_module_permission.dart';
import './agents_before_module_permission.dart';
import '../datetime/to_local_date_time.dart';
import '../exceptions/data_mismatch_exception.dart';
import '../user/user.dart';

/// Класс разрешений пользователя относительно модуля
class UserModule implements Model<UserModuleId> {
  /// Идентификатор
  UserModuleId id;

  /// Пользователь
  User user;

  /// Модуль
  AppModule module;

  /// Разрешения
  ModulePermissions permissions;

  /// Дата создания
  DateTime createdAt;

  /// Дата обновления
  DateTime updatedAt;

  UserModule(
      {this.id,
      this.user,
      this.module,
      this.permissions,
      DateTime createdAt,
      DateTime updatedAt})
      : this.createdAt = createdAt?.toLocal(),
        this.updatedAt = updatedAt?.toLocal();

  factory UserModule.fromJson(dynamic json) {
    if (json == null) return null;

    ModulePermissions _permissions;
    AppModule _module = AppModule(json['module']);

    try {
      if (_module == AppModule.specs)
        _permissions = SpecsPermissions.fromJson(json['permissions']);
      if (_module == AppModule.agentsBf)
        _permissions = AgentsBeforePermissions.fromJson(json['permissions']);
      if (_module == AppModule.legalPersons)
        _permissions =
            LegalPersonsModulePermissions.fromJson(json['permissions']);
    } catch (e) {
      throw DataMismatchException(e is Error
          ? e.toString()
          : e.message + '\nУ доступных модулей пользователя id: ${json['id']}');
    }
    if (json['created_at'] != null &&
        json['created_at'] is! String &&
        json['created_at'] is! DateTime) {
      throw DataMismatchException(
          'Неверный формат даты создания ("${json['created_at']}" - требуется String или DateTime)\nУ модуля пользователя id: ${json['id']}');
    }
    if (json['updated_at'] != null &&
        json['updated_at'] is! String &&
        json['updated_at'] is! DateTime) {
      throw DataMismatchException(
          'Неверный формат даты обновления ("${json['updated_at']}" - требуется String или DateTime)\nУ модуля пользователя id: ${json['id']}');
    }

    return UserModule(
        id: UserModuleId(json['id']),
        user: User.fromJson(json['user']),
        module: _module,
        permissions: _permissions,
        createdAt: toLocalDateTime(json['created_at']),
        updatedAt: toLocalDateTime(json['updated_at']));
  }

  Map<String, dynamic> get json {
    Map<String, dynamic> _permissionsJson;

    if (module == AppModule.specs)
      _permissionsJson = (permissions as SpecsPermissions).json;
    if (module == AppModule.agentsBf)
      _permissionsJson = (permissions as AgentsBeforePermissions).json;
    if (module == AppModule.legalPersons)
      _permissionsJson = (permissions as LegalPersonsModulePermissions).json;

    return {
      'id': id?.json,
      'user': user?.json,
      'module': module?.json,
      'permissions': _permissionsJson,
      'created_at': createdAt?.toUtc(),
      'updated_at': updatedAt?.toUtc()
    }..removeWhere((key, value) => value == null);
  }
}

/// Идентификатор набора доступных модулей пользователя
class UserModuleId extends ObjectId {
  UserModuleId._(dynamic id) : super(id);
  factory UserModuleId(id) {
    if (id == null) return null;
    return UserModuleId._(id);
  }
}
