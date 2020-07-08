import 'package:data_model/data_model.dart';

/// Статус карточки юридического лица
class LegalPersonStatus implements JsonEncodable {
  static const active = LegalPersonStatus._('active');
  static const archived = LegalPersonStatus._('archived');

  static const List<LegalPersonStatus> values = [active, archived];

  final String _status;
  const LegalPersonStatus._(this._status);

  factory LegalPersonStatus(String status) =>
      values.firstWhere((v) => v._status == status, orElse: () => null);

  @override
  String get json => _status;

  @override
  String toString() => _status;
}
