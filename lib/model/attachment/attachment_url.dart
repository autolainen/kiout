import 'package:data_model/data_model.dart';
import 'package:mime/mime.dart';

import '../exceptions/data_mismatch_exception.dart';

/// Url вложения
abstract class AttachmentUrl implements JsonEncodable {
  final String full;
  final String thumbnail;

  AttachmentUrl({this.full, this.thumbnail});

  factory AttachmentUrl.fromJson(dynamic json) {
    if (json == null) return null;
    if (json is String) return AmazonUrl.fromJson({'url': json});
    if (json is! Map)
      throw DataMismatchException(
          'Не верный формат json у Url вложения - требуется String либо Map');

    if (json['url'] == null || json['url'] is! String) {
      throw DataMismatchException(
          'url не может быть пустым или не строкой у вложения ${json['url']}');
    }
    if (json['type'] == 'slack') {
      return SlackUrl.fromJson(json);
    } else {
      return AmazonUrl.fromJson(json);
    }
  }
}

/// Url вложения на Амазон
class AmazonUrl extends AttachmentUrl {
  AmazonUrl(String full, {bool isImage})
      : super(
            full: full,
            thumbnail:
                isImage ?? (lookupMimeType(full)?.contains('image') ?? false)
                    ? _fetchThumbnail(full)
                    : null);

  static String _fetchThumbnail(String fullUrl) {
    if (fullUrl != null) {
      var urlParts = fullUrl.split('/');
      urlParts.remove('origin');
      urlParts.insert(urlParts.length - 1, 'thumbs');
      return urlParts.join('/');
    }
    return null;
  }

  factory AmazonUrl.fromJson(Map json) {
    if (json == null) return null;
    return AmazonUrl(json['url'],
        isImage: json['mime_type']?.contains('image'));
  }

  /// Возвращает данные url в JSON-формате ([Map])
  @override
  Map<String, dynamic> get json => {'url': full};

  @override
  String toString() => json.toString();
}

/// Url Slack вложения
class SlackUrl extends AttachmentUrl {
  SlackUrl(String full, {String thumbnail})
      : super(full: full, thumbnail: thumbnail);

  factory SlackUrl.fromJson(Map json) {
    if (json == null) return null;
    if (json['thumbnail'] != null && json['thumbnail'] is! String) {
      throw DataMismatchException(
          'thumbnail должен быть строкой у slack вложения ${json['thumbnail']}');
    }
    return SlackUrl(json['url'], thumbnail: json['thumbnail']);
  }

  /// Возвращает данные url в JSON-формате ([Map])
  @override
  Map<String, dynamic> get json => {
        'url': full,
        'thumbnail': thumbnail,
        'type': 'slack'
      }..removeWhere((key, value) => value == null);

  @override
  String toString() => json.toString();
}
