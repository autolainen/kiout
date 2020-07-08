import 'package:data_model/data_model.dart';

import 'exceptions/data_mismatch_exception.dart';

/// Параметры гроба
class CoffinParams implements JsonEncodable {
  /// Длина
  final num length;

  /// Ширина
  final num width;

  /// Вес
  final num weight;

  CoffinParams({this.length, this.width, this.weight});

  factory CoffinParams.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    if (json['length'] != null && json['length'] is! num) {
      throw DataMismatchException(
          'Неверный формат номера высоты ("${json['length']}" - требуется num)\nУ параметров гроба');
    }

    if (json['width'] != null && json['width'] is! num) {
      throw DataMismatchException(
          'Неверный формат номера ширины ("${json['width']}" - требуется num)\nУ параметров гроба');
    }

    if (json['weight'] != null && json['weight'] is! num) {
      throw DataMismatchException(
          'Неверный формат номера веса ("${json['weight']}" - требуется num)\nУ параметров гроба');
    }

    return CoffinParams(
        length: json['length'], width: json['width'], weight: json['weight']);
  }

  @override
  Map<String, dynamic> get json => {
        'length': length,
        'width': width,
        'weight': weight
      }..removeWhere((key, value) => value == null);

  @override
  String toString() => json.toString();
}
