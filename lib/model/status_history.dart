import 'package:kiouttest/model/specifications/spec_status.dart';
import 'package:kiouttest/model/specifications/specification.dart';
import 'package:data_model/data_model.dart';

import 'datetime/to_local_date_time.dart';
import 'detachment/detachment.dart';
import 'detachment/detachment_status.dart';
import 'exceptions/data_mismatch_exception.dart';
import 'order/order.dart';
import 'order/order_status.dart';
import 'order/payment_status.dart';
import 'user/user.dart';

/// Класс, реализующий данные об изменении статуса объекта
class StatusHistory implements Model<StatusHistoryId> {
  /// Идентификатор записи об изменении статуса
  StatusHistoryId id;

  /// Тип объекта, изменившего статус
  StatusHistoryType type;

  /// Дата установки нового статуса
  DateTime setAt;

  /// Идентификатор пользователя, изменившего статус
  UserId user;

  StatusHistory({this.id, this.type, DateTime setAt, this.user})
      : this.setAt = toLocalDateTime(setAt);

  /// Создает запись об изменении статуса объекта из JSON-данных
  factory StatusHistory.fromJson(dynamic json) {
    if (json == null) return null;

    if (json is String) {
      return StatusHistory(id: StatusHistoryId(json));
    }

    if (json is! Map) {
      throw DataMismatchException(
          'Неверный формат json у записи об изменении статуса - требуется String либо Map');
    }

    if (json['id'] != null && json['_id'] != null) {
      throw DataMismatchException(
          'Идентификатор записи об изменении статуса указан в двух атрибутах: id и _id ("${json['id']} ~ ${json['_id']}" - требуется один)');
    }

    if (json['type'] != null && json['type'] is! String) {
      throw DataMismatchException(
          'Неверный формат типа объекта ("${json['type']}" - требуется String)\nУ записи об изменении статуса id: ${json['id']}');
    }
    if (json['set_at'] != null &&
        json['set_at'] is! String &&
        json['set_at'] is! DateTime) {
      throw DataMismatchException(
          'Неверный формат даты установки нового статуса("${json['created_at']}" - требуется String или DateTime)\nУ записи об изменении статуса id: ${json['id']}');
    }
    if (json['user'] != null && json['user'] is! String) {
      throw DataMismatchException(
          'Неверный формат пользователя, изменившего статус ("${json['user']}" - требуется String)\nУ записи об изменении статуса id: ${json['id']}');
    }

    var _type = json['type'] ?? '';

    if (_type == StatusHistoryType.detachment.json)
      return DetachmentStatusHistory.fromJson(json);
    if (_type == StatusHistoryType.order.json)
      return OrderStatusHistory.fromJson(json);
    if (_type == StatusHistoryType.payment.json)
      return PaymentStatusHistory.fromJson(json);
    if (_type == StatusHistoryType.specification.json)
      return SpecificationStatusHistory.fromJson(json);

    throw ArgumentError('Unknown status history type: ${json['type']}');
  }

  @override
  bool operator ==(other) {
    if (other is StatusHistory) {
      return other.id == id;
    }
    return false;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => json.toString();

  /// Возвращает данные записи об изменении статуса в JSON-формате (String/Map)
  ///   String - когда в объекте был заполнен только id
  ///   Map - в ином случае
  @override
  dynamic get json {
    Map<String, dynamic> json = {
      'id': id?.json,
      'type': type?.json,
      'set_at': setAt?.toUtc(),
      'user': user?.json
    }..removeWhere((key, value) => value == null);

    if (json.keys.length == 1 && json.keys.first == 'id') return json['id'];

    return json;
  }
}

/// Изменение статуса заказ-наряда
class DetachmentStatusHistory extends StatusHistory {
  /// Идентификатор заказ-наряда, изменившего статус
  DetachmentId idEntity;

  /// Новый статус заказ-наряда
  DetachmentStatus status;

  /// Создает запись об изменении статуса заказ-наряда
  DetachmentStatusHistory(
      {StatusHistoryId id,
      this.idEntity,
      StatusHistoryType type = StatusHistoryType.detachment,
      this.status,
      DateTime setAt,
      UserId user})
      : super(id: id, type: type, setAt: setAt, user: user);

  /// Создает запись об изменении статуса заказ-наряда из JSON данных
  factory DetachmentStatusHistory.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    var _type = json['type'] ?? '';

    if (_type != StatusHistoryType.detachment.json) {
      throw ArgumentError(
          'Invalid status history type: ${json['type']}. Expected: ${StatusHistoryType.detachment}');
    }
    if (json['id_entity'] != null && json['id_entity'] is! String) {
      throw DataMismatchException(
          'Неверный формат идентификатора заказ-наряда ("${json['id_entity']}" - требуется String)\nУ записи об изменении статуса id: ${json['id']}');
    }
    if (json['status'] != null && json['status'] is! String) {
      throw DataMismatchException(
          'Неверный формат нового статуса заказ-наряда ("${json['status']}" - требуется String)\nУ записи об изменении статуса id: ${json['id']}');
    }

