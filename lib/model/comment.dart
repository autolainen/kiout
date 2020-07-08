import 'package:data_model/data_model.dart';

import 'attachment/attachment.dart';
import 'datetime/to_local_date_time.dart';
import 'exceptions/data_mismatch_exception.dart';
import 'user/user.dart';

/// Класс реализующий комментарии
class Comment implements Model<CommentId> {
  /// Идентификатор комментария
  CommentId id;

  /// Текст сообщения
  String message;

  /// Автор сообщения
  User user;

  /// Список вложений
  List<Attachment> attachments;

  /// Дата создания
  DateTime createdAt;

  /// Создает комментарий
  Comment(
      {this.id, DateTime createdAt, this.message, this.attachments, this.user})
      : this.createdAt = createdAt?.toLocal();

  /// Создает комментарий из JSON-данных
  factory Comment.fromJson(dynamic json) {
    if (json == null) return null;

    if (json is String) {
      return Comment(id: CommentId(json));
    }

    if (json is! Map) {
      throw DataMismatchException(
          'Не верный формат json у комментария - требуется String либо Map');
    }

    if (json['id'] != null && json['_id'] != null) {
      throw DataMismatchException(
          'Идентификатор комментария указан в двух атрибутах: id и _id ("${json['id']} ~ ${json['_id']}" - требуется один)');
    }

    if (json['message'] != null && json['message'] is! String) {
      throw DataMismatchException(
          'Неверный формат сообщения ("${json['message']}" - требуется String)\nВ комментарии id (${json['id'] ?? json['_id']})');
    }

    if (json['user'] != null &&
        json['user'] is! Map<String, dynamic> &&
        json['user'] is! String) {
      throw DataMismatchException(
          'Неверный формат автора ("${json['user']}" - требуется Map<String, dynamic>) или String\nВ комментарии id (${json['id'] ?? json['_id']})');
    }

    User _user;
    try {
      _user = User.fromJson(json['user']);
    } catch (e) {
      throw DataMismatchException(e is Error
          ? e.toString()
          : e.message + '\nВ комментарии id (${json['id'] ?? json['_id']})');
    }

    if (json['attachments'] != null && json['attachments'] is! List) {
      throw DataMismatchException(
          'Неверный формат вложений ("${json['attachments']}" - требуется String)\nВ комментарии id (${json['id'] ?? json['_id']})');
    }
    List<Attachment> _attachments = [];
    Attachment _attachment;
    try {
      if (json['attachments'] != null) {
        (json['attachments'] as List).forEach((attachment) {
          _attachment = Attachment.fromJson(attachment);
          if (_attachment != null) _attachments.add(_attachment);
        });
      }
    } catch (e) {
      throw DataMismatchException(e is Error
          ? e.toString()
          : e.message + '\nВ комментарии id (${json['id'] ?? json['_id']})');
    }

    if (json['created_at'] != null &&
        json['created_at'] is! String &&
        json['created_at'] is! DateTime) {
      throw DataMismatchException(
          'Неверный формат даты создания ("${json['created_at']}" - требуется String или DateTime)\nВ комментарии id (${json['id'] ?? json['_id']})');
    }

    CommentId id;
    if (json['_id'] != null) {
      id = CommentId(
          json['_id'] is String ? json['_id'] : json['_id']?.toHexString());
    } else {
      id = CommentId(json['id']);
    }

    return Comment(
        id: id,
        message: json['message'],
        user: _user,
        attachments: _attachments.isEmpty ? null : _attachments,
        createdAt: toLocalDateTime(json['created_at']));
  }

  @override
  String toString() => json.toString();

  @override
  bool operator ==(other) {
    if (other is Comment) {
      return other.id == id;
    }
    return false;
  }

  @override
  int get hashCode => id.hashCode;

  /// Возвращает данные персоны в JSON-формате (String/Map)
  ///   String - когда в объекте был заполнен только id
  ///   Map - в ином случае
  @override
  dynamic get json {
    Map<String, dynamic> _json = {
      'id': id?.json,
      'message': message,
      'user': user?.json,
      'attachments':
          attachments?.map((attachment) => attachment.json)?.toList(),
      'created_at': createdAt?.toUtc()
    }..removeWhere((key, value) => value == null);

    if (_json.keys.length == 1 && _json.keys.first == 'id') return _json['id'];

    return _json;
  }
}

/// Идентификатор комментария
class CommentId extends ObjectId {
  CommentId._(dynamic id) : super(id);
  factory CommentId(id) {
    if (id == null) return null;
    return CommentId._(id);
  }
}
