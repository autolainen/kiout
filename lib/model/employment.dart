import 'package:kiouttest/model/services/capitalize_first_letter.dart';
import 'package:data_model/data_model.dart';

/// Занятость
///
/// возможные виды занятости:
///
/// * unemployed - Безработные
/// * student - Студенты и учащиеся
/// * military - Занятые на военной службе
/// * qualified - Квалифицированные рабочие
/// * otherSpecialist - Прочие специалисты
/// * privateFarm - Работающие в личном подсобном хозяйстве
/// * topManager - Руководители и специалисты высшего уровня квалификации
/// * pensioner - Пенсионеры
/// * other - Прочие
class Employment implements JsonEncodable {
  /// Безработные
  static const Employment unemployed = Employment._('безработные');

  /// Студенты и учащиеся
  static const Employment student = Employment._('студенты и учащиеся');

  /// Занятые на военной службе
  static const Employment military = Employment._('занятые на военной службе');

  /// Квалифицированные рабочие
  static const Employment qualified = Employment._('квалифицированные рабочие');

  /// Прочие специалисты
  static const Employment otherSpecialist = Employment._('прочие специалисты');

  /// Работающие в личном подсобном хозяйстве
  static const Employment privateFarm =
      Employment._('работающие в личном подсобном хозяйстве');

  /// Руководители и специалисты высшего уровня квалификации
  static const Employment topManager =
      Employment._('руководители и специалисты высшего уровня квалификации');

  /// Пенсионеры
  static const Employment pensioner = Employment._('пенсионеры');

  /// Прочие
  static const Employment other = Employment._('прочие');

  final String _type;

  // Создает вид занятости
  const Employment._(String type) : _type = type;

  factory Employment(String type) {
    if (type == null) return null;
    Employment _curType = Employment._(type);
    if (values.contains(_curType)) {
      return _curType;
    } else {
      throw ArgumentError('Unknown employment type: $type.');
    }
  }

  String get value => _type;
  static List get values => [
        unemployed,
        student,
        military,
        qualified,
        otherSpecialist,
        privateFarm,
        topManager,
        pensioner,
        other
      ];

  @override
  bool operator ==(dynamic other) {
    if (other is Employment) {
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
