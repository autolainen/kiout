import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:aahitest/global_services.dart';
import 'package:aahitest/model/order/order_type.dart';
import 'package:aahitest/services/events.dart';
import 'package:aahitest/services/exceptions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quiver/strings.dart';
import 'package:url_launcher/url_launcher.dart';

/// Преобразует значение долготы к тайлу карты x
int long2tilex(double lon, int z) {
  return ((lon + 180) / 360 * pow(2, z)).floor().toInt();
}

/// Преобразует значение широты к тайлу карты y
int lat2tiley(double lat, int z) {
  return ((1.0 -
              log(tan(lat * pi / 180.0) + 1.0 / cos(lat * pi / 180.0)) / pi) /
          2.0 *
          pow(2.0, z))
      .floor()
      .toInt();
}

/// Однострочный текст небольшого размера
///
/// В случае переполнения строки применяется эффект пропадания
class OneLineText extends Text {
  OneLineText(String data,
      {TextStyle style = const TextStyle(fontSize: 12.0),
      TextAlign textAlign = TextAlign.left})
      : super(
          data,
          textAlign: textAlign,
          style: style,
          overflow: TextOverflow.fade,
          maxLines: 1,
          softWrap: false,
        );
}

const String unbreakableSpace = '\u00a0';
const String rubleSymbol = '\u20bd';

String formatCurrencyAndUnits({String currency = 'руб.', String unit = ''}) {
  final currencyPart = unbreakableSpace +
      (isNotEmpty(currency)
          ? currency.toLowerCase().contains('руб') ? rubleSymbol : currency
          : '');
  final unitsPart = isNotEmpty(unit)
      ? unit.toLowerCase().contains('штук') ? '/шт.' : '/$unit'
      : '';
  return '$currencyPart$unitsPart';
}

String mapOrderTypeDisplayName(OrderType orderType, {bool inEnglish = false}) {
  String result;
  if (orderType == null) {
    result = null;
  } else if (orderType == OrderType.cremation) {
    result = inEnglish ? 'Cremation' : 'Кремация';
  } else if (orderType == OrderType.burial) {
    result = inEnglish ? 'Burial' : 'Захоронение';
  } else if (orderType == OrderType.subburial) {
    result = inEnglish ? 'SubBurial' : 'Подзахоронение';
  } else if (orderType == OrderType.agentService) {
    result = inEnglish ? 'AgentService' : 'Агентские услуги';
  } else if (orderType == OrderType.accomplishment) {
    result = inEnglish ? 'Accomplishment' : 'Благоустройство';
  } else {
    throw ExtAppException('Неизвестный тип заказа');
  }
  return result;
}

/// Загружает файл в оперативную память
Future<Uint8List> downloadFile(String url) async {
  final response = await (await HttpClient().getUrl(Uri.parse(url))).close();
  return consolidateHttpClientResponseBytes(response);
}

/// Создает локальное дату/время с обнуленным временем. Поля даты берутся из аргумента.
DateTime resetTimeToMidnight(DateTime dateTime) {
  return dateTime == null
      ? null
      : DateTime(dateTime.year, dateTime.month, dateTime.day);
}

/// Создает динамический отступ между блоками
Widget createSpacer(int flex) => Flexible(flex: flex, child: Container());

/// Добавляет разделитель между виджетами
///
/// Код скопирован из ListTile.divideTiles и изменен
Iterable<Widget> divideTiles(BuildContext context,
    {@required Iterable<Widget> tiles, @required Widget divider}) sync* {
  assert(tiles != null);
  assert(divider != null || context != null);

  final iterator = tiles.iterator;
  final isNotEmpty = iterator.moveNext();

  var tile = iterator.current;
  while (iterator.moveNext()) {
    yield tile;
    yield divider;
    tile = iterator.current;
  }
  if (isNotEmpty) yield tile;
}

/// Получает цифровой код из СМС
String fetchNumberCodeFromSms(String sms) {
  String code;
  if (sms != null) {
    final intRegex = RegExp(r'\d{4,6}', multiLine: true);
    final match = intRegex.firstMatch(sms);
    code = match?.group(0);
  }
  return code;
}

// TODO migrate to showYesNoDialog from commons
Future<bool> showCloseConfirmationDialog(
    BuildContext context, bool isDataChanged, String title) async {
  return isDataChanged
      ? (await showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                    title: Text(title),
                    content: Text('Закрыть без сохранения изменений?'),
                    actions: <Widget>[
                      FlatButton(
                          child: Text('ЗАКРЫТЬ'),
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          }),
                      FlatButton(
                          child: Text('ОТМЕНА'),
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          })
                    ]);
              })) ??
          false
      : true;
}

Future<bool> launchUrl(String url, {String errorMessage}) async {
  final _errorMessage = errorMessage ?? 'Не удалось открыть ссылку $url';
  var result = false;
  if (await canLaunch(url)) {
    result = await launch(url);
  } else {
    eventBus.fire(ExceptionEvent(ExtAppException(_errorMessage), null, true));
  }
  return result;
}

/*
Future<bool> callSupport() {
  return launchUrl('tel:+' + Settings.supportPhone.phone,
      errorMessage: 'Невозможно выполнить звонок');
}
*/

/// Делает заглавной первую букву строки, остальные буквы строчными
String capFirstLowRest(String input) => input == null || input.isEmpty
    ? input
    : '${input[0].toUpperCase()}${input.substring(1)?.toLowerCase()}';
