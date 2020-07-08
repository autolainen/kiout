import 'package:data_model/data_model.dart';

import 'datetime/to_local_date_time.dart';
import 'exceptions/data_mismatch_exception.dart';

/// Класс реализующий данные о документах заказа/наряда
class Document implements Model<DocumentId> {
  /// Идентификатор документа
  DocumentId id;

  /// Тип документа
  DocumentType type;

  /// Название документа
  String name;

  /// Расположение файла
  String file;

  /// Полный Url ведущий к файлу
  String url;

  /// Дата создания
  DateTime createdAt;

  Document(
      {this.id, this.type, this.name, this.file, this.url, DateTime createdAt})
      : this.createdAt = createdAt?.toLocal();

  /// Создает документ из JSON-данных
  factory Document.fromJson(dynamic json) {
    if (json == null) return null;

    if (json is String) {
      return Document(id: DocumentId(json));
    }

    if (json is! Map) {
      throw DataMismatchException(
          'Не верный формат json у документа - требуется String либо Map');
    }

    if (json['id'] != null && json['_id'] != null) {
      throw DataMismatchException(
          'Идентификатор документа указан в двух атрибутах: id и _id ("${json['id']} ~ ${json['_id']}" - требуется один)');
    }

    if (json['type'] != null && json['type'] is! String) {
      throw DataMismatchException(
          'Неверный формат типа документа ("${json['type']}" - требуется String)\nУ документа id: ${json['id']}');
    }

    if (json['name'] != null && json['name'] is! String) {
      throw DataMismatchException(
          'Неверный формат названия ("${json['name']}" - требуется String)\nУ документа id: ${json['id']}');
    }

    if (json['file'] != null && json['file'] is! String) {
      throw DataMismatchException(
          'Неверный формат расположения файла ("${json['file']}" - требуется String)\nУ документа id: ${json['id']}');
    }

    if (json['url'] != null && json['url'] is! String) {
      throw DataMismatchException(
          'Неверный формат полного url файла ("${json['url']}" - требуется String)\nУ документа id: ${json['id']}');
    }

    if (json['created_at'] != null &&
        json['created_at'] is! String &&
        json['created_at'] is! DateTime) {
      throw DataMismatchException(
          'Неверный формат даты создания ("${json['created_at']}" - требуется String или DateTime)\nУ документа id: ${json['id']}');
    }

    DocumentType _documentType;
    try {
      _documentType = DocumentType(json['type']);
    } catch (e) {
      throw DataMismatchException((e is Error ? e.toString() : e.message) +
          '\nУ документа id: ${json['id']}');
    }

    DocumentId id;
    if (json['_id'] != null) {
      id = DocumentId(
          json['_id'] is String ? json['_id'] : json['_id']?.toHexString());
    } else {
      id = DocumentId(json['id']);
    }

    return Document(
        id: id,
        type: _documentType,
        name: json['name'],
        file: json['file'],
        url: json['url'],
        createdAt: toLocalDateTime(json['created_at']));
  }

  @override
  String toString() => json.toString();

  /// Возвращает данные документа в JSON-формате (String/Map)
  ///   String - когда в объекте был заполнен только id
  ///   Map - в ином случае
  @override
  dynamic get json {
    Map<String, dynamic> json = {
      'id': id?.json,
      'type': type?.json,
      'name': name,
      'file': file,
      'url': url,
      'created_at': createdAt?.toUtc()
    }..removeWhere((key, value) => value == null);

    if (json.keys.length == 1 && json.keys.first == 'id') return json['id'];

    return json;
  }
}

/// Идентификатор документа
class DocumentId extends ObjectId {
  DocumentId._(dynamic id) : super(id);
  factory DocumentId(id) {
    if (id == null) return null;
    return DocumentId._(id);
  }
}

/// Тип документа
///
/// возможный тип документа:
/// clientPassport - паспорт заказчика
/// identificationDocument - удостоверение личности
/// deceasedPassport - паспорт усопшего
/// check - чек
/// certificateOfCivilRegistration - св-во ЗАГС
/// other - другой документ
class DocumentType implements JsonEncodable {
  /// Паспорт заказчика
  static const DocumentType customerPassport =
      DocumentType._('паспорт заказчика');

  /// Удостоверение личности
  static const DocumentType identificationDocument =
      DocumentType._('удостоверение личности');

  /// Паспорт усопшего
  static const DocumentType deceasedPassport =
      DocumentType._('паспорт усопшего');

  /// Чек
  static const DocumentType check = DocumentType._('чек');

  /// Свидетельство ЗАГС
  static const DocumentType certificateOfCivilRegistration =
      DocumentType._('св-во ЗАГС');

  /// Согласие на подзахоронение
  static const DocumentType subburialConsent =
      DocumentType._('согласие на подзахоронение');

  /// Приложение-анкета
  static const DocumentType orderInfo = DocumentType._('приложение-анкета');

  /// Cчёт-договор
  static const DocumentType contract = DocumentType._('счёт-договор');

  /// Акт
  static const DocumentType act = DocumentType._('акт');

  /// Удостоверение на участок
  static const DocumentType plotCertificate =
      DocumentType._('удостоверение на участок');

