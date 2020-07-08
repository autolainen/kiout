class DataMismatchException implements Exception {
  final String message;
  DataMismatchException([this.message = '']);

  String toString() {
    if (message == null) return 'DataMismatchException';
    return 'DataMismatchException: ${message}';
  }
}
