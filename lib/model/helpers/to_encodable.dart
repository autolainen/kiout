dynamic toEncodable(value) {
  if (value is DateTime) return value.toUtc().toIso8601String();
  return '';
}
