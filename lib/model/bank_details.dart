import 'package:data_model/data_model.dart';
import 'package:equatable/equatable.dart';

import 'exceptions/data_mismatch_exception.dart';

/// Банковские данные
class BankDetails with EquatableMixin implements JsonEncodable {
  /// Название
  String bank;

  /// Рассчетный счет
  String checkingAccount;

  /// Корреспондентский счет
  String correspondentAccount;

  /// БИК
  String bik;

  BankDetails(
      {this.bank, this.checkingAccount, this.correspondentAccount, this.bik});

  factory BankDetails.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    if (json['bank'] != null && json['bank'] is! String) {
      throw DataMismatchException(
          'Неверный формат названия ("${json['type']}" - требуется String)\nВ банковских данных.');
    }
    if (json['checking_account'] != null &&
        json['checking_account'] is! String) {
      throw DataMismatchException(
          'Неверный формат рассчетного счета ("${json['checking_account']}" - требуется String)\nВ банковских данных.');
    }
    if (json['correspondent_account'] != null &&
        json['correspondent_account'] is! String) {
      throw DataMismatchException(
          'Неверный формат корреспондентского счета ("${json['correspondent_account']}" - требуется String)\nВ банковских данных.');
    }
    if (json['bik'] != null && json['bik'] is! String) {
      throw DataMismatchException(
          'Неверный формат БИК ("${json['bik']}" - требуется String)\nВ банковских данных.');
    }

    return BankDetails(
        bank: json['bank'],
        checkingAccount: json['checking_account'],
        correspondentAccount: json['correspondent_account'],
        bik: json['bik']);
  }

  factory BankDetails.fromDadata(Map<String, dynamic> ddJson) {
    if (ddJson == null) return null;
    return BankDetails(
        bank: ddJson['name']['payment'],
        correspondentAccount: ddJson['correspondent_account'],
        bik: ddJson['bic']);
  }

  /// Возвращает данные адреса в JSON-формате ([Map])
  @override
  Map<String, dynamic> get json => {
        'bank': bank,
        'checking_account': checkingAccount,
        'correspondent_account': correspondentAccount,
        'bik': bik
      }..removeWhere((key, value) => value == null);

  @override
  List<Object> get props => [bank, checkingAccount, correspondentAccount, bik];
}
