import 'package:data_model/data_model.dart';

import 'exceptions/data_mismatch_exception.dart';
import 'user/user_group.dart';

/// Комиссия
class Fee implements JsonEncodable {
  /// Размер комиссии
  num value;

  /// Группы внешнего агента
  UserGroupId referrerGroupId;

  /// Создает комиссию
  Fee({this.value, this.referrerGroupId});

  /// Создает комиссию из JSON-данных
  factory Fee.fromJson(Map<String, num> json) {
    if (json == null) return null;

    if (json.length != 1) {
      throw DataMismatchException(
          'Неверный формат комиссии ("${json}" - требуется Map<String, num> с одним значением)}');
    }
    String _referrerGroupId = json.keys.first;
    if (json[_referrerGroupId] == null || json[_referrerGroupId] is! num) {
      throw DataMismatchException(
          'Неверный формат комиссии ("${json}" - требуется Map<String, num> с одним непустым значением)}');
    }

    return Fee(
      referrerGroupId: UserGroupId(_referrerGroupId),
      value: json[_referrerGroupId],
    );
  }

  /// Возвращает данные комиссии в JSON-формате ([Map])
  @override
  Map<String, dynamic> get json => {referrerGroupId.json: value};

  @override
  String toString() => json.toString();
}