  /// Cправка о смерти
  static const DocumentType deathCertificate =
      DocumentType._('справка о смерти');

  /// Предварительный заказ
  static const DocumentType preOrder = DocumentType._('предварительный заказ');

  /// Cвидетельствово о смерти ранее захороненного лица
  static const DocumentType buriedPersonCertificate =
      DocumentType._('cв-во о смерти ранее захороненного лица');

  /// Разрешение на проведение подзахоронения
  static const DocumentType burialPermission =
      DocumentType._('разрешение на проведение подзахоронения');

  /// Подтверждающий родство документ
  static const DocumentType kinshipAffirmation =
      DocumentType._('подтверждающий родство документ');

  /// Подтверждение скидки
  static const DocumentType discountAffirmation =
      DocumentType._('подтверждение скидки');

  /// Фотография участка
  static const DocumentType plotPhoto = DocumentType._('фотография участка');

  /// Карточки
  static const DocumentType cards = DocumentType._('карточки');

  /// Cправка и получение
  static const DocumentType getAshesCertificate =
      DocumentType._('справка и получение');

  /// Заявление
  static const DocumentType statement = DocumentType._('заявление');

  /// Cопроводительный лист
  static const DocumentType accompanyingDocument =
      DocumentType._('сопроводительный лист');

  /// Доверенность
  static const DocumentType powerOfAttorney = DocumentType._('доверенность');

  /// Акт к дополнительному соглашению
  static const DocumentType actSupplementaryAgreement =
      DocumentType._('акт к дополнительному соглашению');

  /// Дополнительное соглашение
  static const DocumentType supplementaryAgreement =
      DocumentType._('дополнительное соглашение');

  /// Паспорт клиента
  static const DocumentType clientPassport = DocumentType._('паспорт клиента');

  /// Заявление на демонтаж
  static const DocumentType dismantlingApplication =
      DocumentType._('заявление на демонтаж');

  /// Соглашение на обработку персональных данных
  static const DocumentType agreementForProcessingOfPersonalData =
      DocumentType._('соглашение на обработку персональных данных');

  /// Иной документ
  static const DocumentType other = DocumentType._('другой документ');

  final String _type;

  // Создает тип документа
  const DocumentType._(String type) : _type = type;

  factory DocumentType(String type) {
    if (type == null) return null;
    DocumentType _curType = DocumentType._(type);
    if (values.contains(_curType)) {
      return _curType;
    } else {
      throw ArgumentError('Invalid documents type: ${type}.');
    }
  }

  final Map<String, String> _typeStr = const {
    'паспорт заказчика': 'Паспорт заказчика',
    'удостоверение личности': 'Удостоверение личности',
    'паспорт усопшего': 'Паспорт усопшего',
    'чек': 'Чек',
    'св-во ЗАГС': 'Свидетельство ЗАГС',
    'счёт-договор': 'Счёт-договор',
    'акт': 'Акт',
    'удостоверение на участок': 'Удостоверение на участок',
    'справка о смерти': 'Справка о смерти',
    'предварительный заказ': 'Предварительный заказ',
    'cв-во о смерти ранее захороненного лица':
        'Свидетельство о смерти ранее захороненного лица',
    'разрешение на проведение подзахоронения':
        'Разрешение на проведение подзахоронения',
    'подтверждающий родство документ': 'Подтверждающий родство документ',
    'подтверждение скидки': 'Подтверждение скидки',
    'фотография участка': 'Фотография участка',
    'карточки': 'Карточки',
    'справка и получение': 'Справка и получение',
    'заявление': 'Заявление',
    'сопроводительный лист': 'Сопроводительный лист',
    'доверенность': 'Доверенность',
    'акт к дополнительному соглашению': 'Акт к дополнительному соглашению',
    'дополнительное соглашение': 'Дополнительное соглашение',
    'паспорт клиента': 'Паспорт клиента',
    'заявление на демонтаж': 'Заявление на демонтаж',
    'соглашение на обработку персональных данных':
        'Соглашение на обработку персональных данных',
    'согласие на подзахоронение': 'Согласие на подзахоронение',
    'приложение-анкета': 'Приложение-анкета',
    'другой документ': 'Другой документ'
  };

  String get value => _type;
  static List get values => [
        customerPassport,
        identificationDocument,
        deceasedPassport,
        check,
        certificateOfCivilRegistration,
        other,
        subburialConsent,
        orderInfo,
        contract,
        plotCertificate,
        deathCertificate,
        act,
        preOrder,
        buriedPersonCertificate,
        burialPermission,
        kinshipAffirmation,
        discountAffirmation,
        plotPhoto,
        cards,
        getAshesCertificate,
        statement,
        accompanyingDocument,
        powerOfAttorney,
        actSupplementaryAgreement,
        supplementaryAgreement,
        clientPassport,
        dismantlingApplication,
        agreementForProcessingOfPersonalData
      ];

  @override
  bool operator ==(dynamic other) {
    if (other is DocumentType) {
      return other._type == _type;
    }
    return false;
  }

  @override
  int get hashCode => _type.hashCode;

  String get json => _type;

  @override
  String toString() => _typeStr[_type];
}
