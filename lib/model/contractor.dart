import 'package:data_model/data_model.dart';

import 'account.dart';
import 'can_do.dart';
import 'exceptions/data_mismatch_exception.dart';
import 'work_category.dart';

/// Класс содержащий данные об организации подрядчика
class Contractor implements Model<ContractorId> {
  /// Идентификатор организации подрядчика
  ContractorId id;

  /// Доступные виды работ на кладбищах
  List<CanDo> canDo;

  /// Активность подрядчика
  bool active;

  /// Информацию о юр лице
  AccountId account;

  /// Наименование
  String name;

  /// Категория работ подрядчика
  WorkCategory workCategory;

  /// Создает нового подрядчика
  Contractor(
      {this.id,
      this.name,
      this.canDo,
      this.active,
      this.account,
      this.workCategory});

  /// Создает подрядчика из JSON данных
  factory Contractor.fromJson(dynamic json) {
    if (json == null) return null;

    if (json is String) {
      return Contractor(id: ContractorId(json));
    }

    if (json is! Map) {
      throw DataMismatchException(
          'Не верный формат json у подрядчика - требуется String либо Map');
    }

    if (json['id'] != null && json['_id'] != null) {
      throw DataMismatchException(
          'Идентификатор подрядчика указан в двух атрибутах: id и _id ("${json['id']} ~ ${json['_id']}" - требуется один)');
    }

    if (json['active'] != null && json['active'] is! bool) {
      throw DataMismatchException(
          'Неверный формат активности ("${json['active']}" - требуется bool)\nУ подрядчика id: ${json['id']}');
    }
    if (json['account'] != null && json['account'] is! String) {
      throw DataMismatchException(
          'Неверный формат идентификатора аккаунта ("${json['account']}" - требуется String)\nУ подрядчика id: ${json['id']}');
    }
    if (json['name'] != null && json['name'] is! String) {
      throw DataMismatchException(
          'Неверный формат наименования ("${json['name']}" - требуется String)\nУ подрядчика id: ${json['id']}');
    }
    if (json['type'] != null && json['type'] is! String) {
      throw DataMismatchException(
          'Неверный формат типа ("${json['type']}" - требуется String)\nУ подрядчика id: ${json['id']}');
    }
    if (json['can_do'] != null && json['can_do'] is! List) {
      throw DataMismatchException(
          'Неверный формат списка доступных услуг на кладбищах ("${json['can_do']}" - требуется List)\nУ подрядчика id: ${json['id']}');
    }
    List<CanDo> _canDo = json['can_do'] == null
        ? null
        : (json['can_do'] as List)
            .map((canDo) => CanDo.fromJson(canDo))
            .toList();

    ContractorId id;
    if (json['_id'] != null) {
      id = ContractorId(
          json['_id'] is String ? json['_id'] : json['_id']?.toHexString());
    } else {
      id = ContractorId(json['id']);
    }

    return Contractor(
        id: id,
        active: json['active'],
        account: AccountId(json['account']),
        name: json['name'],
        workCategory: WorkCategory(json['type']),
        canDo: _canDo);
  }

  @override
  bool operator ==(other) {
    if (other is Contractor) {
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
      'active': active,
      'account': account?.json,
      'name': name,
      'type': workCategory?.json,
      'can_do': canDo?.map((canDoItem) => canDoItem.json)?.toList()
    }..removeWhere((key, value) => value == null);

    if (json.keys.length == 1 && json.keys.first == 'id') return json['id'];

    return json;
  }
}

/// Идентификатор организации подрядчика
class ContractorId extends ObjectId {
  ContractorId._(dynamic id) : super(id);
  factory ContractorId(id) {
    if (id == null) return null;
    return ContractorId._(id);
  }
}
