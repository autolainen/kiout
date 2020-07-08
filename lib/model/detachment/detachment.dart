import 'package:data_model/data_model.dart';

import '../cemetery.dart';
import '../comment.dart';
import '../contractor.dart';
import '../datetime/to_local_date_time.dart';
import '../document.dart';
import '../exceptions/data_mismatch_exception.dart';
import '../hall.dart';
import '../order/order.dart';
import '../user/user.dart';
import '../work_type.dart';
import 'detachment_item.dart';
import 'detachment_stage.dart';
import 'detachment_status.dart';

/// Класс реализующий данные о заказ-наряде
class Detachment implements Model<DetachmentId> {
  // Возвращает список этапов выполнения заказ-наряда по типу
  static List<DetachmentStage> stagesOf(WorkType type) => allStages[type];

  /// Возвращает следующий этап заказ-наряда или null, если он завершен
  DetachmentStage get nextStage {
    if (currentStage == null || stages == null) return null;

    int nestStageIndex = stages.indexOf(currentStage) + 1;
    return (nestStageIndex == stages.length ? null : stages[nestStageIndex]);
  }

  /// Текущий этап выполнения заказ-наряда
  DetachmentStage get currentStage =>
      stages?.firstWhere((stage) => stage.status == status, orElse: () => null);

  List<DetachmentStage> get stages => Detachment.stagesOf(type);

  /// Идентификатор наряда
  DetachmentId id;

  /// Номер заказ-наряда
  String no;

  /// Кладбище
  Cemetery cemetery;

  /// Зал прощания
  Hall hall;

  /// Заказ связанный с заказ-нарядом
  Order order;

  /// Услуги и товары заказ-наряда
  List<DetachmentItem> items;

  /// Менеджер заказ-наряда
  UserId manager;

  /// Агент оформитель з-н
  UserId agent;

  /// Исполнитель подрядчика заказ-наряда
  User contractorWorker;

  /// Подрядчик заказ-наряда
  ContractorId contractor;

  /// Статус
  DetachmentStatus status;

  /// Срочность
  bool urgent;

  /// Проверен ли менеджером на текущем этапе выполнения
  bool verificationRequired;

  /// Вид работ
  WorkType type;

  /// Дата уведомления
  DateTime notifyAt;

  /// Дата завершения
  DateTime finishAt;

  /// Список комментариев, оставленных к заказ-наряду
  List<Comment> comments;

  /// Дата создания
  DateTime createdAt;

  /// Дата обновления
  DateTime updatedAt;

  /// Список документов
  List<DocumentId> documents;

  /// Список смежных з-н
  List<Detachment> related;

  /// Признак архивности
  bool archived;

  Detachment(
      {this.id,
      DateTime notifyAt,
      DateTime finishAt,
      DateTime createdAt,
      DateTime updatedAt,
      bool archived,
      this.no,
      this.cemetery,
      this.hall,
      this.order,
      this.items,
      this.contractor,
      this.contractorWorker,
      this.manager,
      this.agent,
      this.comments,
      this.status,
      this.urgent,
      this.verificationRequired,
      this.type,
      this.documents,
      this.related})
      : this.notifyAt = notifyAt?.toLocal(),
        this.finishAt = finishAt?.toLocal(),
        this.createdAt = createdAt?.toLocal(),
        this.updatedAt = updatedAt?.toLocal(),
        this.archived = archived;