    StatusHistoryId id;
    if (json['_id'] != null) {
      id = StatusHistoryId(
          json['_id'] is String ? json['_id'] : json['_id']?.toHexString());
    } else {
      id = StatusHistoryId(json['id']);
    }

    DetachmentStatus _status;
    try {
      _status = DetachmentStatus(json['status']);
    } catch (e) {
      throw DataMismatchException(e is Error
          ? e.toString()
          : e.message + '\nУ записи об изменении статуса id: ${json['id']}');
    }

    return DetachmentStatusHistory(
        id: id,
        idEntity: DetachmentId(json['id_entity']),
        type: StatusHistoryType.detachment,
        status: _status,
        setAt: json['set_at'],
        user: UserId(json['user']));
  }

  /// Возвращает данные об изменении статуса заказ-наряда в JSON-формате (String/Map)
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
      ..addAll({'id_entity': idEntity?.json, 'status': status?.json})
      ..removeWhere((key, value) => value == null);
    if (json.keys.length == 1 && json.keys.first == 'id') return json['id'];
    return json;
  }
}

/// Изменение статуса заказа
class OrderStatusHistory extends StatusHistory {
  /// Идентификатор заказа, изменившего статус
  OrderId idEntity;

  /// Новый статус заказа
  OrderStatus status;

  /// Создает запись об изменении статуса заказа
  OrderStatusHistory(
      {StatusHistoryId id,
      this.idEntity,
      StatusHistoryType type = StatusHistoryType.order,
      this.status,
      DateTime setAt,
      UserId user})
      : super(id: id, type: type, setAt: setAt, user: user);

  /// Создает запись об изменении статуса заказа из JSON данных
  factory OrderStatusHistory.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    var _type = json['type'] ?? '';

    if (_type != StatusHistoryType.order.json) {
      throw ArgumentError(
          'Invalid status history type: ${json['type']}. Expected: ${StatusHistoryType.order}');
    }
    if (json['id_entity'] != null && json['id_entity'] is! String) {
      throw DataMismatchException(
          'Неверный формат идентификатора заказа ("${json['id_entity']}" - требуется String)\nУ записи об изменении статуса id: ${json['id']}');
    }
    if (json['status'] != null && json['status'] is! String) {
      throw DataMismatchException(
          'Неверный формат нового статуса заказа ("${json['status']}" - требуется String)\nУ записи об изменении статуса id: ${json['id']}');
    }

    StatusHistoryId id;
    if (json['_id'] != null) {
      id = StatusHistoryId(
          json['_id'] is String ? json['_id'] : json['_id']?.toHexString());
    } else {
      id = StatusHistoryId(json['id']);
    }

    OrderStatus _status;
    try {
      _status = OrderStatus(json['status']);
    } catch (e) {
      throw DataMismatchException(e is Error
          ? e.toString()
          : e.message + '\nУ записи об изменении статуса id: ${json['id']}');
    }

    return OrderStatusHistory(
        id: id,
        idEntity: OrderId(json['id_entity']),
        type: StatusHistoryType.order,
        status: _status,
        setAt: json['set_at'],
        user: UserId(json['user']));
  }

  /// Возвращает данные об изменении статуса заказа в JSON-формате (String/Map)
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
      ..addAll({'id_entity': idEntity?.json, 'status': status?.json})
      ..removeWhere((key, value) => value == null);
    if (json.keys.length == 1 && json.keys.first == 'id') return json['id'];
    return json;
  }
}

/// Изменение статуса платежа
class PaymentStatusHistory extends StatusHistory {
  /// Идентификатор заказа
  OrderId idEntity;

  /// Новый статус платежа
  PaymentStatus status;

  /// Создает запись об изменении статуса платежа
  PaymentStatusHistory(
      {StatusHistoryId id,
      this.idEntity,
      StatusHistoryType type = StatusHistoryType.payment,
      this.status,
      DateTime setAt,
      UserId user})
      : super(id: id, type: type, setAt: setAt, user: user);

  /// Создает запись об изменении статуса платежа из JSON данных
  factory PaymentStatusHistory.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    var _type = json['type'] ?? '';

    if (_type != StatusHistoryType.payment.json) {
      throw ArgumentError(
          'Invalid status history type: ${json['type']}. Expected: ${StatusHistoryType.payment}');
    }
    if (json['id_entity'] != null && json['id_entity'] is! String) {
      throw DataMismatchException(
          'Неверный формат идентификатора заказа ("${json['id_entity']}" - требуется String)\nУ записи об изменении статуса id: ${json['id']}');
    }
    if (json['status'] != null && json['status'] is! String) {
      throw DataMismatchException(
          'Неверный формат нового статуса платежа ("${json['status']}" - требуется String)\nУ записи об изменении статуса id: ${json['id']}');
    }

    StatusHistoryId id;
    if (json['_id'] != null) {
      id = StatusHistoryId(
          json['_id'] is String ? json['_id'] : json['_id']?.toHexString());
    } else {
      id = StatusHistoryId(json['id']);
    }

