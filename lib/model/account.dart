import 'package:data_model/data_model.dart';

import 'bank_details.dart';
import 'contract.dart';
import 'dadata_address.dart';
import 'datetime/to_local_date_time.dart';
import 'exceptions/data_mismatch_exception.dart';
import 'passport.dart';
import 'person.dart';
import 'phone.dart';

/// Аккаунт
class Account extends Person implements Model<AccountId> {
  /// Идентификатор аккаунта
  AccountId id;

  /// Название
  String name;

  /// Тип
  AccountType type;

  /// Банковские данные
  BankDetails bankDetails;

  /// Паспортные данные
  Passport passport;

  /// СНИЛС
  String snils;

  /// ИНН
  String inn;

  /// ОГРН
  String ogrn;

  /// Юридический адрес
  DadataAddress legalAddress;

  /// Телефон
  Phone phone;

  /// Электронная почта
  String email;

  /// Договор
  Contract contract;

  /// Дата создания
  DateTime createdAt;

  /// Дата обновления
  DateTime updatedAt;

  Account({
    this.id,
    String lastName,
    String firstName,
    String patronymic,
    DateTime createdAt,
    DateTime updatedAt,
    this.name,
    this.type,
    this.bankDetails,
    this.passport,
    this.snils,
    this.inn,
    this.ogrn,
    this.legalAddress,
    this.phone,
    this.email,
    this.contract,
  })  : this.createdAt = createdAt?.toLocal(),
        this.updatedAt = updatedAt?.toLocal(),
        super(
            lastName: lastName, firstName: firstName, patronymic: patronymic) {}

  /// Создает аккаунт из JSON-данных
  factory Account.fromJson(dynamic json) {
    if (json == null) return null;

    if (json is String) {
      return Account(id: AccountId(json));
    }

    if (json is! Map) {
      throw DataMismatchException(
          'Не верный формат json у аккаунта - требуется String либо Map');
    }

    if (json['name'] != null && json['name'] is! String) {
      throw DataMismatchException(
          'Неверный формат названия ("${json['name']}" - требуется String)\nУ аккаунта id: ${json['id']}');
    }
    if (json['email'] != null && json['email'] is! String) {
      throw DataMismatchException(
          'Неверный формат email ("${json['email']}" - требуется String)\nУ аккаунта id: ${json['id']}');
    }
    if (json['phone'] != null && json['phone'] is! String) {
      throw DataMismatchException(
          'Неверный формат телефона ("${json['phone']}" - требуется String)\nУ аккаунта id: ${json['id']}');
    }
    if (json['type'] != null && json['type'] is! String) {
      throw DataMismatchException(
          'Неверный формат типа ("${json['type']}" - требуется String)\nУ аккаунта id: ${json['id']}');
    }
    if (json['snils'] != null && json['snils'] is! String) {
      throw DataMismatchException(
          'Неверный формат СНИЛС ("${json['snils']}" - требуется String)\nУ аккаунта id: ${json['id']}');
    }
    if (json['inn'] != null && json['inn'] is! String) {
      throw DataMismatchException(
          'Неверный формат ИНН ("${json['inn']}" - требуется String)\nУ аккаунта id: ${json['id']}');
    }
    if (json['ogrn'] != null && json['ogrn'] is! String) {
      throw DataMismatchException(
          'Неверный формат ОГРН ("${json['ogrn']}" - требуется String)\nУ аккаунта id: ${json['id']}');
    }
    if (json['snils'] != null && json['snils'] is! String) {
      throw DataMismatchException(
          'Неверный формат пароля ("${json['snils']}" - требуется String)\nУ аккаунта id: ${json['id']}');
    }
    if (json['lastname'] != null && json['lastname'] is! String ||
        json['lastname'] == '') {
      throw DataMismatchException(
          'Неверный формат фамилии ("${json['lastname']}" - требуется не пустой String)\nУ аккаунта id: ${json['id']}');
    }
    if (json['firstname'] != null && json['firstname'] is! String ||
        json['firstname'] == '') {
      throw DataMismatchException(
          'Неверный формат имени ("${json['firstname']}" - требуется не пустой String)\nУ аккаунта id: ${json['id']}');
    }
    if (json['patronymic'] != null && json['patronymic'] is! String) {
      throw DataMismatchException(
          'Неверный формат отчества ("${json['patronymic']}" - требуется String)\nУ аккаунта id: ${json['id']}');
    }
    if (json['bank_details'] != null && json['bank_details'] is! Map) {
      throw DataMismatchException(
          'Неверный формат банковских данных ("${json['bank_details']}" - требуется Map)\nУ аккаунта id: ${json['id']}');
    }
    if (json['passport'] != null && json['passport'] is! Map) {
      throw DataMismatchException(
          'Неверный формат паспортных данных ("${json['passport']}" - требуется Map)\nУ аккаунта id: ${json['id']}');
    }
    if (json['legal_address'] != null && json['legal_address'] is! Map) {
      throw DataMismatchException(
          'Неверный формат юридического адреса ("${json['legal_address']}" - требуется Map)\nУ аккаунта id: ${json['id']}');
    }
    if (json['created_at'] != null &&
        json['created_at'] is! String &&
        json['created_at'] is! DateTime) {
      throw DataMismatchException(
          'Неверный формат даты создания("${json['created_at']}" - требуется String или DateTime)\nУ аккаунта id: ${json['id']}');
    }
    if (json['updated_at'] != null &&
        json['updated_at'] is! String &&
        json['updated_at'] is! DateTime) {
      throw DataMismatchException(
          'Неверный формат даты обновления ("${json['updated_at']}" - требуется String или DateTime)\nУ аккаунта id: ${json['id']}');
    }

    Passport _passport;
    DadataAddress _legalAddress;
    BankDetails _bankDetails;
    AccountType _type;
    Contract _contract;

    try {
      _passport = Passport.fromJson(json['passport']);
      _legalAddress = DadataAddress.fromJson(json['legal_address']);
      _bankDetails = BankDetails.fromJson(json['bank_details']);
      _type = AccountType(json['type']);
      _contract = Contract.fromJson(json['contract']);
    } catch (e) {
      throw DataMismatchException(e is Error
          ? e.toString()
          : e.message + '\nУ аккаунта id: ${json['id']}');
    }

    return Account(
        id: AccountId(json['id']),
        email: json['email'],
        phone: Phone(json['phone']),
        lastName: json['lastname'],
        firstName: json['firstname'],
        patronymic: json['patronymic'],
        name: json['name'],
        type: _type,
        bankDetails: _bankDetails,
        passport: _passport,
        snils: json['snils'],
        inn: json['inn'],
        ogrn: json['ogrn'],
        legalAddress: _legalAddress,
        contract: _contract,
        createdAt: toLocalDateTime(json['created_at']),
        updatedAt: toLocalDateTime(json['updated_at']));
  }

