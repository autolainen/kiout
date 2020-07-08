abstract class Event {}

/// Событие исключения
class ExceptionEvent extends Event {
  final dynamic exception;
  final StackTrace stackTrace;
  final bool showDialog;

  ExceptionEvent(this.exception, this.stackTrace, this.showDialog);
}

/// Событие анонса
class AnnouncementEvent extends Event {}

/// Событие сообщения в чате
class SlackMessageEvent extends Event {}

/// Событие сообщения в чат обработано
class SlackMessageProcessedEvent extends Event {}

/// Событие изменения предзаказов
class PreordersChangeEvent extends Event {}

/// Событие изменения группы пользователя
class UserGroupChangeEvent extends Event {}
