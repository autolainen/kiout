import 'package:data_model/data_model.dart';

/// Вид работы
///
/// возможные виды работ:
/// * installation - монтаж
/// * removal - демонтаж
/// * singumator - сингуматор
/// * burial - захоронение
/// * columbarium - колумбарий
/// * collectDocuments - сбор документов
/// * fence - ограды
/// * monuments - памятники
/// * accomplishment - благоустройство
/// * cemeteryGoods - товары на кладбище
/// * higherService - повышенный сервис
/// * passengerTransport - пассажирский транспорт
/// * catafalTransport - катафальный транспорт
/// * corpseTransfer - перевозка тел
/// * ashTransfer - перевозка праха
/// * farewell - прощание
/// * cremation - кремация
/// * ashGiveOut - выдача праха
/// * crematoryAshGiveOut - выдача в крематории
/// * ritualGoods - ритуальные товары
/// * ritualService - ритуальные услуги
/// * sanitaryService - санитарские услуги
/// * registrationService - услуги оформления
/// * corpseStorage - трупохранилище
/// * embalming - бальзамирование
/// * vipHallFarewell - прощание VIP
/// * urnAssembly - комплектация урны
class WorkType implements JsonEncodable, Comparable {
  /// Монтаж
  static const WorkType installation = WorkType._('монтаж');

  /// Демонтаж
  static const WorkType removal = WorkType._('демонтаж');

  /// Сингуматор
  static const WorkType singumator = WorkType._('сингуматор');

  /// Захоронение
  static const WorkType burial = WorkType._('захоронение');

  /// Колумбарий
  static const WorkType columbarium = WorkType._('колумбарий');

  /// Ограды
  static const WorkType fence = WorkType._('ограды');

  /// Памятники
  static const WorkType monuments = WorkType._('памятники');

  /// Благоустройство
  static const WorkType accomplishment = WorkType._('благоустройство');

  /// Товары на кладбище
  static const WorkType cemeteryGoods = WorkType._('товары на кладбище');

  /// Повышенный сервис
  static const WorkType higherService = WorkType._('повышенный сервис');

  /// Пассажирский транспорт
  static const WorkType passengerTransport =
      WorkType._('пассажирский транспорт');

  /// Катафальный транспорт
  static const WorkType catafalTransport = WorkType._('катафальный транспорт');

  /// Перевозка тел
  static const WorkType corpseTransfer = WorkType._('перевозка тел');

  /// Перевозка праха
  static const WorkType ashTransfer = WorkType._('перевозка праха');

  /// Прощание
  static const WorkType farewell = WorkType._('прощание');

  /// Кремация
  static const WorkType cremation = WorkType._('кремация');

  /// Выдача праха
  static const WorkType ashGiveOut = WorkType._('выдача праха');

  /// Ритуальные товары
  static const WorkType ritualGoods = WorkType._('ритуальные товары');

  /// Ритуальные услуги
  static const WorkType ritualService = WorkType._('ритуальные услуги');

  /// Санитарские услуги
  static const WorkType sanitaryService = WorkType._('санитарские услуги');

  /// Услуги оформления
  static const WorkType registrationService = WorkType._('услуги оформления');

  /// Трупохранилище
  static const WorkType corpseStorage = WorkType._('трупохранилище');

  /// Бальзамирование
  static const WorkType embalming = WorkType._('бальзамирование');

  /// Прощание VIP
  static const WorkType vipHallFarewell = WorkType._('прощание VIP');

  /// Комплектация урны
  static const WorkType urnAssembly = WorkType._('комплектация урны');

  /// Выдача в крематории
  static const WorkType crematoryAshGiveOut = WorkType._('выдача в крематории');

  /// Сбор документов
  static const WorkType collectDocuments = WorkType._('сбор документов');

  /// Эксклюзив
  static const WorkType exclusive = WorkType._('эксклюзив');

  final String _workType;

  // Создает вид работ
  const WorkType._(String workType) : _workType = workType;

  factory WorkType(String workType) {
    if (workType == null) return null;
    WorkType _curWorkType = WorkType._(workType);
    if (values.contains(_curWorkType)) {
      return _curWorkType;
    } else {
      throw ArgumentError('Unknown work type: ${workType}.');
    }
  }

  int compareTo(value) {
    return _workType.compareTo(value.toString());
  }

  String get value => _workType;
  static List get values => [
        installation,
        removal,
        singumator,
        burial,
        columbarium,
        fence,
        monuments,
        accomplishment,
        cemeteryGoods,
        higherService,
        passengerTransport,
        catafalTransport,
        corpseTransfer,
        ashTransfer,
        farewell,
        cremation,
        ashGiveOut,
        ritualGoods,
        ritualService,
        sanitaryService,
        registrationService,
        corpseStorage,
        embalming,
        vipHallFarewell,
        urnAssembly,
        crematoryAshGiveOut,
        collectDocuments,
        exclusive
      ];

  static Map<WorkType, String> get _englishNamesMap => {
        WorkType.installation: 'installation',
        WorkType.removal: 'removal',
        WorkType.singumator: 'singumator',
        WorkType.burial: 'burial',
        WorkType.columbarium: 'columbarium',
        WorkType.fence: 'fence',
        WorkType.monuments: 'monuments',
        WorkType.accomplishment: 'accomplishment',
        WorkType.cemeteryGoods: 'cemeteryGoods',
        WorkType.higherService: 'higherService',
        WorkType.passengerTransport: 'passengerTransport',
        WorkType.catafalTransport: 'catafalTransport',
        WorkType.corpseTransfer: 'corpseTransfer',
        WorkType.ashTransfer: 'ashTransfer',
        WorkType.farewell: 'farewell',
        WorkType.cremation: 'cremation',
        WorkType.ashGiveOut: 'ashGiveOut',
        WorkType.ritualGoods: 'ritualGoods',
        WorkType.ritualService: 'ritualService',
        WorkType.sanitaryService: 'sanitaryService',
        WorkType.registrationService: 'registrationService',
        WorkType.corpseStorage: 'corpseStorage',
        WorkType.embalming: 'embalming',
        WorkType.vipHallFarewell: 'vipHallFarewell',
        WorkType.urnAssembly: 'urnAssembly',
        WorkType.crematoryAshGiveOut: 'crematoryAshGiveOut',
        WorkType.collectDocuments: 'collectDocuments',
        WorkType.exclusive: 'exclusive',
      };

  String get englishName => _englishNamesMap[this];

  @override
  bool operator ==(dynamic other) {
    if (other is WorkType) {
      return other._workType == _workType;
    }
    return false;
  }

  @override
  int get hashCode => _workType.hashCode;

  String get json => _workType;

  @override
  String toString() => _workType;
}
