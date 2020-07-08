import 'package:intl/intl.dart';
import 'package:data_model/data_model.dart';

import 'dadata_address.dart';
import 'datetime/to_local_date_time.dart';
import 'exceptions/data_mismatch_exception.dart';

/// Класс, реализующий данные аттрибутов
class Attribute implements JsonEncodable {
  /// Тип
  String type;

  /// Метка
  String label;

  /// Значение
  dynamic value;

  /// Требуется з-н
  bool detachmentRequired;

  /// Требуется заказ
  bool orderRequired;

  Attribute(
      {this.type,
      this.label,
      this.value,
      this.detachmentRequired,
      this.orderRequired}) {
    if (['arrival', 'departure', 'finish_date', 'reservation_date']
        .contains(type)) {
      value = toLocalDateTime(value)?.toIso8601String();
    }
  }

  factory Attribute.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    if (json['type'] != null && json['type'] is! String) {
      throw DataMismatchException(
          'Неверный формат типа ("${json['type']}" - требуется String)\nУ атрибута.');
    }
    if (json['label'] != null && json['label'] is! String) {
      throw DataMismatchException(
          'Неверный формат метки ("${json['label']}" - требуется String)\nУ атрибута.');
    }

    if (json['detachment_required'] != null &&
        json['detachment_required'] is! bool) {
      throw DataMismatchException(
          'Неверный формат поля detachment_required ("${json['value']}" - требуется bool)\nУ атрибута.');
    }
    if (json['order_required'] != null && json['order_required'] is! bool) {
      throw DataMismatchException(
          'Неверный формат поля order_required ("${json['value']}" - требуется bool)\nУ атрибута.');
    }

    dynamic value = json['value'];
    if (value != null) {
      if (['bighall_schedule', 'smallhall2_schedule', 'route_point', 'comments']
          .contains(json['type'])) {
        if (value is! List)
          throw DataMismatchException(
              'Неверный формат значения ("$value" - требуется List)\nУ атрибута.');
        value = List<Attribute>.from(
            value.map((attribute) => Attribute.fromJson(attribute)).toList());
      } else if (json['type'] == 'address') {
        if (value is! Map)
          throw DataMismatchException(
              'Неверный формат значения ("$value" - требуется Map)\nУ атрибута.');
        value = DadataAddress.fromJson(json['value']);
      }
    }
    return Attribute(
        type: json['type'],
        label: json['label'],
        value: value,
        detachmentRequired: json['detachment_required'],
        orderRequired: json['order_required']);
  }

  /// Возвращает данные адреса в JSON-формате ([Map])
  @override
  Map<String, dynamic> get json {
    var result = {
      'type': type,
      'label': label,
      'detachment_required': detachmentRequired,
      'order_required': orderRequired
    };
    dynamic jsonValue;

    switch (type) {
      case 'arrival':
      case 'departure':
      case 'finish_date':
      case 'reservation_date':
        jsonValue = toLocalDateTime(value)?.toUtc()?.toIso8601String();
        break;
      case 'address':
        jsonValue = value?.json;
        break;
      case 'bighall_schedule':
      case 'smallhall2_schedule':
      case 'route_point':
      case 'comments':
        jsonValue = value?.map((attribute) => attribute.json)?.toList();
        if (jsonValue?.isEmpty ?? false) jsonValue = null;
        break;
      default:
        jsonValue = value;
        break;
    }
    result.addAll({'value': jsonValue});
    return result..removeWhere((key, value) => value == null);
  }

  @override
  String toString() {
    switch (type) {
      case 'arrival':
      case 'departure':
      case 'finish_date':
        return value != null
            ? DateFormat('dd.MM.yyyy в H:mm').format(DateTime.parse(value))
            : null;
        break;
      case 'reservation_date':
        return value != null
            ? DateFormat('dd.MM.yyyy').format(DateTime.parse(value))
            : null;
        break;
      case 'bighall_schedule':
      case 'smallhall2_schedule':
      case 'route_point':
      case 'comments':
        return value
            ?.map((attribute) => "${attribute.label}: ${attribute.toString()}")
            ?.toList()
            ?.toString();
      default:
        return value?.toString();
        break;
    }
  }
}
