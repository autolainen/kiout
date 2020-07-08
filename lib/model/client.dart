import 'package:data_model/data_model.dart';

import 'dadata_address.dart';
import 'datetime/to_local_date_time.dart';
import 'exceptions/data_mismatch_exception.dart';
import 'passport.dart';
import 'person.dart';
import 'phone.dart';

/// Заказчик
class Client extends Person implements JsonEncodable {
  /// Номер
  final String no;

  /// Дата рождения
  final DateTime birthDate;

  /// Номер телефона
  final Phone phone;

  /// Адрес электронной почты
  final String email;

  /// Пол
  final Sex sex;

  /// Паспортные данные
  final Passport passport;

  /// Адрес регистрации
  final DadataAddress registrationAddress;

  /// Почтовый адрес
  final DadataAddress postAddress;

  Client(
      {this.no,
      DateTime birthDate,
      this.phone,
      this.email,
      this.sex,
      this.passport,
      this.registrationAddress,
      this.postAddress,
      String lastName,
      String firstName,
      String patronymic})
      : this.birthDate = birthDate?.toLocal(),
        super(lastName: lastName, firstName: firstName, patronymic: patronymic);

  factory Client.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    if (json['no'] != null && json['no'] is! String || json['no'] == '') {
      throw DataMismatchException(
          'Неверный формат номера ("${json['no']}" - требуется не пустой String)\nУ клиента');
    }

    if (json['birth_date'] != null &&
        json['birth_date'] is! DateTime &&
        json['birth_date'] is! String) {
      throw DataMismatchException(
          'Неверный формат даты рождения ("${json['birth_date']}" - требуется DateTime или String)\nУ клиента');
    }

    if (json['phone'] != null && json['phone'] is! String ||
        json['phone'] == '') {
      throw DataMismatchException(
          'Неверный формат номера телефона ("${json['phone']}" - требуется не пустой String)\nУ клиента');
    }

    if (json['email'] != null && json['email'] is! String) {
      throw DataMismatchException(
          'Неверный формат электронной почты ("${json['email']}" - требуется не пустой String)\nУ клиента');
    }

    if (json['identity'] != null && json['identity'] is! Map) {
      throw DataMismatchException(
          'Неверный формат паспорта ("${json['identity']}" - требуется Map)\nУ клиента');
    }

    if (json['registrationAddress'] != null &&
        json['registrationAddress'] is! Map) {
      throw DataMismatchException(
          'Неверный формат адреса регистрации ("${json['registrationAddress']}" - требуется Map)\nУ клиента');
    }

    if (json['sex'] != null && json['sex'] is! String) {
      throw DataMismatchException(
          'Неверный формат пола ("${json['registratiosexnAddress']}" - требуется String)\nУ клиента');
    }

    if (json['postAddress'] != null && json['postAddress'] is! Map) {
      throw DataMismatchException(
          'Неверный формат почтового адреса ("${json['postAddress']}" - требуется Map)\nУ клиента');
    }

    if (json['lastname'] != null && json['lastname'] is! String ||
        json['lastname'] == '') {
      throw DataMismatchException(
          'Неверный формат фамилии ("${json['lastname']}" - требуется не пустой String)\nУ клиента');
    }
    if (json['firstname'] != null && json['firstname'] is! String ||
        json['firstname'] == '') {
      throw DataMismatchException(
          'Неверный формат имени ("${json['firstname']}" - требуется не пустой String)\nУ клиента');
    }
    if (json['patronymic'] != null && json['patronymic'] is! String) {
      throw DataMismatchException(
          'Неверный формат отчества ("${json['patronymic']}" - требуется String)\nУ клиента');
    }

    Passport _passport;
    DadataAddress _registrationAddress;
    DadataAddress _postAddress;
    Sex _sex;

    try {
      _passport = Passport.fromJson(json['identity']);
      _registrationAddress =
          DadataAddress.fromJson(json['registration_address']);
      _postAddress = DadataAddress.fromJson(json['post_address']);
      _sex = Sex(json['sex']);
    } catch (e) {
      throw DataMismatchException(e is Error
          ? e.toString()
          : e.message + '\nУ клиента no: ${json['no']}');
    }

    return Client(
        no: json['no'],
        phone: Phone(json['phone']),
        email: json['email'],
        lastName: json['lastname'],
        firstName: json['firstname'],
        patronymic: json['patronymic'],
        passport: _passport,
        registrationAddress: _registrationAddress,
        postAddress: _postAddress,
        sex: _sex,
        birthDate: toLocalDateTime(json['birth_date']));
  }

  @override
  Map<String, dynamic> get json => Map.from(super.json)
    ..addAll({
      'no': no,
      'birth_date': birthDate?.toUtc(),
      'phone': phone?.json,
      'email': email,
      'sex': sex?.json,
      'identity': passport?.json,
      'registration_address': registrationAddress?.json,
      'post_address': postAddress?.json
    })
    ..removeWhere((key, value) => value == null);
}
