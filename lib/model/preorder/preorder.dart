import 'package:kiouttest/model/package/package_type.dart';
import 'package:kiouttest/model/preorder/agent_service_preorder.dart';
import 'package:kiouttest/model/sku.dart';
import 'package:kiouttest/model/work_category.dart';
import 'package:kiouttest/model/work_type.dart';
import 'package:collection/collection.dart';

import '../catalog_item.dart';
import '../cemetery.dart';
import '../client.dart';
import '../comment.dart';
import '../datetime/to_local_date_time.dart';
import '../deceased.dart';
import '../document.dart';
import '../exceptions/data_mismatch_exception.dart';
import '../geo/point.dart';
import '../helpers/json_validators.dart';
import '../order/base_order_data.dart';
import '../order/order_item.dart';
import '../order/order_type.dart';
import '../package/package.dart';
import '../representative.dart';
import '../user/agent.dart';
import '../user/referrer.dart';
import '../user/user.dart';
import 'preorder_status.dart';

/// Класс реализующий данные о предзаказе
class Preorder extends BaseOrderData {
  /// Представитель
  Representative representative;

  /// Внешний агент
  Referrer referrer;

  /// Менеджер внешних агентов
  User referrersManager;

  /// Оператор колл-центра
  User operatorCC;

  /// Позиции предзаказа
  List<OrderItem> items;

  /// Статус предзаказа
  PreorderStatus status;

  /// Геопозиция участка
  Point plotPosition;

  /// Тип предзаказа
  OrderType type;

  /// Дата назначения
  DateTime assignedAt;

  /// Стоимость предзаказа
  num get cost =>
      additionalItems?.fold(
          package?.cost ?? 0, (sum, item) => sum + item.cost) ??
      package?.cost ??
      0;

  /// Стоимость комиссии предзаказа
  num get feeCost =>
      additionalItems?.fold(
          package?.feeCost ?? 0, (sum, item) => sum + item.feeCost) ??
      package?.feeCost ??
      0;

  /// Пакет, входящий в состав предзаказа
  Package get package {
    Package _package;
    try {
      items?.forEach((orderItem) {
        if (orderItem.types != null && orderItem.types.contains('пакет')) {
          var _json = orderItem.json;
          _json['id'] = orderItem.idOrigin.json;
          _package = Package.fromJson(_json);
          return;
        }
      });
    } catch (e) {
      print(e);
    }
    if (_package != null) {
      var _requiredPackages = <Package>[];
      try {
        OrderItem _packageOrderItem = items?.firstWhere(
            (orderItem) =>
                orderItem.types != null && orderItem.types.contains('пакет'),
            orElse: () => null);
        _packageOrderItem?.items?.forEach((orderItem) {
          if (orderItem.types != null && orderItem.types.contains('пакет')) {
            var _json = orderItem.json;
            _json['id'] = orderItem.idOrigin.json;
            _requiredPackages.add(Package.fromJson(_json));
          }
        });
        _package.require = _requiredPackages.isEmpty ? null : _requiredPackages;
      } catch (e) {
        print(e);
      }
    }
    return _package;
  }

  /// Дополнительные товары и услуги, входящие в состав предзаказа
  List<CatalogItem> get additionalItems {
    var _additionalItems = <CatalogItem>[];
    try {
      items?.forEach((orderItem) {
        if (orderItem.types != null && !orderItem.types.contains('пакет')) {
          var _json = orderItem.json;
          _json['id'] = orderItem.idOrigin.json;
          _additionalItems.add(CatalogItem.fromJson(_json));
        }
      });
    } catch (e) {
      print(e);
    }
    return _additionalItems.isEmpty ? null : _additionalItems;
  }

  OrderItem get farewellService {
    if (type != OrderType.cremation) return null;
    final eq = const UnorderedIterableEquality<String>().equals;
    OrderItem result;
    for (OrderItem preorderItem in items ?? []) {
      if (preorderItem.types?.contains(PackageType.package.json) ?? false) {
        for (OrderItem packageItem in preorderItem?.items ?? []) {
          for (OrderItem serviceItem in packageItem?.items ?? []) {
            if (eq(serviceItem?.types ?? [], [
              ItemType.service.json,
              WorkCategory.farewellHall.json,
              WorkType.farewell.json,
              CatalogItem.externalHall
            ])) {
              if (serviceItem.idHall != null) {
                result = serviceItem;
                break;
              }
            }
          }
          if (result != null) break;
        }
      }
      if (result != null) break;
    }
    return result;
  }

