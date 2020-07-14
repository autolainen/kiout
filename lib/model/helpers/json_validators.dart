import 'package:kiouttest/model/purchase_price.dart';
import 'package:kiouttest/model/sku.dart';
import 'package:mime/mime.dart';

import '../attachment/attachment.dart';
import '../attachment/attachment_url.dart';
import '../attribute.dart';
import '../exceptions/data_mismatch_exception.dart';

void validateUserJson(dynamic json) {
  if (json is! Map) {
    throw DataMismatchException(
        'Не верный формат json у пользователя - требуется String либо Map');
  }

  if (json['email'] != null && json['email'] is! String) {
    throw DataMismatchException(
        'Неверный формат email ("${json['email']}" - требуется String)\nУ пользователя id: ${json['id']}');
  }
  if (json['phone'] != null && json['phone'] is! String) {
    throw DataMismatchException(
        'Неверный формат телефона ("${json['phone']}" - требуется String)\nУ пользователя id: ${json['id']}');
  }
  if (json['phone_confirmed'] != null && json['phone_confirmed'] is! bool) {
    throw DataMismatchException(
        'Неверный формат признака подтвержденного телефона ("${json['phone_confirmed']}" - требуется bool)\nУ пользователя id: ${json['id']}');
  }
  if (json['username'] != null && json['username'] is! String) {
    throw DataMismatchException(
        'Неверный формат имени пользователя ("${json['username']}" - требуется String)\nУ пользователя id: ${json['id']}');
  }
  if (json['password'] != null && json['password'] is! String) {
    throw DataMismatchException(
        'Неверный формат пароля ("${json['password']}" - требуется String)\nУ пользователя id: ${json['id']}');
  }
  if (json['lastname'] != null && json['lastname'] is! String ||
      json['lastname'] == '') {
    throw DataMismatchException(
        'Неверный формат фамилии ("${json['lastname']}" - требуется не пустой String)\nУ пользователя id: ${json['id']}');
  }
  if (json['firstname'] != null && json['firstname'] is! String ||
      json['firstname'] == '') {
    throw DataMismatchException(
        'Неверный формат имени ("${json['firstname']}" - требуется не пустой String)\nУ пользователя id: ${json['id']}');
  }
  if (json['patronymic'] != null && json['patronymic'] is! String) {
    throw DataMismatchException(
        'Неверный формат отчества ("${json['patronymic']}" - требуется String)\nУ пользователя id: ${json['id']}');
  }
  if (json['status'] != null && json['status'] is! String) {
    throw DataMismatchException(
        'Неверный формат статуса ("${json['status']}" - требуется String)\nУ пользователя id: ${json['id']}');
  }
  if (json['created_at'] != null &&
      json['created_at'] is! String &&
      json['created_at'] is! DateTime) {
    throw DataMismatchException(
        'Неверный формат даты создания ("${json['created_at']}" - требуется String или DateTime)\nУ пользователя id: ${json['id']}');
  }
  if (json['updated_at'] != null &&
      json['updated_at'] is! String &&
      json['updated_at'] is! DateTime) {
    throw DataMismatchException(
        'Неверный формат даты обновления ("${json['updated_at']}" - требуется String или DateTime)\nУ пользователя id: ${json['id']}');
  }
  if (json['no'] != null && json['no'] is! String) {
    throw DataMismatchException(
        'Неверный формат номера пользователя ("${json['no']}" - требуется String)\nУ пользователя id: ${json['id']}');
  }
  if (json['allowed_user_managment'] != null &&
      json['allowed_user_managment'] is! bool) {
    throw DataMismatchException(
        'Неверный формат доступа к редактированю пользователей ("${json['allowed_user_managment']}" - требуется bool)\nУ пользователя id: ${json['id']}');
  }
  if (json['can_receive_sms'] != null && json['can_receive_sms'] is! bool) {
    throw DataMismatchException(
        'Неверный формат разрешения отправки SMS ("${json['can_receive_sms']}" - требуется bool)\nУ пользователя id: ${json['id']}');
  }
  if (json['account'] != null && json['account'] is! String) {
    throw DataMismatchException(
        'Неверный формат идентификатора банковского аккаунта ("${json['account']}" - требуется String)\nУ пользователя id: ${json['id']}');
  }
  if (json['role'] != null && json['role'] is! String) {
    throw DataMismatchException(
        'Неверный формат роли ("${json['role']}" - требуется String)\nУ пользователя id: ${json['id']}');
  }
  if (json['authority'] != null && json['authority'] is! Map<String, dynamic>) {
    throw DataMismatchException(
        'Неверный формат доверенности ("${json['authority']}" - требуется Map<String, dynamic>)\nУ пользователя id: ${json['id']}');
  }
  if (json['groups'] != null && json['groups'] is! List) {
    throw DataMismatchException(
        'Неверный формат групп пользователей ("${json['groups']}" - требуется List)\nУ пользователя id: ${json['id']}');
  }
  if (json['group'] != null && json['group'] is! String) {
    throw DataMismatchException(
        'Неверный формат группы пользователей ("${json['group']}" - требуется String)\nУ пользователя id: ${json['id']}');
  }
  if (json['selling_point'] != null && json['selling_point'] is! String) {
    throw DataMismatchException(
        'Неверный формат точки продаж ("${json['selling_point']}" - требуется String)\nУ агента id: ${json['id']}');
  }
  if (json['id_contractor'] != null && json['id_contractor'] is! String) {
    throw DataMismatchException(
        'Неверный формат идентификатора организации ("${json['id_contractor']}" - требуется String)\nУ пользователя id: ${json['id']}');
  }
  if (json['work_category'] != null && json['work_category'] is! String) {
    throw DataMismatchException(
        'Неверный формат категории работ подрядчика ("${json['work_category']}" - требуется String)\nУ исполнителя подрядчика id: ${json['id']}');
  }
  if (json['device_token'] != null && json['device_token'] is! String) {
    throw DataMismatchException(
        'Неверный формат токена устройства ("${json['device_token']}" - требуется String)\nУ исполнителя подрядчика id: ${json['id']}');
  }
  if (json['can_do'] != null && json['can_do'] is! List) {
    throw DataMismatchException(
        'Неверный формат списка доступных категорий работ на кладбище ("${json['can_do']}" - требуется List)\nУ исполнителя подрядчика id: ${json['id']}');
  }
  if (json['referrer_manager'] != null && json['referrer_manager'] is! String) {
    throw DataMismatchException(
        'Неверный формат идентификатора менеджера внешних агентов ("${json['referrer_manager']}" - требуется String)\nУ внешнего агента id: ${json['id']}');
  }
}

