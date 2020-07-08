import 'package:aahitest/model/package/package.dart';
import 'package:data_model/data_model.dart';
//import 'package:openagent_data_models/src/package/package.dart';

import '../cemetery.dart';
import '../datetime/to_local_date_time.dart';
import '../exceptions/data_mismatch_exception.dart';
import '../geo/polygon.dart';
import '../order/order.dart';
import '../section.dart';

/// Класс реализующий данные об участках из каталога
class Plot implements Model<PlotId> {
  /// Идентификатор участка
  PlotId id;

  /// Название участка из каталога
  String number;

  /// Квартал участка из каталога
  Section section;

  /// Площадь участка
  num area;

  /// Тип участка
  String type;

  /// Стоимость участка
  double cost;

  /// Валюта стоимости
  String currency;

  /// Статус участка
  PlotStatus plotStatus;

  /// Кладбище
  CemeteryId cemetery;

  /// Фотографии участка
  List<String> photos;

  /// Список идентификаторов пакетов доступных для заказа на этом участке
  List<PackageId> packages;

  /// Дата создания
  DateTime createdAt;

  /// Дата обновления
  DateTime updatedAt;

  /// Граница кладбища
  Polygon border;

  /// Заказ, к которуму привязан участок
  OrderId order;

  Plot(
      {this.id,
      DateTime createdAt,
      DateTime updatedAt,
      this.number,
      this.section,
      this.area,
      this.type,
      this.cost,
      this.currency,
      this.plotStatus,
      this.cemetery,
      this.photos,
      this.packages,
      this.border,
      this.order})
      : this.createdAt = createdAt?.toLocal(),
        this.updatedAt = updatedAt?.toLocal();

  /// Создает кладбище из JSON-данных
  factory Plot.fromJson(dynamic json) {
    if (json == null) return null;

    if (json is String) {
      return Plot(id: PlotId(json));
    }

    if (json is! Map) {
      throw DataMismatchException(
          'Не верный формат json у участка- требуется String либо Map');
    }

    if (json['id'] != null && json['_id'] != null) {
      throw DataMismatchException(
          'Идентификатор участка указан в двух атрибутах: id и _id ("${json['id']} ~ ${json['_id']}" - требуется один)');
    }

    if (json['number'] != null && json['number'] is! String) {
      throw DataMismatchException(
          'Неверный формат номера ("${json['number']}" - требуется String)\nУ участка из каталога id: ${json['id']}');
    }
    if (json['area'] != null && json['area'] is! num) {
      throw DataMismatchException(
          'Неверный формат места ("${json['area']}" - требуется num)\nУ участка из каталога id: ${json['id']}');
    }
    if (json['type'] != null && json['type'] is! String) {
      throw DataMismatchException(
          'Неверный формат типа ("${json['type']}" - требуется String)\nУ участка из каталога id: ${json['id']}');
    }
    if (json['cost'] != null && json['cost'] is! double) {
      throw DataMismatchException(
          'Неверный формат стоимости ("${json['cost']}" - требуется double)\nУ участка из каталога id: ${json['id']}');
    }
    if (json['status'] != null && json['status'] is! String) {
      throw DataMismatchException(
          'Неверный формат статуса ("${json['status']}" - требуется String)\nУ участка из каталога id: ${json['id']}');
    }
    if (json['currency'] != null && json['currency'] is! String) {
      throw DataMismatchException(
          'Неверный формат валюты ("${json['currency']}" - требуется String)\nУ участка из каталога id: ${json['id']}');
    }
    if (json['cemetery'] != null && json['cemetery'] is! String) {
      throw DataMismatchException(
          'Неверный формат идентификатора кладбища ("${json['cemetery']}" - требуется String)\nУ участка из каталога id: ${json['id']}');
    }
    if (json['photo'] != null && json['photo'] is! List) {
      throw DataMismatchException(
          'Неверный формат списка фотографий ("${json['photo']}" - требуется List)\nУ участка из каталога id: ${json['id']}');
    }
    if (json['order'] != null && json['order'] is! String) {
      throw DataMismatchException(
          'Неверный формат заказа ("${json['order']}" - требуется String)\nУ участка из каталога id: ${json['id']}');
    }
    if (json['packages'] != null && json['packages'] is! List) {
      throw DataMismatchException(
          'Неверный формат списка пакетов ("${json['packages']}" - требуется List)\nУ участка из каталога id: ${json['id']}');
    }
    List<PackageId> _packages = json['packages'] == null
        ? null
        : (json['packages'] as List)
            .map((package) => PackageId(package))
            .toList();

    if (json['section'] != null &&
        json['section'] is! Map<String, dynamic> &&
        json['section'] is! String) {
      throw DataMismatchException(
          'Неверный формат квартала ("${json['section']}" - требуется Map<String, dynamic> или String)\nУ участка из каталога id: ${json['id']}');
    }
    Polygon _border;
    if (json['geom'] == null ||
        json['geom'] is Map<String, dynamic> &&
            json['geom']['coordinates'] is List &&
            json['geom']['coordinates'][0] is List &&
            json['geom']['coordinates'][0][0] is List) {
      if (json['geom'] != null) {
        try {
          _border = Polygon.fromJson(json['geom']);
        } catch (e) {
          throw DataMismatchException(e.message ??
              e.toString() +
                  '\nНеверный формат границ у участка из каталога id: ${json['id']}');
        }
      }
    } else {
      throw DataMismatchException(
          'Неверный формат границ кладбища ("${json['geom']}" - требуется Map<String, dynamic>)\nУ участка из каталога id: ${json['id']}');
    }
    if (json['created_at'] != null &&
        json['created_at'] is! String &&
        json['created_at'] is! DateTime) {
      throw DataMismatchException(
          'Неверный формат даты создания("${json['created_at']}" - требуется String или DateTime)\nУ участка из каталога id: ${json['id']}');
    }
    if (json['updated_at'] != null &&
        json['updated_at'] is! String &&
        json['updated_at'] is! DateTime) {
      throw DataMismatchException(
          'Неверный формат даты обновления ("${json['updated_at']}" - требуется String или DateTime)\nУ участка из каталога id: ${json['id']}');
    }

    List<String> _photos = [];
    if (json['photo'] != null) {
      _photos = List<String>.from(
          json['photo'].map((photo) => photo.toString()).toList());
    }

    PlotId id;
    if (json['_id'] != null) {
      id = PlotId(
          json['_id'] is String ? json['_id'] : json['_id']?.toHexString());
    } else {
      id = PlotId(json['id']);
    }

    return Plot(
        id: id,
        number: json['number'],
        section: Section.fromJson(json['section']),
        area: json['area'],
        type: json['type'],
        cost: json['cost'],
        currency: json['currency'],
        plotStatus: PlotStatus(json['status']),
        cemetery: CemeteryId(json['cemetery']),
        photos: _photos.isEmpty ? null : _photos,
        packages: _packages,
        border: _border,
        order: OrderId(json['order']),
        createdAt: toLocalDateTime(json['created_at']),
        updatedAt: toLocalDateTime(json['updated_at']));
  }

