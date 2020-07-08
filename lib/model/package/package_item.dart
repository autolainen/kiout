import 'package:data_model/data_model.dart';

import '../catalog_item.dart';
import '../exceptions/data_mismatch_exception.dart';

/// Позиция пакета
class PackageItem implements JsonEncodable {
  /// Название
  String name;

  /// Позиции каталога, входящие в позицию пакета
  List<CatalogItemId> catalogItems;

  /// Позиция каталога по умолчанию
  CatalogItemId defaultSelected;

  PackageItem({this.name, this.catalogItems, this.defaultSelected});

  /// Создает позицию пакета из JSON-данных
  factory PackageItem.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    if (json['catalog_items'] != null && json['catalog_items'] is! List) {
      throw DataMismatchException(
          'Неверный формат списка позиций каталога в позиции пакета товаров/услуг ("${json['catalog_items']}" - требуется List)');
    }
    var _catalogItemIds = List<CatalogItemId>.from(
        json['catalog_items']?.map((req) => CatalogItemId(req))?.toList() ??
            []);

    if (json['name'] != null && json['name'] is! String) {
      throw DataMismatchException(
          'Неверный формат имени в позиции пакета товаров/услуг ("${json['name']}" - требуется String)');
    }
    if (json['default'] != null && json['default'] is! String) {
      throw DataMismatchException(
          'Неверный формат позиции каталога по умолчанию в позиции пакета товаров/услуг ("${json['default']}" - требуется String)');
    }
    return PackageItem(
        name: json['name'],
        defaultSelected: CatalogItemId(json['default']),
        catalogItems: _catalogItemIds.isEmpty ? null : _catalogItemIds);
  }

  @override
  String toString() => json.toString();

  /// Возвращает данные позиции пакета в JSON-формате ([Map])
  @override
  Map<String, dynamic> get json => {
        'name': name,
        'default': defaultSelected?.json,
        'catalog_items': catalogItems?.map((item) => item.json)?.toList()
      }..removeWhere((key, value) => value == null);
}