void validateBaseOrderDataJson(dynamic json) {
  if (json is! Map) {
    throw DataMismatchException(
        'Не верный формат json у заказа - требуется String либо Map');
  }

  if (json['id'] != null && json['_id'] != null) {
    throw DataMismatchException(
        'Идентификатор заказа указан в двух атрибутах: id и _id ("${json['id']} ~ ${json['_id']}" - требуется один)');
  }

  if (json['no'] != null && json['no'] is! String) {
    throw DataMismatchException(
        'Неверный формат номера ("${json['no']}" - требуется String)\nУ заказа id: ${json['id']}');
  }
  if (json['agent'] != null && json['agent'] is! Map<String, dynamic>) {
    throw DataMismatchException(
        'Неверный формат агента ("${json['agent']}" - требуется Map<String, dynamic>)\nУ заказа id: ${json['id']}');
  }
  if (json['client'] != null && json['client'] is! Map<String, dynamic>) {
    throw DataMismatchException(
        'Неверный формат клиента ("${json['client']}" - требуется Map<String, dynamic>)\nУ заказа id: ${json['id']}');
  }
  if (json['deceased'] != null && json['deceased'] is! Map<String, dynamic>) {
    throw DataMismatchException(
        'Неверный формат усопшего ("${json['deceased']}" - требуется Map<String, dynamic>)\nУ заказа id: ${json['id']}');
  }
  if (json['cemetery'] != null && json['cemetery'] is! String) {
    throw DataMismatchException(
        'Неверный формат кладбища ("${json['cemetery']}" - требуется String)\nУ заказа id: ${json['id']}');
  }
  if (json['comments'] != null && json['comments'] is! List) {
    throw DataMismatchException(
        'Неверный формат списка комментариев ("${json['comments']}" - требуется List)\nУ заказа id: ${json['id']}');
  }
  if (json['created_at'] != null &&
      json['created_at'] is! String &&
      json['created_at'] is! DateTime) {
    throw DataMismatchException(
        'Неверный формат даты создания ("${json['created_at']}" - требуется String или DateTime)\nУ заказа id: ${json['id']}');
  }
  if (json['updated_at'] != null &&
      json['updated_at'] is! String &&
      json['updated_at'] is! DateTime) {
    throw DataMismatchException(
        'Неверный формат даты обновления ("${json['updated_at']}" - требуется String или DateTime)\nУ заказа id: ${json['id']}');
  }
  if (json['geo_position'] != null &&
      json['geo_position'] is! Map<String, dynamic>) {
    throw DataMismatchException(
        'Неверный формат гео позиции ("${json['geo_position']}" - требуется Map<String, dynamic> или DateTime)\nУ заказа id: ${json['id']}');
  }
  if (json['documents'] != null && json['documents'] is! List) {
    throw DataMismatchException(
        'Неверный формат списка документов/услуг ("${json['documents']}" - требуется List)\nУ заказа id: ${json['id']}');
  }
}

