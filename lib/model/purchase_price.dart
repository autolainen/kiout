import 'package:data_model/data_model.dart';

import './contractor.dart';
import 'exceptions/data_mismatch_exception.dart';

/// Закупочная цена
class PurchasePrice implements JsonEncodable {
  /// Подрядчик
  ContractorId contractor;

  /// Валюта
  String currency;

  /// Цена
  num value;

  PurchasePrice({
    this.contractor,
    this.currency,
    this.value,
  });

  factory PurchasePrice.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    if (json['contractor'] != null && json['contractor'] is! String) {
      throw DataMismatchException(
          'Неверный формат подрядчика ("${json['contractor']}" - требуется String)\nВ модели PurchasePrice');
    }

    if (json['currency'] != null && json['currency'] is! String) {
      throw DataMismatchException(
          'Неверный формат валюты ("${json['currency']}" - требуется String)\nВ модели PurchasePrice');
    }

    if (json['value'] != null && json['value'] is! num) {
      throw DataMismatchException(
          'Неверный формат цены ("${json['value']}" - требуется num)\nВ модели PurchasePrice');
    }

    return PurchasePrice(
        currency: json['currency'],
        value: json['value'],
        contractor: ContractorId(json['contractor']));
  }

  /// Возвращает данные адреса в JSON-формате ([Map])
  @override
  Map<String, dynamic> get json => {
        'currency': currency,
        'value': value,
        'contractor': contractor?.json
      }..removeWhere((key, value) => value == null);

  @override
  String toString() => json.toString();
}