  @override
  bool operator ==(other) {
    if (other is Plot) {
      return other.id == id;
    }
    return false;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => json.toString();

  /// Возвращает данные участка в JSON-формате (String/Map)
  ///   String - когда в объекте был заполнен только id
  ///   Map - в ином случае
  @override
  dynamic get json {
    Map<String, dynamic> json = {
      'id': id?.json,
      'geom': border?.json,
      'number': number,
      'section': section?.json,
      'area': area,
      'type': type,
      'cost': cost,
      'currency': currency,
      'status': plotStatus?.json,
      'cemetery': cemetery?.json,
      'order': order?.json,
      'photo': photos,
      'packages': packages?.map((package) => package.json)?.toList(),
      'created_at': createdAt?.toUtc(),
      'updated_at': updatedAt?.toUtc()
    }..removeWhere((key, value) => value == null);

    if (json.keys.length == 1 && json.keys.first == 'id') return json['id'];

    return json;
  }
}

/// Идентификатор участка из каталога
class PlotId extends ObjectId {
  PlotId._(dynamic id) : super(id);
  factory PlotId(id) {
    if (id == null) return null;
    return PlotId._(id);
  }
}

/// Статус участка кладбища
///
/// возможный статус участка:
/// * recent - новый
/// * ready - подготовлен
/// * forSale - продается
/// * reserved - зарезервирован
/// * sold - продан
class PlotStatus implements JsonEncodable {
  /// Новый
  static const PlotStatus recent = PlotStatus._('new');

  /// Подготовлен
  static const PlotStatus ready = PlotStatus._('ready');

  /// Продается
  static const PlotStatus forSale = PlotStatus._('4sale');

  /// Зарезервирован
  static const PlotStatus reserved = PlotStatus._('reserved');

  /// Продан
  static const PlotStatus sold = PlotStatus._('sold');

  final String _status;

  // Создает статус участка
  const PlotStatus._(String status) : _status = status;

  factory PlotStatus(String status) {
    if (status == null) return null;
    PlotStatus _curStatus = PlotStatus._(status);
    if (values.contains(_curStatus)) {
      return _curStatus;
    } else {
      throw ArgumentError('Invalid plot status: ${status}.');
    }
  }

  final Map<String, String> _statusStr = const {
    'new': 'Новый',
    'ready': 'Подготовлен',
    '4sale': 'Продаётся',
    'reserved': 'Зарезервирован',
    'sold': 'Продан'
  };

  String get value => _status;
  static List get values => [recent, ready, forSale, reserved, sold];

  @override
  bool operator ==(dynamic other) {
    if (other is PlotStatus) {
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
