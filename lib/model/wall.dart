import 'package:data_model/data_model.dart';

import 'cemetery.dart';
import 'geo/point.dart';
import 'exceptions/data_mismatch_exception.dart';
import 'order/order.dart';
import 'package/package.dart';

/// Колумбарная стена
class Wall implements Model<WallId> {
  /// Идентификатор колумбарной стены
  WallId id;

  /// Название кладбища
  final String name;

  /// Активность кладбища
  final CemeteryId cemetery;

  /// URL фото
  final String letter;

  /// Дата создания
  final bool active;

  /// Геопозиция
  final Point location;

  /// Ряд колумбарной стены
  final List<WallRow> wallRows;

  Wall(
      {this.id,
      this.name,
      this.active,
      this.cemetery,
      this.letter,
      this.location,
      List<WallRow> wallRows})
      : this.wallRows = List.unmodifiable(wallRows);

  /// Создает колумбарную стену из JSON-данных
  factory Wall.fromJson(dynamic json) {
    if (json == null) return null;

    if (json is String) {
      return Wall(id: WallId(json));
    }

    if (json is! Map) {
      throw DataMismatchException(
          'Не верный формат json у колумбарной стены - требуется String либо Map');
    }

    if (json['name'] != null && json['name'] is! String) {
      throw DataMismatchException(
          'Неверный формат названия ("${json['name']}" - требуется String)\nУ колумбарной стены id: ${json['id']}');
    }
    if (json['active'] != null && json['active'] is! bool) {
      throw DataMismatchException(
          'Неверный формат активности ("${json['active']}" - требуется bool)\nУ колумбарной стены id: ${json['id']}');
    }
    if (json['cemetery'] != null && json['cemetery'] is! String) {
      throw DataMismatchException(
          'Неверный формат идентификатора кладбища ("${json['cemetery']}" - требуется bool)\nУ колумбарной стены id: ${json['id']}');
    }
    if (json['letter'] != null && json['letter'] is! String) {
      throw DataMismatchException(
          'Неверный формат индекса ("${json['letter']}" - требуется String)\nУ колумбарной стены id: ${json['id']}');
    }
    if (json['location'] != null && json['location'] is! Map) {
      throw DataMismatchException(
          'Неверный формат геопозиции ("${json['location']}" - требуется Map)\nУ колумбарной стены id: ${json['id']}');
    }
    if (json['rows'] != null && json['rows'] is! List) {
      throw DataMismatchException(
          'Неверный формат рядов ("${json['rows']}" - требуется List)\nУ колумбарной стены id: ${json['id']}');
    }

    var _wallRows = <WallRow>[];
    var _location;
    try {
      WallRow _wallRow;
      if (json['rows'] != null) {
        (json['rows'] as List).forEach((row) {
          _wallRow = WallRow.fromJson(row);
          if (_wallRow != null) {
            _wallRows.add(_wallRow);
          }
        });
      }
      _location = Point.fromJson(json['location']);
    } catch (e) {
      throw DataMismatchException(e is Error
          ? e.toString()
          : e.message + '\nУ колумбарной стены id: ${json['id']}');
    }

    return Wall(
        id: WallId(json['id']),
        name: json['name'],
        active: json['active'],
        cemetery: CemeteryId(json['cemetery']),
        wallRows: _wallRows,
        location: _location,
        letter: json['letter']);
  }

  @override
  bool operator ==(other) {
    if (other is Wall) {
      return other.id == id;
    }
    return false;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => json.toString();

  /// Возвращает данные персоны в JSON-формате (String/Map)
  ///   String - когда в объекте был заполнен только id
  ///   Map - в ином случае
  @override
  dynamic get json {
    Map<String, dynamic> json = {
      'id': id?.json,
      'name': name,
      'active': active,
      'cemetery': cemetery?.json,
      'letter': letter,
      'location': location?.json,
      'rows': wallRows?.map((row) => row.json)?.toList()
    }..removeWhere((key, value) => value == null);

    if (json.keys.length == 1 && json.keys.first == 'id') return json['id'];

    return json;
  }
}

/// Идентификатор колумбарной стены
class WallId extends ObjectId {
  WallId._(dynamic id) : super(id);
  factory WallId(id) {
    if (id == null) return null;
    return WallId._(id);
  }
}

/// Ряд колумбарной стены
class WallRow implements JsonEncodable {
  /// Номер
  final int number;

  /// Колумбарные ниши
  final List<Niche> niches;

  WallRow({
    this.number,
    List<Niche> niches,
  }) : this.niches = List.unmodifiable(niches);

