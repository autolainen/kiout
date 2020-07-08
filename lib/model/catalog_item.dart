import 'package:data_model/data_model.dart';

import 'attachment/attachment.dart';
import 'attribute.dart';
import 'datetime/to_local_date_time.dart';
import 'ekam.dart';
import 'exceptions/data_mismatch_exception.dart';
import 'fee.dart';
import 'hall.dart';
import 'helpers/json_validators.dart';
import 'item.dart';
import 'purchase_price.dart';
import 'service_norm.dart';
import 'sku.dart';
import 'user/user_group.dart';
import 'work_category.dart';
import 'work_type.dart';

/// Позиция каталога
class CatalogItem extends Item implements Model<CatalogItemId> {
  /// Идентификатор позиции каталога
  CatalogItemId id;

  /// Тип работы верхнего уровня
  ItemType itemType;

  /// Категория работы
  WorkCategory workCategory;

  /// Вид работы
  WorkType workType;

  /// Признак зала прощания
  bool isFarewellHall;

  /// Идентификатор зала прощания
  HallId hallId;

  /// Теги
  List<String> tags;

  /// Комиссии
  List<Fee> fees;

  /// Количество на складе
  int quantity;

  /// Обязательные позиции каталога, идущие с этим
  List<CatalogItemId> require;

  /// Рекомендованные позиции каталога
  List<CatalogItemId> recommend;

  /// Статус
  ItemStatus status;

  /// Норматив выполнения услуги
  List<ServiceNorm> norms;

  /// Размер НДС (null - свидетельствует об отсутствии)
  num vatRate;

  /// Примечание
  String note;

  /// Доступность для групп пользователей
  List<UserGroupId> allowedForGroups;

  /// Данные Ekam (электронной кассы)
  Ekam ekam;

  /// Доступность для предзаказа
  bool allowedForOpportunities;

  /// Только для пакета
  bool onlyForPackage;

  /// Закупочные стоимости
  List<PurchasePrice> purchasePrices;

  /// Количество, идущее в заказ
  @override
  num get amount => 1;

  static const String externalHall = 'зал прощания';

  CatalogItem({
    DateTime createdAt,
    DateTime updatedAt,
    Sku sku,
    String name,
    String description,
    num price,
    String currency,
    String unit,
    dynamic amountOrigin,
    num norm,
    num fee,
    PurchasePrice purchasePrice,
    List<Attribute> attributes,
    List<Attachment> photos,
    List<String> types,
    this.id,
    this.itemType,
    this.workCategory,
    this.workType,
    this.isFarewellHall = false,
    this.hallId,
    this.tags,
    this.fees,
    this.quantity,
    this.require,
    this.recommend,
    this.status,
    this.norms,
    this.vatRate,
    this.note,
    this.allowedForGroups,
    this.ekam,
    this.allowedForOpportunities,
    this.onlyForPackage,
    this.purchasePrices,
  }) : super(
            norm: norm,
            fee: fee,
            purchasePrice: purchasePrice,
            createdAt: createdAt,
            updatedAt: updatedAt,
            sku: sku,
            name: name,
            description: description,
            price: price,
            currency: currency,
            unit: unit,
            types: types,
            amountOrigin: amountOrigin,
            attributes: attributes,
            photos: photos) {
    if (types != null) {
      if (types.length < 3) {
        throw DataMismatchException(
            'Неверный формат типов ("$types" - требуется 3 или 4 типа)\nУ позиции каталога id: $id');
      }
      if (types.length == 4 && types.last != externalHall) {
        throw DataMismatchException(
            'Неверный формат типов ("$types" - на 4 позиции может быть только значение "зал прощания")\nУ позиции каталога id: $id');
      }
      this.isFarewellHall = types.length == 4;
      try {
        this.itemType = ItemType(types.first);
        this.workCategory = WorkCategory(types[1]);
        this.workType = WorkType(types[2]);
      } catch (e) {
        throw DataMismatchException(e is Error
            ? e.toString()
            : e.message + '\nВ позиции каталога id: $id');
      }
    }
  }

