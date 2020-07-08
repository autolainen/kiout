import 'package:data_model/data_model.dart';

import 'cemetery.dart';
import 'datetime/to_local_date_time.dart';
import 'geo/polygon.dart';
import 'exceptions/data_mismatch_exception.dart';

/// Класс реализующий данные о квартале кладбища
class Section implements Model<SectionId> {
  /// Идентификатор квартала
  SectionId id;

  /// Номер квартала
  String number;

  /// Кладбище
  CemeteryId cemetery;

  /// Дата создания
  DateTime createdAt;

  /// Дата обновления
  DateTime updatedAt;

  /// Граница квартала
  Polygon border;

  Section(
      {this.id,
      DateTime createdAt,
      DateTime updatedAt,
      this.number,
      this.cemetery,
      this.border})
      : this.createdAt = createdAt?.toLocal(),
        this.updatedAt = updatedAt?.toLocal();

  /// Создает квартал из JSON-данных
  factory Section.fromJson(dynamic json) {
    if (json == null) return null;

    if (json is String) {
      return Section(id: SectionId(json));
    }

    if (json is! Map) {
      throw DataMismatchException(
          'Не верный формат json у квартала - требуется String либо Map');
    }

    if (json['id'] != null && json['_id'] != null) {
      throw DataMismatchException(
          'Идентификатор квартала указан в двух атрибутах: id и _id ("${json['id']} ~ ${json['_id']}" - требуется один)');
    }

    if (json['number'] != null && json['number'] is! String) {
      throw DataMismatchException(
          'Неверный формат номера ("${json['number']}" - требуется String)\nУ квартала id: ${json['id']}');
    }
    if (json['cemetery'] != null && json['cemetery'] is! String) {
      throw DataMismatchException(
          'Неверный формат идентификатора кладбища ("${json['cemetery']}" - требуется String)\nУ квартала id: ${json['id']}');
    }
    Polygon _border;
    if (json['geom'] == null ||
        json['geom'] is Map<String, dynamic> &&
            json['geom']['coordinates'] is List &&
            json['geom']['coordinates'][0] is List &&
            json['geom']['coordinates'][0][0] is List) {
      if (json['geom'] != null) {
        try {
          _border = Polygon.fromJson(json['geom']);
        } catch (e) {
          throw DataMismatchException(e.message ??
              e.toString() +
                  '\nНеверный формат границ у квартала id: ${json['id']}');
        }
      }
    } else {
      throw DataMismatchException(
          'Неверный формат границ ("${json['geom']}" - требуется Map<String, dynamic>)\nУ квартала id: ${json['id']}');
    }
    if (json['created_at'] != null &&
        json['created_at'] is! String &&
        json['created_at'] is! DateTime) {
      throw DataMismatchException(
          'Неверный формат даты создания("${json['created_at']}" - требуется String или DateTime)\nУ квартала id: ${json['id']}');
    }
    if (json['updated_at'] != null &&
        json['updated_at'] is! String &&
        json['updated_at'] is! DateTime) {
      throw DataMismatchException(
          'Неверный формат даты обновления ("${json['updated_at']}" - требуется String или DateTime)\nУ квартала id: ${json['id']}');
    }

    SectionId id;
    if (json['_id'] != null) {
      id = SectionId(
          json['_id'] is String ? json['_id'] : json['_id']?.toHexString());
    } else {
      id = SectionId(json['id']);
    }

    return Section(
        id: id,
        number: json['number'],
        cemetery: CemeteryId(json['cemetery']),
        border: _border,
        createdAt: toLocalDateTime(json['created_at']),
        updatedAt: toLocalDateTime(json['updated_at']));
  }

  @override
  bool operator ==(other) {
    if (other is Section) {
      return other.id == id;
    }
    return false;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => json.toString();

  /// Возвращает данные квартала в JSON-формате (String/Map)
  ///   String - когда в объекте был заполнен только id
  ///   Map - в ином случае
  @override
  dynamic get json {
    Map<String, dynamic> json = {
      'id': id?.json,
      'geom': border?.json,
      'number': number,
      'cemetery': cemetery?.toString(),
      'created_at': createdAt?.toUtc(),
      'updated_at': updatedAt?.toUtc()
    }..removeWhere((key, value) => value == null);

    if (json.keys.length == 1 && json.keys.first == 'id') return json['id'];

    return json;
  }
}

/// Идентификатор квартала кладбища
class SectionId extends ObjectId {
  SectionId._(dynamic id) : super(id);
  factory SectionId(id) {
    if (id == null) return null;
    return SectionId._(id);
  }
}
