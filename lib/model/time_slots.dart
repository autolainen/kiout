import 'package:data_model/data_model.dart';

import 'exceptions/data_mismatch_exception.dart';

/// Класс реализующий временной слот зала
class TimeSlot implements JsonEncodable {
  /// Время начала слота в минутах с 00:00:00
  int from;

  /// Время окончания слота в минутах с 00:00:00
  int to;

  /// Стоимость аренды слота
  int cost;

  TimeSlot({this.from, this.to, this.cost});

  /// Создает временной слот из JSON-данных
  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    if (json['from'] != null && json['from'] is! int) {
      throw DataMismatchException(
          'Неверный формат начала временного слота ("${json['from']}" - требуется int)');
    }

    if (json['to'] != null && json['to'] is! int) {
      throw DataMismatchException(
          'Неверный формат окончания временного слота ("${json['to']}" - требуется int)');
    }

    if (json['cost'] != null && json['cost'] is! int) {
      throw DataMismatchException(
          'Неверный формат стоимости временного слота ("${json['cost']}" - требуется int)');
    }

    return TimeSlot(from: json['from'], to: json['to'], cost: json['cost']);
  }

  @override
  bool operator ==(other) {
    if (other is TimeSlot) {
      return other.from == from && other.to == to && other.cost == cost;
    }
    return false;
  }

  @override
  int get hashCode => from.hashCode;

  @override
  String toString() => json.toString();

  /// Возвращает данные временного слота зала в JSON-формате (Map)
  @override
  dynamic get json => {'from': from, 'to': to, 'cost': cost};
}
