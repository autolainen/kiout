import 'package:data_model/data_model.dart';

import 'exceptions/data_mismatch_exception.dart';
import 'geo/point.dart';

class Address implements JsonEncodable {
  /// Геоточка соответствующая адресу
  Point location;

  /// Строковый адрес
  String formattedAddress;

  /// Номер комнаты/квартиры
  String room;

  Address({this.location, this.formattedAddress, this.room});

  factory Address.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    if (json['location'] != null && json['location'] is! Map<String, dynamic>) {
      throw DataMismatchException(
          'Неверный формат гео-точки ("${json['url']}" - требуется Map<String, dynamic>)\nУ адреса.');
    }
    if (json['formattedAddress'] != null &&
        json['formattedAddress'] is! String) {
      throw DataMismatchException(
          'Неверный формат строкового адреса ("${json['formattedAddress']}" - требуется String)\nУ адреса.');
    }
    if (json['room'] != null && json['room'] is! String) {
      throw DataMismatchException(
          'Неверный формат номера комнаты/квартиры ("${json['room']}" - требуется String)\nУ адреса.');
    }
    return Address(
        location: Point.fromJson(json['location']),
        formattedAddress: json['formattedAddress'],
        room: json['room']);
  }

  /// Возвращает данные адреса в JSON-формате ([Map])
  @override
  Map<String, dynamic> get json => {
        'location': location?.json,
        'formattedAddress': formattedAddress,
        'room': room
      }..removeWhere((key, value) => value == null);

  @override
  String toString() => json.toString();
}
