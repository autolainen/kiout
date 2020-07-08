import 'package:data_model/data_model.dart';

import '../exceptions/data_mismatch_exception.dart';
import '../work_type.dart';
import 'detachment.dart';
import 'detachment_stage.dart';
import 'detachment_status.dart';

/// Статистика заказ-нарядов
class DetachmentStatistics implements JsonEncodable {
  /// Вид работы
  final WorkType workType;

  /// Количество рекламаций, открытых по заказ-нарядам определенного вида работ
  int reclamationsCount;

  /// Признак наличия рекламаций
  bool get hasReclamations => reclamationsCount > 0;

  /// Количество заказ-нарядов по статусам
  Map<DetachmentStatus, DetachmentStatusStatistics> get statusStatistics =>
      _statusStatistics;
  Map<DetachmentStatus, DetachmentStatusStatistics> _statusStatistics = {};

  DetachmentStatistics(this.workType,
      {this.reclamationsCount = 0,
      Map<DetachmentStatus, DetachmentStatusStatistics> statusStatistics}) {
    // Если передан параметр, то заполняем значениями _statusStatistics из него
    if (statusStatistics != null) {
      _statusStatistics = statusStatistics;
      // Иначе заполняем пустыми значениями
    } else {
      for (DetachmentStage stage in Detachment.stagesOf(workType) ?? []) {
        _statusStatistics[stage.status] =
            DetachmentStatusStatistics(stage.status);
      }
    }
  }

  factory DetachmentStatistics.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    if (json['workType'] != null && json['workType'] is! String) {
      throw DataMismatchException(
          'Неверный формат вида работы ("${json['workType']}" - требуется String)\nУ статистики заказ-наряда.');
    }
    if (json['reclamationsCount'] != null &&
        json['reclamationsCount'] is! int) {
      throw DataMismatchException(
          'Неверный формат метки ("${json['reclamationsCount']}" - требуется int)\nУ статистики заказ-наряда.');
    }
    if (json['statusStatistics'] != null && json['statusStatistics'] is! List) {
      throw DataMismatchException(
          'Неверный формат статистики по статусам ("${json['statusStatistics']}" - требуется List)\nУ статистики заказ-наряда.');
    }
    Map<DetachmentStatus, DetachmentStatusStatistics> _statusStatistics = {};
    try {
      // Заполняем все статусы нулевыми данными чтобы сохранить нужный порядок
      for (DetachmentStage stage
          in Detachment.stagesOf(WorkType(json['workType'])) ?? []) {
        _statusStatistics[stage.status] =
            DetachmentStatusStatistics(stage.status);
      }
      // Восстанавливаем модели из json
      for (var statusStatisticsJson in json['statusStatistics']) {
        DetachmentStatusStatistics curDSS =
            DetachmentStatusStatistics.fromJson(statusStatisticsJson);
        _statusStatistics[curDSS.status] = curDSS;
      }
    } catch (e) {
      throw DataMismatchException(e is Error
          ? e.toString()
          : e.message + '\nУ статистики заказ-наряда');
    }

    return DetachmentStatistics(WorkType(json['workType']),
        reclamationsCount: json['reclamationsCount'],
        statusStatistics: _statusStatistics.isEmpty ? null : _statusStatistics);
  }

  /// Возвращает данные статистики в JSON-формате ([Map])
  @override
  Map<String, dynamic> get json => {
        'workType': workType.json,
        'reclamationsCount': reclamationsCount,
        // Нулевые значения мы пропускаем
        'statusStatistics': statusStatistics == null
            ? null
            : statusStatistics.values.map((ss) {
                if (ss.total > 0 || ss.hasOverdue) {
                  return ss.json;
                } else {
                  return null;
                }
              }).toList()
          ..removeWhere((element) => element == null),
      }..removeWhere((key, value) => value == null);

  @override
  String toString() => json.toString();
}

/// Статистика заказ-нарядов, разграниченная по статусам
class DetachmentStatusStatistics implements JsonEncodable {
  /// Общее количество заказ-нарядов с определенным статусом
  final int total;

  /// Статус заказ-наряда
  final DetachmentStatus status;

  /// Признак наличия среди заказ-нарядов просроченных по дате завершения
  final bool hasOverdue;

  DetachmentStatusStatistics(
    this.status, {
    this.total = 0,
    this.hasOverdue = false,
  });

  factory DetachmentStatusStatistics.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    if (json['status'] != null && json['status'] is! String) {
      throw DataMismatchException(
          'Неверный формат статуса ("${json['status']}" - требуется String)\nУ статистики заказ-наряда по статусу.');
    }
    if (json['total'] != null && json['total'] is! int) {
      throw DataMismatchException(
          'Неверный формат общего количества ("${json['total']}" - требуется int)\nУ статистики заказ-наряда по статусу.');
    }
    if (json['hasOverdue'] != null && json['hasOverdue'] is! bool) {
      throw DataMismatchException(
          'Неверный формат признака просроченности ("${json['hasOverdue']}" - требуется bool)\nУ статистики заказ-наряда по статусу.');
    }
    return DetachmentStatusStatistics(DetachmentStatus(json['status']),
        total: json['total'], hasOverdue: json['hasOverdue']);
  }

  /// Возвращает данные адреса в JSON-формате ([Map])
  @override
  Map<String, dynamic> get json => {
        'status': status.json,
        'total': total,
        'hasOverdue': hasOverdue
      }..removeWhere((key, value) => value == null);

  @override
  String toString() => json.toString();
}
