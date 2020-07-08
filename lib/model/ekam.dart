import 'package:data_model/data_model.dart';

import 'exceptions/data_mismatch_exception.dart';

/// Данные Ekam (электронной кассы)
class Ekam implements JsonEncodable {
  /// Идентификатор
  int id;

  /// Вариант
  int variant;

  Ekam({this.id, this.variant});

  /// Создает Ekam данные из JSON-данных
  factory Ekam.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    if (json['id'] == null || json['id'] is! int) {
      throw DataMismatchException(
          'Неверный идентификатор данных Ekam ("${json['id']}" - он должен присутствовать и быть int)');
    }
    if (json['variant'] == null || json['variant'] is! int) {
      throw DataMismatchException(
          'Неверный вариант данных Ekam ("${json['variant']}" - он должен присутствовать и быть int)');
    }
    return Ekam(id: json['id'], variant: json['variant']);
  }

  @override
  String toString() => json.toString();

  /// Возвращает данные Ekam в JSON-формате ([Map])
  @override
  Map<String, dynamic> get json => {'id': id, 'variant': variant};
}
