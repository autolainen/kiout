import '../work_type.dart';
import 'detachment_status.dart';

/// Этап прохождения заказ-наряда
class DetachmentStage {
  /// Статус заказ-наряда
  final DetachmentStatus _status;

  /// Необходимость подтверждения статуса перед переходом к следующему
  final bool _verificationRequired;

  /// Необходимость отправки отчета с фотографиями перед переходом к следующему этапу
  final bool _reportRequired;

  // Создает этап прохождения заказ-наряда
  DetachmentStage(DetachmentStatus status,
      {bool verificationRequired = false, bool reportRequired = false})
      : _status = status,
        _reportRequired = reportRequired,
        _verificationRequired = verificationRequired;

  @override
  bool operator ==(dynamic other) {
    if (other is DetachmentStage) {
      return other._status == _status &&
          other._verificationRequired == _verificationRequired &&
          other._reportRequired == _reportRequired;
    }
    return false;
  }

  @override
  int get hashCode => _status.hashCode;

  DetachmentStatus get status => _status;

  bool get verificationRequired => _verificationRequired;

  bool get reportRequired => _reportRequired;

  @override
  String toString() => _status.toString();
}

/// Список этапов заказ-наряда в зависимости от вида работ
final Map<WorkType, List<DetachmentStage>> allStages = {
  WorkType.installation: [
    DetachmentStage(DetachmentStatus.draft),
    DetachmentStage(DetachmentStatus.created),
    DetachmentStage(DetachmentStatus.processing),
    DetachmentStage(DetachmentStatus.finished, reportRequired: true),
  ],
  WorkType.removal: [
    DetachmentStage(DetachmentStatus.draft),
    DetachmentStage(DetachmentStatus.created),
    DetachmentStage(DetachmentStatus.processing, reportRequired: true),
    DetachmentStage(DetachmentStatus.finished, reportRequired: true),
  ],
  WorkType.singumator: [
    DetachmentStage(DetachmentStatus.draft),
    DetachmentStage(DetachmentStatus.created),
    DetachmentStage(DetachmentStatus.processing),
    DetachmentStage(DetachmentStatus.ready, reportRequired: true),
    DetachmentStage(DetachmentStatus.finished),
  ],
  WorkType.burial: [
    DetachmentStage(DetachmentStatus.draft),
    DetachmentStage(DetachmentStatus.created),
    DetachmentStage(DetachmentStatus.processing),
    DetachmentStage(DetachmentStatus.ready, reportRequired: true),
    DetachmentStage(DetachmentStatus.finished, reportRequired: true),
  ],
  WorkType.fence: [
    DetachmentStage(DetachmentStatus.draft),
    DetachmentStage(DetachmentStatus.created),
    DetachmentStage(DetachmentStatus.processing),
    DetachmentStage(DetachmentStatus.ready, reportRequired: true),
    DetachmentStage(DetachmentStatus.finished,
        reportRequired: true, verificationRequired: true),
  ],
  WorkType.higherService: [
    DetachmentStage(DetachmentStatus.draft),
    DetachmentStage(DetachmentStatus.created),
    DetachmentStage(DetachmentStatus.processing),
    DetachmentStage(DetachmentStatus.finished, reportRequired: true),
  ],
  WorkType.accomplishment: [
    DetachmentStage(DetachmentStatus.draft),
    DetachmentStage(DetachmentStatus.created),
    DetachmentStage(DetachmentStatus.processing, reportRequired: true),
    DetachmentStage(DetachmentStatus.finished, reportRequired: true),
  ],
  WorkType.columbarium: [
    DetachmentStage(DetachmentStatus.draft),
    DetachmentStage(DetachmentStatus.created),
    DetachmentStage(DetachmentStatus.processing),
    DetachmentStage(DetachmentStatus.ready, reportRequired: true),
    DetachmentStage(DetachmentStatus.finished, reportRequired: true),
  ],
  WorkType.corpseStorage: [
    DetachmentStage(DetachmentStatus.draft),
    DetachmentStage(DetachmentStatus.created),
    DetachmentStage(DetachmentStatus.received),
    DetachmentStage(DetachmentStatus.givenOut),
  ],
  WorkType.embalming: [
    DetachmentStage(DetachmentStatus.draft),
    DetachmentStage(DetachmentStatus.created),
    DetachmentStage(DetachmentStatus.processing, reportRequired: true),
    DetachmentStage(DetachmentStatus.finished, reportRequired: true),
  ],
  WorkType.farewell: [
    DetachmentStage(DetachmentStatus.draft),
    DetachmentStage(DetachmentStatus.created),
    DetachmentStage(DetachmentStatus.finished),
  ],
  WorkType.vipHallFarewell: [
    DetachmentStage(DetachmentStatus.draft),
    DetachmentStage(DetachmentStatus.created),
    DetachmentStage(DetachmentStatus.processing),
    DetachmentStage(DetachmentStatus.ready, reportRequired: true),
    DetachmentStage(DetachmentStatus.finished),
  ],
  WorkType.ashTransfer: [
    DetachmentStage(DetachmentStatus.draft),
    DetachmentStage(DetachmentStatus.created),
    DetachmentStage(DetachmentStatus.transferStarted),
    DetachmentStage(DetachmentStatus.taken),
    DetachmentStage(DetachmentStatus.delivered),
  ],
  WorkType.corpseTransfer: [
    DetachmentStage(DetachmentStatus.draft),
    DetachmentStage(DetachmentStatus.created),
    DetachmentStage(DetachmentStatus.transferStarted),
    DetachmentStage(DetachmentStatus.taken),
    DetachmentStage(DetachmentStatus.delivered),
  ],
  WorkType.catafalTransport: [
    DetachmentStage(DetachmentStatus.draft),
    DetachmentStage(DetachmentStatus.created),
    DetachmentStage(DetachmentStatus.transferStarted),
    DetachmentStage(DetachmentStatus.taken),
    DetachmentStage(DetachmentStatus.delivered),
  ],
  WorkType.passengerTransport: [
    DetachmentStage(DetachmentStatus.draft),
    DetachmentStage(DetachmentStatus.created),
    DetachmentStage(DetachmentStatus.transferStarted),
    DetachmentStage(DetachmentStatus.taken),
    DetachmentStage(DetachmentStatus.delivered),
  ],
  WorkType.cremation: [
    DetachmentStage(DetachmentStatus.draft),
    DetachmentStage(DetachmentStatus.created),
    DetachmentStage(DetachmentStatus.bodyReceived),
    DetachmentStage(DetachmentStatus.ashReady,
        reportRequired: true, verificationRequired: true),
    DetachmentStage(DetachmentStatus.ashShipped),
  ],
  WorkType.urnAssembly: [
    DetachmentStage(DetachmentStatus.draft),
    DetachmentStage(DetachmentStatus.created),
    DetachmentStage(DetachmentStatus.urnReady),
    DetachmentStage(DetachmentStatus.ashReceived),
    DetachmentStage(DetachmentStatus.capsuleInUrn),
    DetachmentStage(DetachmentStatus.transferredToHandOut,
        reportRequired: true),
  ],
  WorkType.ashGiveOut: [
    DetachmentStage(DetachmentStatus.draft),
    DetachmentStage(DetachmentStatus.created),
    DetachmentStage(DetachmentStatus.ashReceived),
    DetachmentStage(DetachmentStatus.transferredToHandOut,
        reportRequired: true),
    DetachmentStage(DetachmentStatus.ashGivenOut, reportRequired: true),
  ],
  WorkType.crematoryAshGiveOut: [
    DetachmentStage(DetachmentStatus.draft),
    DetachmentStage(DetachmentStatus.created),
    DetachmentStage(DetachmentStatus.urnReserved),
    DetachmentStage(DetachmentStatus.ashReceived),
    DetachmentStage(DetachmentStatus.urnReady, reportRequired: true),
    DetachmentStage(DetachmentStatus.ashGivenOut, reportRequired: true),
  ],
  WorkType.collectDocuments: [
    DetachmentStage(DetachmentStatus.created),
    DetachmentStage(DetachmentStatus.processing),
    DetachmentStage(DetachmentStatus.finished, reportRequired: true),
  ],
};
