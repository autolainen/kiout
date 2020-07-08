import 'package:data_model/data_model.dart';

import '../attachment/attachment.dart';
import '../attribute.dart';
import '../datetime/to_local_date_time.dart';
import '../exceptions/data_mismatch_exception.dart';
import '../hall.dart';
import '../helpers/json_validators.dart';
import '../item_discount.dart';
import '../item.dart';
import '../purchase_price.dart';
import '../sku.dart';

/// Позиция заказа
class OrderItem extends Item implements Model<OrderItemId> {
  /// Идентификатор позиции заказа
  OrderItemId id;

  /// Идентификатор оригинального товара/услуги/пакета
  ItemId idOrigin;

  /// Идентификатор зала прощания
  HallId idHall;

  /// Скидка
  ItemDiscount discount;

  /// Размер НДС (null - свидетельствует об отсутствии)
  num vatRate;

  /// Подпозиции заказа
  List<OrderItem> items;

  OrderItem(
      {this.id,
      this.discount,
      this.vatRate,
      this.items,
      this.idOrigin,
      this.idHall,
      Sku sku,
      List<String> types,
      String name,
      String description,
      dynamic amountOrigin,
      String unit,
      num price,
      num fee,
      num norm,
      PurchasePrice purchasePrice,
      String currency,
      List<Attachment> photos,
      List<Attribute> attributes,
      DateTime createdAt,
      DateTime updatedAt})
      : super(
          sku: sku,
          types: types,
          name: name,
          description: description,
          amountOrigin: amountOrigin,
          unit: unit,
          price: price,
          fee: fee,
          norm: norm,
          purchasePrice: purchasePrice,
          currency: currency,
          photos: photos,
          attributes: attributes,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  /// Создает позицию заказа из JSON данных
  factory OrderItem.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    validateItemJson(Map<String, dynamic>.from(json));

    ItemDiscount _discount;
    try {
      _discount = ItemDiscount.fromJson(json['discount']);
    } catch (e) {
      throw DataMismatchException(e is Error
          ? e.toString()
          : e.message + '\nУ позиции заказа id: ${json['id']}');
    }

    var _types = fetchItemTypes(json);
    var _items = <OrderItem>[];
    try {
      _items = json['items'] == null
          ? null
          : List<OrderItem>.from(
              json['items'].map((item) => OrderItem.fromJson(item)));
    } catch (e) {
      throw DataMismatchException(e is Error
          ? e.toString()
          : e.message + '\nУ позиции заказа id: ${json['id']}');
    }

    return OrderItem(
        id: OrderItemId(json['id']),
        idOrigin: ItemId(json['id_origin']),
        idHall: HallId(json['id_hall']),
        createdAt: toLocalDateTime(json['created_at']),
        updatedAt: toLocalDateTime(json['updated_at']),
        name: json['name'],
        norm: json['norm'],
        description: json['description'],
        sku: Sku(json['sku']),
        types: _types.isEmpty ? null : _types,
        amountOrigin: json['amount'],
        unit: json['unit'],
        price: json['price'],
        fee: json['fee'],
        purchasePrice: fetchPurchasePrice(json),
        currency: json['currency'],
        photos: fetchItemPhotos(json),
        attributes: fetchItemAttributes(json),
        discount: _discount,
        vatRate: json['vat_rate'],
        items: (_items?.isEmpty ?? true) ? null : _items);
  }

  @override
  bool operator ==(other) {
    if (other is OrderItem) {
      return other.id == id;
    }
    return false;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => json.toString();

  /// Возвращает данные позиции заказа в JSON-формате (String/Map)
  ///   String - когда в объекте был заполнен только id
  ///   Map - в ином случае
  @override
  dynamic get json {
    var json = Map<String, dynamic>.from(super.json);

    json
      ..addAll({
        'id': id?.json,
        'id_origin': idOrigin?.json,
        'id_hall': idHall?.json,
        'discount': discount?.json,
        'items': items?.map((item) => item.json)?.toList(),
      })
      ..removeWhere((key, value) => value == null);
    if (sku != null) json..addAll({'vat_rate': vatRate});
    if (json.keys.length == 1 && json.keys.first == 'id') return json['id'];
    return json;
  }
}

/// Идентификатор позиции наряда
class OrderItemId extends ObjectId {
  OrderItemId._(dynamic id) : super(id);
  factory OrderItemId(id) {
    if (id == null) return null;
    return OrderItemId._(id);
  }
}