  factory CatalogItem.fromJson(dynamic json) {
    if (json == null) return null;
    if (json is String) {
      return CatalogItem(id: CatalogItemId(json));
    }

    validateItemJson(json);

    if (json['id'] != null && json['_id'] != null) {
      throw DataMismatchException(
          'Идентификатор позиции каталога указан в двух атрибутах: id и _id ("${json['id']} ~ ${json['_id']}" - требуется один)');
    }
    CatalogItemId id;
    if (json['_id'] != null) {
      id = CatalogItemId(
          json['_id'] is String ? json['_id'] : json['_id']?.toHexString());
    } else {
      id = CatalogItemId(json['id']);
    }

    ItemType _itemType;
    WorkCategory _workCategory;
    WorkType _workType;
    bool _isFarewellHall = false;
    if (json['type'] != null) {
      if ((json['type'] as List).length < 3) {
        throw DataMismatchException(
            'Неверный формат типов ("${json['type']}" - требуется 3 или 4 типа)\nУ позиции каталога id: ${json['id']}');
      }
      if ((json['type'] as List).length == 4 &&
          (json['type'] as List).last != externalHall) {
        throw DataMismatchException(
            'Неверный формат типов ("${json['type']}" - на 4 позиции может быть только значение "зал прощания")\nУ позиции каталога id: ${json['id']}');
      }
      _isFarewellHall = (json['type'] as List).length == 4;
      try {
        _itemType = ItemType((json['type'] as List).first);
        _workCategory = WorkCategory((json['type'] as List)[1]);
        _workType = WorkType((json['type'] as List)[2]);
      } catch (e) {
        throw DataMismatchException(e is Error
            ? e.toString()
            : e.message + '\nВ позиции пакета id: ${json['id']}');
      }
    }

    if (json['quantity'] != null && json['quantity'] is! int) {
      throw DataMismatchException(
          'Неверный формат количества на складе ("${json['quantity']}" - требуется int)\nУ позиции каталога id: ${json['id']}');
    }

    if (json['status'] != null && json['status'] is! String) {
      throw DataMismatchException(
          'Неверный формат статуса ("${json['status']}" - требуется String)\nУ позиции каталога id: ${json['id']}');
    }
    if (json['note'] != null && json['note'] is! String) {
      throw DataMismatchException(
          'Неверный формат примечания ("${json['note']}" - требуется String)\nУ позиции каталога id: ${json['id']}');
    }
    if (json['allowedForOpportunities'] != null &&
        json['allowedForOpportunities'] is! bool) {
      throw DataMismatchException(
          'Неверный формат доступности в предзаказах ("${json['allowedForOpportunities']}" - требуется bool)\nУ позиции каталога id: ${json['id']}');
    }
    if (json['only_for_package'] != null && json['only_for_package'] is! bool) {
      throw DataMismatchException(
          'Неверный формат признака "только для пакета" ("${json['only_for_package']}" - требуется bool)\nУ позиции каталога id: ${json['id']}');
    }
    if (json['vat_rate'] != null && json['vat_rate'] is! num) {
      throw DataMismatchException(
          'Неверный формат размера НДС в предзаказах ("${json['vat_rate']}" - требуется num)\nУ позиции каталога id: ${json['id']}');
    }
    if (json['ekam'] != null && json['ekam'] is! Map<String, dynamic>) {
      throw DataMismatchException(
          'Неверный формат данных ekam ("${json['ekam']}" - требуется Map<String, dynamic>)\nУ позиции каталога id: ${json['id']}');
    }

    if (json['id_hall'] != null && json['id_hall'] is! String) {
      throw DataMismatchException(
          'Неверный формат идентификатора зала прощания ("${json['id_hall']}" - требуется String)\nУ позиции каталога id: ${json['id']}');
    }

    if (json['require'] != null && json['require'] is! List) {
      throw DataMismatchException(
          'Неверный формат списка обязятельных пакетов ("${json['require']}" - требуется List)\nУ позиции каталога id: ${json['id']}');
    }
    var _require = List<CatalogItemId>.from(
        json['require']?.map((req) => CatalogItemId(req))?.toList() ?? []);

    if (json['recommend'] != null && json['recommend'] is! List) {
      throw DataMismatchException(
          'Неверный формат списка рекомендованных пакетов ("${json['recommend']}" - требуется List)\nУ позиции каталога id: ${json['id']}');
    }
    var _recommend = List<CatalogItemId>.from(
        json['recommend']?.map((rec) => CatalogItemId(rec))?.toList() ?? []);

    if (json['tags'] != null && json['tags'] is! List) {
      throw DataMismatchException(
          'Неверный формат списка тегов ("${json['tags']}" - требуется List)\nУ позиции каталога id: ${json['id']}');
    }
    var _tags = List<String>.from(
        json['tags']?.map((tag) => tag.toString())?.toList() ?? []);

    if (json['cemeteries'] != null && json['cemeteries'] is! List) {
      throw DataMismatchException(
          'Неверный формат списка кладбищ ("${json['cemeteries']}" - требуется List)\nУ позиции каталога id: ${json['id']}');
    }
    if (json['allowedForGroups'] != null && json['allowedForGroups'] is! List) {
      throw DataMismatchException(
          'Неверный формат списка разрешенных групп пользователей ("${json['allowedForGroups']}" - требуется List)\nУ позиции каталога id: ${json['id']}');
    }
    var _allowedForGroups = List<UserGroupId>.from(json['allowedForGroups']
            ?.map((group) => UserGroupId(group))
            ?.toList() ??
        []);

    if (json['fees'] != null && json['fees'] is! Map) {
      throw DataMismatchException(
          'Неверный формат комиссий ("${json['fees']}" - требуется Map<String, num>)\nУ позиции каталога id: ${json['id']}');
    }

    var _fees = <Fee>[];
    Fee _fee;
    try {
      if (json['fees'] != null) {
        json['fees'].forEach((group, value) {
          if (value is! num || group is! String) {
            throw DataMismatchException(
                'Неверный формат комиссий ("${json['fees']}" - требуется Map<String, num>)\nУ позиции каталога id: ${json['id']}');
          }
          _fee = Fee(value: value, referrerGroupId: UserGroupId(group));
          if (_fee != null) _fees.add(_fee);
        });
      }
    } catch (e) {
      throw DataMismatchException(e is Error
          ? e.toString()
          : e.message + '\nВ позиции каталога id: ${json['id']}');
    }

    var _purchasePrices = <PurchasePrice>[];
    PurchasePrice _purchasePrice;
    try {
      if (json['purchase_prices'] != null) {
        (json['purchase_prices'] as List).forEach((pp) {
          _purchasePrice = PurchasePrice.fromJson(pp);
          if (_purchasePrice != null) _purchasePrices.add(_purchasePrice);
        });
      }
    } catch (e) {
      throw DataMismatchException(e is Error
          ? e.toString()
          : e.message + '\nВ позиции каталога id: ${json['id']}');
    }

    var _norms = <ServiceNorm>[];
    ServiceNorm _norm;
    try {
      if (json['norms'] != null) {
        (json['norms'] as List).forEach((norm) {
          _norm = ServiceNorm.fromJson(norm);
          if (_norm != null) _norms.add(_norm);
        });
      }
    } catch (e) {
      throw DataMismatchException(e is Error
          ? e.toString()
          : e.message + '\nВ позиции каталога id: ${json['id']}');
    }
    var _types = fetchItemTypes(json);

    return CatalogItem(
      id: id,
      sku: Sku(json['sku']),
      itemType: _itemType,
      workCategory: _workCategory,
      workType: _workType,
      isFarewellHall: _isFarewellHall,
      types: _types.isEmpty ? null : _types,
      name: json['name'],
      description: json['description'],
      price: json['price'],
      unit: json['unit'],
      currency: json['currency'],
      quantity: json['quantity'],
      amountOrigin: json['amount'],
      hallId: HallId(json['id_hall']),
      fees: _fees.isEmpty ? null : _fees,
      fee: json['fee'],
      norm: json['norm'],
      purchasePrice: fetchPurchasePrice(json),
      tags: _tags.isEmpty ? null : _tags,
      require: _require.isEmpty ? null : _require,
      recommend: _recommend.isEmpty ? null : _recommend,
      photos: fetchItemPhotos(json),
      attributes: fetchItemAttributes(json),
      norms: _norms.isEmpty ? null : _norms,
      purchasePrices: _purchasePrices.isEmpty ? null : _purchasePrices,
      status: ItemStatus(json['status']),
      allowedForGroups: _allowedForGroups.isEmpty ? null : _allowedForGroups,
      ekam: Ekam.fromJson(json['ekam']),
      note: json['note'],
      allowedForOpportunities: json['allowedForOpportunities'],
      onlyForPackage: json['only_for_package'],
      vatRate: json['vat_rate'],
      createdAt: toLocalDateTime(json['created_at']),
      updatedAt: toLocalDateTime(json['updated_at']),
    );
  }

