import 'package:data_model/data_model.dart';
import 'package:expressions/expressions.dart';

import 'attachment/attachment.dart';
import 'attribute.dart';
import 'exceptions/data_mismatch_exception.dart';
import 'purchase_price.dart';
import 'sku.dart';

/// Позиция заказ-наряда
abstract class Item implements JsonEncodable {
  /// Артикул
  Sku sku;

  /// Виды работ
  List<String> types;

  /// Название
  String name;

  /// Описание
  String description;

  /// Количество, идущее в заказ в том виде, как хранится в базе
  ///
  /// Значение может быть следующих типов: [num] или [String].
  /// Строковое значение должно содержать формулу для вычисления количества, например, 'length/100',
  /// при этом обязательно должен присутствовать одноименный атрибут 'length'
  dynamic amountOrigin;

  /// Количество, идущее в заказ
  num get amount {
    if (amountOrigin == null || amountOrigin is num) return amountOrigin;
    try {
      bool doCeil = false;
      bool doFloor = false;
      bool doRound = false;
      String _amount = amountOrigin.toString();
      if (amountOrigin.toString().startsWith('ceil')) {
        doCeil = true;
        _amount = _amount.replaceFirst('ceil', '');
      }
      if (amountOrigin.toString().startsWith('floor')) {
        doFloor = true;
        _amount = _amount.replaceFirst('floor', '');
      }
      if (amountOrigin.toString().startsWith('round')) {
        doRound = true;
        _amount = _amount.replaceFirst('round', '');
      }
      Expression expression = Expression.parse(_amount);

      var context = <String, dynamic>{};
      attributes?.forEach((attribute) {
        if (attribute.value is String)
          context[attribute.type] = num.tryParse(attribute.value) ?? 0;
      });

      final evaluator = const ExpressionEvaluator();
      num result = evaluator.eval(expression, context);

      if (doCeil) return result.ceil();
      if (doFloor) return result.floor();
      if (doRound) return result.round();

      return result;
    } catch (e) {
      throw DataMismatchException(
          'Неверный формат формулы количества или связанных с ней атрибутов у позиции $sku');
    }
  }

  /// Единица измерения
  String unit;

  /// Цена
  num price;

  /// Комиссия
  num fee;

  /// Закупочная стоимость у подрядчика
  PurchasePrice purchasePrice;

  /// Валюта
  String currency;

  /// Список фото
  List<Attachment> photos;

  /// Аттрибуты
  List<Attribute> attributes;

  /// Норма исполнения услуги
  num norm;

  /// Стоимость
  ///
  /// Вычисляется как произведение цены на количество
  num get cost => (amount ?? 1) * (price ?? 0);

  /// Стоимость комиссии
  ///
  /// Вычисляется как произведение комисии на стоимость
  num get feeCost => (cost ?? 0) * (fee ?? 0);

  /// Дата создания
  DateTime createdAt;

  /// Дата обновления
  DateTime updatedAt;

  Item({
    DateTime createdAt,
    DateTime updatedAt,
    this.sku,
    this.types,
    this.name,
    this.description,
    this.amountOrigin,
    this.unit,
    this.norm,
    this.price,
    this.fee,
    this.purchasePrice,
    this.currency,
    this.photos,
    this.attributes,
  })  : this.createdAt = createdAt?.toLocal(),
        this.updatedAt = updatedAt?.toLocal();

  @override
  String toString() => json.toString();

  /// Возвращает данные товара или услуги в JSON-формате ([Map])
  @override
  dynamic get json => {
        'norm': norm,
        'sku': sku?.json,
        'type': types,
        'name': name,
        'description': description,
        'amount': amountOrigin,
        'unit': unit,
        'price': price,
        'fee': fee,
        'purchase_price': purchasePrice?.json,
        'photo': photos?.map((p) => p.url.json['url'])?.toList(),
        'attributes': attributes?.map((attribute) => attribute.json)?.toList(),
        'currency': currency,
        'created_at': createdAt?.toUtc(),
        'updated_at': updatedAt?.toUtc()
      }..removeWhere((key, value) => value == null);
}

/// Идентификатор позиции
class ItemId extends ObjectId {
  ItemId._(dynamic id) : super(id);
  factory ItemId(id) {
    if (id == null) return null;
    return ItemId._(id);
  }
}