    PaymentStatus _status;
    try {
      _status = PaymentStatus(json['status']);
    } catch (e) {
      throw DataMismatchException(e is Error
          ? e.toString()
          : e.message + '\nУ записи об изменении статуса id: ${json['id']}');
    }

    return PaymentStatusHistory(
        id: id,
        idEntity: OrderId(json['id_entity']),
        type: StatusHistoryType.payment,
        status: _status,
        setAt: json['set_at'],
        user: UserId(json['user']));
  }

  /// Возвращает данные об изменении статуса платежа в JSON-формате (String/Map)
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
      ..addAll({'id_entity': idEntity?.json, 'status': status?.json})
      ..removeWhere((key, value) => value == null);
    if (json.keys.length == 1 && json.keys.first == 'id') return json['id'];
    return json;
  }
}

/// Изменение статуса спецификации
class SpecificationStatusHistory extends StatusHistory {
  /// Идентификатор спецификации, изменившего статус
  SpecificationId idEntity;

  /// Новый статус спецификации
  SpecStatus status;

  /// Создает запись об изменении статуса спецификации
  SpecificationStatusHistory(
      {StatusHistoryId id,
      this.idEntity,
      StatusHistoryType type = StatusHistoryType.specification,
      this.status,
      DateTime setAt,
      UserId user})
      : super(id: id, type: type, setAt: setAt, user: user);

  /// Создает запись об изменении статуса спецификации из JSON данных
  factory SpecificationStatusHistory.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    var _type = json['type'] ?? '';

    if (_type != StatusHistoryType.specification.json) {
      throw ArgumentError(
          'Invalid status history type: ${json['type']}. Expected: ${StatusHistoryType.specification}');
    }
    if (json['id_entity'] != null && json['id_entity'] is! String) {
      throw DataMismatchException(
          'Неверный формат идентификатора спецификации ("${json['id_entity']}" - требуется String)\nУ записи об изменении статуса id: ${json['id']}');
    }
    if (json['status'] != null && json['status'] is! String) {
      throw DataMismatchException(
          'Неверный формат нового статуса спецификации ("${json['status']}" - требуется String)\nУ записи об изменении статуса id: ${json['id']}');
    }

    StatusHistoryId id;
    if (json['_id'] != null) {
      id = StatusHistoryId(
          json['_id'] is String ? json['_id'] : json['_id']?.toHexString());
    } else {
      id = StatusHistoryId(json['id']);
    }

    SpecStatus _status;
    try {
      _status = SpecStatus(json['status']);
    } catch (e) {
      throw DataMismatchException(e is Error
          ? e.toString()
          : e.message + '\nУ записи об изменении статуса id: ${json['id']}');
    }

    return SpecificationStatusHistory(
        id: id,
        idEntity: SpecificationId(json['id_entity']),
        type: StatusHistoryType.specification,
        status: _status,
        setAt: json['set_at'],
        user: UserId(json['user']));
  }

  /// Возвращает данные об изменении статуса спецификации в JSON-формате (String/Map)
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
      ..addAll({'id_entity': idEntity?.json, 'status': status?.json})
      ..removeWhere((key, value) => value == null);
    if (json.keys.length == 1 && json.keys.first == 'id') return json['id'];
    return json;
  }
}

/// Идентификатор записи об изменении статуса
class StatusHistoryId extends ObjectId {
  StatusHistoryId._(dynamic id) : super(id);
  factory StatusHistoryId(id) {
    if (id == null) return null;
    return StatusHistoryId._(id);
  }
}

/// Тип объекта, изменившего статус
///
/// возможный тип объекта:
/// * detachment - заказ-наряд
/// * order - заказ
/// * payment - платеж
/// * specification - спецификация
class StatusHistoryType implements JsonEncodable {
  /// Заказ-наряд
  static const StatusHistoryType detachment = StatusHistoryType._('detachment');

  /// Заказ
  static const StatusHistoryType order = StatusHistoryType._('order');

  /// Платеж
  static const StatusHistoryType payment = StatusHistoryType._('payment');

  /// Спецификация
  static const StatusHistoryType specification =
      StatusHistoryType._('specification');

  final String _type;

  // Создает тип объекта, изменившего статус
  const StatusHistoryType._(String type) : _type = type;

  factory StatusHistoryType(String type) {
    if (type == null) return null;
    StatusHistoryType _curType = StatusHistoryType._(type);
    if (values.contains(_curType)) {
      return _curType;
    } else {
      throw ArgumentError('Invalid status history type: ${type}.');
    }
  }

  final Map<String, String> _typeStr = const {
    'detachment': 'заказ-наряд',
    'order': 'заказ',
    'payment': 'платеж',
    'specification': 'спецификация'
  };

  String get value => _type;
  static List get values => [detachment, order, payment, specification];

  @override
  bool operator ==(dynamic other) {
    if (other is StatusHistoryType) {
      return other._type == _type;
    }
    return false;
  }

  @override
  int get hashCode => _type.hashCode;

  String get json => _type;

  @override
  String toString() => _typeStr[_type];
}
