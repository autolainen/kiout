import 'package:data_model/data_model.dart';

import 'dadata_address.dart';
import 'exceptions/data_mismatch_exception.dart';
import 'time_slots.dart';

/// Зал прощания
class Hall implements Model<HallId> {
  /// Идентификатор зала
  HallId id;

  /// Адрес зала
  DadataAddress address;

  /// Ссылка на карту
  String mapUrl;

  /// Название зала
  String name;

  /// Временные слоты зала
  List<TimeSlot> timeSlots;

  Hall({this.id, this.address, this.mapUrl, this.name, this.timeSlots});

  /// Создает зал из JSON-данных
  factory Hall.fromJson(dynamic json) {
    if (json == null) return null;

    if (json is String) {
      return Hall(id: HallId(json));
    }

    if (json['id'] != null && json['_id'] != null) {
      throw DataMismatchException(
          'Идентификатор зала указан в двух атрибутах: id и _id ("${json['id']} ~ ${json['_id']}" - требуется один)');
    }

    if (json['address'] != null && json['address'] is! Map) {
      throw DataMismatchException(
          'Неверный формат адреса ("${json['address']}" - требуется Map)\nУ зала id: ${json['_id']}');
    }

    if (json['map_url'] != null && json['map_url'] is! String) {
      throw DataMismatchException(
          'Неверный формат ссылки на карту ("${json['map_url']}" - требуется String)\nУ зала id: ${json['_id']}');
    }

    if (json['name'] != null && json['name'] is! String) {
      throw DataMismatchException(
          'Неверный формат названия ("${json['name']}" - требуется String)\nУ зала id: ${json['_id']}');
    }

    if (json['time_slots'] != null && json['time_slots'] is! List) {
      throw DataMismatchException(
          'Неверный формат списка временных слотов ("${json['time_slots']}" - требуется List)\nУ зала id: ${json['id']}');
    }

    List<TimeSlot> _timeSlots = [];
    TimeSlot _timeSlot;

    try {
      if (json['time_slots'] != null) {
        (json['time_slots'] as List).forEach((timeSlot) {
          _timeSlot = TimeSlot.fromJson(timeSlot);
          if (_timeSlot != null) _timeSlots.add(_timeSlot);
        });
      }
    } catch (e) {
      throw DataMismatchException(
          e is Error ? e.toString() : e.message + '\nУ зала id: ${json['id']}');
    }

    HallId id;
    if (json['_id'] != null) {
      id = HallId(
          json['_id'] is String ? json['_id'] : json['_id']?.toHexString());
    } else {
      id = HallId(json['id']);
    }

    return Hall(
        id: id,
        address: DadataAddress.fromJson(json['address']),
        mapUrl: json['map_url'],
        name: json['name'],
        timeSlots: _timeSlots);
  }

  @override
  bool operator ==(other) {
    if (other is Hall) {
      return other.id == id;
    }
    return false;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => json.toString();

  /// Возвращает данные зала в JSON-формате (String/Map)
  ///   String - когда в объекте был заполнен только id
  ///   Map - в ином случае
  @override
  dynamic get json {
    Map<String, dynamic> json = {
      'id': id?.json,
      'name': name,
      'address': address?.json,
      'map_url': mapUrl,
      'time_slots': timeSlots?.map((timeSlot) => timeSlot.json)?.toList()
    }..removeWhere((key, value) => value == null);

    if (json.keys.length == 1 && json.keys.first == 'id') return json['id'];
    return json;
  }
}

class HallId extends ObjectId {
  HallId._(dynamic id) : super(id);
  factory HallId(id) {
    if (id == null) return null;
    return HallId._(id);
  }
}
