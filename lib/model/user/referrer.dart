import '../account.dart';
import '../datetime/to_local_date_time.dart';
import '../exceptions/data_mismatch_exception.dart';
import '../helpers/json_validators.dart';
import '../phone.dart';
import 'authority.dart';
import 'role.dart';
import 'user_group.dart';
import 'user_status.dart';
import 'user.dart';

/// Внешний агент
class Referrer extends User {
  /// Менеджер внешнего агента
  final UserId referrerManager;

  /// Тип банковского аккаунта
  AccountType _accountType;
  AccountType get accountType => _accountType ?? AccountType.physicalEntity;

  /// Создает нового пользователя с ролью внешнего агента
  Referrer(
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
      AccountType accountType,
      this.referrerManager})
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
            group: group,
            groups: groups,
            allowedUserManagment: allowedUserManagment,
            canReceiveSms: canReceiveSms,
            account: account,
            authority: authority,
            role: Role.referrer) {
    _accountType = accountType;
  }

  /// Создает исполнителя подрядчика из JSON данных
  factory Referrer.fromJson(dynamic json) {
    if (json == null) return null;

    if (json is String) {
      return Referrer(id: UserId(json));
    }

    validateUserJson(json);

    if (json['account_type'] != null && json['account_type'] is! String) {
      throw DataMismatchException(
          'Неверный формат типа банковского аккаунта ("${json['account_type']}" - требуется String)\nУ внешнего агента id: ${json['id']}');
    }

    Authority _authority;
    try {
      _authority = Authority.fromJson(json['authority']);
    } catch (e) {
      throw DataMismatchException(e is Error
          ? e.toString()
          : e.message + '\nУ внешнего агента id: ${json['id']}');
    }

    return Referrer(
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
        accountType: AccountType(json['account_type']),
        referrerManager: UserId(json['referrer_manager']),
        authority: _authority);
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
          'referrer_manager': referrerManager?.json,
          'account_type': _accountType?.json
        })
        ..removeWhere((key, value) => value == null);
      if (json.keys.length == 1 && json.keys.first == 'id') return json['id'];
      return json;
    }
  }
}
