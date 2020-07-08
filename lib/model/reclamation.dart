import 'package:data_model/data_model.dart';

import 'attachment/attachment.dart';
import 'comment.dart';
import 'contractor.dart';
import 'datetime/to_local_date_time.dart';
import 'detachment/detachment.dart';
import 'detachment/detachment_item.dart';
import 'exceptions/data_mismatch_exception.dart';
import 'user/user.dart';

/// Класс реализующий рекламацию
class Reclamation implements Model<ReclamationId> {
  /// Идентификатор рекламации
  ReclamationId id;

  /// Позиция заказ-наряда
  DetachmentItemId item;

  /// Заказ-наряд
  Detachment detachment;

  /// Список вложений
  List<Attachment> attachments;

  /// Список комментариев
  List<Comment> comments;

  /// Дата создания
  DateTime createdAt;

  /// Дата обновления
  DateTime updatedAt;

  /// Статус
  ReclamationStatus status;

  /// Исполнитель подрядчика
  UserId contractorWorker;

  /// Подрядчик
  ContractorId contractor;

  /// Текст
  String message;

  /// Агент, открывший рекламацию
  UserId agent;

  /// Создает рекламацию
  Reclamation(
      {this.id,
      DateTime createdAt,
      DateTime updatedAt,
      this.item,
      this.attachments,
      this.detachment,
      this.status,
      this.contractorWorker,
      this.contractor,
      this.comments,
      this.message,
      this.agent})
      : this.createdAt = createdAt?.toLocal(),
        this.updatedAt = updatedAt?.toLocal();

  /// Создает рекламацию из JSON-данных
  factory Reclamation.fromJson(dynamic json) {
    if (json == null) return null;

    if (json is String) {
      return Reclamation(id: ReclamationId(json));
    }

    if (json is! Map) {
      throw DataMismatchException(
          'Не верный формат json у рекламации - требуется String либо Map');
    }

    if (json['id'] != null && json['_id'] != null) {
      throw DataMismatchException(
          'Идентификатор рекламации указан в двух атрибутах: id и _id ("${json['id']} ~ ${json['_id']}" - требуется один)');
    }

    if (json['item'] != null && json['item'] is! String) {
      throw DataMismatchException(
          'Неверный формат позиции заказ-наряда ("${json['item']}" - требуется String)\nУ рекламации id: ${json['id']}');
    }
    if (json['detachment'] != null &&
        json['detachment'] is! Map<String, dynamic> &&
        json['detachment'] is! String) {
      throw DataMismatchException(
          'Неверный формат заказ-наряда ("${json['detachment']}" - требуется Map<String, dynamic> или String)\nУ рекламации id: ${json['id']}');
    }
    if (json['status'] != null && json['status'] is! String) {
      throw DataMismatchException(
          'Неверный формат статуса ("${json['status']}" - требуется String)\nУ рекламации id: ${json['id']}');
    }
    if (json['contractor_worker'] != null &&
        json['contractor_worker'] is! String) {
      throw DataMismatchException(
          'Неверный формат исполнителя подрядчика ("${json['contractor_worker']}" - требуется String)\nУ рекламации id: ${json['id']}');
    }
    if (json['contractor'] != null && json['contractor'] is! String) {
      throw DataMismatchException(
          'Неверный формат подрядчика ("${json['contractor']}" - требуется String)\nУ рекламации id: ${json['id']}');
    }
    if (json['message'] != null && json['message'] is! String) {
      throw DataMismatchException(
          'Неверный формат сообщения ("${json['message']}" - требуется String)\nУ рекламации id: ${json['id']}');
    }
    if (json['agent'] != null && json['agent'] is! String) {
      throw DataMismatchException(
          'Неверный формат автора ("${json['agent']}" - требуется String)\nУ рекламации id: ${json['id']}');
    }
    if (json['attachments'] != null && json['attachments'] is! List) {
      throw DataMismatchException(
          'Неверный формат вложений ("${json['attachments']}" - требуется String)\nУ рекламации id: ${json['id']}');
    }
    if (json['comments'] != null && json['comments'] is! List) {
      throw DataMismatchException(
          'Неверный формат списка комментариев ("${json['comments']}" - требуется String)\nУ рекламации id: ${json['id']}');
    }
    if (json['created_at'] != null &&
        json['created_at'] is! String &&
        json['created_at'] is! DateTime) {
      throw DataMismatchException(
          'Неверный формат даты создания ("${json['created_at']}" - требуется String или DateTime)\nУ рекламации id: ${json['id']}');
    }
    if (json['updated_at'] != null &&
        json['updated_at'] is! String &&
        json['updated_at'] is! DateTime) {
      throw DataMismatchException(
          'Неверный формат даты обновления ("${json['updated_at']}" - требуется String или DateTime)\nУ рекламации id: ${json['id']}');
    }

    Detachment _detachment;
    List<Comment> _comments = [];
    Comment _comment;
    List<Attachment> _attachments = [];
    Attachment _attachment;
    try {
      _detachment = Detachment.fromJson(json['detachment']);
      if (json['attachments'] != null) {
        (json['attachments'] as List).forEach((attachment) {
          _attachment = Attachment.fromJson(attachment);
          if (_attachment != null) {
            _attachments.add(_attachment);
          }
        });
      }
      if (json['comments'] != null) {
        (json['comments'] as List).forEach((comment) {
          _comment = Comment.fromJson(comment);
          if (_comment != null) {
            _comments.add(_comment);
          }
        });
      }
    } catch (e) {
      throw DataMismatchException(e is Error
          ? e.toString()
          : e.message + '\nУ рекламации id: ${json['id']}');
    }

    ReclamationId id;
    if (json['_id'] != null) {
      id = ReclamationId(
          json['_id'] is String ? json['_id'] : json['_id']?.toHexString());
    } else {
      id = ReclamationId(json['id']);
    }

    return Reclamation(
        id: id,
        item: DetachmentItemId(json['item']),
        detachment: _detachment,
        status: ReclamationStatus(json['status']),
        contractorWorker: UserId(json['contractor_worker']),
        contractor: ContractorId(json['contractor']),
        message: json['message'],
        agent: UserId(json['agent']),
        attachments: _attachments.isEmpty ? null : _attachments,
        comments: _comments.isEmpty ? null : _comments,
        createdAt: toLocalDateTime(json['created_at']),
        updatedAt: toLocalDateTime(json['updated_at']));
  }

