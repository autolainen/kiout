import 'package:data_model/data_model.dart';

import 'exceptions/data_mismatch_exception.dart';
import 'person.dart';
import 'phone.dart';

/// Представитель
class Representative extends Person implements JsonEncodable {
  /// Телефон
  final Phone phone;

  /// Адрес электронной почты
  final String email;

  Representative(
      {this.phone, this.email, lastName, String firstName, String patronymic})
      : super(lastName: lastName, firstName: firstName, patronymic: patronymic);

  factory Representative.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    if (json['phone'] != null && json['phone'] is! String ||
        json['phone'] == '') {
      throw DataMismatchException(
          'Неверный формат номера телефона ("${json['phone']}" - требуется не пустой String)\nУ представителя');
    }
    if (json['email'] != null && json['email'] is! String) {
      throw DataMismatchException(
          'Неверный формат электронной почты ("${json['email']}" - требуется не пустой String)\nУ представителя');
    }
    if (json['lastname'] != null && json['lastname'] is! String ||
        json['lastname'] == '') {
      throw DataMismatchException(
          'Неверный формат фамилии ("${json['lastname']}" - требуется не пустой String)\nУ представителя');
    }
    if (json['firstname'] != null && json['firstname'] is! String ||
        json['firstname'] == '') {
      throw DataMismatchException(
          'Неверный формат имени ("${json['firstname']}" - требуется не пустой String)\nУ представителя');
    }
    if (json['patronymic'] != null && json['patronymic'] is! String) {
      throw DataMismatchException(
          'Неверный формат отчества ("${json['patronymic']}" - требуется String)\nУ представителя');
    }

    return Representative(
        phone: Phone(json['phone']),
        email: json['email'],
        lastName: json['lastname'],
        firstName: json['firstname'],
        patronymic: json['patronymic']);
  }

  @override
  Map<String, dynamic> get json => Map.from(super.json)
    ..addAll({
      'phone': phone?.json,
      'email': email,
    })
    ..removeWhere((key, value) => value == null);
}
