import 'package:data_model/data_model.dart';

/// Класс товар/услуга каталога товаров/услуг ДО
class SpecCatalogItem implements Model<SpecCatalogItemId> {
  /// Идентификатор товара/услуги ДО
  SpecCatalogItemId id;

  /// Название
  String name;

  /// Стоимость
  num price;

  SpecCatalogItem({this.id, this.name, this.price});

  factory SpecCatalogItem.fromJson(dynamic json) {
    if (json == null) return null;

    return SpecCatalogItem(
        id: SpecCatalogItemId(json['id']),
        name: json['name'],
        price: json['price']);
  }

  Map<String, dynamic> get json => {
        'id': id?.json,
        'name': name,
        'price': price
      }..removeWhere((key, value) => value == null);
}

/// Идентификатор товаров/услуг ДО
class SpecCatalogItemId extends ObjectId {
  SpecCatalogItemId._(dynamic id) : super(id);
  factory SpecCatalogItemId(id) {
    if (id == null) return null;
    return SpecCatalogItemId._(id);
  }
}
