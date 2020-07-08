import 'package:data_model/data_model.dart';

/// Тип отчета
///
/// возможные отчеты:
/// * transportationCorpses - тип отчета транспортировка тел фурой
class ReportType implements JsonEncodable {
  /// Тип отчета ранспортировка тел фурой
  static const ReportType transportationCorpses =
      ReportType._('transportationCorpses');

  final String _type;

  // Создает тип отчета
  const ReportType._(String type) : _type = type;

  factory ReportType(String type) {
    if (type == null) return null;
    ReportType reportType = ReportType._(type);
    if (values.contains(reportType)) {
      return reportType;
    } else {
      throw ArgumentError('Invalid report type: ${type}.');
    }
  }

  final Map<String, String> _typesStr = const {
    'transportationCorpses': 'Накладная на перевозку тел фурой'
  };

  String get value => _type;
  static List get values => [transportationCorpses];

  @override
  bool operator ==(dynamic other) {
    if (other is ReportType) {
      return other._type == _type;
    }
    return false;
  }

  @override
  int get hashCode => _type.hashCode;

  String get json => _type;

  @override
  String toString() => _typesStr[_type];
}
