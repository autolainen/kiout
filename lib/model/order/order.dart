import '../cemetery.dart';
import '../client.dart';
import '../coffin_params.dart';
import '../comment.dart';
import '../deceased.dart';
import '../document.dart';
import '../exceptions/data_mismatch_exception.dart';
import '../geo/point.dart';
import '../helpers/json_validators.dart';
import '../order/base_order_data.dart';
import '../specifications/specification.dart';
import '../user/agent.dart';
import '../user/user.dart';
import 'agent_service_order.dart';
import 'burial_order.dart';
import 'cremation_order.dart';
import 'order_item.dart';
import 'order_status.dart';
import 'order_type.dart';
import 'payment_status.dart';
import 'subburial_order.dart';

/// Класс реализующий данные о заказе
class Order extends BaseOrderData {
  /// Менеджер
  UserId manager;

  /// Параметры гроба
  CoffinParams coffin;

  /// Позиции заказа
  List<OrderItem> items;

  /// Статус заказа
  OrderStatus status;

  /// Статус платежа
  PaymentStatus paymentStatus;

  /// Общая стоимость
  num totalAmount;

  /// Дата выполнения
  DateTime executeTo;

  /// Виды работ
  List<String> types;

  /// Спецификация
  Specification specification;

  Order(
      {OrderId id,
      DateTime executeTo,
      DateTime createdAt,
      DateTime updatedAt,
      String no,
      Agent agent,
      List<Comment> comments,
      Point geoPosition,
      Client client,
      Deceased deceased,
      CemeteryId cemetery,
      List<Document> documents,
      this.coffin,
      this.manager,
      this.items,
      this.status,
      this.paymentStatus,
      this.totalAmount,
      this.types,
      this.specification})
      : super(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            no: no,
            agent: agent,
            comments: comments,
            geoPosition: geoPosition,
            client: client,
            deceased: deceased,
            cemetery: cemetery,
            documents: documents) {
    this.executeTo = executeTo?.toLocal();
  }

  /// Создает заказ из JSON-данных
  factory Order.fromJson(dynamic json) {
    if (json == null) return null;

    if (json is String) {
      return Order(id: OrderId(json));
    }

    validateBaseOrderDataJson(json);

    if (json['type'] != null && json['type'] is! List) {
      throw DataMismatchException(
          'Неверный формат типа ("${json['type']}" - требуется List)\nУ заказа id: ${json['id']}');
    }
    var _types = List<String>.from(
        json['type']?.map((type) => type.toString())?.toList() ?? []);

    if (json['manager'] != null && json['manager'] is! String) {
      throw DataMismatchException(
          'Неверный формат менеджера ("${json['manager']}" - требуется String)\nУ заказа id: ${json['id']}');
    }
    if (json['coffin'] != null && json['coffin'] is! Map<String, dynamic>) {
      throw DataMismatchException(
          'Неверный формат параметров гроба ("${json['coffin']}" - требуется Map<String, dynamic>)\nУ заказа id: ${json['id']}');
    }
    if (json['items'] != null && json['items'] is! List) {
      throw DataMismatchException(
          'Неверный формат списка товаров/услуг ("${json['items']}" - требуется List)\nУ заказа id: ${json['id']}');
    }
    if (json['status'] != null && json['status'] is! String) {
      throw DataMismatchException(
          'Неверный формат статуса ("${json['status']}" - требуется String)\nУ заказа id: ${json['id']}');
    }
    if (json['payment_status'] != null && json['payment_status'] is! String) {
      throw DataMismatchException(
          'Неверный формат статуса платежа ("${json['payment_status']}" - требуется String)\nУ заказа id: ${json['id']}');
    }
    if (json['total_amount'] != null && json['total_amount'] is! num) {
      throw DataMismatchException(
          'Неверный формат итоговой стоимости ("${json['total_amount']}" - требуется num)\nУ заказа id: ${json['id']}');
    }
    if (json['execute_to'] != null &&
        json['execute_to'] is! String &&
        json['execute_to'] is! DateTime) {
      throw DataMismatchException(
          'Неверный формат даты исполнения ("${json['execute_to']}" - требуется String или DateTime)\nУ заказа id: ${json['id']}');
    }

    if (_types.contains(OrderType.burial.json))
      return BurialOrder.fromJson(json);
    if (_types.contains(OrderType.subburial.json))
      return SubburialOrder.fromJson(json);
    if (_types.contains(OrderType.cremation.json))
      return CremationOrder.fromJson(json);
    if (_types.contains(OrderType.agentService.json))
      return AgentServiceOrder.fromJson(json);
    throw ArgumentError('Unknown order type: ${json['type']}');
  }

  @override
  bool operator ==(other) {
    if (other is Order) {
      return other.id == id;
    }
    return false;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => json.toString();

  /// Возвращает данные заказа в JSON-формате (String/Map)
  ///   String - когда в объекте был заполнен только id
  ///   Map - в ином случае
  @override
  dynamic get json {
    Map<String, dynamic> json;
    var superJson = super.json;
    if (superJson is String) {
      json = {'id': superJson};
    } else {
      json = superJson;
    }
    json
      ..addAll({
        'manager': manager?.json,
        'coffin': coffin?.json,
        'payment_status': paymentStatus?.json,
        'total_amount': totalAmount,
        'status': status?.json,
        'items': items?.map((item) => item.json)?.toList(),
        'type': types,
        'execute_to': executeTo?.toUtc(),
        'specification': specification?.json
      })
      ..removeWhere((key, value) => value == null);

    if (json.keys.length == 1 && json.keys.first == 'id') return json['id'];

    return json;
  }
}

/// Идентификатор заказа
class OrderId extends OrderEntityId {
  OrderId._(dynamic id) : super(id);
  factory OrderId(id) {
    if (id == null) return null;
    return OrderId._(id);
  }
}
