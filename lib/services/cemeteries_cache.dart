import 'package:aahitest/global_services.dart';
import 'package:aahitest/model/cemetery.dart';
import 'package:aahitest/model/order/order_type.dart';
import 'package:aahitest/services/events.dart';
import 'package:hive/hive.dart';
import 'package:pedantic/pedantic.dart';

import 'helpers.dart';

class CemeteriesCache {
  static final String boxName = 'cemetery';
  final Duration cacheDuration;

  CemeteriesCache({this.cacheDuration = const Duration(hours: 24)});

  Future<List<Cemetery>> find(OrderType orderType) async {
    return <Cemetery>[Cemetery.fromJson(MockCemetery.json),
      Cemetery.fromJson(MockCemetery.json2)];

/*
    final cemeteryBox = service<Box<CemeteryCacheItem>>();

    final cemeteryIdListKey =
        'cemeteryList' + mapOrderTypeDisplayName(orderType, inEnglish: true);

    var cachedCemeteryIdList = cemeteryBox.get(cemeteryIdListKey);
    try {
      if (cachedCemeteryIdList == null ||
          DateTime.now().difference(cachedCemeteryIdList.cacheAddTime) >=
              cacheDuration) {

        final cemeteryList = CemeteryCacheItem(DateTime.now(), cemeteryIds: []);
        final cemeteries = await service<CemeteriesClient>()
            .find(orderType: orderType, active: true, closed: false);
        cemeteries.forEach((cemetery) async {
          final cemeteryWrapper =
              CemeteryCacheItem(DateTime.now(), cemetery: cemetery);
          unawaited(cemeteryBox.put(cemetery.id.toString(), cemeteryWrapper));
          cemeteryList.cemeteryIds.add(cemetery.id.toString());

        });
        unawaited(cemeteryBox.put(cemeteryIdListKey, cemeteryList));
        cachedCemeteryIdList = cemeteryList;
      }
    } catch (e, s) {
      eventBus.fire(ExceptionEvent(e, s, false));
      if (cachedCemeteryIdList == null) {
        rethrow;
      }
    }
    return cachedCemeteryIdList.cemeteryIds.map<Cemetery>((cemeteryId) {
      return cemeteryBox.get(cemeteryId.toString()).cemetery;
    }).toList()
      ..sort((a, b) => a.name.compareTo(b.name));
*/
  }

/*
  Future<Cemetery> read(CemeteryId cemeteryId) async {
    Cemetery result;
    if (cemeteryId != null) {
      final cemeteryIdStr = cemeteryId.toString();
      final cemeteryBox = service<Box<CemeteryCacheItem>>();
      var cemeteryWrapper = cemeteryBox.get(cemeteryIdStr);
      if (cemeteryWrapper == null) {
        final cemetery = await service<CemeteriesClient>().read(cemeteryId);
        cemeteryWrapper =
            CemeteryCacheItem(DateTime.now(), cemetery: cemetery as Cemetery);
        unawaited(cemeteryBox.put(cemeteryIdStr, cemeteryWrapper));
      }
      result = cemeteryWrapper.cemetery;
    }
    return result;
  }
*/
}

class MockCemetery {
  static Map<String, dynamic> json = {
    'name': 'Богородское кладбище (Ногинск)',
    'photo_url':
    'https://s3-eu-west-1.amazonaws.com/gravemap.ru/bogorodskoenoginsk/',
    'created_at': '2016-12-29T12:34:46.000Z',
    'updated_at': '2016-12-29T12:34:46.000Z',
    'geom': {
      'type': 'Polygon',
      'coordinates': [
        [
          [38.3129379146312, 55.7700756949708],
          [38.320359496218, 55.7680294324504],
          [38.316518487711, 55.7635748191973],
          [38.3142725741029, 55.7640825609532],
          [38.3119337338917, 55.7645989624781],
          [38.3104007082089, 55.764888173106],
          [38.3094983718204, 55.7650759501642],
          [38.3095323667885, 55.7654802673359],
          [38.3082006994618, 55.7654927413774],
          [38.3080736482265, 55.7653638725993],
          [38.3076758779664, 55.7655918152225],
          [38.3073514036552, 55.7658594039238],
          [38.307544669712, 55.7691947714723],
          [38.3129379146312, 55.7700756949708]
        ]
      ]
    },
    'active': true,
    'closed': false,
    'address': 'Московская область, Ногинский р-он, дер. Тимохово',
    'id': 'hRxPBDzF'
  };
  static Map<String, dynamic> json2 = {
    'name': 'Богородское кладбище',
    'photo_url':
    'https://s3-eu-west-1.amazonaws.com/gravemap.ru/bogorodskoenoginsk/',
    'created_at': '2016-12-29T12:34:46.000Z',
    'updated_at': '2016-12-29T12:34:46.000Z',
    'geom': {
      'type': 'Polygon',
      'coordinates': [
        [
          [38.3129379146312, 55.7700756949708],
          [38.320359496218, 55.7680294324504],
          [38.316518487711, 55.7635748191973],
          [38.3142725741029, 55.7640825609532],
          [38.3119337338917, 55.7645989624781],
          [38.3104007082089, 55.764888173106],
          [38.3094983718204, 55.7650759501642],
          [38.3095323667885, 55.7654802673359],
          [38.3082006994618, 55.7654927413774],
          [38.3080736482265, 55.7653638725993],
          [38.3076758779664, 55.7655918152225],
          [38.3073514036552, 55.7658594039238],
          [38.307544669712, 55.7691947714723],
          [38.3129379146312, 55.7700756949708]
        ]
      ]
    },
    'active': true,
    'closed': false,
    'address': 'Московская область, Ногинский р-он, дер. Тимохово',
    'district': '7JYONI6p',
    'id': 'hRxPBdxu'
  };
}