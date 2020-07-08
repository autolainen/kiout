import 'package:data_model/data_model.dart';

import 'datetime/to_local_date_time.dart';
import 'exceptions/data_mismatch_exception.dart';

/// Договор
class Contract implements JsonEncodable {
  /// Номер договора
  String no;

  /// Дата начала договора
  DateTime signingDate;

  /// Дата подписания договора
  DateTime terminationDate;

  Contract({this.no, this.signingDate, this.terminationDate});

  /// Создает договор из JSON данных
  factory Contract.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    if (json['no'] != null && json['no'] is! String) {
      throw DataMismatchException(
          'Неверный формат номера договора ("${json['no']}" - требуется String)');
    }

    if (json['signing_date'] != null &&
        json['signing_date'] is! String &&
        json['signing_date'] is! DateTime) {
      throw DataMismatchException(
          'Неверный формат даты начала договора("${json['signing_date']}" - требуется String или DateTime)\nУ договора no: ${json['no']}');
    }

    if (json['termination_date'] != null &&
        json['termination_date'] is! String &&
        json['termination_date'] is! DateTime) {
      throw DataMismatchException(
          'Неверный формат даты подписания договора ("${json['termination_date']}" - требуется String или DateTime)\nУ договора no: ${json['no']}');
    }

    return Contract(
        no: json['no'],
        signingDate: toLocalDateTime(json['signing_date']),
        terminationDate: toLocalDateTime(json['termination_date']));
  }

  @override
  String toString() => json.toString();

  @override
  Map<String, dynamic> get json => {
        'no': no,
        'signing_date': signingDate?.toUtc(),
        'termination_date': terminationDate?.toUtc()
      }..removeWhere((key, value) => value == null);
}
