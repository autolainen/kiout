import 'package:data_model/data_model.dart';
import 'datetime/to_local_date_time.dart';
import 'exceptions/data_mismatch_exception.dart';
import 'geo/polygon.dart';

/// Класс реализующий данные о кладбище
class Cemetery implements Model<CemeteryId> {
  /// Идентификатор кладбища
  CemeteryId id;

  /// Название кладбища
  String name;

  /// Активность кладбища
  bool active;

  /// URL фото
  String photoUrl;

  /// Дата создания
  DateTime createdAt;

  /// Дата обновления
  DateTime updatedAt;

  /// Граница кладбища
  Polygon border;

  Cemetery({
    this.id,
    DateTime createdAt,
    DateTime updatedAt,
    this.name,
    this.active,
    this.photoUrl,
    this.border,
  })  : this.createdAt = createdAt?.toLocal(),
        this.updatedAt = updatedAt?.toLocal();

  /// Создает кладбище из JSON-данных
  factory Cemetery.fromJson(dynamic json) {
    if (json == null) return null;

    if (json is String) {
      return Cemetery(id: CemeteryId(json));
    }

    if (json is! Map) {
      throw DataMismatchException(
          'Не верный формат json у кладбища - требуется String либо Map');
    }

    if (json['id'] != null && json['_id'] != null) {
      throw DataMismatchException(
          'Идентификатор кладбища указан в двух атрибутах: id и _id ("${json['id']} ~ ${json['_id']}" - требуется один)');
    }

    if (json['name'] != null && json['name'] is! String) {
      throw DataMismatchException(
          'Неверный формат названия ("${json['name']}" - требуется String)\nУ кладбища id: ${json['id']}');
    }
    if (json['photo_url'] != null && json['photo_url'] is! String) {
      throw DataMismatchException(
          'Неверный формат сслылки на фотографии ("${json['photo_url']}" - требуется String)\nУ кладбища id: ${json['id']}');
    }
    if (json['active'] != null && json['active'] is! bool) {
      throw DataMismatchException(
          'Неверный формат активности ("${json['active']}" - требуется bool)\nУ кладбища id: ${json['id']}');
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
                  '\nНеверный формат границ у кладбища id: ${json['id']}');
        }
      }
    } else {
      throw DataMismatchException(
          'Неверный формат границ кладбища ("${json['geom']}" - требуется Map<String, dynamic>)\nУ кладбища id: ${json['id']}');
    }
    if (json['created_at'] != null &&
        json['created_at'] is! String &&
        json['created_at'] is! DateTime) {
      throw DataMismatchException(
          'Неверный формат даты создания("${json['created_at']}" - требуется String или DateTime)\nУ кладбища id: ${json['id']}');
    }
    if (json['updated_at'] != null &&
        json['updated_at'] is! String &&
        json['updated_at'] is! DateTime) {
      throw DataMismatchException(
          'Неверный формат даты обновления ("${json['updated_at']}" - требуется String или DateTime)\nУ кладбища id: ${json['id']}');
    }

    CemeteryId id;
    if (json['_id'] != null) {
      id = CemeteryId(
          json['_id'] is String ? json['_id'] : json['_id']?.toHexString());
    } else {
      id = CemeteryId(json['id']);
    }

    return Cemetery(
        id: id,
        name: json['name'],
        active: json['active'],
        photoUrl: json['photo_url'],
        border: _border,
        createdAt: toLocalDateTime(json['created_at']),
        updatedAt: toLocalDateTime(json['updated_at']));
  }

  @override
  bool operator ==(other) {
    if (other is Cemetery) {
      return other.id == id;
    }
    return false;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => json.toString();

  /// Возвращает данные персоны в JSON-формате (String/Map)
  ///   String - когда в объекте был заполнен только id
  ///   Map - в ином случае
  @override
  dynamic get json {
    Map<String, dynamic> json = {
      'id': id?.json,
      'geom': border?.json,
      'name': name,
      'active': active,
      'photo_url': photoUrl,
      'created_at': createdAt?.toUtc(),
      'updated_at': updatedAt?.toUtc()
    }..removeWhere((key, value) => value == null);

    if (json.keys.length == 1 && json.keys.first == 'id') return json['id'];

    return json;
  }
}

/// Идентификатор кладбища
class CemeteryId extends ObjectId {
  CemeteryId._(dynamic id) : super(id);
  factory CemeteryId(id) {
    if (id == null) return null;
    return CemeteryId._(id);
  }
}
