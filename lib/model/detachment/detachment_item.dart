import 'package:data_model/data_model.dart';

import '../attachment/attachment.dart';
import '../attribute.dart';
import '../catalog_item.dart';
import '../datetime/to_local_date_time.dart';
import '../helpers/json_validators.dart';
import '../item.dart';
import '../purchase_price.dart';
import '../sku.dart';

/// Позиция наряда
class DetachmentItem extends Item implements Model<DetachmentItemId> {
  /// Идентификатор позиции наряда
  DetachmentItemId id;

  /// Идентификатор оригинального товара/услуги
  CatalogItemId idOrigin;

  DetachmentItem(
      {this.id,
      this.idOrigin,
      Sku sku,
      List<String> types,
      String name,
      String description,
      dynamic amountOrigin,
      String unit,
      num norm,
      num price,
      num fee,
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

  /// Создает позицию наряда из JSON данных
  factory DetachmentItem.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    validateItemJson(json);

    var _types = fetchItemTypes(json);

    return DetachmentItem(
        id: DetachmentItemId(json['id']),
        idOrigin: CatalogItemId(json['id_origin']),
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
        attributes: fetchItemAttributes(json));
  }

  @override
  bool operator ==(other) {
    if (other is DetachmentItem) {
      return other.id == id;
    }
    return false;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => json.toString();

  /// Возвращает данные позиции наряда в JSON-формате (String/Map)
  ///   String - когда в объекте был заполнен только id
  ///   Map - в ином случае
  @override
  dynamic get json {
    {
      var json = Map<String, dynamic>.from(super.json);
      json
        ..addAll({
          'id': id?.json,
          'id_origin': idOrigin?.json,
        })
        ..removeWhere((key, value) => value == null);
      if (json.keys.length == 1 && json.keys.first == 'id') return json['id'];
      return json;
    }
  }
}

/// Идентификатор позиции наряда
class DetachmentItemId extends ObjectId {
  DetachmentItemId._(dynamic id) : super(id);
  factory DetachmentItemId(id) {
    if (id == null) return null;
    return DetachmentItemId._(id);
  }
}