  @override
  bool operator ==(other) {
    if (other is Reclamation) {
      return other.id == id;
    }
    return false;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => json.toString();

  /// Возвращает данные рекламации в JSON-формате (String/Map)
  ///   String - когда в объекте был заполнен только id
  ///   Map - в ином случае
  @override
  dynamic get json {
    Map<String, dynamic> json = {
      'id': id?.json,
      'item': item?.json,
      'detachment': detachment?.json,
      'status': status?.json,
      'contractor_worker': contractorWorker?.json,
      'contractor': contractor?.json,
      'message': message,
      'agent': agent?.json,
      'attachments':
          attachments?.map((attachment) => attachment.json)?.toList(),
      'comments': comments?.map((comment) => comment.json)?.toList(),
      'created_at': createdAt?.toUtc(),
      'updated_at': updatedAt?.toUtc()
    }..removeWhere((key, value) => value == null);

    if (json.keys.length == 1 && json.keys.first == 'id') return json['id'];

    return json;
  }
}

/// Идентификатор рекламации
class ReclamationId extends ObjectId {
  ReclamationId._(dynamic id) : super(id);
  factory ReclamationId(id) {
    if (id == null) return null;
    return ReclamationId._(id);
  }
}

/// Статус рекламации
///
/// возможный статус рекламации:
/// * open - открыта
/// * closed - закрыта
class ReclamationStatus implements JsonEncodable {
  /// Открыта
  static const ReclamationStatus open = ReclamationStatus._('open');

  /// Закрыта
  static const ReclamationStatus closed = ReclamationStatus._('closed');

  final String _status;

  // Создает статус рекламации
  const ReclamationStatus._(String status) : _status = status;

  factory ReclamationStatus(String status) {
    if (status == null) return null;
    ReclamationStatus _curStatus = ReclamationStatus._(status);
    if (values.contains(_curStatus)) {
      return _curStatus;
    } else {
      throw ArgumentError('Invalid reclamation status: ${status}.');
    }
  }

  final Map<String, String> _statusStr = const {
    'open': 'Открыта',
    'closed': 'Закрыта',
  };

  String get value => _status;
  static List get values => [open, closed];

  @override
  bool operator ==(dynamic other) {
    if (other is ReclamationStatus) {
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
