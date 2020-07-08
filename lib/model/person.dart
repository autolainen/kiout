import 'package:data_model/data_model.dart';

/// Класс реализующий обобщенные данные человека (Person)
class Person implements JsonEncodable {
  /// Фамилия
  String lastName;

  /// Имя
  String firstName;

  /// Отчество
  String patronymic;

  Person({this.lastName, this.firstName, this.patronymic});

  factory Person.fromJson(Map<String, String> json) {
    if (json == null) return null;
    return Person(
        lastName: json['lastname'],
        firstName: json['firstname'],
        patronymic: json['patronymic']);
  }

  dynamic get json => {
        'lastname': lastName,
        'firstname': firstName,
        'patronymic': patronymic
      }..removeWhere((key, value) => value == null);

  /// Возвращает полное имя (ФИО)
  String get fullName =>
      lastName == null && firstName == null && patronymic == null
          ? '-'
          : '${lastName ?? ''} ${firstName ?? ''} ${patronymic ?? ''}'.trim();

  /// Возвращает короткое имя (И.О. Фамилия)
  String get shortName => '${initials} ${lastName ?? ''}'.trim();

  /// Возвращает короткое имя в обратном порядке (Фамилия И.О.)
  String get reversedShortName => '${lastName ?? ''} ${initials}'.trim();

  /// Возвращает инициалы
  String get initials =>
      '${firstName?.isNotEmpty == true ? '${firstName.substring(0, 1)}.' : ''}${patronymic?.isNotEmpty == true ? '${patronymic.substring(0, 1)}.' : ''}';

  /// Возвращает форматированное имя
  String formattedName(String pattern) {
    return pattern.replaceAllMapped(RegExp(r'[fplFPL]'), (m) {
      switch (m.group(0)) {
        case 'f':
          return (firstName?.isEmpty ?? true) ? '' : firstName.substring(0, 1);
        case 'F':
          return firstName ?? '';
        case 'l':
          return (lastName?.isEmpty ?? true) ? '' : lastName.substring(0, 1);
        case 'L':
          return lastName ?? '';
        case 'p':
          return (patronymic?.isEmpty ?? true)
              ? ''
              : patronymic.substring(0, 1);
        case 'P':
          return patronymic ?? '';
        default:
          return '';
      }
    });
  }

  @override
  String toString() => fullName;
}

/// Пол пользователя
///
/// возможный пол:
/// * female - Женский
/// * male - Мужской
class Sex implements JsonEncodable {
  /// Женский
  static const Sex female = Sex._('female');

  /// Мужской
  static const Sex male = Sex._('male');

  final String _sex;

  // Создает пол пользователя
  const Sex._(String sex) : _sex = sex;

  factory Sex(String sex) {
    if (sex == null) return null;
    Sex _curSex = Sex._(sex);
    if (values.contains(_curSex)) {
      return _curSex;
    } else {
      throw ArgumentError('Invalid sex: ${sex}.');
    }
  }

  final Map<String, String> _sexStr = const {
    'female': 'Женский',
    'male': 'Мужской'
  };

  String get value => _sex;
  static List get values => [female, male];

  @override
  bool operator ==(dynamic other) {
    if (other is Sex) {
      return other._sex == _sex;
    }
    return false;
  }

  @override
  int get hashCode => _sex.hashCode;

  String get json => _sex;

  @override
  String toString() => _sexStr[_sex];
}
