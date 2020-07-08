import 'package:data_model/data_model.dart';

import '../exceptions/data_mismatch_exception.dart';
import 'to_local_date_time.dart';

/// Временной промежуток
class DateTimePeriod implements JsonEncodable {
  /// Дата и время начала периода (нижняя граница)
  final DateTime from;

  /// Дата и время конца периода (верхняя граница)
  final DateTime to;

  DateTimePeriod({this.from, this.to}) {
    if (from == null && to == null)
      throw ArgumentError(
          'Parameters "from" and "to" must not be null at the same time');
  }

  /// Создает промежуток времени с 0 часов дня [day] до 0 часов следующего дня
  DateTimePeriod.singleDay(DateTime day)
      : from = DateTime(
            day.toLocal().year, day.toLocal().month, day.toLocal().day),
        to = DateTime(
                day.toLocal().year, day.toLocal().month, day.toLocal().day + 1)
            .add(Duration(microseconds: -1));

  factory DateTimePeriod.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    if (json['from'] == null && json['to'] == null) {
      throw DataMismatchException(
          'Начало и конец периода ("${json['from']} - ${json['to']}" - не могут отсутствовать одновременно).');
    }
    if (json['from'] != null &&
        json['from'] is! String &&
        json['from'] is! DateTime) {
      throw DataMismatchException(
          'Неверный формат начала периода ("${json['from']}" - требуется String или DateTime).');
    }
    if (json['to'] != null &&
        json['to'] is! String &&
        json['to'] is! DateTime) {
      throw DataMismatchException(
          'Неверный формат конца периода ("${json['to']}" - требуется String или DateTime).');
    }

    return DateTimePeriod(
        from: toLocalDateTime(json['from']), to: toLocalDateTime(json['to']));
  }

  @override
  Map<String, dynamic> get json => {'from': from?.toUtc(), 'to': to?.toUtc()}
    ..removeWhere((key, value) => value == null);
}
