import 'package:data_model/data_model.dart';
import '../datetime/to_local_date_time.dart';
import '../exceptions/data_mismatch_exception.dart';
import '../geo/point.dart';

/// Класс реализующий данные о собственном участке кладбища
class PlotInfo implements JsonEncodable {
  /// Секция
  String section;

  /// Номер участка
  String plot;

  /// Сертификат о собственности участка
  PlotCertificate certificate;

  /// Координаты участка
  Point geometry;

  PlotInfo({this.section, this.plot, this.certificate, this.geometry});

  /// Создает участок из JSON-данных
  factory PlotInfo.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    if (json['section'] != null && json['section'] is! String) {
      throw DataMismatchException(
          'Неверный формат секции ("${json['section']}" - требуется String)\nУ участка кладбища в заказе id: ${json['id']}');
    }
    if (json['plot'] != null && json['plot'] is! String) {
      throw DataMismatchException(
          'Неверный формат номера участка а("${json['plot']}" - требуется String)\nУ участка кладбища в заказе id: ${json['id']}');
    }
    if (json['certificate'] != null &&
        json['certificate'] is! Map<String, dynamic>) {
      throw DataMismatchException(
          'Неверный формат сертификата  ("${json['certificate']}" - требуется Map<String, dynamic>)\nУ участка кладбища в заказе id: ${json['id']}');
    }

    if (json['geometry'] != null && json['geometry'] is! Map<String, dynamic>) {
      throw DataMismatchException(
          'Неверный формат геопозиции ("${json['geometry']}" - требуется GeoJson - Map<String, dynamic>)\nУ участка кладбища в заказе id: ${json['id']}');
    }

    Point _geometry;
    if (json['geometry'] != null) {
      _geometry = Point.fromJson(json['geometry']);
    }

    return PlotInfo(
        section: json['section'],
        plot: json['plot'],
        certificate: PlotCertificate.fromJson(json['certificate']),
        geometry: _geometry);
  }

  @override
  bool operator ==(other) {
    if (other is PlotInfo) {
      return other.certificate == certificate;
    }
    return false;
  }

  @override
  int get hashCode => certificate.hashCode;

  @override
  String toString() => json.toString();

  /// Возвращает данные участка в JSON-формате ([Map])
  @override
  Map<String, dynamic> get json => {
        'section': section,
        'plot': plot,
        'certificate': certificate?.json,
        'geometry': geometry?.json
      }..removeWhere((key, value) => value == null);
}

/// Сертификат собственности участка
class PlotCertificate implements JsonEncodable {
  /// Номер
  String no;

  /// Дата выдачи
  DateTime issueDate;

  /// Кем выдан
  String issuedBy;

  PlotCertificate({DateTime issueDate, this.no, this.issuedBy})
      : this.issueDate = issueDate?.toLocal();

  /// Создает сертификат из JSON-данных
  factory PlotCertificate.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    if (json['no'] != null && json['no'] is! String) {
      throw DataMismatchException(
          'Неверный формат номера ("${json['no']}" - требуется String)\nУ сертификата участка в заказе id: ${json['id']}');
    }
    if (json['issued_by'] != null && json['issued_by'] is! String) {
      throw DataMismatchException(
          'Неверный формат выдавшей паспорт организации ("${json['issued_by']}" - требуется String)\nУ сертификата участка в заказе id: ${json['id']}');
    }
    if (json['issue_date'] != null &&
        json['issue_date'] is! String &&
        json['issue_date'] is! DateTime) {
      throw DataMismatchException(
          'Неверный формат даты выдачи паспорта ("${json['issue_date']}" - требуется String или DateTime)\nУ сертификата участка в заказе id: ${json['id']}');
    }

    return PlotCertificate(
      no: json['no'],
      issueDate: toLocalDateTime(json['issue_date']),
      issuedBy: json['issued_by'],
    );
  }

  @override
  bool operator ==(other) {
    if (other is PlotCertificate) {
      return other.no == no;
    }
    return false;
  }

  @override
  int get hashCode => no.hashCode;

  @override
  String toString() => json.toString();

  /// Возвращает данные сертификата в JSON-формате ([Map])
  @override
  Map<String, dynamic> get json => {
        'no': no,
        'issued_by': issuedBy,
        'issue_date': issueDate?.toUtc()
      }..removeWhere((key, value) => value == null);
}
