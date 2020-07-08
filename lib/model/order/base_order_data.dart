import 'package:data_model/data_model.dart';

import '../cemetery.dart';
import '../client.dart';
import '../comment.dart';
import '../datetime/to_local_date_time.dart';
import '../deceased.dart';
import '../document.dart';
import '../exceptions/data_mismatch_exception.dart';
import '../geo/point.dart';
import '../helpers/json_validators.dart';
import '../order/order.dart';
import '../preorder/preorder.dart';
import '../user/agent.dart';

/// Основные данные заказа/предзаказа
class BaseOrderData implements Model<OrderEntityId> {
  /// Идентификатор заказа/предзаказа
  OrderEntityId id;

  /// Номер заказа
  String no;

  /// Агент
  Agent agent;

  /// Клиент
  Client client;

  /// Усопший
  Deceased deceased;

  /// Кладбище
  CemeteryId cemetery;

  /// Комментарии
  List<Comment> comments;

  /// Геопозиция
  Point geoPosition;

  /// Дата создания
  DateTime createdAt;

  /// Дата обновления
  DateTime updatedAt;

  /// Список документов
  List<Document> documents;

  BaseOrderData(
      {this.id,
      DateTime executeTo,
      DateTime createdAt,
      DateTime updatedAt,
      this.no,
      this.agent,
      this.client,
      this.deceased,
      this.cemetery,
      this.comments,
      this.geoPosition,
      this.documents})
      : this.createdAt = createdAt?.toLocal(),
        this.updatedAt = updatedAt?.toLocal();

  /// Создает заказ из JSON-данных
  factory BaseOrderData.fromJson(dynamic json) {
    if (json == null) return null;

    if (json is String) {
      return BaseOrderData(id: OrderEntityId(json));
    }

    OrderEntityId id;
    if (json['_id'] != null) {
      id = OrderEntityId(
          json['_id'] is String ? json['_id'] : json['_id']?.toHexString());
    } else if (json['id'] != null) {
      id = OrderEntityId(json['id']);
    }

    if (json['entity_type'] != null) {
      if (json['entity_type'] == 'preorder') {
        return Preorder.fromJson(json);
      }
      if (json['entity_type'] == 'order') {
        return Order.fromJson(json);
      }
    }

    validateBaseOrderDataJson(json);

    Agent _agent;
    Client _client;
    List<Comment> _comments;
    List<Document> _documents;
    Deceased _deceased;
    Point _geoPoint;
    try {
      _agent = Agent.fromJson(json['agent']);
      _client = Client.fromJson(json['client']);
      _deceased = Deceased.fromJson(json['deceased']);
      _geoPoint = Point.fromJson(json['geo_position']);
      _comments = json['comments']?.isEmpty ?? true
          ? null
          : (List<Comment>.from((json['comments'] as List)
              .map((comment) => Comment.fromJson(comment)))
            ..removeWhere((c) => c == null));
      _documents = json['documents']?.isEmpty ?? true
          ? null
          : (List<Document>.from((json['documents'] as List)
              .map((document) => Document.fromJson(document)))
            ..removeWhere((d) => d == null));
    } catch (e) {
      throw DataMismatchException(e is Error
          ? e.toString()
          : e.message + '\nУ заказа id: ${json['id']}');
    }

    return BaseOrderData(
      id: id,
      createdAt: toLocalDateTime(json['created_at']),
      updatedAt: toLocalDateTime(json['updated_at']),
      no: json['no'],
      agent: _agent,
      client: _client,
      deceased: _deceased,
      cemetery: CemeteryId(json['cemetery']),
      comments: _comments,
      documents: _documents,
      geoPosition: _geoPoint,
    );
  }

  @override
  bool operator ==(other) {
    if (other is BaseOrderData) {
      return other.id == id;
    }
    return false;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => json.toString();

  /// Возвращает данные заказа в JSON-формате (String/Map)
  ///   String - когда в объекте был заполнен только id
  ///   Map - в ином случае
  @override
  dynamic get json {
    Map<String, dynamic> json = {
      'id': id?.json,
      'no': no,
      'agent': agent?.json,
      'client': client?.json,
      'deceased': deceased?.json,
      'cemetery': cemetery?.json,
      'comments': comments?.map((comment) => comment.json)?.toList(),
      'geo_position': geoPosition?.json,
      'created_at': createdAt?.toUtc(),
      'updated_at': updatedAt?.toUtc(),
      'documents': documents?.map((document) => document.json)?.toList(),
    }..removeWhere((key, value) => value == null);

    if (json.keys.length == 1 && json.keys.first == 'id') return json['id'];

    return json;
  }
}

/// Идентификатор заказа/предзаказа
class OrderEntityId extends ObjectId {
  dynamic _id;
  OrderEntityId(dynamic id) : super(id) {
    this._id = id;
  }
  @override
  bool operator ==(other) {
    if ([OrderEntityId, OrderId, PreorderId].contains(other.runtimeType))
      return _id == other.json;
    return false;
  }

  @override
  int get hashCode => _id.hashCode;
}
