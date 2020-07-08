import 'package:data_model/data_model.dart';
import '../package/package_type.dart';

/// Тип заказа
///
/// возможный тип заказа:
/// * burial - захоронение
/// * subburial - подзахоронение
/// * cremation - кремация
/// * agentService - агентские услуги
/// * accomplishment - благоустройство
class OrderType implements JsonEncodable {
  /// Захоронение
  static const OrderType burial = OrderType._('захоронение');

  /// Подзахоронение
  static const OrderType subburial = OrderType._('подзахоронение');

  /// Кремация
  static const OrderType cremation = OrderType._('кремация');

  /// Агентские услуги
  static const OrderType agentService = OrderType._('агентские услуги');

  /// Благоустройство
  static const OrderType accomplishment = OrderType._('благоустройство');

  final String _type;

  // Создает тип заказа
  const OrderType._(String type) : _type = type;

  factory OrderType(String type) {
    if (type == null) return null;
    OrderType _curType = OrderType._(type);
    if (values.contains(_curType)) {
      return _curType;
    } else {
      throw ArgumentError('Invalid order type: ${type}.');
    }
  }

  final Map<String, List<PackageType>> _packageTypes = const {
    'захоронение': [
      PackageType.atCemetery,
      PackageType.burial,
      PackageType.main
    ],
    'подзахоронение': [
      PackageType.atCemetery,
      PackageType.subburial,
      PackageType.main
    ],
    'кремация': [PackageType.cremation],
    'агентские услуги': [PackageType.agentService],
    'благоустройство': []
  };

  String get value => _type;
  static List get values =>
      [burial, subburial, cremation, agentService, accomplishment];

  @override
  bool operator ==(dynamic other) {
    if (other is OrderType) {
      return other._type == _type;
    }
    return false;
  }

  @override
  int get hashCode => _type.hashCode;

  String get json => _type;

  List<PackageType> get packageTypes => _packageTypes[_type];

  @override
  String toString() => json.toString();
}