  /// Создает ряд колумбарной стены из JSON-данных
  factory WallRow.fromJson(Map json) {
    if (json == null) return null;

    if (json['number'] != null && json['number'] is! int) {
      throw DataMismatchException(
          'Неверный формат названия ("${json['number']}" - требуется int)\nУ ряда колумбарной стены');
    }
    if (json['niches'] != null && json['niches'] is! List) {
      throw DataMismatchException(
          'Неверный формат колумбарных ниш ("${json['niches']}" - требуется List)\nУ ряда колумбарной стены');
    }

    var _niches = <Niche>[];
    Niche _niche;
    if (json['niches'] != null) {
      (json['niches'] as List).forEach((niche) {
        _niche = Niche.fromJson(niche);
        if (_niche != null) {
          _niches.add(_niche);
        }
      });
    }

    return WallRow(number: json['number'], niches: _niches);
  }

  @override
  String toString() => json.toString();

  /// Возвращает данные персоны в JSON-формате (String/Map)
  ///   String - когда в объекте был заполнен только id
  ///   Map - в ином случае
  @override
  Map<String, dynamic> get json => {
        'number': number,
        'niches': niches?.map((niche) => niche.json)?.toList()
      }..removeWhere((key, value) => value == null);
}

/// Колумбарная ниша
class Niche implements JsonEncodable {
  /// Номер
  final int number;

  /// Статус
  final NicheStatus status;

  /// Пакеты товаров/услуг
  final List<PackageId> packages;

  /// Заказы
  final List<OrderId> orders;

  Niche({
    this.number,
    this.status,
    List<PackageId> packages,
    List<OrderId> orders,
  })  : this.packages = packages != null ? List.unmodifiable(packages) : null,
        this.orders = orders != null ? List.unmodifiable(orders) : null;

  /// Создает ряд колумбарной стены из JSON-данных
  factory Niche.fromJson(Map json) {
    if (json == null) return null;

    if (json['number'] != null && json['number'] is! int) {
      throw DataMismatchException(
          'Неверный формат названия ("${json['number']}" - требуется int)\nУ ряда колумбарной стены');
    }
    if (json['status'] != null && json['status'] is! String) {
      throw DataMismatchException(
          'Неверный формат статуса ("${json['status']}" - требуется String)\nУ ряда колумбарной стены');
    }
    if (json['packages'] != null && json['packages'] is! List) {
      throw DataMismatchException(
          'Неверный формат пакетов ("${json['packages']}" - требуется List)\nУ ряда колумбарной стены');
    }
    if (json['orders'] != null && json['orders'] is! List) {
      throw DataMismatchException(
          'Неверный формат заказов ("${json['orders']}" - требуется List)\nУ ряда колумбарной стены');
    }

    NicheStatus _status;
    try {
      _status = NicheStatus(json['status']);
    } catch (e) {
      throw DataMismatchException(
          e is Error ? e.toString() : e.message + '\nУ ряда колумбарной стены');
    }
    return Niche(
        number: json['number'],
        status: _status,
        packages:
            (json['packages'] as List)?.map((p) => PackageId(p))?.toList(),
        orders: (json['orders'] as List)?.map((o) => OrderId(o))?.toList());
  }

  @override
  String toString() => json.toString();

  /// Возвращает данные персоны в JSON-формате (String/Map)
  ///   String - когда в объекте был заполнен только id
  ///   Map - в ином случае
  @override
  Map<String, dynamic> get json => {
        'number': number,
        'status': status?.json,
        'packages': packages?.map((p) => p.json)?.toList(),
        'orders': orders?.map((o) => o.json)?.toList()
      }..removeWhere((key, value) => value == null);
}

/// Статус колумбарной ниши
///
/// возможный статус колумбарной ниши:
/// * 4sale - продается
/// * sold - продан
/// * reserved - забронирован
class NicheStatus implements JsonEncodable {
  /// Продается
  static const NicheStatus forSale = NicheStatus._('4sale');

  /// Продан
  static const NicheStatus sold = NicheStatus._('sold');

  /// Забронирован
  static const NicheStatus reserved = NicheStatus._('reserved');

  final String _status;

  // Создает статус колумбарной ниши
  const NicheStatus._(String status) : _status = status;

  factory NicheStatus(String status) {
    if (status == null) return null;
    NicheStatus _curNicheStatus = NicheStatus._(status);
    if (values.contains(_curNicheStatus)) {
      return _curNicheStatus;
    } else {
      throw ArgumentError('Unknown niche status: ${status}.');
    }
  }

  final Map<String, String> _statusStr = const {
    '4sale': 'Продается',
    'sold': 'Продан',
    'reserved': 'Забронирован',
  };

  String get value => _status;
  static List get values => [forSale, sold, reserved];

  @override
  bool operator ==(dynamic other) {
    if (other is NicheStatus) {
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
