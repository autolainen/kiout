import 'package:data_model/data_model.dart';

import 'client.dart';
import 'datetime/to_local_date_time.dart';
import 'exceptions/data_mismatch_exception.dart';
import 'purchase_price.dart';

/// Строка биллинга
class BillingItem implements Model<ObjectId> {
  /// Количество
  num amount;

  /// Кладбище / Зал прощания
  String workplace;

  /// Клиент
  Client client;

  /// Валюта
  String currency;

  /// Дата оказания услуги
  DateTime dueDate;

  /// Название
  String name;

  /// Цена
  num price;

  /// Закупочная стоимость у подрядчика
  PurchasePrice purchasePrice;

  /// Единица измерения
  String unit;

  BillingItem(
      {this.amount,
      this.workplace,
      this.client,
      this.currency,
      DateTime dueDate,
      this.name,
      this.price,
      this.purchasePrice,
      this.unit})
      : this.dueDate = dueDate?.toLocal();

  factory BillingItem.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    if (json['amount'] != null && json['amount'] is! num)
      throw DataMismatchException(
          'Неверный формат количества ("${json['amount']}" - требуется num)\nУ позиции биллинга.');

    if (json['workplace'] != null && json['workplace'] is! String) {
      throw DataMismatchException(
          'Неверный формат кладбища/зала прощания ("${json['workplace']}" - требуется String\nУ позиции биллинга');
    }

    if (json['currency'] != null && json['currency'] is! String) {
      throw DataMismatchException(
          'Неверный формат валюты ("${json['currency']}" - требуется String)\nУ позиции биллинга');
    }

    if (json['client'] != null && json['client'] is! Map<String, dynamic>) {
      throw DataMismatchException(
          'Неверный формат клиента ("${json['client']}" - требуется Map<String, dynamic>)\nУ позиции биллинга.');
    }

    if (json['due_date'] != null &&
        json['due_date'] is! String &&
        json['due_date'] is! DateTime) {
      throw DataMismatchException(
          'Неверный формат даты оказания услуги ("${json['due_date']}" - требуется String или DateTime)\nУ позиции биллинга.');
    }

    if (json['name'] != null && json['name'] is! String) {
      throw DataMismatchException(
          'Неверный формат названия ("${json['name']}" - требуется String)\nУ позиции биллинга.');
    }

    if (json['price'] != null && json['price'] is! num) {
      throw DataMismatchException(
          'Неверный формат цены ("${json['price']}" - требуется num)\nУ позиции биллинга.');
    }
    if (json['purchase_price'] != null &&
        json['purchase_price'] is! Map<String, dynamic>) {
      throw DataMismatchException(
          'Неверный формат закупочной цены ("${json['purchase_price']}" - требуется Map<String, dynamic>)\nУ позиции биллинга.');
    }

    if (json['unit'] != null && json['unit'] is! String) {
      throw DataMismatchException(
          'Неверный формат единицы измерения ("${json['unit']}" - требуется String)\nУ позиции биллинга.');
    }

    if (json['due_date'] != null &&
        json['due_date'] is! String &&
        json['due_date'] is! DateTime) {
      throw DataMismatchException(
          'Неверный формат даты выполнения ("${json['due_date']}" - требуется String или DateTime)\nУ позиции биллинга');
    }

    return BillingItem(
        amount: json['amount'],
        workplace: json['workplace'],
        client: Client.fromJson(json['client']),
        currency: json['currency'],
        dueDate: toLocalDateTime(json['due_date']),
        name: json['name'],
        price: json['price'],
        purchasePrice: PurchasePrice.fromJson(json['purchase_price']),
        unit: json['unit']);
  }

  /// Возвращает данные адреса в JSON-формате ([Map])
  @override
  Map<String, dynamic> get json => {
        'amount': amount,
        'workplace': workplace,
        'client': client?.json,
        'currency': currency,
        'due_date': dueDate?.toUtc(),
        'name': name,
        'price': price,
        'purchase_price': purchasePrice?.json,
        'unit': unit
      }..removeWhere((key, value) => value == null);

  @override
  String toString() => json.toString();

  @override
  ObjectId id;
}
