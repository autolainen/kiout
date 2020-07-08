import 'package:data_model/data_model.dart';

import './attachment_url.dart';
import '../datetime/to_local_date_time.dart';
import '../exceptions/data_mismatch_exception.dart';
import 'attachment_stub.dart'
    // ignore: uri_does_not_exist
    if (dart.library.html) 'browser_attachment.dart'
    // ignore: uri_does_not_exist
    if (dart.library.io) 'mobile_attachment.dart';

/// Класс реализующий данные о вложенных файлах
abstract class Attachment<T> implements JsonEncodable {
  factory Attachment(
          {DateTime createdAt,
          AttachmentUrl url,
          String mimeType,
          String name,
          T file}) =>
      createAttachment(
          createdAt: createdAt,
          url: url,
          mimeType: mimeType,
          name: name,
          file: file);

  /// Физический файл
  T _file;
  T get file => _file;

  /// Ссылка на файл
  AttachmentUrl url;

  /// Тип вложения
  String mimeType;

  /// Дата создания
  DateTime createdAt;

  /// Наименование файла вложения
  String name;

  Attachment.createAttachment(
      {DateTime createdAt, this.url, this.mimeType, this.name, T file})
      : this.createdAt = createdAt?.toLocal(),
        this._file = file;

  /// Создает вложение из JSON-данных
  factory Attachment.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    if (json['url'] != null && json['url'] is! String) {
      throw DataMismatchException(
          'Неверный формат ссылки ("${json['url']}" - требуется String)\nУ вложения id: ${json['id']}');
    }
    if (json['mime_type'] != null && json['mime_type'] is! String) {
      throw DataMismatchException(
          'Неверный формат типа ("${json['mime_type']}" - требуется String)\nУ вложения id: ${json['id']}');
    }
    if (json['created_at'] != null &&
        json['created_at'] is! String &&
        json['created_at'] is! DateTime) {
      throw DataMismatchException(
          'Неверный формат даты создания("${json['created_at']}" - требуется String или DateTime)\nУ вложения id: ${json['id']}');
    }
    if (json['name'] != null && json['name'] is! String) {
      throw DataMismatchException(
          'Неверный формат наименования файла ("${json['name']}" - требуется String)\nУ вложения id: ${json['id']}');
    }

    return Attachment(
        url: json['url'] == null ? null : AttachmentUrl.fromJson(json),
        mimeType: json['mime_type'],
        createdAt: toLocalDateTime(json['created_at']),
        name: json['name']);
  }

  @override
  String toString() => json.toString();

  /// Возвращает данные вложения в JSON-формате ([Map])
  @override
  Map<String, dynamic> get json =>
      {'mime_type': mimeType, 'created_at': createdAt?.toUtc(), 'name': name}
        ..addAll(url?.json ?? {})
        ..removeWhere((key, value) => value == null);
}
