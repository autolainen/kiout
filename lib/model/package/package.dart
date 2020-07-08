import 'package:data_model/data_model.dart';

import '../attachment/attachment.dart';
import '../attribute.dart';
import '../catalog_item.dart';
import '../cemetery.dart';
import '../datetime/to_local_date_time.dart';
import '../ekam.dart';
import '../exceptions/data_mismatch_exception.dart';
import '../fee.dart';
import '../hall.dart';
import '../helpers/json_validators.dart';
import '../item_discount.dart';
import '../item.dart';
import '../purchase_price.dart';
import '../sku.dart';
import '../user/user_group.dart';
import 'package_item.dart';
import 'package_type.dart';

/// Пакет услуг/товаров
class Package extends Item implements Model<PackageId> {
  /// Идентификатор пакета товаров/услуг
  PackageId id;

  /// Категории работ
  List<PackageType> packageTypes;

  /// Скидка
  ItemDiscount discount;

  /// Комиссии
  List<Fee> fees;

  /// Позиции пакета
  List<PackageItem> items;

  /// Обязательные пакеты, идущие с этим
  List<Package> require;

  /// Рекомендованные пакеты
  List<PackageId> recommend;

  /// Статус
  ItemStatus status;

  /// Доступность для групп пользователей
  List<UserGroupId> allowedForGroups;

  /// Доступность для предзаказа
  bool allowedForOpportunities;

  /// Размер НДС (null - свидетельствует об отсутствии)
  num vatRate;

  /// Примечание
  String note;

  /// Данные Ekam (электронной кассы)
  Ekam ekam;

  /// Кладбища
  List<CemeteryId> cemeteries;

  /// Прощальный зал
  HallId hall;

  /// Стоимость
  ///
  /// Вычисляется как произведение цены на количество + стоимости дополнительных пакетов
  @override
  num get cost =>
      require?.fold(super.cost, (sum, item) => sum + item.cost) ?? super.cost;

  Package({
    DateTime createdAt,
    DateTime updatedAt,
    Sku sku,
    String name,
    String description,
    num price,
    String currency,
    List<Attachment> photos,
    List<String> types,
    num norm,
    num fee,
    PurchasePrice purchasePrice,
    String unit,
    dynamic amountOrigin,
    List<Attribute> attributes,
    this.id,
    this.discount,
    this.fees,
    this.items,
    this.require,
    this.recommend,
    this.packageTypes,
    this.status,
    this.allowedForGroups,
    this.allowedForOpportunities,
    this.ekam,
    this.hall,
    this.note,
    this.vatRate,
    this.cemeteries,
  }) : super(
          createdAt: createdAt,
          updatedAt: updatedAt,
          sku: sku,
          name: name,
          description: description,
          price: price,
          types: types,
          currency: currency,
          photos: photos,
          norm: norm,
          fee: fee,
          purchasePrice: purchasePrice,
          unit: unit,
          amountOrigin: amountOrigin,
          attributes: attributes,
        );

