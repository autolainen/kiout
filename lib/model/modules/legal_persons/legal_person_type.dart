import 'package:data_model/data_model.dart';

/// Тип юридического лица
class LegalPersonType implements JsonEncodable {
  /// Подрядчик
  static const contractor = LegalPersonType._('подрядчик');

  /// Агент
  static const agent = LegalPersonType._('агент');

  /// Клиент
  static const client = LegalPersonType._('клиент');

  /// Поставщик
  static const supplier = LegalPersonType._('поставщик');

  static const values = [contractor, agent, client, supplier];

  final String _type;

  const LegalPersonType._(this._type);

  factory LegalPersonType(String type) =>
      values.firstWhere((v) => v._type == type, orElse: () => null);

  @override
  String get json => _type;

  @override
  String toString() => _type.substring(0, 1).toUpperCase() + _type.substring(1);
}
