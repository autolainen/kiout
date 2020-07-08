import 'package:data_model/data_model.dart';

/// Статус заказа
///
/// возможный статус заказа:
/// * draft - черновик
/// * ready - подготовлен
/// * signed - подписан
/// * processing - в процессе
/// * finished - завершён
/// * canceled - отменён
class OrderStatus implements JsonEncodable {
  /// Черновик
  static const OrderStatus draft = OrderStatus._('draft');

  /// Подготовлен
  static const OrderStatus ready = OrderStatus._('ready');

  /// Подписан
  static const OrderStatus signed = OrderStatus._('signed');

  /// В процессе
  static const OrderStatus processing = OrderStatus._('processing');

  /// Завершён
  static const OrderStatus finished = OrderStatus._('finished');

  /// Отменён
  static const OrderStatus canceled = OrderStatus._('canceled');

  final String _status;

  // Создает статус заказа
  const OrderStatus._(String status) : _status = status;

  factory OrderStatus(String status) {
    if (status == null) return null;
    OrderStatus _curOrderStatus = OrderStatus._(status);
    if (values.contains(_curOrderStatus)) {
      return _curOrderStatus;
    } else {
      throw ArgumentError('Unknown order status: ${status}.');
    }
  }

  final Map<String, String> _statusStr = const {
    'draft': 'Черновик',
    'ready': 'Подготовлен',
    'signed': 'Подписан',
    'processing': 'В процессе',
    'finished': 'Завершён',
    'canceled': 'Отменён',
  };

  String get value => _status;
  static List get values =>
      [draft, ready, signed, processing, finished, canceled];

  @override
  bool operator ==(dynamic other) {
    if (other is OrderStatus) {
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
