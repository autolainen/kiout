/// Преобразует переменную типа `String` или `DateTime` в `DateTime` с текущей временной зоной
DateTime toLocalDateTime(dynamic value) {
  if (value == null || !(value is DateTime || value is String)) return null;

  return ((value is DateTime) ? value : DateTime.parse(value)).toLocal();
}
