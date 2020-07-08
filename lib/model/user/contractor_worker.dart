import '../account.dart';
import '../can_do.dart';
import '../contractor.dart';
import '../datetime/to_local_date_time.dart';
import '../exceptions/data_mismatch_exception.dart';
import '../helpers/json_validators.dart';
import '../phone.dart';
import '../work_category.dart';
import 'authority.dart';
import 'role.dart';
import 'user.dart';
import 'user_group.dart';
import 'user_status.dart';

/// Исполнитель подрядчика
///
/// Пользователь с ролью исполнителя подрядчика
class ContractorWorker extends User {
  /// Идентификатор организации подрядчика
  final ContractorId contractor;

  /// Категория работы исполнителя подрядчика
  final WorkCategory workCategory;

  /// Виды работ, которые производит исполнитель на кладбище
  List<CanDo> canDo;

  /// Создает нового пользователя с ролью исполнителя подрядчика
  ContractorWorker(
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
      this.contractor,
      this.canDo,
      this.workCategory})
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
            role: Role.contractorWorker);

  /// Создает исполнителя подрядчика из JSON данных
  factory ContractorWorker.fromJson(dynamic json) {
    if (json == null) return null;

    if (json is String) {
      return ContractorWorker(id: UserId(json));
    }

    validateUserJson(json);

    var _canDo = <CanDo>[];
    WorkCategory _workCategory;
    try {
      _workCategory = WorkCategory(json['work_category']);
      _canDo = json['can_do'] == null
          ? null
          : (json['can_do'] as List)
              .map((canDo) => CanDo.fromJson(canDo))
              .toList();
    } catch (e) {
      throw DataMismatchException(e is Error
          ? e.toString()
          : e.message + '\nУ исполнителя подрядчика id: ${json['id']}');
    }

    return ContractorWorker(
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
        canDo: _canDo,
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
        authority: Authority.fromJson(json['authority']),
        workCategory: _workCategory);
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
          'id_contractor': contractor?.json,
          'can_do': canDo?.map((canDo) => canDo.json)?.toList(),
          'work_category': workCategory?.value
        })
        ..removeWhere((key, value) => value == null);
      if (json.keys.length == 1 && json.keys.first == 'id') return json['id'];
      return json;
    }
  }
}
