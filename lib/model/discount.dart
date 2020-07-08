import 'package:data_model/data_model.dart';

import 'exceptions/data_mismatch_exception.dart';

/// Модель скидки
class Discount implements Model<DiscountId> {
  /// Идентификатор скидки
  DiscountId id;

  /// Наименование скидки
  String name;

  /// Размер скидки
  num amount;

  Discount({this.id, this.name, this.amount});

  /// Создает скидку из JSON данных
  factory Discount.fromJson(dynamic json) {
    if (json == null) return null;

    if (json is String) return Discount(id: DiscountId(json));

    if (json is! Map) {
      throw DataMismatchException(
          'Неверный формат json у скидки для позиции заказа - требуется String либо Map');
    }

    if (json['name'] is! String || json['name'].isEmpty) {
      throw DataMismatchException(
          'Неверный формат наименования скидки для позиции заказа ("${json['name']}" - требуется непустой String)\n' +
              'У скидки id: ${json['id']}');
    }

    if (json['amount'] != null && json['amount'] is! num) {
      throw DataMismatchException(
          'Неверный формат размера скидки ("${json['amount']}" - требуется num)\nУ скидки id: ${json['id']}');
    }

    return Discount(
        id: DiscountId(json['id']), name: json['name'], amount: json['amount']);
  }

  @override
  bool operator ==(other) {
    if (other is Discount) {
      return other.id == id;
    }
    return false;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => json.toString();

  @override
  dynamic get json {
    Map<String, dynamic> json = {'id': id.json, 'name': name, 'amount': amount}
      ..removeWhere((key, value) => value == null);

    if (json.keys.length == 1 && json.keys.first == 'id') return json['id'];
    return json;
  }
}

/// Идентификатор скидки
class DiscountId extends ObjectId {
  DiscountId._(dynamic id) : super(id);
  factory DiscountId(id) {
    if (id == null) return null;
    return DiscountId._(id);
  }
}
