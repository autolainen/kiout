import 'package:event_bus/event_bus.dart';
import 'package:get_it/get_it.dart';

/// Локатор служб
///
/// Обращение к сервисам доступно следующим образом: `service<ServiceType>()`
final service = GetIt.instance..allowReassignment = true;

/// Сервис подписки и доставки типизированных сообщений
final eventBus = EventBus();
