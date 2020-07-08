import 'package:data_model/data_model.dart';

import './agent_before.dart';
import './spec_catalog_item.dart';
import './order_data.dart';
import './spec_status.dart';
import '../datetime/to_local_date_time.dart';
import '../exceptions/data_mismatch_exception.dart';
import '../user/user.dart';

/// Класс спецификация
class Specification implements Model<SpecificationId> {
  /// Идентификатор спецификации
  SpecificationId id;

  /// Номер спецификации
  String no;

  /// Заказ для которого создавалась спецификация
  OrderData orderData;

  /// Агент
  AgentBefore agent;

  /// Оператор
  User operatorBC;

  /// Статус спецификации
  SpecStatus status;

  /// Наименования спецификации
  List<SpecItem> items;

  /// Дата доставки
  DateTime deliveryDate;

  /// Время доставки
  DateTime deliveryTime;

  /// Место доставки
  String deliveryPlace;

  /// Дата создания
  DateTime createdAt;

  /// Дата обновлениия
  DateTime updatedAt;

  /// Общая стоимость
  num get totalCost =>
      items == null ? 0 : items.fold(0, (cost, item) => cost + item.cost);

  Specification(
      {this.id,
      this.no,
      this.orderData,
      this.agent,
      this.operatorBC,
      this.status,
      this.items,
      this.deliveryDate,
      this.deliveryTime,
      this.deliveryPlace,
      this.createdAt,
      this.updatedAt});

  /// Создает спецификацию из JSON-данных
  factory Specification.fromJson(dynamic json) {
    if (json == null) return null;

    if (json is String) {
      return Specification(id: SpecificationId(json));
    }

    if (json is! Map) {
      throw DataMismatchException(
          'Не верный формат json у спецификации - требуется Map');
    }

    List<SpecItem> _items;
    OrderData _orderData;
    AgentBefore _agent;
    User _operatorBC;
    DateTime _deliveryDate;
    DateTime _deliveryTime;
    DateTime _deliveryDateTime = toLocalDateTime(json['delivery_datetime']);

    try {
      _deliveryDate = _deliveryDateTime == null
          ? null
          : DateTime(_deliveryDateTime.year, _deliveryDateTime.month,
              _deliveryDateTime.day);

      _deliveryTime = _deliveryDateTime == null
          ? null
          : DateTime(1, 1, 1, _deliveryDateTime.hour, _deliveryDateTime.minute,
              _deliveryDateTime.second);

      _items = json['items']?.isEmpty ?? true
          ? null
          : (List<SpecItem>.from(
              (json['items'] as List).map((item) => SpecItem.fromJson(item)))
            ..removeWhere((c) => c == null));

      _orderData = OrderData.fromJson(json['order']);
      _agent = AgentBefore.fromJson(json['agent']);
      _operatorBC = User.fromJson(json['operator_bc']);
    } catch (e) {
      throw DataMismatchException(e is Error
          ? e.toString()
          : e.message + '\nУ спецификации id: ${json['id']}');
    }

    return Specification(
        id: SpecificationId(json['id']),
        no: json['no'],
        orderData: _orderData,
        agent: _agent,
        operatorBC: _operatorBC,
        status: SpecStatus(json['status']),
        items: _items,
        deliveryDate: _deliveryDate,
        deliveryTime: _deliveryTime,
        deliveryPlace: json['delivery_place'],
        createdAt: toLocalDateTime(json['created_at']),
        updatedAt: toLocalDateTime(json['updated_at']));
  }

  dynamic get json {
    DateTime deliveryDatetime = deliveryDate == null
        ? null
        : DateTime(
            deliveryDate.year,
            deliveryDate.month,
            deliveryDate.day,
            deliveryTime?.hour ?? 0,
            deliveryTime?.minute ?? 0,
            deliveryTime?.second ?? 0);

    Map<String, dynamic> json = {
      'id': id?.json,
      'no': no,
      'order': orderData?.json,
      'agent': agent?.json,
      'operator_bc': operatorBC?.json,
      'status': status?.json,
      'items': items?.map((item) => item.json)?.toList(),
      'delivery_datetime': deliveryDatetime?.toUtc(),
      'delivery_place': deliveryPlace,
      'created_at': createdAt?.toUtc(),
      'updated_at': updatedAt?.toUtc(),
    }..removeWhere((key, value) => value == null);

    if (json.keys.length == 1 && json.keys.first == 'id') return json['id'];

    return json;
  }
}

class SpecItem {
  /// Товар/услуга каталога
  SpecCatalogItem catalogItem;

  /// Количество
  num amount;

  /// Общая стоимость наименования
  num get cost => (amount ?? 0) * (catalogItem?.price ?? 0);

  SpecItem({this.catalogItem, this.amount});

  /// Создает наименование спецификации из JSON-данных
  factory SpecItem.fromJson(dynamic json) {
    if (json == null) return null;

    return SpecItem(
        catalogItem: SpecCatalogItem.fromJson(json), amount: json['amount']);
  }

  Map<String, dynamic> get json => catalogItem.json
    ..addAll({'amount': amount})
    ..removeWhere((key, value) => value == null);
}

/// Идентификатор спецификации
class SpecificationId extends ObjectId {
  SpecificationId._(dynamic id) : super(id);
  factory SpecificationId(id) {
    if (id == null) return null;
    return SpecificationId._(id);
  }
}
