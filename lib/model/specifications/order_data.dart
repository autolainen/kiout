import 'package:data_model/data_model.dart';

import '../client.dart';
import '../deceased.dart';
import '../exceptions/data_mismatch_exception.dart';
import '../order/order.dart';
import '../order/order_status.dart';

/// Заказ для которого создавалась спецификация (усеченная часть основного заказа)
class OrderData implements Model<OrderId> {
  /// Идентификатор заказа
  OrderId id;

  /// Номер заказа
  String no;

  /// Клиент
  Client client;

  /// Усопший
  Deceased deceased;

  /// Статус заказа
  OrderStatus status;

  OrderData({this.id, this.no, this.client, this.deceased, this.status});

  factory OrderData.fromJson(dynamic json) {
    if (json == null) return null;

    if (json is String) {
      return OrderData(id: OrderId(json));
    }

    if (json is! Map) {
      throw DataMismatchException(
          'Неверный формат json у основной части усеченного заказа - требуется Map');
    }

    Client _client;
    Deceased _deceased;
    OrderStatus _status;
    try {
      _client = Client.fromJson(json['client']);
      _deceased = Deceased.fromJson(json['deceased']);
      _status = OrderStatus(json['status']);
    } catch (e) {
      throw DataMismatchException(e is Error
          ? e.toString()
          : e.message + '\nУ заказа спецификации id: ${json['id']}');
    }

    return OrderData(
        id: OrderId(json['id']),
        no: json['no'],
        client: _client,
        deceased: _deceased,
        status: _status);
  }

  dynamic get json {
    Map<String, dynamic> json = {
      'id': id?.json,
      'no': no,
      'status': status?.json,
      'client': client?.json,
      'deceased': deceased?.json
    }..removeWhere((key, value) => value == null);

    if (json.keys.length == 1 && json.keys.first == 'id') return json['id'];

    return json;
  }
}