  factory Package.fromJson(dynamic json) {
    if (json == null) return null;

    if (json is String) {
      return Package(id: PackageId(json));
    }

    validateItemJson(json);

    if (json['id'] != null && json['_id'] != null) {
      throw DataMismatchException(
          'Идентификатор пакета товаров/услуг указан в двух атрибутах: id и _id ("${json['id']} ~ ${json['_id']}" - требуется один)');
    }
    PackageId id;
    if (json['_id'] != null) {
      id = PackageId(
          json['_id'] is String ? json['_id'] : json['_id']?.toHexString());
    } else {
      id = PackageId(json['id']);
    }

    var _packageTypes = List<PackageType>.from(
        json['type']?.map((type) => PackageType(type))?.toList() ?? []);

    if (json['status'] != null && json['status'] is! String) {
      throw DataMismatchException(
          'Неверный формат статуса ("${json['status']}" - требуется num)\nУ пакета товаров/услуг id: ${json['id']}');
    }
    if (json['note'] != null && json['note'] is! String) {
      throw DataMismatchException(
          'Неверный формат примечания ("${json['note']}" - требуется num)\nУ пакета товаров/услуг id: ${json['id']}');
    }
    if (json['allowedForOpportunities'] != null &&
        json['allowedForOpportunities'] is! bool) {
      throw DataMismatchException(
          'Неверный формат доступности в предзаказах ("${json['allowedForOpportunities']}" - требуется bool)\nУ пакета товаров/услуг id: ${json['id']}');
    }
    if (json['vat_rate'] != null && json['vat_rate'] is! num) {
      throw DataMismatchException(
          'Неверный формат размера НДС в предзаказах ("${json['vat_rate']}" - требуется num)\nУ пакета товаров/услуг id: ${json['id']}');
    }
    if (json['ekam'] != null && json['ekam'] is! Map<String, dynamic>) {
      throw DataMismatchException(
          'Неверный формат данных ekam ("${json['ekam']}" - требуется Map<String, dynamic>)\nУ пакета товаров/услуг id: ${json['id']}');
    }
    if (json['require'] != null && json['require'] is! List) {
      throw DataMismatchException(
          'Неверный формат списка обязятельных пакетов ("${json['require']}" - требуется List)\nУ пакета товаров/услуг id: ${json['id']}');
    }
    if (json['recommend'] != null && json['recommend'] is! List) {
      throw DataMismatchException(
          'Неверный формат списка рекомендованных пакетов ("${json['recommend']}" - требуется List)\nУ пакета товаров/услуг id: ${json['id']}');
    }
    if (json['hall'] != null && json['hall'] is! String) {
      throw DataMismatchException(
          'Неверный формат прощального зала ("${json['hall']}" - требуется String)\nУ пакета товаров/услуг id: ${json['id']}');
    }
    var _recommend = List<PackageId>.from(
        json['recommend']?.map((recommend) => PackageId(recommend))?.toList() ??
            []);

    if (json['cemeteries'] != null && json['cemeteries'] is! List) {
      throw DataMismatchException(
          'Неверный формат списка кладбищ ("${json['cemeteries']}" - требуется List)\nУ пакета товаров/услуг id: ${json['id']}');
    }
    var _cemeteries = List<CemeteryId>.from(
        json['cemeteries']?.map((cemetery) => CemeteryId(cemetery))?.toList() ??
            []);

    if (json['allowedForGroups'] != null && json['allowedForGroups'] is! List) {
      throw DataMismatchException(
          'Неверный формат списка разрешенных групп пользователей ("${json['allowedForGroups']}" - требуется List)\nУ пакета товаров/услуг id: ${json['id']}');
    }
    var _allowedForGroups = List<UserGroupId>.from(json['allowedForGroups']
            ?.map((group) => UserGroupId(group))
            ?.toList() ??
        []);

    if (json['fees'] != null && json['fees'] is! Map) {
      throw DataMismatchException(
          'Неверный формат комиссий ("${json['fees']}" - требуется Map<String, num>)\nУ пакета товаров/услуг id: ${json['id']}');
    }

    List<Package> _require;
    List<PackageItem> _items;
    var _fees = <Fee>[];
    Fee _fee;
    try {
      if (json['fees'] != null) {
        json['fees'].forEach((group, value) {
          if (value is! num || group is! String) {
            throw DataMismatchException(
                'Неверный формат комиссий ("${json['fees']}" - требуется Map<String, num>)\nУ пакета товаров/услуг id: ${json['id']}');
          }
          _fee = Fee(value: value, referrerGroupId: UserGroupId(group));
          if (_fee != null) _fees.add(_fee);
        });
      }
      _require = json['require']?.isEmpty ?? true
          ? null
          : List<Package>.from(
              (json['require'] as List).map((item) => Package.fromJson(item)));
      _items = json['items']?.isEmpty ?? true
          ? null
          : List<PackageItem>.from((json['items'] as List)
              .map((item) => PackageItem.fromJson(item)));
    } catch (e) {
      throw DataMismatchException(e is Error
          ? e.toString()
          : e.message + '\nВ пакете товаров/услуг id: ${json['id']}');
    }

    if (json['created_at'] != null &&
        json['created_at'] is! String &&
        json['created_at'] is! DateTime) {
      throw DataMismatchException(
          'Неверный формат даты создания ("${json['created_at']}" - требуется String или DateTime)\nУ пакета товаров/услуг id: ${json['id']}');
    }
    if (json['updated_at'] != null &&
        json['updated_at'] is! String &&
        json['updated_at'] is! DateTime) {
      throw DataMismatchException(
          'Неверный формат даты обновления ("${json['updated_at']}" - требуется String или DateTime)\nУ пакета товаров/услуг id: ${json['id']}');
    }
    final Sku sku = Sku(json['sku']);
    if (_packageTypes.isNotEmpty &&
        !_packageTypes.contains(PackageType(sku?.itemType?.toString()))) {
      throw DataMismatchException(
          'Не совпадает артикул и тип ("${json['sku']}, ${json['type']}")\nУ пакета товаров/услуг id: ${json['id']}');
    }
    var _types = fetchItemTypes(json);

    ItemDiscount _discount;
    try {
      _discount = ItemDiscount.fromJson(json['discount']);
    } catch (e) {
      throw DataMismatchException(e is Error
          ? e.toString()
          : e.message + '\nУ пакета товаров/услуг id: ${json['id']}');
    }

    return Package(
      id: id,
      sku: sku,
      types: _types.isEmpty ? null : _types,
      packageTypes: _packageTypes,
      name: json['name'],
      description: json['description'],
      price: json['price'],
      currency: json['currency'],
      discount: _discount,
      fees: _fees.isEmpty ? null : _fees,
      items: _items,
      require: _require,
      recommend: _recommend.isEmpty ? null : _recommend,
      photos: fetchItemPhotos(json),
      status: ItemStatus(json['status']),
      allowedForGroups: _allowedForGroups.isEmpty ? null : _allowedForGroups,
      cemeteries: _cemeteries.isEmpty ? null : _cemeteries,
      ekam: Ekam.fromJson(json['ekam']),
      hall: HallId(json['hall']),
      note: json['note'],
      norm: json['norm'],
      amountOrigin: json['amount'],
      unit: json['unit'],
      fee: json['fee'],
      purchasePrice: fetchPurchasePrice(json),
      attributes: fetchItemAttributes(json),
      allowedForOpportunities: json['allowedForOpportunities'],
      vatRate: json['vat_rate'],
      createdAt: toLocalDateTime(json['created_at']),
      updatedAt: toLocalDateTime(json['updated_at']),
    );
  }

