import 'package:data_model/data_model.dart';

/// Статус заказ-наряда
///
/// возможный статус заказ-наряда:
/// * draft - черновик
/// * created - создан
/// * processing - в процессе
/// * ready - готов
/// * finished - завершён
/// * canceled - отменен
/// * received - принято
/// * givenOut - выдано
/// * transferStarted - трансфер начат
/// * taken - забрано
/// * delivered - доставлено
/// * bodyReceived - тело принято
/// * ashReady - прах готов
/// * ashShipped - прах отгружен
/// * urnReserved - урна отложена
/// * urnReady - урна подготовлена
/// * ashReceived - прах принят
/// * capsuleInUrn - капсула в урне
/// * transferredToHandOut - передано на выдачу
/// * ashGivenOut - прах выдан
class DetachmentStatus implements JsonEncodable {
  /// Черновик
  static const DetachmentStatus draft = DetachmentStatus._('draft');

  /// Создан
  static const DetachmentStatus created = DetachmentStatus._('created');

  /// В процессе
  static const DetachmentStatus processing = DetachmentStatus._('processing');

  /// Готов
  static const DetachmentStatus ready = DetachmentStatus._('ready');

  /// Завершён
  static const DetachmentStatus finished = DetachmentStatus._('finished');

  /// Отменен
  static const DetachmentStatus canceled = DetachmentStatus._('canceled');

  /// Принято
  static const DetachmentStatus received = DetachmentStatus._('received');

  /// Выдано
  static const DetachmentStatus givenOut = DetachmentStatus._('givenOut');

  /// Трансфер начат
  static const DetachmentStatus transferStarted =
      DetachmentStatus._('transferStarted');

  /// Забрано
  static const DetachmentStatus taken = DetachmentStatus._('taken');

  /// Доставлено
  static const DetachmentStatus delivered = DetachmentStatus._('delivered');

  /// Тело принято
  static const DetachmentStatus bodyReceived =
      DetachmentStatus._('bodyReceived');

  /// Прах готов
  static const DetachmentStatus ashReady = DetachmentStatus._('ashReady');

  /// Прах отгружен
  static const DetachmentStatus ashShipped = DetachmentStatus._('ashShipped');

  /// Урна отложена
  static const DetachmentStatus urnReserved = DetachmentStatus._('urnReserved');

  /// Урна подготовлена
  static const DetachmentStatus urnReady = DetachmentStatus._('urnReady');

  /// Прах принят
  static const DetachmentStatus ashReceived = DetachmentStatus._('ashReceived');

  /// Капсула в урне
  static const DetachmentStatus capsuleInUrn =
      DetachmentStatus._('capsuleInUrn');

  /// Передано на выдачу
  static const DetachmentStatus transferredToHandOut =
      DetachmentStatus._('transferredToHandOut');

  /// Прах выдан
  static const DetachmentStatus ashGivenOut = DetachmentStatus._('ashGivenOut');

  final String _status;

  // Создает статус заказ-наряда
  const DetachmentStatus._(String status) : _status = status;

  factory DetachmentStatus(String status) {
    if (status == null) return null;
    DetachmentStatus _curStatus = DetachmentStatus._(status);
    if (values.contains(_curStatus)) {
      return _curStatus;
    } else {
      throw ArgumentError('Invalid detachment status: ${status}.');
    }
  }

  final Map<String, Map<String, String>> _statusStr = const {
    'draft': {
      'single': 'Черновик',
      'plural': 'Черновики',
      'changeStatusLabel': 'Черновик'
    },
    'created': {
      'single': 'Новый',
      'plural': 'Новые',
      'changeStatusLabel': 'Новый'
    },
    'processing': {
      'single': 'В работе',
      'plural': 'В работе',
      'changeStatusLabel': 'В работу'
    },
    'ready': {
      'single': 'Подготовлен',
      'plural': 'Подготовлено',
      'changeStatusLabel': 'Подготовлено'
    },
    'finished': {
      'single': 'Завершен',
      'plural': 'Завершено',
      'changeStatusLabel': 'Завершено'
    },
    'canceled': {
      'single': 'Отменен',
      'plural': 'Отменено',
      'changeStatusLabel': 'Отменено'
    },
    'received': {
      'single': 'Принято',
      'plural': 'Принято',
      'changeStatusLabel': 'Принято'
    },
    'givenOut': {
      'single': 'Выдано',
      'plural': 'Выдано',
      'changeStatusLabel': 'Выдано'
    },
    'transferStarted': {
      'single': 'Трансфер начат',
      'plural': 'Трансфер начат',
      'changeStatusLabel': 'Трансфер начат'
    },
    'taken': {
      'single': 'Забрано',
      'plural': 'Забрано',
      'changeStatusLabel': 'Забрано'
    },
    'delivered': {
      'single': 'Доставлено',
      'plural': 'Доставлено',
      'changeStatusLabel': 'Доставлено'
    },
    'bodyReceived': {
      'single': 'Тело принято',
      'plural': 'Тело принято',
      'changeStatusLabel': 'Тело принято'
    },
    'ashReady': {
      'single': 'Прах готов',
      'plural': 'Прах готов',
      'changeStatusLabel': 'Прах готов'
    },
    'ashShipped': {
      'single': 'Прах отгружен',
      'plural': 'Прах отгружен',
      'changeStatusLabel': 'Прах отгружен'
    },
    'urnReserved': {
      'single': 'Урна отложена',
      'plural': 'Урна отложена',
      'changeStatusLabel': 'Урна отложена'
    },
    'urnReady': {
      'single': 'Урна подготовлена',
      'plural': 'Урна подготовлена',
      'changeStatusLabel': 'Урна подготовлена'
    },
    'ashReceived': {
      'single': 'Прах принят',
      'plural': 'Прах принят',
      'changeStatusLabel': 'Прах принят'
    },
    'capsuleInUrn': {
      'single': 'Капсула в урне',
      'plural': 'Капсула в урне',
      'changeStatusLabel': 'Капсула в урне'
    },
    'transferredToHandOut': {
      'single': 'Передано на выдачу',
      'plural': 'Передано на выдачу',
      'changeStatusLabel': 'Передано на выдачу'
    },
    'ashGivenOut': {
      'single': 'Прах выдан',
      'plural': 'Прах выдан',
      'changeStatusLabel': 'Прах выдан'
    },
  };

  String get value => _status;
  static List get values => [
        draft,
        created,
        processing,
        ready,
        finished,
        canceled,
        received,
        givenOut,
        transferStarted,
        taken,
        delivered,
        bodyReceived,
        ashReady,
        ashShipped,
        urnReserved,
        urnReady,
        ashReceived,
        capsuleInUrn,
        transferredToHandOut,
        ashGivenOut
      ];

  @override
  bool operator ==(dynamic other) {
    if (other is DetachmentStatus) {
      return other._status == _status;
    }
    return false;
  }

  @override
  int get hashCode => _status.hashCode;

  String get json => _status;

  String get plural => _statusStr[_status]['plural'];

  String get changeStatusLabel => _statusStr[_status]['changeStatusLabel'];

  @override
  String toString() => _statusStr[_status]['single'];
}
