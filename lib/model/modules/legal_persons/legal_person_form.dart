import 'package:data_model/data_model.dart';

/// Форма юридического лица
class LegalPersonForm implements JsonEncodable {
  static const ooo = LegalPersonForm._('ООО');
  static const odo = LegalPersonForm._('ОДО');
  static const ao = LegalPersonForm._('АО');
  static const dzo = LegalPersonForm._('ДЗО');
  static const pt = LegalPersonForm._('ПТ');
  static const tv = LegalPersonForm._('ТВ');
  static const pk = LegalPersonForm._('ПК');
  static const gmup = LegalPersonForm._('ГМУП');
  static const nko = LegalPersonForm._('НКО');
  static const ip = LegalPersonForm._('ИП');

  static const values = [ooo, odo, ao, dzo, pt, tv, pk, gmup, nko, ip];

  final String _form;
  const LegalPersonForm._(this._form);

  factory LegalPersonForm(String form) =>
      values.firstWhere((v) => v._form == form, orElse: () => null);

  @override
  String get json => _form;

  @override
  String toString() => _form;
}