  /// Создает заказ-наряд из JSON-данных
  factory Detachment.fromJson(dynamic json) {
    if (json == null) return null;

    if (json is String) {
      return Detachment(id: DetachmentId(json));
    }

    if (json is! Map) {
      throw DataMismatchException(
          'Не верный формат json у заказ-наряда - требуется String либо Map');
    }

    if (json['id'] != null && json['_id'] != null) {
      throw DataMismatchException(
          'Идентификатор заказ-наряда указан в двух атрибутах: id и _id ("${json['id']} ~ ${json['_id']}" - требуется один)');
    }

    if (json['no'] != null && json['no'] is! String) {
      throw DataMismatchException(
          'Неверный формат номера ("${json['no']}" - требуется String)\nУ заказ-наряда id: ${json['id']}');
    }
    if (json['cemetery'] != null &&
        json['cemetery'] is! Map<String, dynamic> &&
        json['cemetery'] is! String) {
      throw DataMismatchException(
          'Неверный формат кладбища ("${json['cemetery']}" - требуется Map<String, dynamic>) или String\nУ заказ-наряда id: ${json['id']}');
    }
    if (json['hall'] != null &&
        json['hall'] is! Map<String, dynamic> &&
        json['hall'] is! String) {
      throw DataMismatchException(
          'Неверный формат зала прощания ("${json['hall']}" - требуется Map<String, dynamic>) или String\nУ заказ-наряда id: ${json['id']}');
    }
    if (json['order'] != null &&
        json['order'] is! Map<String, dynamic> &&
        json['order'] is! String) {
      throw DataMismatchException(
          'Неверный формат заказа ("${json['order']}" - требуется Map<String, dynamic>) или String\nУ заказ-наряда id: ${json['id']}');
    }
    if (json['contractor'] != null && json['contractor'] is! String) {
      throw DataMismatchException(
          'Неверный формат подрядчика ("${json['contractor']}" - требуется String)\nУ заказ-наряда id: ${json['id']}');
    }
    if (json['contractor_worker'] != null &&
        json['contractor_worker'] is! Map<String, dynamic> &&
        json['contractor_worker'] is! String) {
      throw DataMismatchException(
          'Неверный формат исполнителя подрядчика ("${json['contractor_worker']}" - требуется Map<String, dynamic>) или String\nУ заказ-наряда id: ${json['id']}');
    }
    if (json['manager'] != null && json['manager'] is! String) {
      throw DataMismatchException(
          'Неверный формат менеджера ("${json['manager']}" - требуется String)\nУ заказ-наряда id: ${json['id']}');
    }
    if (json['agent'] != null && json['agent'] is! String) {
      throw DataMismatchException(
          'Неверный формат агента-оформителя ("${json['agent']}" - требуется String)\nУ заказ-наряда id: ${json['id']}');
    }
    if (json['status'] != null && json['status'] is! String) {
      throw DataMismatchException(
          'Неверный формат статуса ("${json['status']}" - требуется String)\nУ заказ-наряда id: ${json['id']}');
    }
    if (json['type'] != null && json['type'] is! String) {
      throw DataMismatchException(
          'Неверный формат вида работ ("${json['type']}" - требуется String)\nУ заказ-наряда id: ${json['id']}');
    }
    if (json['urgent'] != null && json['urgent'] is! bool) {
      throw DataMismatchException(
          'Неверный формат срочности ("${json['urgent']}" - требуется bool)\nУ заказ-наряда id: ${json['id']}');
    }
    if (json['verification_required'] != null &&
        json['verification_required'] is! bool) {
      throw DataMismatchException(
          'Неверный формат проверки менеджером ("${json['verification_required']}" - требуется bool)\nУ заказ-наряда id: ${json['id']}');
    }
    if (json['items'] != null && json['items'] is! List) {
      throw DataMismatchException(
          'Неверный формат списка товаров/услуг ("${json['items']}" - требуется List)\nУ заказ-наряда id: ${json['id']}');
    }
    if (json['comments'] != null && json['comments'] is! List) {
      throw DataMismatchException(
          'Неверный формат списка комментариев ("${json['comments']}" - требуется List)\nУ заказ-наряда id: ${json['id']}');
    }
    if (json['notify_at'] != null &&
        json['notify_at'] is! String &&
        json['notify_at'] is! DateTime) {
      throw DataMismatchException(
          'Неверный формат даты уведомления ("${json['notify_at']}" - требуется String или DateTime)\nУ заказ-наряда id: ${json['id']}');
    }
    if (json['finish_at'] != null &&
        json['finish_at'] is! String &&
        json['finish_at'] is! DateTime) {
      throw DataMismatchException(
          'Неверный формат даты окончания ("${json['finish_at']}" - требуется String или DateTime)\nУ заказ-наряда id: ${json['id']}');
    }
    if (json['created_at'] != null &&
        json['created_at'] is! String &&
        json['created_at'] is! DateTime) {
      throw DataMismatchException(
          'Неверный формат даты создания ("${json['created_at']}" - требуется String или DateTime)\nУ заказ-наряда id: ${json['id']}');
    }
    if (json['updated_at'] != null &&
        json['updated_at'] is! String &&
        json['updated_at'] is! DateTime) {
      throw DataMismatchException(
          'Неверный формат даты обновления ("${json['updated_at']}" - требуется String или DateTime)\nУ участка из заказ-наряда id: ${json['id']}');
    }
    if (json['documents'] != null && json['documents'] is! List) {
      throw DataMismatchException(
          'Неверный формат списка документов/услуг ("${json['documents']}" - требуется List)\nУ заказ-наряда id: ${json['id']}');
    }

    if (json['related'] != null && json['related'] is! List) {
      throw DataMismatchException(
          'Неверный формат списка смежных заказ-нарядов ("${json['related']}" - требуется List)\nУ заказ-наряда id: ${json['id']}');
    }

    if (json['archived'] != null && json['archived'] is! bool) {
      throw DataMismatchException(
          'Неверный формат признака архивности ("${json['archived']}" - требуется bool)\nУ заказ-наряда id: ${json['id']}');
    }

    Cemetery _cemetery;
    Hall _hall;
    Order _order;
    User _contractorWorker;
    var _comments = <Comment>[];
    Comment _comment;
    var _items = <DetachmentItem>[];
    DetachmentItem _item;

    try {
      _cemetery = Cemetery.fromJson(json['cemetery']);
      _hall = Hall.fromJson(json['hall']);
      _order = Order.fromJson(json['order']);
      _contractorWorker = User.fromJson(json['contractor_worker']);
      if (json['items'] != null) {
        (json['items'] as List).forEach((item) {
          _item = DetachmentItem.fromJson(item);
          if (_item != null) _items.add(_item);
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
          : e.message + '\nУ заказ-наряда id: ${json['id']}');
    }

    var _documents = json['documents'] == null
        ? null
        : List<DocumentId>.from((json['documents'] as List)
            .map((document) => DocumentId(document)));

    var _related = json['related'] == null
        ? null
        : List<Detachment>.from((json['related'] as List)
            .map((detachment) => Detachment.fromJson(detachment)));

    DetachmentId id;
    if (json['_id'] != null) {
      id = DetachmentId(
          json['_id'] is String ? json['_id'] : json['_id']?.toHexString());
    } else {
      id = DetachmentId(json['id']);
    }

    return Detachment(
        id: id,
        no: json['no'],
        cemetery: _cemetery,
        hall: _hall,
        order: _order,
        items: _items.isEmpty ? null : _items,
        comments: _comments.isEmpty ? null : _comments,
        contractor: ContractorId(json['contractor']),
        contractorWorker: _contractorWorker,
        manager: UserId(json['manager']),
        agent: UserId(json['agent']),
        status: DetachmentStatus(json['status']),
        urgent: json['urgent'],
        verificationRequired: json['verification_required'],
        type: WorkType(json['type']),
        notifyAt: toLocalDateTime(json['notify_at']),
        finishAt: toLocalDateTime(json['finish_at']),
        createdAt: toLocalDateTime(json['created_at']),
        updatedAt: toLocalDateTime(json['updated_at']),
        documents: _documents,
        archived: json['archived'],
        related: _related);
  }

  @override
  bool operator ==(other) {
    if (other is Detachment) {
      return other.id == id;
    }
    return false;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => json.toString();

  /// Возвращает данные заказ-наряда в JSON-формате (String/Map)
  ///   String - когда в объекте был заполнен только id
  ///   Map - в ином случае
  @override
  dynamic get json {
    Map<String, dynamic> json = {
      'id': id?.json,
      'no': no,
      'cemetery': cemetery?.json,
      'hall': hall?.json,
      'order': order?.json,
      'contractor': contractor?.json,
      'contractor_worker': contractorWorker?.json,
      'manager': manager?.json,
      'agent': agent?.json,
      'status': status?.json,
      'urgent': urgent,
      'verification_required': verificationRequired,
      'type': type?.json,
      'items': items?.map((item) => item.json)?.toList(),
      'comments': comments?.map((comment) => comment.json)?.toList(),
      'notify_at': notifyAt?.toUtc(),
      'finish_at': finishAt?.toUtc(),
      'created_at': createdAt?.toUtc(),
      'updated_at': updatedAt?.toUtc(),
      'documents': documents?.map((document) => document.json)?.toList(),
      'related': related?.map((_detachment) => _detachment.json)?.toList(),
      'archived': archived
    }..removeWhere((key, value) => value == null);

    if (json.keys.length == 1 && json.keys.first == 'id') return json['id'];

    return json;
  }
}

/// Идентификатор заказ-наряда
class DetachmentId extends ObjectId {
  DetachmentId._(dynamic id) : super(id);
  factory DetachmentId(id) {
    if (id == null) return null;
    return DetachmentId._(id);
  }
}
