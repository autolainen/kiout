import '../cemetery.dart';
import '../client.dart';
import '../comment.dart';
import '../dadata_address.dart';
import '../datetime/to_local_date_time.dart';
import '../deceased.dart';
import '../document.dart';
import '../exceptions/data_mismatch_exception.dart';
import '../geo/point.dart';
import '../helpers/json_validators.dart';
import '../order/order_item.dart';
import '../order/order_type.dart';
import '../representative.dart';
import '../user/agent.dart';
import '../user/referrer.dart';
import '../user/user.dart';
import 'preorder.dart';
import 'preorder_status.dart';

/// Класс реализующий данные о предзаказе
class AgentServicePreorder extends Preorder {
  /// Дата встречи
  DateTime meetingAt;

  /// Адрес встречи
  DadataAddress meetingAddress;

  AgentServicePreorder(
      {this.meetingAddress,
      DateTime meetingAt,
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
      Referrer referrer,
      User referrersManager,
      Representative representative,
      User operatorCC,
      List<OrderItem> items,
      PreorderStatus status,
      Point plotPosition})
      : super(
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
            documents: documents,
            assignedAt: assignedAt,
            referrer: referrer,
            referrersManager: referrersManager,
            representative: representative,
            operatorCC: operatorCC,
            items: items,
            status: status,
            type: OrderType.agentService,
            plotPosition: plotPosition) {
    this.meetingAt = meetingAt?.toLocal();
  }

  /// Создает предзаказ из JSON-данных
  factory AgentServicePreorder.fromJson(dynamic json) {
    if (json == null) return null;

    if (json is String) {
      return AgentServicePreorder(id: PreorderId(json));
    }
    OrderType _type;
    try {
      _type = OrderType(json['type']);
    } catch (e) {
      throw DataMismatchException(e is Error
          ? e.toString()
          : e.message + '\nУ предзаказа id: ${json['id']}');
    }
    if (_type != OrderType.agentService) {
      throw ArgumentError(
          'Invalid order type: ${json['type']}. Expected: [${OrderType.agentService},..]');
    }

    validateBaseOrderDataJson(json);
    validatePreorderDataJson(json);

    if (json['meeting_at'] != null &&
        json['meeting_at'] is! String &&
        json['meeting_at'] is! DateTime) {
      throw DataMismatchException(
          'Неверный формат даты встречи ("${json['meeting_at']}" - требуется String или DateTime)\nУ предзаказа id: ${json['id']}');
    }
    if (json['meeting_address'] != null &&
        json['meeting_address'] is! Map<String, dynamic>) {
      throw DataMismatchException(
          'Неверный формат адреса встречи ("${json['meeting_address']}" - требуется Map<String, dynamic>)\nУ предзаказа id: ${json['id']}');
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
    DadataAddress _meetingAddress;
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
      _meetingAddress = DadataAddress.fromJson(json['meeting_address']);
    } catch (e) {
      throw DataMismatchException(e is Error
          ? e.toString()
          : e.message + '\nУ предзаказа id: ${json['id']}');
    }

    return AgentServicePreorder(
        id: PreorderId(json['id']),
        assignedAt: toLocalDateTime(json['assigned_at']),
        createdAt: toLocalDateTime(json['created_at']),
        updatedAt: toLocalDateTime(json['updated_at']),
        meetingAt: toLocalDateTime(json['meeting_at']),
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
        comments: _comments,
        geoPosition: _geoPosition,
        plotPosition: _plotPosition,
        documents: _documents,
        meetingAddress: _meetingAddress);
  }

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
        'meeting_at': meetingAt?.toUtc(),
        'meeting_address': meetingAddress?.json,
      })
      ..removeWhere((key, value) => value == null);

    if (json.keys.length == 1 && json.keys.first == 'id') return json['id'];

    return json;
  }
}