  @override
  bool operator ==(other) {
    if (other is Account) {
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
      'name': name,
      'email': email,
      'phone': phone?.json,
      'lastname': lastName,
      'firstname': firstName,
      'patronymic': patronymic,
      'type': type?.json,
      'snils': snils,
      'inn': inn,
      'ogrn': ogrn,
      'passport': passport?.json,
      'legal_address': legalAddress?.json,
      'bank_details': bankDetails?.json,
      'contract': contract?.json,
      'created_at': createdAt?.toUtc(),
      'updated_at': updatedAt?.toUtc()
    }..removeWhere((key, value) => value == null);

    if (json.keys.length == 1 && json.keys.first == 'id') return json['id'];

    return json;
  }
}

/// Идентификатор аккаунта организации
class AccountId extends ObjectId {
  AccountId._(dynamic id) : super(id);
  factory AccountId(id) {
    if (id == null) return null;
    return AccountId._(id);
  }
}

/// Тип аккаунта
///
/// возможный тип аккаунта:
/// * physicalEntity - физическое лицо
/// * selfEmployed - индивидуальный предприниматель
/// * legalEntity - юридическое лицо
class AccountType implements JsonEncodable {
  /// Физическое лицо
  static const AccountType physicalEntity = AccountType._('физлицо');

  /// Индивидуальный предприниматель
  static const AccountType selfEmployed = AccountType._('ИП');

  /// Юридическое лицо
  static const AccountType legalEntity = AccountType._('юрлицо');

  final String _type;

  // Создает тип аккаунта
  const AccountType._(String type) : _type = type;

  factory AccountType(String type) {
    if (type == null) return null;
    AccountType _curType = AccountType._(type);
    if (values.contains(_curType)) {
      return _curType;
    } else {
      throw ArgumentError('Invalid account type: ${type}.');
    }
  }

  String get value => _type;
  static List get values => [physicalEntity, legalEntity, selfEmployed];

  static const _typeStr = <String, String>{
    'физлицо': 'Физическое лицо',
    'ИП': 'Индивидуальный предприниматель',
    'юрлицо': 'Юридическое лицо',
  };

  @override
  bool operator ==(dynamic other) {
    if (other is AccountType) {
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
