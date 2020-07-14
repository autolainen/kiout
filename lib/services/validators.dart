import 'package:kiouttest/model/phone.dart';
import 'package:kiouttest/services/helpers.dart';
import 'package:quiver/strings.dart';
import 'package:validate/validate.dart';

const incorrectValue = 'Ошибка ввода';
const fieldIsRequiredMsg = 'Поле обязательно для заполнения';

/// Проверяет правильность URI
String isValidUri(String value) {
  try {
    Validate.matchesPattern(
        value,
        RegExp(
            '^https?:\/\/(?:[a-z-]{1,63}(?:\.[a-z-]{1,63})*|(?:[0-9]{1,3}(?:\.[0-9]{1,3}){3}))(?::[0-9]{2,5})?\$'),
        'Неверный формат');
  } on ArgumentError catch (e) {
    return e.toString();
  }
  return null;
}

/// Проверяет правильность email
String isValidEmail(String value) {
  if (isNotEmpty(value)) {
    try {
      Validate.isEmail(value, 'Неверный формат');
    } on ArgumentError catch (e) {
      return e.message.toString();
    }
  }
  return null;
}

String isNotNull(Object value) {
  return value == null ? fieldIsRequiredMsg : null;
}

String isNotBlankField(String value) {
  try {
    Validate.notBlank(value);
  } on ArgumentError {
    return fieldIsRequiredMsg;
  }
  return null;
}

/// Проверяет допустимость имени/фамилии/отчества
///
/// Не допускается null, пустая строка, строка из пробелов
String isNotBlankAndValidName(String value) {
  return isNotBlankField(value) ?? isValidName(value);
}

/// Проверяет допустимость имени/фамилии/отчества
///
/// Допускается null, пустая строка, строка из пробелов и
/// пробелы в начале и в конце строки.
/// Имя должно начинаться с заглавной буквы, может содержать несколько слов,
/// разделенных одним пробелом или дефисом.
/// Каждое слово должно начинаться с заглавной буквы,
/// остальные буквы должны быть строчными.
/// Минимально допустимая длина каждого слова - 2 символа.
String isValidName(String value) {
  String result;
  final trimmedValue = value?.trim();
  if (isNotEmpty(trimmedValue)) {
    try {
      Validate.matchesPattern(trimmedValue,
          RegExp(r'^\p{Lu}\p{Ll}+([\s-]\p{Lu}\p{Ll}+)*$', unicode: true));
    } on ArgumentError {
      result = incorrectValue;
    }
  }
  return result;
}

String isNotBlankAndValidPhone(Phone phone, [bool forbidAgentPhone = true]) {
  if (phone == null) {
    return fieldIsRequiredMsg;
  }
  if (!phone.isValid) {
    return incorrectValue;
  }
/*
  if (forbidAgentPhone && common.service<Settings>().phone == phone) {
    return 'Укажите номер заказчика, а не агента';
  }
*/
  return null;
}

String isDateInFuture(DateTime date) {
  String result;
  if (date != null) {
    result = resetTimeToMidnight(DateTime.now()).isBefore(date)
        ? 'Выбрана дата в будущем'
        : null;
  }
  return result;
}

String isDateTooFarInFuture(DateTime date, Duration duration) {
  String result;
  if (date != null) {
    result = resetTimeToMidnight(DateTime.now()).add(duration).isBefore(date)
        ? 'Некорректная дата'
        : null;
  }
  return result;
}

String isDateInPast(DateTime date) {
  String result;
  if (date != null) {
    result = resetTimeToMidnight(DateTime.now()).isAfter(date)
        ? 'Выбрана дата в прошлом'
        : null;
  }
  return result;
}
