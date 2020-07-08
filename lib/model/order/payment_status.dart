import 'package:data_model/data_model.dart';

/// Статус плaтежа
///
/// возможный статус платежа:
/// * unpaid - не оплачен
/// * paid - оплачен
/// * accepted - подтверждён
class PaymentStatus implements JsonEncodable {
  /// Не оплачен
  static const PaymentStatus notPaid = PaymentStatus._('unpaid');

  /// Оплачен
  static const PaymentStatus paid = PaymentStatus._('paid');

  /// Подтверждён
  static const PaymentStatus accepted = PaymentStatus._('accepted');

  final String _status;

  // Создает статус платежа
  const PaymentStatus._(String status) : _status = status;

  factory PaymentStatus(String status) {
    if (status == null) return null;
    PaymentStatus _curPaymentStatus = PaymentStatus._(status);
    if (values.contains(_curPaymentStatus)) {
      return _curPaymentStatus;
    } else {
      throw ArgumentError('Unknown payment status: ${status}.');
    }
  }

  final Map<String, String> _statusStr = const {
    'unpaid': 'Не оплачен',
    'paid': 'Оплачен',
    'accepted': 'Подтверждён'
  };

  String get value => _status;
  static List get values => [paid, notPaid, accepted];

  @override
  bool operator ==(dynamic other) {
    if (other is PaymentStatus) {
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
