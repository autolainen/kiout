import 'package:data_model/data_model.dart';

import 'datetime/to_local_date_time.dart';
import 'exceptions/data_mismatch_exception.dart';

/// Класс реализующий паспортные данные пользователя
class Passport implements JsonEncodable {
  /// Серия
  String series;

  /// Номер
  String number;

  /// Кому выдан
  String name;

  /// Дата выдачи
  DateTime issueDate;

  /// Кем выдан
  String issuedBy;

  /// Код подразделения
  String departmentCode;

  /// Создает паспорт
  Passport(
      {DateTime issueDate,
      this.series,
      this.number,
      this.name,
      this.issuedBy,
      this.departmentCode})
      : this.issueDate = issueDate?.toLocal();

  /// Создает паспорт из JSON-данных
  factory Passport.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    if (json['series'] != null && json['series'] is! String) {
      throw DataMismatchException(
          'Неверный формат серии паспорта ("${json['series']}" - требуется String)\nУ пользователя id: ${json['id']}');
    }
    if (json['number'] != null && json['number'] is! String) {
      throw DataMismatchException(
          'Неверный формат номера паспорта ("${json['number']}" - требуется String)\nУ пользователя id: ${json['id']}');
    }
    if (json['name'] != null && json['name'] is! String) {
      throw DataMismatchException(
          'Неверный формат имени в паспорте ("${json['name']}" - требуется String)\nУ пользователя id: ${json['id']}');
    }
    if (json['issued_by'] != null && json['issued_by'] is! String) {
      throw DataMismatchException(
          'Неверный формат выдавшей паспорт организации ("${json['issued_by']}" - требуется String)\nУ пользователя id: ${json['id']}');
    }
    if (json['department_code'] != null && json['department_code'] is! String) {
      throw DataMismatchException(
          'Неверный формат кода подразделения в паспорте ("${json['department_code']}" - требуется String)\nУ пользователя id: ${json['id']}');
    }
    if (json['issue_date'] != null &&
        json['issue_date'] is! String &&
        json['issue_date'] is! DateTime) {
      throw DataMismatchException(
          'Неверный формат даты выдачи паспорта ("${json['issue_date']}" - требуется String или DateTime)\nУ пользователя id: ${json['id']}');
    }

    return Passport(
      series: json['series'],
      number: json['number'],
      departmentCode: json['department_code'],
      issueDate: toLocalDateTime(json['issue_date']),
      issuedBy: json['issued_by'],
      name: json['name'],
    );
  }

  /// Возвращает данные персоны в JSON-формате ([Map])
  @override
  Map<String, dynamic> get json => {
        'number': number,
        'series': series,
        'department_code': departmentCode,
        'issued_by': issuedBy,
        'name': name,
        'issue_date': issueDate?.toUtc()
      }..removeWhere((key, value) => value == null);

  @override
  String toString() => json.toString();
}
