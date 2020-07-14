import 'package:kiouttest/model/slack/slack_message.dart';
import 'package:data_model/data_model.dart';

import 'comment.dart';
import 'detachment/detachment.dart';
import 'exceptions/data_mismatch_exception.dart';
import 'reclamation.dart';

/// Событие, данные которого передаются через веб-сокет
class WebSocketEvent implements JsonEncodable {
  /// Тип события
  final WebSocketEventType type;

  WebSocketEvent({WebSocketEventType type}) : type = type;

  factory WebSocketEvent.fromJson(dynamic json) {
    if (json == null) return null;

    if (json is! Map) {
      throw DataMismatchException(
          'Не верный формат json у web socket event - требуется Map');
    }
    if (json['type'] != null && json['type'] is! String) {
      throw DataMismatchException(
          'Неверный формат типа ("${json['type']}" - требуется String)\nУ web socket события');
    }
    final type = WebSocketEventType(json['type']);
    if (type == WebSocketEventType.detachmentComment)
      return WsDetachmentCommentEvent.fromJson(json);
    if (type == WebSocketEventType.reclamationComment)
      return WsReclamationCommentEvent.fromJson(json);
    if (type == WebSocketEventType.slackMessage)
      return WsSlackMessageEvent.fromJson(json);

    return WebSocketEvent(type: type);
  }

  /// Возвращает данные пользователя в JSON-формате (Map)
  @override
  dynamic get json {
    Map<String, dynamic> json = {
      'type': type?.json,
    }..removeWhere((key, value) => value == null);

    return json;
  }

  @override
  String toString() => json.toString();
}

/// Веб-сокет событие нового комментария к заказ-наряду
class WsDetachmentCommentEvent extends WebSocketEvent {
  /// Идентификатор заказ-наряда
  final DetachmentId detachmentId;

  /// Новый комментарий
  final Comment comment;

  /// Создает веб-сокет событие нового комментария к заказ-наряду
  WsDetachmentCommentEvent({DetachmentId detachmentId, Comment comment})
      : detachmentId = detachmentId,
        comment = comment,
        super(type: WebSocketEventType.detachmentComment);

  /// Создает событие нового комментария к заказ-наряду из JSON данных
  factory WsDetachmentCommentEvent.fromJson(dynamic json) {
    if (json == null) return null;

    if (json['detachment_id'] == null ||
        json['detachment_id'] != null && json['detachment_id'] is! String) {
      throw DataMismatchException(
          'Неверный формат идентификатора заказ-наряда ("${json['detachment_id']}" - требуется String)\nУ веб-сокет события нового комментария к заказ-наряду');
    }

    if (json['comment'] == null ||
        json['comment'] != null && json['comment'] is! Map) {
      throw DataMismatchException(
          'Неверный формат комментария ("${json['comment']}" - требуется Map)\nУ веб-сокет события нового комментария к заказ-наряду');
    }
    Comment _comment;
    try {
      _comment = Comment.fromJson(json['comment']);
    } catch (e) {
      throw DataMismatchException((e is Error ? e.toString() : e.message) +
          '\nУ веб-сокет события нового комментария к заказ-наряду');
    }

    return WsDetachmentCommentEvent(
        detachmentId: DetachmentId(json['detachment_id']), comment: _comment);
  }

  /// Возвращает данные веб-сокет события нового комментария к заказ-наряду в JSON-формате (Map)
  @override
  dynamic get json {
    return super.json
      ..addAll({'detachment_id': detachmentId?.json, 'comment': comment?.json})
      ..removeWhere((key, value) => value == null);
  }
}

/// Веб-сокет событие нового сообщения от службы поддержки
class WsSlackMessageEvent extends WebSocketEvent {
  /// Новое сообщение
  final SlackMessage message;

  /// Создает веб-сокет событие нового сообщения от службы поддержки
  WsSlackMessageEvent(this.message)
      : super(type: WebSocketEventType.slackMessage);

  /// Создает событие нового сообщения от службы поддержки из JSON данных
  factory WsSlackMessageEvent.fromJson(dynamic json) {
    if (json == null) return null;

    if (json['message'] == null ||
        json['message'] != null && json['message'] is! Map) {
      throw DataMismatchException(
          'Неверный формат сообщения ("${json['message']}" - требуется Map)\nУ веб-сокет события нового сообщения от службы поддержки');
    }
    SlackMessage _message;
    try {
      _message = SlackMessage.fromJson(json['message']);
    } catch (e) {
      throw DataMismatchException((e is Error ? e.toString() : e.message) +
          '\nУ веб-сокет события нового сообщения от службы поддержки');
    }

    return WsSlackMessageEvent(_message);
  }

