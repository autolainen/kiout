import 'package:data_model/data_model.dart';

/// Телефонный номер
///
/// Реализована поддержка форматирования номера
class Phone implements JsonEncodable {
  String _phone;
  final validationRegExp = RegExp(
      r'^\+?([7])+[\s-]?[(]?([0-9]{3})[)]?[\s-]?([0-9]{3})[\s-]?([0-9]{2})[\s-]?([0-9]{2})$');

  /// Создает экземпляр телефонного номера
  Phone(String phone) {
    if (phone == null) return;
    _phone = phone;
    var match = validationRegExp.firstMatch(phone);
    if (match == null || match.group(0) != phone) {
      _phone = phone;
      return;
    }
    _phone = '';
    for (int i = 1; i <= match.groupCount; i++) {
      _phone += match.group(i);
    }
    if (_phone.startsWith('8')) {
      _phone = _phone.replaceFirst('8', '7');
    }
  }

  /// Строка, содержащая цифры телефонного номера
  String get phone => _phone;

  /// Возвращает `true`, если номер телефона имеет допустимый формат
  bool get isValid => validationRegExp.hasMatch(phone ?? '');

  String get json => _phone;

  /// Форматирует номер телефона по шаблону [pattern]
  ///
  /// Шаблон представляет собой строку в которой цифры номера телефона заменены на символ `#`.
  /// Например, `'+# (###) ###-##-##'`. Если номер телефона не допустимый, то всегда возвращается '-'.
  /// Возвращает [replaceInvalid] при неверном формате телефона
  String format(String pattern, {String replaceInvalid = '-'}) {
    if (isValid) {
      int i = 0;
      return pattern.splitMapJoin(RegExp(r'#'),
          onMatch: (m) => phone.substring(i++, i));
    }
    return replaceInvalid;
  }

  @override
  bool operator ==(other) {
    if (other is Phone) {
      return other._phone == _phone;
    }
    return false;
  }

  @override
  int get hashCode => _phone.hashCode;

  @override
  String toString() => format('+# (###) ###-##-##');
}
