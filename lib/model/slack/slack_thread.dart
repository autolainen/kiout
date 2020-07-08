import 'package:aahitest/model/user/user.dart';
import 'package:data_model/data_model.dart';


import '../exceptions/data_mismatch_exception.dart';

/// Slack thread
class SlackThread extends Model<SlackThreadId> {
  /// Идентификатор треда
  SlackThreadId id;

  /// Строковый идентификатор треда вида timestamp
  String threadTimestamp;

  /// Пользователь инициировавший создание треда
  User user;

  SlackThread({this.id, this.threadTimestamp, this.user});

  /// Создает Slack thread из JSON-данных
  factory SlackThread.fromJson(dynamic json) {
    if (json == null) return null;

    if (json is String) {
      return SlackThread(id: SlackThreadId(json));
    }

    if (json['thread'] != null && json['thread'] is! String) {
      throw DataMismatchException(
          'Неверный формат идентификатора треда в чате ("${json['thread']}" - требуется String)\nУ треда Slack id: ${json['id']}');
    }
    if (json['user'] != null &&
        json['user'] is! Map<String, dynamic> &&
        json['user'] is! String) {
      throw DataMismatchException(
          'Неверный формат пользователя ("${json['user']}" - требуется Map<String, dynamic>) или String\nУ треда Slack id: (${json['id']})');
    }

    User _user;
    try {
      _user = User.fromJson(json['user']);
    } catch (e) {
      throw DataMismatchException(e is Error
          ? e.toString()
          : e.message + '\nУ треда Slack id: ${json['id']}');
    }
    return SlackThread(
        id: SlackThreadId(json['id']),
        threadTimestamp: json['thread'],
        user: _user);
  }

  @override
  String toString() => json.toString();

  /// Возвращает данные в JSON-формате
  @override
  dynamic get json {
    Map<String, dynamic> json = {
      'id': id?.json,
      'thread': threadTimestamp,
      'user': user?.json
    }..removeWhere((key, value) => value == null);

    if (json.keys.length == 1 && json.keys.first == 'id') return json['id'];

    return json;
  }
}

/// Идентификатор треда Slack
class SlackThreadId extends ObjectId {
  SlackThreadId._(dynamic id) : super(id);
  factory SlackThreadId(id) {
    if (id == null) return null;
    return SlackThreadId._(id);
  }
}
