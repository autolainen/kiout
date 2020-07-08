import 'package:data_model/data_model.dart';

import 'exceptions/data_mismatch_exception.dart';

// Модель данных Адрес в формате DaData
class DadataAddress implements JsonEncodable {
  /// Подробная информация о адресе
  Map<String, dynamic> data;

  /// Строковый адрес
  String value;

  /// Полный строковый адрес
  String unrestrictedValue;

  DadataAddress({this.data, this.value, this.unrestrictedValue});

  factory DadataAddress.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    if (json['value'] != null && json['value'] is! String) {
      throw DataMismatchException(
          'Неверный формат строкового адреса ("${json['value']}" - требуется String)\nУ адреса Dadata.');
    }
    if (json['unrestricted_value'] != null &&
        json['unrestricted_value'] is! String) {
      throw DataMismatchException(
          'Неверный формат полного строкового адреса ("${json['unrestricted_value']}" - требуется String)\nУ адреса Dadata.');
    }
    if (json['data'] != null && json['data'] is! Map<String, dynamic>) {
      throw DataMismatchException(
          'Неверный формат данных ("${json['data']}" - требуется Map<String, dynamic>)\nУ адреса Dadata.');
    }
    return DadataAddress(
        data: json['data'],
        value: json['value'],
        unrestrictedValue: json['unrestricted_value']);
  }

  /// Возвращает данные адреса в JSON-формате ([Map])
  @override
  Map<String, dynamic> get json => {
        'data': data,
        'value': value,
        'unrestricted_value': unrestrictedValue
      }..removeWhere((key, value) => value == null);

  @override
  String toString() => unrestrictedValue ?? value;

  @override
  int get hashCode => toString().hashCode;

  @override
  bool operator ==(other) {
    if (other is DadataAddress) {
      return toString() == other.toString();
    }

    return false;
  }
}
