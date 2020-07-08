import 'package:data_model/data_model.dart';

import '../account.dart';
import '../datetime/to_local_date_time.dart';
import '../helpers/json_validators.dart';
import '../person.dart';
import '../phone.dart';
import 'agent.dart';
import 'authority.dart';
import 'contractor_manager.dart';
import 'contractor_worker.dart';
import 'halls_agent.dart';
import 'referrer.dart';
import 'role.dart';
import 'user_group.dart';
import 'user_status.dart';

/// Класс реализующий модель данных User - пользователь
class User extends Person implements Model<UserId> {
  /// Идентификатор пользователя
  UserId id;

  /// Логин пользователя
  String username;

  /// Пароль пользователя
  ///
  /// `password` используется только для установке пароля при создании пользователя или при изменении пароля
  /// При чтении данных пользователя это поле всегда имеет значение `null`
  String password;

  /// Емейл пользователя
  String email;

  /// Телефон пользователя
  Phone phone;

  /// Подтвержден ли номер телефона
  bool phoneConfirmed;

  /// Статус пользователя
  UserStatus status;

  /// Роль пользователя
  Role role;

  /// Дата создания
  DateTime createdAt;

  /// Дата обновления
  DateTime updatedAt;

  /// Номер пользователя
  String no;

  //TODO: привести к одному виду в базе
  /// Группы пользователя
  List<UserGroupId> groups;

  /// Группа пользователя
  UserGroupId group;

  /// Доступ к редактированию пользователей
  bool allowedUserManagment;

  /// Разрешена ли отправка SMS
  bool canReceiveSms;

  /// Аккаунт банковский
  AccountId account;

  /// Данные авторизации
  Authority authority;

  User(
      {this.id,
      String lastName,
      String firstName,
      String patronymic,
      DateTime createdAt,
      DateTime updatedAt,
      this.role,
      this.email,
      this.phone,
      this.phoneConfirmed,
      this.username,
      this.status,
      this.no,
      this.group,
      this.groups,
      this.allowedUserManagment,
      this.canReceiveSms,
      this.account,
      this.authority,
      this.password})
      : this.createdAt = createdAt?.toLocal(),
        this.updatedAt = updatedAt?.toLocal(),
        super(
            lastName: lastName, firstName: firstName, patronymic: patronymic) {}

  factory User.fromJson(dynamic json) {
    if (json == null) return null;

    if (json is String) {
      return User(id: UserId(json));
    }

    validateUserJson(json);

    final role = Role(json['role']);
    if (role == Role.contractorManager) return ContractorManager.fromJson(json);
    if (role == Role.contractorWorker) return ContractorWorker.fromJson(json);
    if (role == Role.agent) return Agent.fromJson(json);
    if (role == Role.hallsAgent) return HallsAgent.fromJson(json);
    if (role == Role.referrer) return Referrer.fromJson(json);

    return User(
        id: UserId(json['id']),
        email: json['email'],
        phone: Phone(json['phone']),
        phoneConfirmed: json['phone_confirmed'],
        lastName: json['lastname'],
        firstName: json['firstname'],
        patronymic: json['patronymic'],
        username: json['username'],
        status: UserStatus(json['status']),
        password: json['password'],
        createdAt: toLocalDateTime(json['created_at']),
        updatedAt: toLocalDateTime(json['updated_at']),
        no: json['no'],
        groups: json['groups'] == null
            ? null
            : List<UserGroupId>.from(
                json['groups'].map((group) => UserGroupId(group))),
        group: UserGroupId(json['group']),
        allowedUserManagment: json['allowed_user_managment'],
        canReceiveSms: json['can_receive_sms'],
        account: AccountId(json['account']),
        authority: Authority.fromJson(json['authority']),
        role: role);
  }

  /// Возвращает данные пользователя в JSON-формате (String/Map)
  ///   String - когда в объекте был заполнен только id
  ///   Map - в ином случае
  @override
  dynamic get json {
    Map<String, dynamic> json = Map.from(super.json)
      ..addAll({
        'id': id?.json,
        'email': email,
        'phone': phone?.json,
        'phone_confirmed': phoneConfirmed,
        'password': password,
        'username': username,
        'status': status?.json,
        'role': role?.json,
        'no': no,
        'groups': groups?.map((group) => group.json)?.toList(),
        'group': group?.json,
        'allowed_user_managment': allowedUserManagment,
        'can_receive_sms': canReceiveSms,
        'authority': authority?.json,
        'account': account?.json,
        'created_at': createdAt?.toUtc(),
        'updated_at': updatedAt?.toUtc(),
      })
      ..removeWhere((key, value) => value == null);

    if (json.keys.length == 1 && json.keys.first == 'id') return json['id'];

    return json;
  }

  @override
  String toString() => json.toString();
}

/// Идентификатор пользователя
class UserId extends ObjectId {
  UserId._(dynamic id) : super(id);
  factory UserId(id) {
    if (id == null) return null;
    return UserId._(id);
  }
}