  @override
  bool operator ==(other) {
    if (other is CatalogItem) {
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

  /// Возвращает данные позиции каталога в JSON-формате (String/Map)
  ///   String - когда в объекте был заполнен только id
  ///   Map - в ином случае
  @override
  dynamic get json {
    var json = Map<String, dynamic>.from(super.json);
    json
      ..addAll({
        'id': id?.json,
        'tags': tags,
        'quantity': quantity,
        'id_hall': hallId?.json,
        'fees': getFeesJson(),
        'norms': norms?.map((norm) => norm.json)?.toList(),
        'require': require?.map((r) => r.json)?.toList(),
        'recommend': recommend?.map((r) => r.json)?.toList(),
        'status': status?.json,
        'allowedForOpportunities': allowedForOpportunities,
        'only_for_package': onlyForPackage,
        'note': note,
        'ekam': ekam?.json,
        'allowedForGroups':
            allowedForGroups?.map((group) => group.json)?.toList(),
        'purchase_prices': purchasePrices
            ?.map((purchasePrice) => purchasePrice.json)
            ?.toList(),
      })
      ..removeWhere((key, value) => value == null);
    // Для синхронизации с Ekam необходимо сохранять null значение
    if (sku != null) json..addAll({'vat_rate': vatRate});
    if (json.keys.length == 1 && json.keys.first == 'id') return json['id'];
    return json;
  }
}

/// Статус позиции каталога/пакета
///
/// возможный статус позиции:
/// * inactive - неактивен
/// * active - активен
/// * archived - архивный
class ItemStatus implements JsonEncodable {
  /// Неактивен
  static const ItemStatus inactive = ItemStatus._('inactive');

  /// Активен
  static const ItemStatus active = ItemStatus._('active');

  /// Архивный
  static const ItemStatus archived = ItemStatus._('archived');

  final String _status;

  // Соодает статус участка
  const ItemStatus._(String status) : _status = status;

  factory ItemStatus(String status) {
    if (status == null) return null;
    ItemStatus _curStatus = ItemStatus._(status);
    if (values.contains(_curStatus)) {
      return _curStatus;
    } else {
      throw ArgumentError('Invalid item status: ${status}.');
    }
  }

  final Map<String, String> _statusStr = const {
    'inactive': 'Неактивен',
    'active': 'Активен',
    'archived': 'Архивный',
  };

  String get value => _status;
  static List get values => [inactive, active, archived];

  @override
  bool operator ==(dynamic other) {
    if (other is ItemStatus) {
      return other._status == _status;
    }
    return false;
  }

  @override
  int get hashCode => _status.hashCode;

  String get json => _status;

  @override
  String toString() => _statusStr[_status];
}

/// Идентификатор позиции
class CatalogItemId extends ObjectId {
  CatalogItemId._(dynamic id) : super(id);
  factory CatalogItemId(id) {
    if (id == null) return null;
    return CatalogItemId._(id);
  }
}
