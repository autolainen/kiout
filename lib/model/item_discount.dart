import 'package:data_model/data_model.dart';

import 'discount.dart';
import 'exceptions/data_mismatch_exception.dart';

/// Cкидка позиции заказа
class ItemDiscount implements JsonEncodable {
  /// Идентификатор скидки
  DiscountId idOrigin;

  /// Размер скидки
  num amount;

  ItemDiscount({this.idOrigin, this.amount});

  /// Создает скидку позиции заказа из JSON данных
  factory ItemDiscount.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    DiscountId _id = DiscountId(json['id_origin']);

    if (json['amount'] != null && json['amount'] is! num) {
      throw DataMismatchException(
          'Неверный формат размера скидки ("${json['amount']}" - требуется num)\nУ скидки id: ${_id?.json}');
    }

    return ItemDiscount(idOrigin: _id, amount: json['amount']);
  }

  @override
  bool operator ==(other) {
    if (other is ItemDiscount) {
      return other.idOrigin == idOrigin && other.amount == amount;
    }
    return false;
  }

  @override
  int get hashCode => idOrigin.hashCode;

  @override
  String toString() => json.toString();

  @override
  Map<String, dynamic> get json {
    Map<String, dynamic> json = {'id_origin': idOrigin?.json, 'amount': amount}
      ..removeWhere((key, value) => value == null);

    return json;
  }
}