  /// Возвращает данные веб-сокет события нового сообщения от службы поддержки в JSON-формате (Map)
  @override
  dynamic get json {
    return super.json
      ..addAll({'message': message?.json})
      ..removeWhere((key, value) => value == null);
  }
}

/// Веб-сокет событие нового комментария к рекламации
class WsReclamationCommentEvent extends WebSocketEvent {
  /// Идентификатор заказ-наряда
  final DetachmentId detachmentId;

  /// Идентификатор рекламации
  final ReclamationId reclamationId;

  /// Новый комментарий
  final Comment comment;

  /// Создает веб-сокет событие нового комментария к рекламации
  WsReclamationCommentEvent(
      {DetachmentId detachmentId, ReclamationId reclamationId, Comment comment})
      : detachmentId = detachmentId,
        reclamationId = reclamationId,
        comment = comment,
        super(type: WebSocketEventType.reclamationComment);

  /// Создает событие нового комментария к рекламации из JSON данных
  factory WsReclamationCommentEvent.fromJson(dynamic json) {
    if (json == null) return null;

    if (json['reclamation_id'] == null ||
        json['reclamation_id'] != null && json['reclamation_id'] is! String) {
      throw DataMismatchException(
          'Неверный формат идентификатора рекламации ("${json['reclamation_id']}" - требуется String)\nУ веб-сокет события нового комментария к рекламации');
    }

    if (json['detachment_id'] == null ||
        json['detachment_id'] != null && json['detachment_id'] is! String) {
      throw DataMismatchException(
          'Неверный формат идентификатора заказ-наряда ("${json['detachment_id']}" - требуется String)\nУ веб-сокет события нового комментария к рекламации');
    }

    if (json['comment'] == null ||
        json['comment'] != null && json['comment'] is! Map) {
      throw DataMismatchException(
          'Неверный формат комментария ("${json['comment']}" - требуется Map)\nУ веб-сокет события нового комментария к рекламации');
    }
    Comment _comment;
    try {
      _comment = Comment.fromJson(json['comment']);
    } catch (e) {
      throw DataMismatchException((e is Error ? e.toString() : e.message) +
          '\nУ веб-сокет события нового комментария к рекламации');
    }

    return WsReclamationCommentEvent(
        reclamationId: ReclamationId(json['reclamation_id']),
        detachmentId: DetachmentId(json['detachment_id']),
        comment: _comment);
  }

  /// Возвращает данные веб-сокет события нового комментария к заказ-наряду в JSON-формате (Map)
  @override
  dynamic get json {
    return super.json
      ..addAll({
        'detachment_id': detachmentId?.json,
        'reclamation_id': reclamationId?.json,
        'comment': comment?.json
      })
      ..removeWhere((key, value) => value == null);
  }
}

/// Тип события, передающегося через веб-сокет
///
/// возможный тип события:
/// * detachmentComment - комментарий к заказ-наряду
/// * slackMessage - сообщение от службы поддержки
/// * reclamationComment - комментарий к рекламации
class WebSocketEventType implements JsonEncodable {
  /// Комментарий к заказ-наряду
  static const WebSocketEventType detachmentComment =
      WebSocketEventType._('detachmentComment');

  /// Сообщение от службы поддержки
  static const WebSocketEventType slackMessage =
      WebSocketEventType._('slackMessage');

  /// Комментарий к рекламации
  static const WebSocketEventType reclamationComment =
      WebSocketEventType._('reclamationComment');

  final String _type;

  // Создает тип веб-сокет события
  const WebSocketEventType._(String type) : _type = type;

  factory WebSocketEventType(String type) {
    if (type == null) return null;
    WebSocketEventType _curType = WebSocketEventType._(type);
    if (values.contains(_curType)) {
      return _curType;
    } else {
      throw ArgumentError('Unknown web-socket event type: ${type}.');
    }
  }

  final Map<String, String> _typeStr = const {
    'detachmentComment': 'Комментарий к заказ-наряду',
    'reclamationComment': 'Комментарий к рекламации',
    'slackMessage': 'Сообщение от службы поддержки',
  };

  String get value => _type;
  static List get values =>
      [detachmentComment, reclamationComment, slackMessage];

  @override
  bool operator ==(dynamic other) {
    if (other is WebSocketEventType) {
      return other._type == _type;
    }
    return false;
  }

  @override
  int get hashCode => _type.hashCode;

  String get json => _type;

  @override
  String toString() => _typeStr[_type];
}
