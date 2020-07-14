import 'package:kiouttest/model/services/capitalize_first_letter.dart';
import 'package:data_model/data_model.dart';

/// Образование
///
/// возможные виды образования:
///
/// * primary - Начальное
/// * secondary - Среднее
/// * incompleteHigher - Неполное высшее
/// * higher - Высшее
/// * unknown - Неизвестно
class Education implements JsonEncodable {
  /// Начальное
  static const Education primary = Education._('начальное');

  /// Среднее
  static const Education secondary = Education._('среднее');

  /// Неполное высшее
  static const Education incompleteHigher = Education._('неполное высшее');

  /// Высшее
  static const Education higher = Education._('высшее');

  /// Неизвестно
  static const Education unknown = Education._('неизвестно');

  final String _type;

  // Создает вид образования
  const Education._(String type) : _type = type;

  factory Education(String type) {
    if (type == null) return null;
    Education _curType = Education._(type);
    if (values.contains(_curType)) {
      return _curType;
    } else {
      throw ArgumentError('Unknown education type: $type.');
    }
  }

  String get value => _type;
  static List get values =>
      [primary, secondary, incompleteHigher, higher, unknown];

  @override
  bool operator ==(dynamic other) {
    if (other is Education) {
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
