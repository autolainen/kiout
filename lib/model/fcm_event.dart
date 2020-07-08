/// Событие FirebaseCloudMessaging уведомления
///
/// возможные события пуш уведомлений:
/// * detachmentAssigned - назначение заказ-наряда
/// * detachmentStatusChanged - смена статуса заказ-наряда
/// * detachmentStageVerified - подтверждение выполнения этапа заказ-наряда
/// * newDetachmentReceived - новый заказ-наряд (отправляет ЧА)
/// * newAnnouncement - новость для внешнего агента
/// * newMessageReceived - новое сообщение
/// * newSlackMessage - новое сообщение из Slack
/// * reclamationOpened - открытие рекламации
/// * newReclamationMessage - открытие рекламации
/// * opportunityStatusChanged - смена статуса предзаказа (отправляет ЧА)
/// * userGroupChange - смена группы у пользователя
/// * specificationConfirmed - спецификация подтверждена
class FcmEvent {
  /// Назначение заказ-наряда
  static const FcmEvent detachmentAssigned = FcmEvent._('detachmentAssigned');

  /// Смена статуса заказ-наряда
  static const FcmEvent detachmentStatusChanged =
      FcmEvent._('detachmentStatusChanged');

  /// Этап выполнения заказ-наряда подтверждён
  static const FcmEvent detachmentStageVerified =
      FcmEvent._('detachmentStageVerified');

  /// Новый заказ-наряд (отправляет ЧА)
  static const FcmEvent newDetachmentReceived =
      FcmEvent._('newDetachmentReceived');

  /// Новость для внешнего агента
  static const FcmEvent newAnnouncement = FcmEvent._('newAnnouncement');

  /// Новое сообщение
  static const FcmEvent newMessageReceived = FcmEvent._('newMessageReceived');

  /// Новое сообщение из Slack
  static const FcmEvent newSlackMessage = FcmEvent._('newSlackMessage');

  /// Открытие рекламации
  static const FcmEvent reclamationOpened = FcmEvent._('reclamationOpened');

  /// Новое сообщение по рекламации
  static const FcmEvent newReclamationMessage =
      FcmEvent._('newReclamationMessage');

  /// Смена статуса предзаказа (отправляет ЧА)
  static const FcmEvent opportunityStatusChanged =
      FcmEvent._('opportunityStatusChanged');

  /// Смена группы у пользователя
  static const FcmEvent userGroupChange = FcmEvent._('userGroupChange');

  /// Спецификация подтверждена
  static const FcmEvent specificationConfirmed =
      FcmEvent._('specificationConfirmed');

  final String _event;

  // Создает событие FCM уведомления
  const FcmEvent._(String event) : _event = event;

  factory FcmEvent(String event) {
    if (event == null) return null;
    FcmEvent _curEvent = FcmEvent._(event);
    if (values.contains(_curEvent)) {
      return _curEvent;
    } else {
      throw ArgumentError('Invalid fcm event: ${event}.');
    }
  }

  String get value => _event;
  static List get values => [
        detachmentAssigned,
        detachmentStatusChanged,
        detachmentStageVerified,
        newAnnouncement,
        newDetachmentReceived,
        newMessageReceived,
        newSlackMessage,
        reclamationOpened,
        newReclamationMessage,
        opportunityStatusChanged,
        userGroupChange,
        specificationConfirmed
      ];

  @override
  bool operator ==(dynamic other) {
    if (other is FcmEvent) {
      return other.json == _event;
    }
    return false;
  }

  @override
  int get hashCode => _event.hashCode;

  String get json => _event;

  @override
  String toString() => _event;
}
