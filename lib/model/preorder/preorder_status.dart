import 'package:data_model/data_model.dart';

/// Статус предзаказа
///
/// возможный статус предзаказа:
/// * lost - отменен
/// * waiting - в ожидании
/// * won - заказ оформлен
/// * confirming - ожидает подтверждения
class PreorderStatus implements JsonEncodable {
  /// Отменен
  static const PreorderStatus cancelled = PreorderStatus._('lost');

  /// Ожидает подтверждения
  static const PreorderStatus confirming = PreorderStatus._('confirming');

  /// В ожидании
  static const PreorderStatus waiting = PreorderStatus._('waiting');

  /// Заказ оформлен
  static const PreorderStatus ordered = PreorderStatus._('won');

  final String _status;

  // Создает статус предзаказа
  const PreorderStatus._(String status) : _status = status;

  factory PreorderStatus(String status) {
    if (status == null) return null;
    PreorderStatus _curPreorderStatus = PreorderStatus._(status);
    if (values.contains(_curPreorderStatus)) {
      return _curPreorderStatus;
    } else {
      throw ArgumentError('Unknown preorder status: ${status}.');
    }
  }

  final Map<String, String> _statusStr = const {
    'lost': 'Отменен',
    'confirming': 'Ожидает подтверждения',
    'waiting': 'В ожидании',
    'won': 'Заказ оформлен',
  };

  String get value => _status;
  static List get values => [cancelled, confirming, ordered, waiting];

  @override
  bool operator ==(dynamic other) {
    if (other is PreorderStatus) {
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
