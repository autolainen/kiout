import 'package:data_model/data_model.dart';

import '../exceptions/data_mismatch_exception.dart';
import './slack_message.dart';

/// Ответ Slack на запрос о получении сообщений
class SlackAnswer implements JsonEncodable {
  /// Наличие ещё сообщений
  bool hasMore;

  /// Признак успешности запроса
  bool success;

  /// Идентификатор текущего положения в списке сообщений
  String nextCursor;

  /// Список сообщений
  List<SlackMessage> messages;

  SlackAnswer({this.hasMore, this.success, this.nextCursor, this.messages});

  /// Создает Slack ответ из JSON-данных
  factory SlackAnswer.fromJson(dynamic json) {
    if (json == null) return null;

    if (json is! Map) {
      throw DataMismatchException(
          'Неверный формат ответа Slack ("$json" - требуется Map)');
    }
    if (json['has_more'] != null && json['has_more'] is! bool) {
      throw DataMismatchException(
          'Неверный формат наличия ещё сообщений ("${json['has_more']}" - требуется bool) у ответа Slack');
    }
    if (json['success'] != null && json['success'] is! bool) {
      throw DataMismatchException(
          'Неверный формат признака успешности запроса ("${json['success']}" - требуется bool) у ответа Slack');
    }
    if (json['next_cursor'] != null && json['next_cursor'] is! String) {
      throw DataMismatchException(
          'Неверный формат идентификатора текущего положения в списке сообщений ("${json['next_cursor']}" - требуется String) у ответа Slack');
    }
    if (json['messages'] != null && json['messages'] is! List) {
      throw DataMismatchException(
          'Неверный формат списка сообщений ("${json['messages']}" - требуется List) у ответа Slack');
    }

    var _messages = <SlackMessage>[];
    SlackMessage _message;
    try {
      if (json['messages'] != null) {
        (json['messages'] as List).forEach((message) {
          _message = SlackMessage.fromJson(message);
          if (_message != null) _messages.add(_message);
        });
      }
    } catch (e) {
      throw DataMismatchException(
          e is Error ? e.toString() : e.message + '\nВ ответе Slack');
    }

    return SlackAnswer(
        hasMore: json['has_more'] == true,
        success: json['success'] == true,
        nextCursor: json['next_cursor'],
        messages: _messages.isEmpty ? null : _messages);
  }

  @override
  String toString() => json.toString();

  /// Возвращает данные в JSON-формате ([Map])
  @override
  Map<String, dynamic> get json => {
        'has_more': hasMore,
        'success': success,
        'next_cursor': nextCursor,
        'messages': messages?.map((message) => message.json)?.toList(),
      }..removeWhere((key, value) => value == null);
}
