import 'package:data_model/data_model.dart';

/// Статус спецификации
///
/// возможный статус спецификации:
/// * draft - черновик
/// * newSpec - новая
/// * confirmed - подверждена
/// * canceled - отменена
class SpecStatus implements JsonEncodable {
  /// Черновик
  static const SpecStatus draft = SpecStatus._('draft');

  /// Новая
  static const SpecStatus newSpec = SpecStatus._('new');

  /// Подверждена
  static const SpecStatus confirmed = SpecStatus._('confirmed');

  /// Отменена
  static const SpecStatus canceled = SpecStatus._('canceled');

  final String _status;

  // Создает статус заказа
  const SpecStatus._(String status) : _status = status;

  factory SpecStatus(String status) {
    if (status == null) return null;
    SpecStatus _curOrderStatus = SpecStatus._(status);
    if (values.contains(_curOrderStatus)) {
      return _curOrderStatus;
    } else {
      throw ArgumentError('Unknown specification status: ${status}.');
    }
  }

  final Map<String, String> _statusStr = const {
    'draft': 'Черновик',
    'new': 'Новая',
    'confirmed': 'Подтверждена',
    'canceled': 'Отменена',
  };

  String get value => _status;
  static List get values => [draft, newSpec, confirmed, canceled];

  @override
  bool operator ==(dynamic other) {
    if (other is SpecStatus) {
      return other._status == _status;
    }
    return false;
  }

  @override
  int get hashCode => _status.hashCode;

  String get json => _status;

  @override
  String toString() => _statusStr[_status];
}
