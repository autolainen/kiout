import 'package:data_model/data_model.dart';

import 'dadata_address.dart';
import 'datetime/to_local_date_time.dart';
import 'death_certificate.dart';
import 'education.dart';
import 'employment.dart';
import 'exceptions/data_mismatch_exception.dart';
import 'marital_status.dart';
import 'passport.dart';
import 'person.dart';
import 'place_of_death.dart';

/// Усопший
class Deceased extends Person implements JsonEncodable {
  /// Дата смерти
  DateTime deathDate;

  /// Дата рождения
  DateTime birthDate;

  /// Пол
  Sex sex;

  /// Семейное положение
  MaritalStatus maritalStatus;

  /// Образование
  Education education;

  /// Занятость
  Employment employment;

  /// Паспортные данные
  Passport passport;

  /// Адрес регистрации
  DadataAddress registrationAddress;

  /// Свидетельство о смерти
  DeathCertificate certificate;

  /// Место смерти
  PlaceOfDeath placeOfDeath;

  /// Место захоронения/кремации
  String placeOfBurialOrCremation;

  /// Адрес получения медицинского свидетельства о смерти
  DadataAddress certificateIssueAddress;

  Deceased(
      {DateTime deathDate,
      DateTime birthDate,
      String lastName,
      String firstName,
      String patronymic,
      this.passport,
      this.sex,
      this.registrationAddress,
      this.certificate,
      this.education,
      this.employment,
      this.maritalStatus,
      this.placeOfDeath,
      this.placeOfBurialOrCremation,
      this.certificateIssueAddress})
      : this.deathDate = deathDate?.toLocal(),
        this.birthDate = birthDate?.toLocal(),
        super(lastName: lastName, firstName: firstName, patronymic: patronymic);

  factory Deceased.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    if (json['lastname'] != null && json['lastname'] is! String ||
        json['lastname'] == '') {
      throw DataMismatchException(
          'Неверный формат фамилии ("${json['lastname']}" - требуется не пустой String)\nУ усопшего');
    }
    if (json['firstname'] != null && json['firstname'] is! String ||
        json['firstname'] == '') {
      throw DataMismatchException(
          'Неверный формат имени ("${json['firstname']}" - требуется не пустой String)\nУ усопшего');
    }
    if (json['patronymic'] != null && json['patronymic'] is! String) {
      throw DataMismatchException(
          'Неверный формат отчества ("${json['patronymic']}" - требуется String)\nУ усопшего');
    }

    if (json['registration_address'] != null &&
        json['registration_address'] is! Map) {
      throw DataMismatchException(
          'Неверный формат адреса регистрации ("${json['registration_address']}" - требуется Map)\nУ усопшего');
    }
    if (json['place_of_death'] != null && json['place_of_death'] is! String) {
      throw DataMismatchException(
          'Неверный формат места смерти ("${json['place_of_death']}" - требуется String)\nУ усопшего');
    }
    if (json['place_of_burial_or_cremation'] != null &&
        json['place_of_burial_or_cremation'] is! String) {
      throw DataMismatchException(
          'Неверный формат места захоронения/кремации ("${json['place_of_burial_or_cremation']}" - требуется String)\nУ усопшего');
    }
    if (json['certificate_issue_address'] != null &&
        json['certificate_issue_address'] is! Map) {
      throw DataMismatchException(
          'Неверный формат адреса получения медицинского свидетельства о смерти ("${json['certificate_issue_address']}" - требуется Map)\nУ усопшего');
    }

    if (json['sex'] != null && json['sex'] is! String) {
      throw DataMismatchException(
          'Неверный формат пола ("${json['sex']}" - требуется String)\nУ усопшего');
    }

    if (json['certificate'] != null && json['certificate'] is! Map) {
      throw DataMismatchException(
          'Неверный формат пола ("${json['certificate']}" - требуется Map)\nУ усопшего');
    }

    if (json['passport'] != null && json['passport'] is! Map) {
      throw DataMismatchException(
          'Неверный формат паспорта ("${json['passport']}" - требуется Map)\nУ усопшего');
    }

    if (json['death_date'] != null &&
        json['death_date'] is! DateTime &&
        json['death_date'] is! String) {
      throw DataMismatchException(
          'Неверный формат даты смерти ("${json['death_date']}" - требуется DateTime или String)\nУ усопшего');
    }
    if (json['birth_date'] != null &&
        json['birth_date'] is! DateTime &&
        json['birth_date'] is! String) {
      throw DataMismatchException(
          'Неверный формат даты рождения ("${json['birth_date']}" - требуется DateTime или String)\nУ усопшего');
    }

    if (json['education'] != null && json['education'] is! String) {
      throw DataMismatchException(
          'Неверный формат образования ("${json['education']}" - требуется String)\nУ усопшего');
    }

    if (json['employment'] != null && json['employment'] is! String) {
      throw DataMismatchException(
          'Неверный формат занятости ("${json['employment']}" - требуется String)\nУ усопшего');
    }

    if (json['marital_status'] != null && json['marital_status'] is! String) {
      throw DataMismatchException(
          'Неверный формат семейного положения ("${json['marital_status']}" - требуется String)\nУ усопшего');
    }

    Passport _passport;
    DadataAddress _certificateIssueAddress;
    DadataAddress _registrationAddress;
    PlaceOfDeath _placeOfDeath;
    DeathCertificate _certificate;
    MaritalStatus _maritalStatus;
    Employment _employment;
    Education _education;
    Sex _sex;

    try {
      _passport = Passport.fromJson(json['passport']);
      _certificate = DeathCertificate.fromJson(json['certificate']);
      _registrationAddress =
          DadataAddress.fromJson(json['registration_address']);
      _certificateIssueAddress =
          DadataAddress.fromJson(json['certificate_issue_address']);
      _sex = Sex(json['sex']);
      _maritalStatus = MaritalStatus(json['marital_status']);
      _employment = Employment(json['employment']);
      _education = Education(json['education']);
      _placeOfDeath = PlaceOfDeath(json['place_of_death']);
    } catch (e) {
      throw DataMismatchException(e is Error
          ? e.toString()
          : e.message +
              '\nУ усопшего (${json['firstname']} ${json['lastname']} ${json['patronymic']})');
    }

    return Deceased(
        lastName: json['lastname'],
        firstName: json['firstname'],
        patronymic: json['patronymic'],
        placeOfBurialOrCremation: json['place_of_burial_or_cremation'],
        placeOfDeath: _placeOfDeath,
        sex: _sex,
        maritalStatus: _maritalStatus,
        education: _education,
        employment: _employment,
        passport: _passport,
        certificate: _certificate,
        registrationAddress: _registrationAddress,
        certificateIssueAddress: _certificateIssueAddress,
        deathDate: toLocalDateTime(json['death_date']),
        birthDate: toLocalDateTime(json['birth_date']));
  }

  @override
  Map<String, dynamic> get json => Map.from(super.json)
    ..addAll({
      'death_date': deathDate?.toUtc(),
      'birth_date': birthDate?.toUtc(),
      'passport': passport?.json,
      'sex': sex?.json,
      'education': education?.json,
      'employment': employment?.json,
      'marital_status': maritalStatus?.json,
      'certificate': certificate?.json,
      'registration_address': registrationAddress?.json,
      'certificate_issue_address': certificateIssueAddress?.json,
      'place_of_burial_or_cremation': placeOfBurialOrCremation,
      'place_of_death': placeOfDeath?.json
    })
    ..removeWhere((key, value) => value == null);
}
