import 'package:data_model/data_model.dart';
import 'package:equatable/equatable.dart';

/// Детализированный адрес
///
/// Формируется в соответствии данными сервиса Dadata
class DetailedAddress with EquatableMixin implements JsonEncodable {
  /// Индекс
  String postalCode;

  /// Город
  String city;

  /// Тип города (сокращенный)
  String cityType;

  /// Тип города
  String cityTypeFull;

  /// Улица
  String street;

  /// Тип улицы (сокращенный)
  String streetType;

  /// Тип улицы
  String streetTypeFull;

  /// Дом
  String house;

  /// Тип дома (сокращенный)
  String houseType;

  /// Тип дома
  String houseTypeFull;

  /// Корпус/строение
  String block;

  /// Тип корпуса/строения (сокращенный)
  String blockType;

  /// Тип корпуса/строения
  String blockTypeFull;

  /// Квартира
  String flat;

  /// Тип квартиры (сокращенный)
  String flatType;

  /// Тип квартиры
  String flatTypeFull;

  DetailedAddress(
      {this.postalCode,
      this.city,
      this.cityType,
      this.cityTypeFull,
      this.house,
      this.houseType,
      this.houseTypeFull,
      this.block,
      this.blockType,
      this.blockTypeFull,
      this.flat,
      this.flatType,
      this.flatTypeFull,
      this.street,
      this.streetType,
      this.streetTypeFull});

  factory DetailedAddress.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return DetailedAddress(
        postalCode: json['postal_code'],
        city: json['city'],
        cityType: json['city_type'],
        cityTypeFull: json['city_type_full'],
        street: json['street'],
        streetType: json['street_type'],
        streetTypeFull: json['street_type_full'],
        house: json['house'],
        houseType: json['house_type'],
        houseTypeFull: json['house_type_full'],
        block: json['block'],
        blockType: json['block_type'],
        blockTypeFull: json['bloc_type_full'],
        flat: json['flat'],
        flatType: json['flat_type'],
        flatTypeFull: json['flat_type_full']);
  }

  @override
  List<Object> get props => [
        postalCode,
        city,
        cityType,
        cityTypeFull,
        street,
        streetType,
        streetTypeFull,
        house,
        houseType,
        houseTypeFull,
        block,
        blockType,
        blockTypeFull,
        flat,
        flatType,
        flatTypeFull
      ];

  @override
  Map<String, dynamic> get json => {
        'postal_code': postalCode,
        'city': city,
        'city_type': cityType,
        'city_type_full': cityTypeFull,
        'street': street,
        'street_type': streetType,
        'street_type_full': streetTypeFull,
        'house': house,
        'house_type': houseType,
        'house_type_full': houseTypeFull,
        'block': block,
        'block_type': blockType,
        'bloc_type_full': blockTypeFull,
        'flat': flat,
        'flat_type': flatType,
        'flat_type_full': flatTypeFull
      }..removeWhere((key, value) => value == null);
}
