import 'package:kiouttest/model/services/capitalize_first_letter.dart';
import 'package:data_model/data_model.dart';

/// Семейное положение
///
/// возможные виды семейного положения:
///
/// * married - состоял(а) в браке
/// * single - не состоял(а) в браке
/// * unknown - Неизвестно
class MaritalStatus implements JsonEncodable {
  /// Состоял(а) в браке
  static const MaritalStatus married = MaritalStatus._('состоял(а) в браке');

  /// Не состоял(а) в браке
  static const MaritalStatus single = MaritalStatus._('не состоял(а) в браке');

  /// Неизвестно
  static const MaritalStatus unknown = MaritalStatus._('неизвестно');

  final String _status;

  // Создает виды семейного положения
  const MaritalStatus._(String status) : _status = status;

  factory MaritalStatus(String status) {
    if (status == null) return null;
    MaritalStatus _curStatus = MaritalStatus._(status);
    if (values.contains(_curStatus)) {
      return _curStatus;
    } else {
      throw ArgumentError('Unknown marital status: $status.');
    }
  }

  String get value => _status;
  static List get values => [married, single, unknown];

  @override
  bool operator ==(dynamic other) {
    if (other is MaritalStatus) {
      return other._status == _status;
    }
    return false;
  }

  @override
  int get hashCode => _status.hashCode;

  String get json => _status;

  @override
  String toString() => capitalizeFirstLetter(_status);
}