void validatePreorderDataJson(dynamic json) {
  if (json['referrer'] != null && json['referrer'] is! Map<String, dynamic>) {
    throw DataMismatchException(
        'Неверный формат внешнего агента ("${json['referrer']}" - требуется Map<String, dynamic>)\nУ предзаказа id: ${json['id']}');
  }
  if (json['referrers_manager'] != null &&
      json['referrers_manager'] is! Map<String, dynamic>) {
    throw DataMismatchException(
        'Неверный формат менеджера внешних агентов ("${json['referrers_manager']}" - требуется Map<String, dynamic>)\nУ предзаказа id: ${json['id']}');
  }
  if (json['representative'] != null &&
      json['representative'] is! Map<String, dynamic>) {
    throw DataMismatchException(
        'Неверный формат представителя ("${json['representative']}" - требуется Map<String, dynamic>)\nУ предзаказа id: ${json['id']}');
  }
  if (json['operator_cc'] != null &&
      json['operator_cc'] is! Map<String, dynamic>) {
    throw DataMismatchException(
        'Неверный формат оператора колл-центра ("${json['operator_cc']}" - требуется Map<String, dynamic>)\nУ предзаказа id: ${json['id']}');
  }
  if (json['items'] != null && json['items'] is! List) {
    throw DataMismatchException(
        'Неверный формат списка товаров/услуг ("${json['items']}" - требуется List)\nУ предзаказа id: ${json['id']}');
  }
  if (json['status'] != null && json['status'] is! String) {
    throw DataMismatchException(
        'Неверный формат статуса ("${json['status']}" - требуется String)\nУ предзаказа id: ${json['id']}');
  }
  if (json['type'] != null && json['type'] is! String) {
    throw DataMismatchException(
        'Неверный формат типа ("${json['type']}" - требуется String)\nУ предзаказа id: ${json['id']}');
  }
  if (json['assigned_at'] != null &&
      json['assigned_at'] is! String &&
      json['assigned_at'] is! DateTime) {
    throw DataMismatchException(
        'Неверный формат даты назначения ("${json['assigned_at']}" - требуется String или DateTime)\nУ предзаказа id: ${json['id']}');
  }
  if (json['plot_position'] != null &&
      json['plot_position'] is! Map<String, dynamic>) {
    throw DataMismatchException(
        'Неверный формат гео позиции участка ("${json['plot_position']}" - требуется Map<String, dynamic>)\nУ предзаказа id: ${json['id']}');
  }
}

