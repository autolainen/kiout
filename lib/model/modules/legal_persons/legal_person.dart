import 'package:aahitest/model/modules/legal_persons/legal_person_status.dart';
import 'package:data_model/data_model.dart';
import 'package:equatable/equatable.dart';

import '../../bank_details.dart';
import '../../datetime/to_local_date_time.dart';
import '../../detailed_address.dart';
import '../../phone.dart';
import 'legal_person_form.dart';
import 'legal_person_type.dart';

/// Юридическое лицо
class LegalPerson extends Model<LegalPersonId> with EquatableMixin {
  /// Идентификатор
  LegalPersonId id;

  /// Краткое название
  String shortName;

  /// Полное название
  String fullName;

  /// Номер договора
  String contractNo;

  /// Дата заключения договора
  DateTime conclusionDate;

  /// Тип юридического лица
  LegalPersonType type;

  /// Форма юридического лица
  LegalPersonForm form;

  /// ФИО контактного лица
  String contactPerson;

  /// Контактный телефон
  Phone contactPhone;

  /// Контактный email
  String contactEmail;

  /// Юридический адрес
  DetailedAddress legalAddress;

  /// Юридический телефон организации
  Phone phone;

  /// Фактический адрес
  DetailedAddress actualAddress;

  /// Банковские реквизиты
  BankDetails bankDetails;

  /// ИНН
  String inn;

  /// КПП
  String kpp;

  /// ОГРН
  String ogrn;

  /// Генеральный директор (ФИО)
  String director;

  /// Статус карточки ЮЛ
  LegalPersonStatus status;

  /// Дата/время создания карточки
  DateTime createdAt;

  /// Дата/время последнего изменения
  DateTime updatedAt;

  LegalPerson({
    this.id,
    this.shortName,
    this.fullName,
    this.contractNo,
    this.conclusionDate,
    this.type,
    this.form,
    this.contactPerson,
    this.contactPhone,
    this.contactEmail,
    this.legalAddress,
    this.actualAddress,
    this.phone,
    this.bankDetails,
    this.inn,
    this.kpp,
    this.ogrn,
    this.director,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory LegalPerson.fromJson(json) {
    if (json == null) return null;
    if (json is String) {
      return LegalPerson(id: LegalPersonId(json));
    } else if (json is Map) {
      return LegalPerson(
        id: LegalPersonId(json['id']),
        shortName: json['short_name'],
        fullName: json['full_name'],
        contractNo: json['contract_no'],
        conclusionDate: toLocalDateTime(json['conclusion_date']),
        type: LegalPersonType(json['type']),
        form: LegalPersonForm(json['form']),
        contactPerson: json['contact_person'],
        contactPhone: Phone(json['contact_phone']),
        contactEmail: json['contact_email'],
        legalAddress: DetailedAddress.fromJson(json['legal_address']),
        actualAddress: DetailedAddress.fromJson(json['actual_address']),
        phone: Phone(json['phone']),
        bankDetails: BankDetails.fromJson(json['bank_details']),
        inn: json['inn'],
        kpp: json['kpp'],
        ogrn: json['ogrn'],
        director: json['director'],
        status: LegalPersonStatus(json['status']),
        createdAt: toLocalDateTime(json['created_at']),
        updatedAt: toLocalDateTime(json['updated_at']),
      );
    }
    throw ArgumentError.value(json, 'json',
        'Invalud json format while creating LegalPerson.from(json)');
  }

  factory LegalPerson.fromDadata(Map<String, dynamic> ddJson) {
    if (ddJson == null) return null;
    Map<String, dynamic> management = ddJson['management'];
    Map<String, dynamic> name = ddJson['name'];
    Map<String, dynamic> opf = ddJson['opf'];
    Map<String, dynamic> address = ddJson['address'];
    return LegalPerson(
      director: management != null ? management['name'] : null,
      shortName: name != null ? name['short_with_opf'] : null,
      fullName: name != null ? name['full_with_opf'] : null,
      form: LegalPersonForm(opf != null ? opf['short'] : null),
      legalAddress:
          DetailedAddress.fromJson(address != null ? address['data'] : null),
      inn: ddJson['inn'],
      kpp: ddJson['kpp'],
      ogrn: ddJson['ogrn'],
    );
  }

  @override
  get json {
    final result = {
      'id': id?.json,
      'short_name': shortName,
      'full_name': fullName,
      'contract_no': contractNo,
      'conclusion_date': conclusionDate?.toUtc(),
      'type': type?.json,
      'form': form?.json,
      'contact_person': contactPerson,
      'contact_phone': contactPhone?.json,
      'contact_email': contactEmail,
      'legal_address': legalAddress?.json,
      'actual_address': actualAddress?.json,
      'phone': phone?.json,
      'bank_details': bankDetails?.json,
      'inn': inn,
      'kpp': kpp,
      'ogrn': ogrn,
      'director': director,
      'status': status?.json,
      'created_at': createdAt?.toUtc(),
      'updated_at': updatedAt?.toUtc(),
    }..removeWhere((k, v) => v == null);
    if (result.length == 1 && result.keys.single == 'id') return result['id'];
    return result;
  }

  @override
  List<Object> get props => [
        id,
        shortName,
        fullName,
        contractNo,
        conclusionDate,
        type,
        form,
        contactPerson,
        contactPhone,
        contactEmail,
        legalAddress,
        actualAddress,
        phone,
        bankDetails,
        inn,
        kpp,
        ogrn,
        director
      ];
}

/// Идентификатор юридического лица
class LegalPersonId extends ObjectId {
  LegalPersonId._(id) : super(id);
  factory LegalPersonId(id) {
    if (id == null) return null;
    return LegalPersonId._(id);
  }
}
