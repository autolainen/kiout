import 'package:data_model/data_model.dart';

import 'exceptions/data_mismatch_exception.dart';

/// Норма выполнения услуги
class ServiceNorm implements JsonEncodable {
  /// Период
  NormPeriod period;

  /// Значение
  num value;

  ServiceNorm({this.period, this.value});

  factory ServiceNorm.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    if (json['value'] != null && json['value'] is! num) {
      throw DataMismatchException(
          'Неверный формат значения ("${json['value']}" - требуется num)\nУ нормы выполнения услуги.');
    }
    if (json['period'] != null && json['period'] is! Map<String, dynamic>) {
      throw DataMismatchException(
          'Неверный формат периода ("${json['period']}" - требуется Map<String, dynamic>)\nУ нормы выполнения услуги.');
    }
    return ServiceNorm(
        value: json['value'], period: NormPeriod.fromJson(json['period']));
  }

  /// Возвращает данные нормы исполнения в JSON-формате ([Map])
  @override
  Map<String, dynamic> get json => {
        'value': value,
        'period': period?.json,
      }..removeWhere((key, value) => value == null);

  @override
  String toString() => json.toString();
}

/// Период нормы выполнения услуги
class NormPeriod implements JsonEncodable {
  /// От
  NormDayMonth from;

  /// До
  NormDayMonth to;

  NormPeriod({this.from, this.to});

  factory NormPeriod.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    if (json['from'] != null && json['from'] is! Map<String, dynamic>) {
      throw DataMismatchException(
          'Неверный формат периода от ("${json['from']}" - требуется Map<String, dynamic>)\nУ периода нормы выполнения услуги.');
    }

    if (json['to'] != null && json['to'] is! Map<String, dynamic>) {
      throw DataMismatchException(
          'Неверный формат периода до ("${json['to']}" - требуется Map<String, dynamic>)\nУ периода нормы выполнения услуги.');
    }

    return NormPeriod(
        from: NormDayMonth.fromJson(json['from']),
        to: NormDayMonth.fromJson(json['to']));
  }

  /// Возвращает данные нормы исполнения в JSON-формате ([Map])
  @override
  Map<String, dynamic> get json => {
        'from': from?.json,
        'to': to?.json,
      }..removeWhere((key, value) => value == null);

  @override
  String toString() => json.toString();
}

/// Дата периода нормы выполнения услуги
class NormDayMonth implements JsonEncodable {
  /// День
  int day;

  /// Месяц
  int month;

  NormDayMonth({this.day, this.month});

  factory NormDayMonth.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    if (json['day'] != null && json['day'] is! int) {
      throw DataMismatchException(
          'Неверный формат дня от ("${json['day']}" - требуется int)\nУ даты периода нормы выполнения услуги.');
    }

    if (json['month'] != null && json['month'] is! int) {
      throw DataMismatchException(
          'Неверный формат месяца до ("${json['month']}" - требуется int)\nУ даты периода нормы выполнения услуги.');
    }

    return NormDayMonth(day: json['day'], month: json['month']);
  }

  /// Возвращает данные нормы исполнения в JSON-формате ([Map])
  @override
  Map<String, dynamic> get json => {
        'day': day,
        'month': month,
      }..removeWhere((key, value) => value == null);

  @override
  String toString() => json.toString();
}
