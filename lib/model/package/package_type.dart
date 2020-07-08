import 'package:data_model/data_model.dart';

/// Тип пакета услуг/товаров
///
/// возможные типы:
/// * package - пакет
/// * main - основной
/// * additional - дополнительный
/// * beforeCemetery - до кладбища
/// * atCemetery - на кладбище
/// * burial - захоронение
/// * subburial - подзахоронение
/// * coffin - гроб
/// * urn - урна
/// * civil - гражданский
/// * child - детский
/// * muslim - мусульманский
/// * cremation - кремация
/// * farewell - с прощанием
/// * falseСremation - фальш-кремация
/// * columbarium - колумбарий
/// * installation - монтаж
/// * arrangement - оформление
/// * adult - взрослый
/// * agentService - агентские услуги
/// * collectDocuments - сбор документов
class PackageType implements JsonEncodable {
  /// пакет
  static const PackageType package = PackageType._('пакет');

  /// основной
  static const PackageType main = PackageType._('основной');

  /// дополнительный
  static const PackageType additional = PackageType._('дополнительный');

  /// до кладбища
  static const PackageType beforeCemetery = PackageType._('до кладбища');

  /// на кладбище
  static const PackageType atCemetery = PackageType._('на кладбище');

  /// захоронение
  static const PackageType burial = PackageType._('захоронение');

  /// подзахоронение
  static const PackageType subburial = PackageType._('подзахоронение');

  /// гроб
  static const PackageType coffin = PackageType._('гроб');

  /// урна
  static const PackageType urn = PackageType._('урна');

  /// гражданский
  static const PackageType civil = PackageType._('гражданский');

  /// детский
  static const PackageType child = PackageType._('детский');

  /// мусульманский
  static const PackageType muslim = PackageType._('мусульманский');

  /// кремация
  static const PackageType cremation = PackageType._('кремация');

  /// с прощанием
  static const PackageType farewell = PackageType._('с прощанием');

  /// фальш-кремация
  static const PackageType falseCremation = PackageType._('фальш-кремация');

  /// колумбарий
  static const PackageType columbarium = PackageType._('колумбарий');

  /// монтаж
  static const PackageType installation = PackageType._('монтаж');

  /// оформление
  static const PackageType arrangement = PackageType._('оформление');

  /// взрослый
  static const PackageType adult = PackageType._('взрослый');

  /// агентские услуги
  static const PackageType agentService = PackageType._('агентские услуги');

  /// сбор документов
  static const PackageType collectDocuments = PackageType._('сбор документов');

  final String _type;

  /// Создает тип пакета
  const PackageType._(String type) : _type = type;

  factory PackageType(String type) {
    if (type == null) return null;
    PackageType _curType = PackageType._(type);
    if (values.contains(_curType)) {
      return _curType;
    } else {
      throw ArgumentError('Invalid package type: ${type}.');
    }
  }

  String get value => _type;
  static List get values => [
        package,
        main,
        additional,
        beforeCemetery,
        atCemetery,
        burial,
        subburial,
        coffin,
        urn,
        civil,
        child,
        muslim,
        cremation,
        farewell,
        falseCremation,
        columbarium,
        installation,
        arrangement,
        adult,
        agentService,
        collectDocuments
      ];

  @override
  bool operator ==(dynamic other) {
    if (other is PackageType) {
      return other._type == _type;
    }
    return false;
  }

  @override
  int get hashCode => _type.hashCode;

  String get json => _type;

  @override
  String toString() => json;
}