void validateItemJson(dynamic json) {
  if (json is! Map) {
    throw DataMismatchException(
        'Не верный формат json у позиции заказа - требуется String либо Map');
  }

  if (json['id_origin'] != null && json['id_origin'] is! String) {
    throw DataMismatchException(
        'Неверный формат идентификатора оригинального товара или услуги ("${json['id_origin']}" - требуется String)\nУ позиции заказа id: ${json['id']}');
  }
  if (json['sku'] != null && json['sku'] is! String) {
    throw DataMismatchException(
        'Неверный формат артикула ("${json['sku']}" - требуется String)\nУ позиции заказа id: ${json['id']}');
  }
  if (json['type'] != null && json['type'] is! List) {
    throw DataMismatchException(
        'Неверный формат типа ("${json['type']}" - требуется List)\nУ позиции заказа id: ${json['id']}');
  }
  if (json['norm'] != null && json['norm'] is! num) {
    throw DataMismatchException(
        'Неверный формат нормы исполнения услуги ("${json['norm']}" - требуется num)\nУ позиции заказа id: ${json['id']}');
  }
  if (json['name'] != null && json['name'] is! String) {
    throw DataMismatchException(
        'Неверный формат названия ("${json['name']}" - требуется String)\nУ позиции заказа id: ${json['id']}');
  }
  if (json['description'] != null && json['description'] is! String) {
    throw DataMismatchException(
        'Неверный формат описания ("${json['description']}" - требуется String)\nУ позиции заказа id: ${json['id']}');
  }
  if (json['amount'] != null &&
      json['amount'] is! String &&
      json['amount'] is! int &&
      json['amount'] is! num) {
    throw DataMismatchException(
        'Неверный формат количества, идущего в заказ ("${json['amount']}" - требуется String или int или num)\nУ позиции заказа id: ${json['id']}');
  }
  if (json['unit'] != null && json['unit'] is! String) {
    throw DataMismatchException(
        'Неверный формат единицы измерения ("${json['unit']}" - требуется String)\nУ позиции заказа id: ${json['id']}');
  }
  if (json['fee'] != null && json['fee'] is! num) {
    throw DataMismatchException(
        'Неверный формат комиссии ("${json['fee']}" - требуется num)\nУ позиции заказа id: ${json['id']}');
  }
  if (json['price'] != null && json['price'] is! num) {
    throw DataMismatchException(
        'Неверный формат цены ("${json['price']}" - требуется num)\nУ позиции заказа id: ${json['id']}');
  }
  if (json['purchase_price'] != null &&
      json['purchase_price'] is! Map<String, dynamic>) {
    throw DataMismatchException(
        'Неверный формат закупочной цены ("${json['purchase_price']}" - требуется Map<String, dynamic>)\nУ позиции заказа id: ${json['id']}');
  }
  if (json['currency'] != null && json['currency'] is! String) {
    throw DataMismatchException(
        'Неверный формат валюты ("${json['currency']}" - требуется String)\nУ позиции заказа id: ${json['id']}');
  }
  if (json['photo'] != null && json['photo'] is! List) {
    throw DataMismatchException(
        'Неверный формат списка фото ("${json['photo']}" - требуется List)\nУ позиции заказа id: ${json['id']}');
  }
  if (json['attributes'] != null && json['attributes'] is! List) {
    throw DataMismatchException(
        'Неверный формат списка аттрибутов ("${json['attributes']}" - требуется List)\nУ позиции заказа id: ${json['id']}');
  }
  if (json['created_at'] != null &&
      json['created_at'] is! String &&
      json['created_at'] is! DateTime) {
    throw DataMismatchException(
        'Неверный формат даты создания ("${json['created_at']}" - требуется String или DateTime)\nУ позиции заказа id: ${json['id']}');
  }
  if (json['updated_at'] != null &&
      json['updated_at'] is! String &&
      json['updated_at'] is! DateTime) {
    throw DataMismatchException(
        'Неверный формат даты обновления ("${json['updated_at']}" - требуется String или DateTime)\nУ позиции заказа id: ${json['id']}');
  }

  if (json['vatRate'] != null && json['vatRate'] is! num) {
    throw DataMismatchException(
        'Неверный формат размера НДС ("${json['discount']}" - требуется num)\nУ позиции заказа id: ${json['id']}');
  }
  if (json['items'] != null && json['items'] is! List) {
    throw DataMismatchException(
        'Неверный формат подпозиций заказа ("${json['items']}" - требуется List)\nУ позиции заказа id: ${json['id']}');
  }
  final Sku sku = Sku(json['sku']);
  if (sku != null) {
    if (!fetchItemTypes(json).contains(sku.itemType.toString())) {
      throw DataMismatchException(
          'Не совпадает артикул и тип ("${json['sku']}, ${json['type']}")\nУ позиции заказа id: ${json['id']}');
    }
  }
}

List<Attribute> fetchItemAttributes(json) {
  var _attributes = <Attribute>[];

  try {
    Attribute _attribute;
    if (json['attributes'] != null) {
      (json['attributes'] as List).forEach((attribute) {
        _attribute = Attribute.fromJson(attribute);
        if (_attribute != null) {
          _attributes.add(_attribute);
        }
      });
    }
  } catch (e) {
    throw DataMismatchException(e is Error
        ? e.toString()
        : e.message + '\nУ позиции заказа id: ${json['id']}');
  }
  return _attributes.isEmpty ? null : _attributes;
}

List<Attachment> fetchItemPhotos(json) {
  var _photos = <Attachment>[];

  try {
    _photos = List<Attachment>.from(json['photo']
            ?.map((photo) => Attachment(
                url: AttachmentUrl.fromJson(photo.toString()),
                mimeType: lookupMimeType(photo.toString())))
            ?.toList() ??
        []);
  } catch (e) {
    throw DataMismatchException(e is Error
        ? e.toString()
        : e.message + '\nУ позиции заказа id: ${json['id']}');
  }
  return _photos.isEmpty ? null : _photos;
}

List<String> fetchItemTypes(Map json) => List<String>.from(
    json['type']?.map((type) => type.toString())?.toList() ?? <String>[]);

PurchasePrice fetchPurchasePrice(json) {
  PurchasePrice _purchasePrice;
  try {
    _purchasePrice = PurchasePrice.fromJson(json['purchase_price']);
  } catch (e) {
    throw DataMismatchException(e is Error
        ? e.toString()
        : e.message + '\nУ позиции заказа id: ${json['id']}');
  }
  return _purchasePrice;
}