  Preorder({
    PreorderId id,
    DateTime createdAt,
    DateTime updatedAt,
    String no,
    Agent agent,
    List<Comment> comments,
    Point geoPosition,
    Client client,
    Deceased deceased,
    CemeteryId cemetery,
    List<Document> documents,
    DateTime assignedAt,
    this.referrer,
    this.referrersManager,
    this.representative,
    this.operatorCC,
    this.items,
    this.status,
    this.type,
    this.plotPosition,
  }) : super(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            no: no,
            agent: agent,
            comments: comments,
            geoPosition: geoPosition,
            client: client,
            deceased: deceased,
            cemetery: cemetery,
            documents: documents) {
    this.assignedAt = assignedAt?.toLocal();
  }

  /// Создает предзаказ из JSON-данных
  factory Preorder.fromJson(dynamic json) {
    if (json == null) return null;

    if (json is String) {
      return Preorder(id: PreorderId(json));
    }

    validateBaseOrderDataJson(json);
    validatePreorderDataJson(json);

    OrderType _type;
    try {
      _type = OrderType(json['type']);
    } catch (e) {
      throw DataMismatchException(e is Error
          ? e.toString()
          : e.message + '\nУ предзаказа id: ${json['id']}');
    }

    if (_type == OrderType.agentService) {
      return AgentServicePreorder.fromJson(json);
    }

    List<OrderItem> _items = json['items']?.isEmpty ?? true
        ? null
        : List<OrderItem>.from(
            (json['items'] as List).map((item) => OrderItem.fromJson(item)));

    List<Comment> _comments = json['comments']?.isEmpty ?? true
        ? null
        : List<Comment>.from((json['comments'] as List)
            .map((comment) => Comment.fromJson(comment)));

    List<Document> _documents = json['documents']?.isEmpty ?? true
        ? null
        : List<Document>.from((json['documents'] as List)
            .map((document) => Document.fromJson(document)));

    Agent _agent;
    Client _client;
    Deceased _deceased;
    Referrer _referrer;
    User _referrersManager;
    Representative _representative;
    User _operatorCC;
    Point _geoPosition;
    Point _plotPosition;
    PreorderStatus _status;
    try {
      _agent = Agent.fromJson(json['agent']);
      _client = Client.fromJson(json['client']);
      _deceased = Deceased.fromJson(json['deceased']);
      _referrer = Referrer.fromJson(json['referrer']);
      _referrersManager = User.fromJson(json['referrers_manager']);
      _representative = Representative.fromJson(json['representative']);
      _operatorCC = User.fromJson(json['operator_cc']);
      _geoPosition = Point.fromJson(json['geo_position']);
      _plotPosition = Point.fromJson(json['plot_position']);
      _status = PreorderStatus(json['status']);
    } catch (e) {
      throw DataMismatchException(e is Error
          ? e.toString()
          : e.message + '\nУ предзаказа id: ${json['id']}');
    }

    return Preorder(
      id: PreorderId(json['id']),
      assignedAt: toLocalDateTime(json['assigned_at']),
      createdAt: toLocalDateTime(json['created_at']),
      updatedAt: toLocalDateTime(json['updated_at']),
      no: json['no'],
      agent: _agent,
      client: _client,
      deceased: _deceased,
      referrer: _referrer,
      referrersManager: _referrersManager,
      representative: _representative,
      operatorCC: _operatorCC,
      cemetery: CemeteryId(json['cemetery']),
      items: _items,
      status: _status,
      type: _type,
      comments: _comments,
      geoPosition: _geoPosition,
      plotPosition: _plotPosition,
      documents: _documents,
    );
  }

  @override
  bool operator ==(other) {
    if (other is Preorder) {
      return other.id == id;
    }
    return false;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => json.toString();

  /// Возвращает данные предзаказа в JSON-формате (String/Map)
  ///   String - когда в объекте был заполнен только id
  ///   Map - в ином случае
  @override
  dynamic get json {
    Map<String, dynamic> json;
    var superJson = super.json;
    if (superJson is String) {
      json = {'id': superJson};
    } else {
      json = superJson;
    }
    json
      ..addAll({
        'referrer': referrer?.json,
        'referrers_manager': referrersManager?.json,
        'representative': representative?.json,
        'operator_cc': operatorCC?.json,
        'status': status?.json,
        'type': type?.json,
        'items': items?.map((item) => item.json)?.toList(),
        'plot_position': plotPosition?.json,
        'assigned_at': assignedAt?.toUtc(),
      })
      ..removeWhere((key, value) => value == null);

    if (json.keys.length == 1 && json.keys.first == 'id') return json['id'];

    return json;
  }
}

/// Идентификатор предзаказа
class PreorderId extends OrderEntityId {
  PreorderId._(dynamic id) : super(id);
  factory PreorderId(id) {
    if (id == null) return null;
    return PreorderId._(id);
  }
}
