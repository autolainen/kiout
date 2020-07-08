import 'package:data_model/data_model.dart';

import '../exceptions/data_mismatch_exception.dart';

/// Доверенность
class Authority implements JsonEncodable {
  /// Номер доверенности
  String no;

  /// Дата выдачи доверенности
  DateTime issueDate;

  Authority({this.no, DateTime issueDate})
      : this.issueDate = issueDate?.toLocal();

  factory Authority.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    if (json['no'] != null && json['no'] is! String) {
      throw DataMismatchException(
          'Неверный формат номера доверенности ("${json['no']}" - требуется String)\n');
    }
    if (json['issue_date'] != null &&
        json['issue_date'] is! String &&
        json['issue_date'] is! DateTime) {
      throw DataMismatchException(
          'Неверный формат даты выдачи доверенности ("${json['issue_date']}" - требуется String или DateTime)\n');
    }

    DateTime _issueDate;
    if (json['issue_date'] != null) {
      _issueDate = json['issue_date'] is DateTime
          ? json['issue_date'].toLocal()
          : (json['issue_date'] == ''
              ? null
              : DateTime.parse(json['issue_date']));
    }

    return Authority(no: json['no'], issueDate: _issueDate);
  }

  @override
  Map<String, dynamic> get json => {'no': no, 'issue_date': issueDate?.toUtc()}
    ..removeWhere((key, value) => value == null);

  @override
  String toString() => json.toString();
}
