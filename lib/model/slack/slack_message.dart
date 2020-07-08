
import 'package:aahitest/model/attachment/attachment.dart';
import 'package:aahitest/model/comment.dart';

import '../datetime/to_local_date_time.dart';
import '../exceptions/data_mismatch_exception.dart';

/// Сообщение Slack
class SlackMessage extends Comment {
  /// Принадлежность сообщения к пользователю
  bool isMy;

  SlackMessage(
      {this.isMy,
      List<Attachment> attachments,
      String message,
      DateTime createdAt})
      : super(message: message, attachments: attachments, createdAt: createdAt);

  /// Создает Slack сообщение из JSON-данных
  factory SlackMessage.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    if (json['is_my'] != null && json['is_my'] is! bool) {
      throw DataMismatchException(
          'Неверный формат принадлежности сообщения к текущему пользователю ("${json['is_my']}" - требуется bool) у сообщения Slack');
    }
    if (json['message'] != null && json['message'] is! String) {
      throw DataMismatchException(
          'Неверный формат сообщения ("${json['message']}" - требуется String) у сообщения Slack');
    }
    if (json['created_at'] != null &&
        json['created_at'] is! String &&
        json['created_at'] is! DateTime) {
      throw DataMismatchException(
          'Неверный формат даты создания ("${json['created_at']}" - требуется String или DateTime) у сообщения Slack');
    }
    if (json['attachments'] != null && json['attachments'] is! List) {
      throw DataMismatchException(
          'Неверный формат файлов ("${json['attachments']}" - требуется List) у сообщения Slack');
    }

    List<Attachment> _attachments;
    try {
      _attachments = json['attachments'] == null
          ? null
          : List<Attachment>.from(json['attachments'].map(
              (file) => Attachment.fromJson(file..addAll({'type': 'slack'}))));
    } catch (e) {
      throw DataMismatchException(
          e is Error ? e.toString() : e.message + '\nУ сообщения Slack');
    }
    return SlackMessage(
        isMy: json['is_my'] == true,
        message: json['message'],
        attachments: _attachments,
        createdAt: toLocalDateTime(json['created_at']));
  }

  @override
  String toString() => json.toString();

  /// Возвращает данные в JSON-формате ([Map])
  @override
  Map<String, dynamic> get json => super.json
    ..addAll({'is_my': isMy})
    ..removeWhere((key, value) => value == null);
}
