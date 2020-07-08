import 'package:data_model/data_model.dart';

import '../datetime/to_local_date_time.dart';
import '../exceptions/data_mismatch_exception.dart';

/// Группа пользователей
class UserGroup implements Model<UserGroupId> {
  /// Идентифиакатор группы
  UserGroupId id;

  /// Название группы
  String name;

  /// Дата создания
  DateTime createdAt;

  /// Дата обновления
  DateTime updatedAt;

  UserGroup({
    this.id,
    this.name,
    DateTime createdAt,
    DateTime updatedAt,
  })  : this.createdAt = createdAt?.toLocal(),
        this.updatedAt = updatedAt?.toLocal();

  factory UserGroup.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    if (json['name'] != null && json['name'] is! String) {
      throw DataMismatchException(
          'Неверный формат названия группы пользователей ("${json['name']}" - требуется String)\n');
    }
    if (json['created_at'] != null &&
        json['created_at'] is! String &&
        json['created_at'] is! DateTime) {
      throw DataMismatchException(
          'Неверный формат даты создания("${json['created_at']}" - требуется String или DateTime)\nУ аккаунта id: ${json['id']}');
    }
    if (json['updated_at'] != null &&
        json['updated_at'] is! String &&
        json['updated_at'] is! DateTime) {
      throw DataMismatchException(
          'Неверный формат даты обновления ("${json['updated_at']}" - требуется String или DateTime)\nУ аккаунта id: ${json['id']}');
    }

    return UserGroup(
        id: UserGroupId(json['id']),
        name: json['name'],
        createdAt: toLocalDateTime(json['created_at']),
        updatedAt: toLocalDateTime(json['updated_at']));
  }

  @override
  Map<String, dynamic> get json => {
        'id': id?.json,
        'name': name,
        'created_at': createdAt?.toUtc(),
        'updated_at': updatedAt?.toUtc()
      }..removeWhere((key, value) => value == null);

  @override
  String toString() => json.toString();
}

/// Идентификатор группы пользователей
class UserGroupId extends ObjectId {
  UserGroupId._(dynamic id) : super(id);
  factory UserGroupId(id) {
    if (id == null) return null;
    return UserGroupId._(id);
  }
}
