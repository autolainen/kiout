import '../cemetery.dart';
import '../client.dart';
import '../coffin_params.dart';
import '../comment.dart';
import '../datetime/to_local_date_time.dart';
import '../deceased.dart';
import '../document.dart';
import '../exceptions/data_mismatch_exception.dart';
import '../geo/point.dart';
import '../specifications/specification.dart';
import '../user/agent.dart';
import '../user/user.dart';
import 'order.dart';
import 'order_item.dart';
import 'order_status.dart';
import 'order_type.dart';
import 'payment_status.dart';

/// Заказ на кремацию
class CremationOrder extends Order {
  /// Создает заказ на кремацию
  CremationOrder(
      {OrderId id,
      DateTime executeTo,
      DateTime createdAt,
      DateTime updatedAt,
      String no,
      Agent agent,
      UserId manager,
      Client client,
      Deceased deceased,
      CoffinParams coffin,
      CemeteryId cemetery,
      List<OrderItem> items,
      OrderStatus status,
      PaymentStatus paymentStatus,
      num totalAmount,
      List<String> types,
      List<Comment> comments,
      Point geoPosition,
      List<Document> documents,
      Specification specification})
      : super(
            id: id,
            executeTo: executeTo,
            createdAt: createdAt,
            updatedAt: updatedAt,
            no: no,
            agent: agent,
            manager: manager,
            client: client,
            deceased: deceased,
            coffin: coffin,
            cemetery: cemetery,
            items: items,
            status: status,
            paymentStatus: paymentStatus,
            totalAmount: totalAmount,
            comments: comments,
            types: types,
            geoPosition: geoPosition,
            documents: documents,
            specification: specification);

  /// Создает заказ на кремацию из JSON данных
  factory CremationOrder.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    var _types = List<String>.from(
        json['type']?.map((type) => type.toString())?.toList() ?? []);

    if (!_types.contains(OrderType.cremation.json)) {
      throw ArgumentError(
          'Invalid order type: ${json['type']}. Expected: [${OrderType.cremation},..]');
    }

    Agent _agent;
    CoffinParams _coffinParams;
    Client _client;
    List<Comment> _comments;
    List<Document> _documents;
    Deceased _deceased;
    Point _geoPoint;
    List<OrderItem> _items;
    Specification _specification;
    try {
      _agent = Agent.fromJson(json['agent']);
      _client = Client.fromJson(json['client']);
      _deceased = Deceased.fromJson(json['deceased']);
      _coffinParams = CoffinParams.fromJson(json['coffin']);
      _geoPoint = Point.fromJson(json['geo_position']);
      _comments = json['comments']?.isEmpty ?? true
          ? null
          : (List<Comment>.from((json['comments'] as List)
              .map((comment) => Comment.fromJson(comment)))
            ..removeWhere((c) => c == null));
      _items = json['items']?.isEmpty ?? true
          ? null
          : (List<OrderItem>.from(
              (json['items'] as List).map((item) => OrderItem.fromJson(item)))
            ..removeWhere((c) => c == null));
      _documents = json['documents']?.isEmpty ?? true
          ? null
          : (List<Document>.from((json['documents'] as List)
              .map((document) => Document.fromJson(document)))
            ..removeWhere((d) => d == null));

      _specification = Specification.fromJson(json['specification']);
    } catch (e) {
      throw DataMismatchException(e is Error
          ? e.toString()
          : e.message + '\nУ заказа id: ${json['id']}');
    }
    OrderId id;
    if (json['_id'] != null) {
      id = OrderId(
          json['_id'] is String ? json['_id'] : json['_id']?.toHexString());
    } else {
      id = OrderId(json['id']);
    }

    return CremationOrder(
        id: id,
        executeTo: toLocalDateTime(json['execute_to']),
        createdAt: toLocalDateTime(json['created_at']),
        updatedAt: toLocalDateTime(json['updated_at']),
        no: json['no'],
        agent: _agent,
        manager: UserId(json['manager']),
        client: _client,
        deceased: _deceased,
        coffin: _coffinParams,
        cemetery: CemeteryId(json['cemetery']),
        items: _items,
        status: OrderStatus(json['status']),
        paymentStatus: PaymentStatus(json['payment_status']),
        totalAmount: json['total_amount'],
        comments: _comments,
        types: _types.isEmpty ? null : _types,
        geoPosition: _geoPoint,
        documents: _documents,
        specification: _specification);
  }

  @override
  dynamic get json => super.json;
}
