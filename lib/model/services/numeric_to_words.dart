import 'dart:core';
import 'package:dartz/dartz.dart' show Tuple3;

/// Грамматический род
enum Gender { male, female, neuter }

/// Называет одну цифру (числа перого десятка)
///
/// [digit] - число первого десятка: 1 - 9.
/// [gender] - род числительного
String sayDigits(int digit, {Gender gender = Gender.male}) {
  switch (digit) {
    case 1:
      switch (gender) {
        case Gender.male:
          return 'один';
        case Gender.female:
          return 'одна';
        case Gender.neuter:
          return 'одно';
      }
      break;
    case 2:
      switch (gender) {
        case Gender.male:
        case Gender.neuter:
          return 'два';
        case Gender.female:
          return 'две';
      }
      break;
    case 3:
      return 'три';
    case 4:
      return 'четыре';
    case 5:
      return 'пять';
    case 6:
      return 'шесть';
    case 7:
      return 'семь';
    case 8:
      return 'восемь';
    case 9:
      return 'девять';
  }
  return '';
}

/// Называет числа второго десятка
///
/// [digit] принимает значение от 0 до 9.
String sayTeens(int digit) {
  switch (digit) {
    case 0:
      return 'десять';
    case 1:
      return 'одиннадцать';
    case 2:
      return 'двенадцать';
    case 3:
      return 'тринадцать';
    case 4:
      return 'четырнадцать';
    case 5:
      return 'пятнадцать';
    case 6:
      return 'шестнадцать';
    case 7:
      return 'семнадцать';
    case 8:
      return 'восемнадцать';
    case 9:
      return 'девятнадцать';
    default:
      return '';
  }
}

/// Называет десятки
///
/// [digit] принимает значения от 2 до 9.
String sayTens(int digit) {
  switch (digit) {
    case 2:
      return 'двадцать';
    case 3:
      return 'тридцать';
    case 4:
      return 'сорок';
    case 5:
      return 'пятьдесят';
    case 6:
      return 'шестьдесят';
    case 7:
      return 'семьдесят';
    case 8:
      return 'восемьдесят';
    case 9:
      return 'девяносто';
    default:
      return '';
  }
}

/// Называет сотни
///
/// [digit] принимает значения от 1 до 9.
String sayHundreds(int digit) {
  switch (digit) {
    case 1:
      return 'сто';
    case 2:
      return 'двести';
    case 3:
      return 'триста';
    case 4:
      return 'четыреста';
    case 5:
      return 'пятьсот';
    case 6:
      return 'шестьсот';
    case 7:
      return 'семьсот';
    case 8:
      return 'восемьсот';
    case 9:
      return 'девятьсот';
    default:
      return '';
  }
}

/// Называет трехзначное число (класс единиц)
///
/// Соответсвует словесному представлению класса единиц
/// - [digits] - кортеж из 3-х цифр класса числа.
/// - [gender] - род числительного
String sayOnes(Tuple3 digits, {Gender gender = Gender.male}) {
  if (digits.value2 == 1) {
    return [sayHundreds(digits.value1), sayTeens(digits.value3)].join(' ');
  }
  return [
    sayHundreds(digits.value1),
    sayTens(digits.value2),
    sayDigits(digits.value3, gender: gender)
  ].join(' ');
}

/// Называет класс тысяч
///
/// - [digits] - кортеж из 3-х цифр класса числа.
String sayThousands(Tuple3 digits) {
  if (digits == Tuple3(0, 0, 0)) {
    return '';
  }
  final s = sayOnes(digits, gender: Gender.female);
  if (digits.value2 == 1) {
    return '$s тысяч';
  } else if (digits.value3 == 1) {
    return '$s тысяча';
  } else if (digits.value3 > 1 && digits.value3 < 5) {
    return '$s тысячи';
  } else {
    return '$s тысяч';
  }
}

/// Называет класс миллионов
///
/// - [digits] - кортеж из 3-х цифр класса числа.
String sayMillions(Tuple3 digits) {
  if (digits == Tuple3(0, 0, 0)) {
    return '';
  }
  final s = sayOnes(digits);
  if (digits.value2 == 1) {
    return '$s миллионов';
  } else if (digits.value3 == 1) {
    return '$s миллион';
  } else if (digits.value3 > 1 && digits.value3 < 5) {
    return '$s миллиона';
  } else {
    return '$s миллионов';
  }
}

