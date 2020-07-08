import 'package:data_model/data_model.dart';

import 'attachment/attachment.dart';
import 'datetime/to_local_date_time.dart';
import 'exceptions/data_mismatch_exception.dart';
import 'user/user_group.dart';

/// Новость для внешних агентов
class Announcement implements Model<AnnouncementId> {
  /// Идентификатор новости
  AnnouncementId id;

  /// Название новости
  String title;

  /// Текст новости
  String text;

  /// Получатели
  List<UserGroup> receivers;

  /// Список вложений
  List<Attachment> attachments;

  /// Дата отправки новости
  DateTime publishedAt;

  /// Является ли новость архивной
  bool archived;

  Announcement(
      {this.id,
      this.title,
      this.text,
      this.receivers,
      this.attachments,
      this.archived,
      DateTime publishedAt})
      : this.publishedAt = publishedAt?.toLocal();

  factory Announcement.fromJson(dynamic json) {
    if (json == null) return null;

    if (json is String) return Announcement(id: AnnouncementId(json));

    if (json is! Map) {
      throw DataMismatchException(
          'Неверный формат json у новости для внешних агентов - требуется String либо Map');
    }

    if (json['id'] != null && json['_id'] != null) {
      throw DataMismatchException(
          'Идентификатор новости для внешних агентов указан в двух атрибутах: id и _id ("${json['id']} ~ ${json['_id']}" - требуется один)');
    }

    AnnouncementId id = AnnouncementId(json['id']);

    if (json['title'] is! String || json['title'].isEmpty) {
      throw DataMismatchException(
          'Неверный формат названия новости ("${json['title']}" - требуется непустой String)\n' +
              'У новости для внешних агентов id: ${id?.json}');
    }

    if (json['text'] is! String || json['text'].isEmpty) {
      throw DataMismatchException(
          'Неверный формат текста новости ("${json['text']}" - требуется непустой String)\n' +
              'У новости для внешних агентов id: ${id?.json}');
    }

    if (json['receivers'] is! List) {
      throw DataMismatchException(
          'Неверный формат групп-получателей ("${json['receivers']}" - требуется List)\n' +
              'У новости для внешних агентов id: ${id?.json}');
    }

    if (json['published_at'] != null &&
        json['published_at'] is! String &&
        json['published_at'] is! DateTime) {
      throw DataMismatchException(
          'Неверный формат даты публикации новости ("${json['published_at']}" - требуется String или DateTime)\n' +
              'У новости для внешних агентов id: ${id?.json}');
    }

    if (json['archived'] != null && json['archived'] is! bool) {
      throw DataMismatchException(
          'Неверный формат признака архивности ("${json['archived']}" - требуется bool)\nУ новости для внешних агентов id: ${id?.json}');
    }

    if (json['attachments'] != null && json['attachments'] is! List) {
      throw DataMismatchException(
          'Неверный формат вложений ("${json['attachments']}" - требуется String)\nУ новости для внешних агентов id: ${id?.json}');
    }

    var _receivers = List<UserGroup>.from((json['receivers'] as List)
            ?.map((group) => UserGroup.fromJson(group))
            ?.toList() ??
        []);

    var _attachments = List<Attachment>.from((json['attachments'] as List)
            ?.map((attachment) => Attachment.fromJson(attachment))
            ?.toList() ??
        []);

    return Announcement(
        id: id,
        title: json['title'],
        text: json['text'],
        receivers: _receivers.isEmpty ? null : _receivers,
        attachments: _attachments.isEmpty ? null : _attachments,
        publishedAt: toLocalDateTime(json['published_at']),
        archived: json['archived'] ?? false);
  }

  @override
  dynamic get json {
    Map<String, dynamic> json = {
      'id': id?.json,
      'title': title,
      'text': text,
      'receivers': receivers?.map((group) => group.json)?.toList(),
      'attachments':
          attachments?.map((attachment) => attachment.json)?.toList(),
      'published_at': publishedAt?.toUtc(),
      'archived': archived
    }..removeWhere((key, value) => value == null);

    if (json.keys.length == 1 && json.keys.first == 'id') return json['id'];

    return json;
  }
}

/// Идентификатор новости для внешних агентов
class AnnouncementId extends ObjectId {
  AnnouncementId._(dynamic id) : super(id);
  factory AnnouncementId(id) {
    if (id == null) return null;
    return AnnouncementId._(id);
  }
}
