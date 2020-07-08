import 'package:data_model/data_model.dart';

class Sku implements JsonEncodable {
  /// Значение артикула
  final String value;

  /// Тип позиции
  ItemType itemType;

  Sku._(this.value) {
    switch (value.split('-').first.toLowerCase()) {
      case 'g':
        this.itemType = ItemType.product;
        break;
      case 's':
      case 'ex':
        this.itemType = ItemType.service;
        break;
      case 'p':
        this.itemType = ItemType.package;
        break;
      default:
        throw ArgumentError('Invalid sku (item type): ${value}.');
    }
  }

  @override
  bool operator ==(other) {
    if (other is Sku) {
      return other.value == value;
    }
    return false;
  }

  @override
  int get hashCode => value.hashCode;

  factory Sku(String value) {
    if (value == null) return null;
    return Sku._(value);
  }

  String get json => value;

  @override
  String toString() => json.toString();
}

/// Тип позиции
///
/// возможные типы позиции:
/// * service - услуга
/// * product - товар
/// * package - пакет
class ItemType implements JsonEncodable {
  /// Услуга
  static const ItemType service = ItemType._('услуга');

  /// Товар
  static const ItemType product = ItemType._('товар');

  /// Пакет
  static const ItemType package = ItemType._('пакет');

  final String _type;

  // Создает тип позиции каталога
  const ItemType._(String type) : _type = type;

  factory ItemType(String type) {
    if (type == null) return null;
    ItemType _curtype = ItemType._(type);
    if (values.contains(_curtype)) {
      return _curtype;
    } else {
      throw ArgumentError('Unknown user type: ${type}.');
    }
  }

  String get value => _type;
  static List get values => [service, product, package];

  @override
  bool operator ==(dynamic other) {
    if (other is ItemType) {
      return other._type == _type;
    }
    return false;
  }

  @override
  int get hashCode => _type.hashCode;

  String get json => _type;

  @override
  String toString() => json.toString();
}
