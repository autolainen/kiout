import 'package:data_model/data_model.dart';

import 'point.dart';

/// Класс реализующий полигон на плоскости
class Polygon implements JsonEncodable {
  List<Point> points;

  Polygon([this.points = const []]);

  /// Создает Polygon на основе geojson
  ///
  /// [json] имеет следующий формат:
  ///
  ///     {
  ///       'type': 'Polygon',
  ///       'coordinates': [[[1.0, 2.0], [3.0, 4.0], [5.0, 6.0], [1.0, 2.0]]]
  ///     }
  factory Polygon.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    if (json['type'] != 'Polygon')
      throw ArgumentError(
          "Invalid geojson type: '${json['type']}'. Expected 'Polygon'");
    var coordinates = json['coordinates'];
    if (coordinates == null)
      throw ArgumentError('Polygon coordinates cannot be null');
    if (coordinates[0].length < 4)
      throw ArgumentError(
          'Polygon cannot contain less then 4 point coordinates');
    if (coordinates[0].first[0] != coordinates[0].last[0] ||
        coordinates[0].first[1] != coordinates[0].last[1])
      throw ArgumentError('First and last poins of Polygon must be equal');
    final points = <Point>[];
    json['coordinates'][0].forEach((coordinates) {
      final point =
          Point.fromJson({'type': 'Point', 'coordinates': coordinates});
      points.add(point);
    });
    return Polygon(points);
  }

  /// Список координат вершин полигона
  List<List<List<double>>> get coordinates =>
      [points.map((point) => point.coordinates).toList()];

  /// Формирует geojson
  @override
  Map<String, dynamic> get json => {
        'type': 'Polygon',
        'coordinates': [points.map((point) => point.coordinates).toList()]
      }..removeWhere((key, value) => value == null);

  /// Расчитывает цетроид полигона
  ///
  /// Расчет центройда происходит путем высчитывания средней координаты из всех
  /// так сделано из-за того что при "правильном" расчете центройда появялется
  /// неточность в рассчетах из-за оперирования малыми дробными долями координат
  Point get centroid {
    double lat = 0.0;
    double lon = 0.0;

    for (int i = 0; i < points.length; i++) {
      lat += points[i].latitude;
      lon += points[i].longitude;
    }

    lat = lat / points.length;
    lon = lon / points.length;

    return Point(lon, lat);
  }

  /// Определяет, находится ли точка внутри текущего полигона
  bool containsPoint(Point point) {
    double prevDiffLng = 0;
    double prevDiffLat = 0;
    double diffLng = points[points.length - 1].longitude - point.longitude;
    double diffLat = points[points.length - 1].latitude - point.latitude;
    int depth = 0;

    for (int i = 0; i < points.length; i++) {
      prevDiffLng = diffLng;
      prevDiffLat = diffLat;
      diffLng = points[i].longitude - point.longitude;
      diffLat = points[i].latitude - point.latitude;

      if (prevDiffLat < 0 && diffLat < 0) continue; // both "down"
      if (prevDiffLat > 0 && diffLat > 0) continue; // both "up"
      if (prevDiffLng < 0 && diffLng < 0) continue; // both points on left

      double lx = prevDiffLng -
          prevDiffLat * (diffLng - prevDiffLng) / (diffLat - prevDiffLat);

      if (lx == 0) return true; // point on edge
      if (lx > 0) depth++;
    }

    return (depth & 1) == 1;
  }
}