/// Называет класс миллиардов
///
/// - [digits] - кортеж из 3-х цифр класса числа.
String sayBillions(Tuple3 digits) {
  if (digits == Tuple3(0, 0, 0)) {
    return '';
  }
  final s = sayOnes(digits);
  if (digits.value2 == 1) {
    return '$s миллиардов';
  } else if (digits.value3 == 1) {
    return '$s миллиард';
  } else if (digits.value3 > 1 && digits.value3 < 5) {
    return '$s миллиарда';
  } else {
    return '$s миллиардов';
  }
}

/// Называет класс триллионов
///
/// - [digits] - кортеж из 3-х цифр класса числа.
String sayTrillions(Tuple3 digits) {
  if (digits == Tuple3(0, 0, 0)) {
    return '';
  }
  final s = sayOnes(digits);
  if (digits.value2 == 1) {
    return '$s триллионов';
  } else if (digits.value3 == 1) {
    return '$s триллион';
  } else if (digits.value3 > 1 && digits.value3 < 5) {
    return '$s триллиона';
  } else {
    return '$s триллионов';
  }
}

/// Разбивает число на цифры
///
/// Например, `12345` -> `[1, 2, 3, 4, 5]`
List<int> splitByDigits(int x) {
  if (x == 0) return [];
  return []
    ..addAll(splitByDigits((x / 10).floor()))
    ..add(x % 10);
}

/// Формирует класс числа из трёх цифр
Tuple3 classFromList(List<int> digits) {
  if (digits.isEmpty) {
    return Tuple3(0, 0, 0);
  } else if (digits.length == 1) {
    return Tuple3(0, 0, digits[0]);
  } else if (digits.length == 2) {
    return Tuple3(0, digits[0], digits[1]);
  } else if (digits.length == 3) {
    return Tuple3(digits[0], digits[1], digits[2]);
  } else {
    throw ArgumentError('Expected 3 digits');
  }
}

/// Разбивает число на классы
///
/// Например, `12345` -> `[(0, 1, 2), (3, 4, 5)]`
List<Tuple3> splitByClasses(int x) => x == 0
    ? []
    : ([]
      ..addAll(splitByClasses((x / 1000).floor()))
      ..add(classFromList(splitByDigits(x % 1000))));

/// Называет число разбитое на классы
///
/// [x] - число разбитое на классы (например, `[(0, 1, 2), (3, 4, 5)]`)
/// [gender] - род числительного
String sayParsedNumber(List<Tuple3> x, {Gender gender = Gender.male}) {
  if (x.length == 5) {
    return ([sayTrillions(x[0])]
          ..add(sayParsedNumber(x.sublist(1), gender: gender)))
        .join(' ');
  }
  if (x.length == 4) {
    return ([sayBillions(x[0])]
          ..add(sayParsedNumber(x.sublist(1), gender: gender)))
        .join(' ');
  }
  if (x.length == 3) {
    return ([sayMillions(x[0])]
          ..add(sayParsedNumber(x.sublist(1), gender: gender)))
        .join(' ');
  }
  if (x.length == 2) {
    return ([sayThousands(x[0])]
          ..add(sayParsedNumber(x.sublist(1), gender: gender)))
        .join(' ');
  }
  if (x.length == 1) {
    return sayOnes(x[0], gender: gender);
  }
  return "";
}

/// Называет число [x]
///
/// [gender] - род числительного.
///
/// Например,
/// ```
/// print(sayNumber(12345)); // "двенадцать тысяч триста сорок пять"
/// ```
String sayNumber(int x, {Gender gender = Gender.male}) => x == 0
    ? 'ноль'
    : sayParsedNumber(splitByClasses(x), gender: gender)
        .replaceAll(RegExp(r'\s+'), ' ')
        .replaceAll(RegExp(r'^\s|\s$'), '');

/// Разбивает число на классы и помещает в строку, где каждый класс разделен параметром [separator]
/// Все ведущие 0 удаляются
///
String toSeparatedClasses(int number, {String separator = ' '}) {
  if (number == 0) return '0';

  return splitByClasses(number)
      .map((item) => "${item.value1}${item.value2}${item.value3}")
      .join(separator)
      .replaceFirst(RegExp(r'^0+'), '');
}

/// Склонение существительных с числительными
/// `oneForm` - Единственная форма: 1 кладбище
/// `fewForm`  - Двойственная форма: 2 кладбища
/// `manyForm` - Множественная форма: 5 кладбищ
///
String pluralForm(int number, String oneForm, String fewForm, String manyForm) {
  var mudulo100 = number.abs() % 100;
  var modulo10 = mudulo100 % 10;
  if (mudulo100 > 10 && mudulo100 < 20) return manyForm;
  if (modulo10 > 1 && modulo10 < 5) return fewForm;
  if (modulo10 == 1) return oneForm;
  return manyForm;
}
