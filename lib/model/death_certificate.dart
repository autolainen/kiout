import 'package:data_model/data_model.dart';

import 'exceptions/data_mismatch_exception.dart';

/// Свидетельство о смерти
class DeathCertificate implements JsonEncodable {
  /// Номер
  String no;

  /// Номер записи акта о смерти
  String actRecordNumber;

  /// Кем выдан
  String issuedBy;

  /// Дата выдачи
  DateTime issueDate;

  DeathCertificate(
      {this.no, this.actRecordNumber, this.issuedBy, DateTime issueDate})
      : this.issueDate = issueDate?.toLocal();

  factory DeathCertificate.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    if (json['no'] != null && json['no'] is! String) {
      throw DataMismatchException(
          'Неверный формат номера сертификата ("${json['no']}" - требуется String)\nУ свидетельства о смерти');
    }
    if (json['number'] != null && json['number'] is! String) {
      throw DataMismatchException(
          'Неверный формат номера записи акта о смерти ("${json['number']}" - требуется String)\nУ свидетельства о смерти');
    }
    if (json['issued_by'] != null && json['issued_by'] is! String) {
      throw DataMismatchException(
          'Неверный формат названия, выдавшего сертификата ("${json['issued_by']}" - требуется String)\nУ свидетельства о смерти');
    }
    if (json['issue_date'] != null &&
        json['issue_date'] is! String &&
        json['issue_date'] is! DateTime) {
      throw DataMismatchException(
          'Неверный формат даты выдачи сертификата ("${json['issue_date']}" - требуется String или DateTime)\nУ свидетельства о смерти');
    }

    DateTime _issueDate;
    if (json['issue_date'] != null) {
      _issueDate = json['issue_date'] is DateTime
          ? json['issue_date'].toLocal()
          : (json['issue_date'] == ''
              ? null
              : DateTime.parse(json['issue_date']));
    }

    return DeathCertificate(
        no: json['no'],
        actRecordNumber: json['act_no'],
        issuedBy: json['issued_by'],
        issueDate: _issueDate);
  }

  @override
  Map<String, dynamic> get json => {
        'no': no,
        'act_no': actRecordNumber,
        'issued_by': issuedBy,
        'issue_date': issueDate?.toUtc()
      }..removeWhere((key, value) => value == null);

  @override
  String toString() => json.toString();
}
