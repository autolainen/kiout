import '../account.dart';
import '../datetime/to_local_date_time.dart';
import '../exceptions/data_mismatch_exception.dart';
import '../helpers/json_validators.dart';
import '../order/order_type.dart';
import '../phone.dart';
import 'authority.dart';
import 'role.dart';
import 'user.dart';
import 'user_group.dart';
import 'user_status.dart';

/// Агент
///
/// Пользователь с ролью агент
class Agent extends User {
  /// Точка продаж
  final String sellingPoint;

  /// Типы предзаказа
  List<OrderType> opportunityTypes;

  /// Создает нового пользователя с ролью агента
  Agent(
      {UserId id,
      String lastName,
      String firstName,
      String patronymic,
      String email,
      Phone phone,
      bool phoneConfirmed,
      String username,
      UserStatus status,
      String password,
      DateTime createdAt,
      DateTime updatedAt,
      String no,
      List<UserGroupId> groups,
      UserGroupId group,
      bool allowedUserManagment,
      bool canReceiveSms,
      AccountId account,
      Authority authority,
      this.sellingPoint,
      this.opportunityTypes})
      : super(
            id: id,
            lastName: lastName,
            firstName: firstName,
            patronymic: patronymic,
            email: email,
            phone: phone,
            phoneConfirmed: phoneConfirmed,
            username: username,
            status: status,
            password: password,
            createdAt: createdAt,
            updatedAt: updatedAt,
            no: no,
            groups: groups,
            group: group,
            allowedUserManagment: allowedUserManagment,
            canReceiveSms: canReceiveSms,
            account: account,
            authority: authority,
            role: Role.agent);

  /// Создает исполнителя подрядчика из JSON данных
  factory Agent.fromJson(dynamic json) {
    if (json == null) return null;

    if (json is String) {
      return Agent(id: UserId(json));
    }

    validateUserJson(json);

    if (json['opportunity_types'] != null &&
        json['opportunity_types'] is! List) {
      throw DataMismatchException(
          'Неверный формат списка типов предзаказов агента ("${json['opportunity_types']}" - требуется List)\nУ агента оформителя id: ${json['id']}');
    }

    var _opportunityTypes;
    try {
      _opportunityTypes = json['opportunity_types']?.isEmpty ?? true
          ? null
          : List<OrderType>.from((json['opportunity_types'] as List)
              .map((type) => OrderType(type)));
    } catch (e) {
      throw DataMismatchException(e is Error
          ? e.toString()
          : e.message + '\nУ агента оформителя id: ${json['id']}');
    }

    return Agent(
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
        sellingPoint: json['selling_point'],
        opportunityTypes: _opportunityTypes,
        authority: Authority.fromJson(json['authority']));
  }

  /// Возвращает данные исполнителя подрядчика в JSON-формате (String/Map)
  ///   String - когда в объекте был заполнен только id
  ///   Map - в ином случае
  @override
  Map<String, dynamic> get json {
    {
      Map<String, dynamic> json;
      var superJson = super.json;
      if (superJson is String) {
        json = {'id': superJson};
      } else {
        json = superJson;
      }
      json
        ..addAll({
          'selling_point': sellingPoint,
          'opportunity_types':
              opportunityTypes?.map((type) => type.json)?.toList()
        })
        ..removeWhere((key, value) => value == null);

      if (json.keys.length == 1 && json.keys.first == 'id') return json['id'];
      return json;
    }
  }
}
