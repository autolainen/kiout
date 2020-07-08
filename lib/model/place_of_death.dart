import 'package:aahitest/model/services/capitalize_first_letter.dart';
import 'package:data_model/data_model.dart';

/// Место смерти
///
/// возможные виды мест смерти:
///
/// * hospital - В стационаре
/// * home - Дома
/// * other - В другом месте
class PlaceOfDeath implements JsonEncodable {
  /// В стационаре
  static const PlaceOfDeath hospital = PlaceOfDeath._('в стационаре');

  /// Дома
  static const PlaceOfDeath home = PlaceOfDeath._('дома');

  /// В другом месте
  static const PlaceOfDeath other = PlaceOfDeath._('в другом месте');

  final String _type;

  // Создает вид места смерти
  const PlaceOfDeath._(String type) : _type = type;

  factory PlaceOfDeath(String type) {
    if (type == null) return null;
    PlaceOfDeath _curType = PlaceOfDeath._(type);
    if (values.contains(_curType)) {
      return _curType;
    } else {
      throw ArgumentError('Unknown place of death type: $type.');
    }
  }

  String get value => _type;
  static List get values => [hospital, home, other];

  @override
  bool operator ==(dynamic other) {
    if (other is PlaceOfDeath) {
      return other._type == _type;
    }
    return false;
  }

  @override
  int get hashCode => _type.hashCode;

  String get json => _type;

  @override
  String toString() => capitalizeFirstLetter(_type);
}
