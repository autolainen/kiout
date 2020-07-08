import 'package:aahitest/model/exceptions/data_mismatch_exception.dart';
import 'package:aahitest/model/person.dart';
import 'package:aahitest/model/user/user_status.dart';
import 'package:data_model/data_model.dart';
import 'package:equatable/equatable.dart';
import '../datetime/to_local_date_time.dart';

import '../phone.dart';

/// Агент ДО
class AgentBefore extends Person
    with EquatableMixin
    implements Model<AgentBeforeId> {
  AgentBeforeId id;
  UserStatus status;
  Phone phone;
  DateTime createdAt;
  DateTime updatedAt;

  AgentBefore(
      {this.id,
      String lastName,
      String firstName,
      String patronymic,
      this.phone,
      this.status,
      this.createdAt,
      this.updatedAt})
      : super(lastName: lastName, firstName: firstName, patronymic: patronymic);

  factory AgentBefore.fromJson(dynamic json) {
    if (json == null) return null;

    if (json is String) {
      return AgentBefore(id: AgentBeforeId(json));
    }

    if (json is! Map) {
      throw DataMismatchException(
          'Неверный формат json у агента до id: ${json['id']} - требуется Map');
    }
    if (json['phone'] != null &&
        (json['phone'] is! String || json['phone'].isEmpty)) {
      throw DataMismatchException(
          'Неверный формат номера телефона ("${json['phone']}" - требуется непустой String)\nУ агента до id: ${json['id']}');
    }
    if (json['lastname'] != null &&
        (json['lastname'] is! String || json['lastname'].isEmpty)) {
      throw DataMismatchException(
          'Неверный формат фамилии ("${json['lastname']}" - требуется непустой String)\nУ агента до id: ${json['id']}');
    }
    if (json['firstname'] != null &&
        (json['firstname'] is! String || json['firstname'].isEmpty)) {
      throw DataMismatchException(
          'Неверный формат имени ("${json['firstname']}" - требуется непустой String)\nУ агента до id: ${json['id']}');
    }
    if (json['patronymic'] != null && json['patronymic'] is! String) {
      throw DataMismatchException(
          'Неверный формат отчества ("${json['patronymic']}" - требуется String)\nУ агента до id: ${json['id']}');
    }
    if (json['status'] != null && json['status'] is! String) {
      throw DataMismatchException(
          'Неверный формат статуса ("${json['status']}" - требуется String)\nУ агента до id: ${json['id']}');
    }

    return AgentBefore(
        id: AgentBeforeId(json['id']),
        lastName: json['lastname'],
        firstName: json['firstname'],
        patronymic: json['patronymic'],
        phone: Phone(json['phone']),
        status: UserStatus(json['status']),
        createdAt: toLocalDateTime(json['created_at']),
        updatedAt: toLocalDateTime(json['updated_at']));
  }

  @override
  dynamic get json {
    Map<String, dynamic> json = {
      'id': id?.json,
      ...super.json,
      'phone': phone?.json,
      'status': status?.json,
      'created_at': createdAt?.toUtc(),
      'updated_at': updatedAt?.toUtc()
    }..removeWhere((key, value) => value == null);

    if (json.length == 1 && json.keys.first == 'id') return json['id'];
    return json;
  }

  @override
  List<Object> get props => [
        id,
        lastName,
        firstName,
        patronymic,
        phone,
        status,
        createdAt,
        updatedAt
      ];

  @override
  String toString() => json.toString();
}

class AgentBeforeId extends ObjectId {
  AgentBeforeId._(id) : super(id);
  factory AgentBeforeId(id) {
    if (id == null) return null;
    return AgentBeforeId._(id);
  }
}
