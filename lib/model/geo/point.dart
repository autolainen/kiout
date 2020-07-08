import 'dart:math' as math;

import 'package:data_model/data_model.dart';

/// Класс реализующий точку на карте (геоточку) - GeoPoint
class Point implements JsonEncodable {
  /// Долгота
  double longitude;

  /// Широта
  double latitude;

  Point([this.longitude = 0.0, this.latitude = 0.0]);

  factory Point.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    if (json['type'] != 'Point')
      throw ArgumentError(
          "Invalid geo type '${json['type']}'. Expected 'Point'.");
    if (json['coordinates'] == null)
      throw ArgumentError("Point coordinates cannot be null.");
    if (json['coordinates'][0] == null)
      throw ArgumentError("Point longitude cannot be null.");
    if (json['coordinates'][1] == null)
      throw ArgumentError("Point latitude cannot be null.");
    return Point(json['coordinates'][0], json['coordinates'][1]);
  }

  Map<String, dynamic> get json => {
        'type': 'Point',
        'coordinates': [longitude, latitude]
      }..removeWhere((key, value) => value == null);

  /// Координаты точки
  List<double> get coordinates => [longitude, latitude];

  /// Вычисление расстояния от текущих координат до заданной
  /// Возвращает результат в метрах
  double distanceTo(Point point) {
    const double EARTH_RADIUS = 6378137.0;
    double distance = 0.0;

    //переводим градусы в радианы
    double currentLatRadians = latitude * (math.pi / 180.0);
    double latRadians = point.latitude * (math.pi / 180.0);

    double deltaLat = latRadians - currentLatRadians;
    double deltaLon = (point.longitude - longitude) * (math.pi / 180.0);

    double a = math.pow(math.sin(deltaLat / 2), 2) +
        math.cos(latRadians) *
            math.cos(currentLatRadians) *
            math.pow(math.sin(deltaLon / 2), 2);

    distance = 2 * EARTH_RADIUS * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return distance;
  }
}