  @override
  bool operator ==(other) {
    if (other is Package) {
      return other.id == id;
    }
    return false;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => json.toString();

  /// Возвращает json представление комиссий, как хранится в базе
  Map<String, num> getFeesJson() {
    Map<String, num> result = {};
    fees?.forEach((fee) {
      result.addAll({fee.referrerGroupId.json: fee.value});
    });
    return result.isEmpty ? null : result;
  }

  /// Возвращает данные персоны в JSON-формате (String/Map)
  ///   String - когда в объекте был заполнен только id
  ///   Map - в ином случае
  @override
  dynamic get json {
    var json = Map<String, dynamic>.from(super.json);

    json
      ..addAll({
        'id': id?.json,
        'discount': discount?.json,
        'fees': getFeesJson(),
        'items': items?.map((item) => item.json)?.toList(),
        'require': require?.map((r) => r.json)?.toList(),
        'recommend': recommend?.map((r) => r.json)?.toList(),
        'status': status?.json,
        'allowedForOpportunities': allowedForOpportunities,
        'note': note,
        'ekam': ekam?.json,
        'hall': hall?.json,
        'allowedForGroups':
            allowedForGroups?.map((group) => group.json)?.toList(),
        'cemeteries': cemeteries?.map((cemetery) => cemetery.json)?.toList(),
      })
      ..removeWhere((key, value) => value == null);
    // Для синхронизации с Ekam необходимо сохранять null значение
    if (sku != null) json..addAll({'vat_rate': vatRate});
    if (json.keys.length == 1 && json.keys.first == 'id') return json['id'];
    return json;
  }
}

/// Идентификатор позиции наряда
class PackageId extends ObjectId {
  PackageId._(dynamic id) : super(id);
  factory PackageId(id) {
    if (id == null) return null;
    return PackageId._(id);
  }
}
