import '../account.dart';
import '../contractor.dart';
import '../datetime/to_local_date_time.dart';
import '../helpers/json_validators.dart';
import '../phone.dart';
import 'authority.dart';
import 'role.dart';
import 'user.dart';
import 'user_group.dart';
import 'user_status.dart';

/// Менеджер подрядчика
///
/// Пользователь с ролью менеджера подрядчика
class ContractorManager extends User {
  /// Идентификатор организации подрядчика
  final ContractorId contractor;

  /// Создает нового пользователя с ролью менеджера подрядчика
  ContractorManager(
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
      UserGroupId group,
      List<UserGroupId> groups,
      bool allowedUserManagment,
      bool canReceiveSms,
      AccountId account,
      Authority authority,
      this.contractor})
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
            role: Role.contractorManager);

  /// Создает менеджера подрядчика из JSON данных
  factory ContractorManager.fromJson(dynamic json) {
    if (json == null) return null;

    if (json is String) {
      return ContractorManager(id: UserId(json));
    }

    validateUserJson(json);

    return ContractorManager(
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
        contractor: ContractorId(json['id_contractor']),
        groups: json['groups'] == null
            ? null
            : List<UserGroupId>.from(
                json['groups'].map((group) => UserGroupId(group))),
        group: UserGroupId(json['group']),
        allowedUserManagment: json['allowed_user_managment'],
        canReceiveSms: json['can_receive_sms'],
        account: AccountId(json['account']),
        authority: Authority.fromJson(json['authority']));
  }

  /// Возвращает данные менеджера подрядчика в JSON-формате (String/Map)
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
      ..addAll({'id_contractor': contractor?.json})
      ..removeWhere((key, value) => value == null);
    if (json.keys.length == 1 && json.keys.first == 'id') return json['id'];
    return json;
  }
}
