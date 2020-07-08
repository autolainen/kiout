import 'package:data_model/data_model.dart';

import 'datetime/to_local_date_time.dart';
import 'exceptions/data_mismatch_exception.dart';
import 'user/user.dart';

/// Класс реализующий токен устройства для пуш уведомлений firebase
class DeviceToken extends Model<DeviceTokenId> {
  /// Идентификатор токена устройства
  DeviceTokenId id;

  /// Значение токена
  final String token;

  /// Смещение часового пояса
  int timezoneOffset;

  /// Пользователь
  UserId user;

  /// Дата обновления
  DateTime updatedAt;

  /// Создает токен устройства
  DeviceToken({this.id, this.token, this.user, this.timezoneOffset, updatedAt})
      : this.updatedAt = updatedAt?.toLocal();

  /// Создает токен устройства из JSON-данных
  factory DeviceToken.fromJson(dynamic json) {
    if (json == null) return null;

    if (json is String) {
      return DeviceToken(id: DeviceTokenId(json));
    }

    if (json is! Map) {
      throw DataMismatchException(
          'Не верный формат json у токена устройства - требуется String либо Map');
    }

    if (json['id'] != null && json['_id'] != null) {
      throw DataMismatchException(
          'Идентификатор токена устройства указан в двух атрибутах: id и _id ("${json['id']} ~ ${json['_id']}" - требуется один)');
    }

    if (json['token'] != null && json['token'] is! String) {
      throw DataMismatchException(
          'Неверный формат значения токена ("${json['token']}" - требуется String)\nВ токене устройства');
    }

    if (json['timezone_offset'] != null && json['timezone_offset'] is! int) {
      throw DataMismatchException(
          'Неверный формат смещения часового пояса ("${json['timezone_offset']}" - требуется int)\nВ токене устройства');
    }

    if (json['user'] != null && json['user'] is! String) {
      throw DataMismatchException(
          'Неверный формат пользователя ("${json['user']}" - требуется String)\nВ токене устройства');
    }

    if (json['updated_at'] != null &&
        json['updated_at'] is! String &&
        json['updated_at'] is! DateTime) {
      throw DataMismatchException(
          'Неверный формат даты создания ("${json['updated_at']}" - требуется String или DateTime)\nВ токене устройства');
    }

    DeviceTokenId id;
    if (json['_id'] != null) {
      id = DeviceTokenId(
          json['_id'] is String ? json['_id'] : json['_id']?.toHexString());
    } else {
      id = DeviceTokenId(json['id']);
    }

    return DeviceToken(
        id: id,
        user: UserId(json['user']),
        token: json['token'],
        timezoneOffset: json['timezone_offset'],
        updatedAt: toLocalDateTime(json['updated_at']));
  }

  @override
  bool operator ==(other) {
    if (other is DeviceToken) {
      return other.id == id;
    }
    return false;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => json.toString();

  /// Возвращает данные токена устройства в JSON-формате (String/Map)
  ///   String - когда в объекте был заполнен только id
  ///   Map - в ином случае
  @override
  dynamic get json {
    Map<String, dynamic> json = {
      'id': id?.json,
      'token': token,
      'timezone_offset': timezoneOffset,
      'user': user?.json,
      'updated_at': updatedAt?.toUtc(),
    }..removeWhere((key, value) => value == null);

    if (json.keys.length == 1 && json.keys.first == 'id') return json['id'];

    return json;
  }
}

/// Идентификатор токена устройства
class DeviceTokenId extends ObjectId {
  DeviceTokenId._(dynamic id) : super(id);
  factory DeviceTokenId(id) {
    if (id == null) return null;
    return DeviceTokenId._(id);
  }
}
