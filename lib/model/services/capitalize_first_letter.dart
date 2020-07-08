/// Делает заглавной первую букву строки
String capitalizeFirstLetter(String input) => input == null || input.isEmpty
    ? input
    : '${input[0].toUpperCase()}${input.substring(1)}';
