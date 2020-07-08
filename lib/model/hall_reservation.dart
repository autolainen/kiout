import 'package:aahitest/model/services/capitalize_first_letter.dart';
import 'package:data_model/data_model.dart';

import 'datetime/to_local_date_time.dart';
import 'exceptions/data_mismatch_exception.dart';
import 'hall.dart';
import 'order/base_order_data.dart';
import 'order/order.dart';
import 'preorder/preorder.dart';

/// Слот бронирования зала прощания
class HallReservation implements Model<HallReservationId> {
  /// Идентификатор забронированного слота
  HallReservationId id;

  /// Идентификатор зала
  HallId hallId;

  /// Основные данные заказа, к которому относится забронированный слот
  BaseOrderData baseOrderData;

  /// Дата начала брони
  DateTime from;

  /// Дата окончания брони
  DateTime to;

  /// Статус забронированного слота
  HallReservationStatus status;

  /// Дата обновления брони
  DateTime updatedAt;

  /// Дата создания бронии
  DateTime createdAt;

  HallReservation(
      {this.id,
      this.hallId,
      this.baseOrderData,
      this.status,
      DateTime from,
      DateTime to,
      DateTime updatedAt,
      DateTime createdAt})
      : this.from = from?.toLocal(),
        this.to = to?.toLocal(),
        this.updatedAt = updatedAt?.toLocal(),
        this.createdAt = createdAt?.toLocal();

  /// Создает забронированный слот из JSON-данных
  factory HallReservation.fromJson(dynamic json) {
    if (json == null) return null;

    if (json is String) {
      return HallReservation(id: HallReservationId(json));
    }

    if (json['id'] != null && json['_id'] != null) {
      throw DataMismatchException(
          'Идентификатор забронированного слота указан в двух атрибутах: id и _id ("${json['id']} ~ ${json['_id']}" - требуется один)');
    }

    if (json['id_hall'] != null && json['id_hall'] is! String) {
      throw DataMismatchException(
          'Неверный формат идентифиакатора забронированного слота ("${json['id_hall']}" - требуется String)\nУ забронированного слота id: ${json['id_hall']}');
    }

    if (json['status'] != null && json['status'] is! String) {
      throw DataMismatchException(
          'Неверный формат статуса ("${json['status']}" - требуется String)\nУ забронированного слота id: ${json['id']}');
    }

    if (json['order_entity'] != null &&
        json['order_entity'] is! String &&
        json['order_entity'] is! Map<String, dynamic>) {
      throw DataMismatchException(
          'Неверный формат заказа ("${json['order_entity']}" - требуется String или Map<String, dynamic>)\nУ забронированного слота id: ${json['id']}');
    }

    if (json['from'] != null &&
        json['from'] is! String &&
        json['from'] is! DateTime) {
      throw DataMismatchException(
          'Неверный формат даты начала брони ("${json['from']}" - требуется String или DateTime)\nУ забронированного слота id: ${json['id']}');
    }
    if (json['to'] != null &&
        json['to'] is! String &&
        json['to'] is! DateTime) {
      throw DataMismatchException(
          'Неверный формат даты окончания брони ("${json['to']}" - требуется String или DateTime)\nУ забронированного слота id: ${json['id']}');
    }

    if (json['created_at'] != null &&
        json['created_at'] is! String &&
        json['created_at'] is! DateTime) {
      throw DataMismatchException(
          'Неверный формат даты создания ("${json['created_at']}" - требуется String или DateTime)\nУ забронированного слота id: ${json['id']}');
    }
    if (json['updated_at'] != null &&
        json['updated_at'] is! String &&
        json['updated_at'] is! DateTime) {
      throw DataMismatchException(
          'Неверный формат даты обновления ("${json['updated_at']}" - требуется String или DateTime)\nУ забронированного слота id: ${json['id']}');
    }

    BaseOrderData _baseOrderData;
    HallReservationStatus _status;

    try {
      _baseOrderData =
          BaseOrderData.fromJson(json['order_entity'] ?? json['id_order']);
      _status = HallReservationStatus(json['status']);
    } catch (e) {
      throw DataMismatchException(e is Error
          ? e.toString()
          : e.message + '\nУ забронированного слота id: ${json['id']}');
    }

    HallReservationId id;
    if (json['_id'] != null) {
      id = HallReservationId(
          json['_id'] is String ? json['_id'] : json['_id']?.toHexString());
    } else {
      id = HallReservationId(json['id']);
    }

    return HallReservation(
      id: id,
      hallId: HallId(json['id_hall']),
      baseOrderData: _baseOrderData,
      status: _status,
      from: toLocalDateTime(json['from']),
      to: toLocalDateTime(json['to']),
      createdAt: toLocalDateTime(json['created_at']),
      updatedAt: toLocalDateTime(json['updated_at']),
    );
  }

  @override
  bool operator ==(other) {
    if (other is HallReservation) {
      return other.id == id;
    }
    return false;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => json.toString();

  /// Возвращает данные о брони в JSON-формате (String/Map)
  ///   String - когда в объекте был заполнен только id
  ///   Map - в ином случае
  @override
  dynamic get json {
    Map<String, dynamic> json = {
      'id': id?.json,
      'id_hall': hallId?.json,
      'order_entity': baseOrderData?.json,
      'status': status?.json,
      'from': from?.toUtc(),
      'to': to?.toUtc(),
      'updated_at': updatedAt?.toUtc(),
      'created_at': createdAt?.toUtc(),
    }..removeWhere((key, value) => value == null);
    if (baseOrderData is Order) {
      json['order_entity']['entity_type'] = 'order';
    } else if (baseOrderData is Preorder) {
      json['order_entity']['entity_type'] = 'preorder';
    }

    if (json.keys.length == 1 && json.keys.first == 'id') return json['id'];
    return json;
  }
}

class HallReservationId extends ObjectId {
  HallReservationId._(dynamic id) : super(id);
  factory HallReservationId(id) {
    if (id == null) return null;
    return HallReservationId._(id);
  }
}

/// Статус бронированного слота
///
/// Возможные статусы
///   * booked - забронирован
///   * ordered - заказан
class HallReservationStatus implements JsonEncodable {
  /// Черновик
  static const HallReservationStatus booked =
      HallReservationStatus._('забронирован');

  /// Подготовлен
  static const HallReservationStatus ordered =
      HallReservationStatus._('заказан');

  final String _status;

  // Создает статус заказа
  const HallReservationStatus._(String status) : _status = status;

  factory HallReservationStatus(String status) {
    if (status == null) return null;
    HallReservationStatus _curHallReservationStatus =
        HallReservationStatus._(status);
    if (values.contains(_curHallReservationStatus)) {
      return _curHallReservationStatus;
    } else {
      throw ArgumentError(
          'Не известный статус брогниирования слота: ${status}.');
    }
  }

  String get value => _status;
  static List get values => [booked, ordered];

  @override
  bool operator ==(dynamic other) {
    if (other is HallReservationStatus) {
      return other._status == _status;
    }
    return false;
  }

  @override
  int get hashCode => _status.hashCode;

  String get json => _status;

  @override
  String toString() => capitalizeFirstLetter(_status);
}
