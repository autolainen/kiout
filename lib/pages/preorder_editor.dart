import 'package:aahitest/model/geo/point.dart';
import 'package:aahitest/services/form_data.dart';
import 'package:aahitest/services/helpers.dart';
import 'package:aahitest/services/preorder_editor_bloc.dart';
import 'package:aahitest/widgets/cemetery_selector_form.dart';
import 'package:aahitest/widgets/navigation_bar.dart';
import 'package:aahitest/widgets/page_navigator.dart';
import 'package:aahitest/widgets/properties_list_form.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

/// Универсальный UI контейнер для редактирования всех типов предзаказов.
///
/// Содержит элементы навигации, название формы,
/// инициализирует отображение форм (страниц)
class PreorderEditor extends StatefulWidget {
  final PreorderEditorBloc _preorderEditorBloc;

  const PreorderEditor(PreorderEditorBloc preorderEditorBloc, {Key key})
      : _preorderEditorBloc = preorderEditorBloc,
        super(key: key);

  @override
  _PreorderEditorState createState() => _PreorderEditorState();
}

class _PreorderEditorState extends State<PreorderEditor> {
  PreorderEditorBloc _preorderEditorBloc;
  Point _geoPosition;

  @override
  void initState() {
    super.initState();
    _preorderEditorBloc = widget._preorderEditorBloc;
    _preorderEditorBloc.currentPageIndex.listen((data) {
      final formData = _preorderEditorBloc.pagesData[data];
      final orderTypeDisplayName = mapOrderTypeDisplayName(
          _preorderEditorBloc.orderType,
          inEnglish: true);
      FirebaseAnalytics().setCurrentScreen(
          screenName: orderTypeDisplayName + '.' + formData.title,
          screenClassOverride: orderTypeDisplayName);
    });
/*
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _geoPosition = await logOrderStartEvent(
          context,
          _preorderEditorBloc.orderType,
          _mapGeoPositionReasonMsg(_preorderEditorBloc.orderType));
    });
*/
  }

/*
  String _mapGeoPositionReasonMsg(OrderType orderType) {
    String result;
    if (OrderType.burial == orderType || OrderType.subburial == orderType) {
      result = 'для определения расстояния до ближайшего кладбища';
    } else if (OrderType.cremation == orderType ||
        OrderType.agentService == orderType) {
      result = 'для назначения ближайшего менеджера';
    } else {
      result = ''; // should never get here
    }
    return result;
  }
*/

  @override
  void dispose() {
    _preorderEditorBloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final closeConfirmationTitle = 'Редактор заказа';
    return StreamBuilder<bool>(
        initialData: false,
        stream: _preorderEditorBloc.isDataChanged,
        builder: (context, snapshot) {
          return WillPopScope(
              onWillPop: () async {
                return showCloseConfirmationDialog(
                    context, snapshot.data, closeConfirmationTitle);
              },
              child: Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  leading: IconButton(
                      tooltip: 'Закрыть',
                      icon: Icon(Icons.close),
                      onPressed: () async {
                        if (await showCloseConfirmationDialog(
                            context, snapshot.data, closeConfirmationTitle)) {
                          Navigator.of(context).pop();
                        }
                      }),
                  title: Text(
                      mapOrderTypeDisplayName(_preorderEditorBloc.orderType),
                      textAlign: TextAlign.left),
                ),
                body: _createBody(context, _preorderEditorBloc),
              ));
        });
  }

  Widget _createBody(
      BuildContext context, PreorderEditorBloc preorderEditorBloc) {
    return StreamBuilder<int>(
      initialData: 0,
      builder: (context, snapshot) {
        final formData = preorderEditorBloc.pagesData[snapshot.data];
        Widget form;
        // порядок проверок имеет значение из-за наследования типов formData
/*
        if (formData is AgentServiceDeceasedFormData) {
          form = _addPaddingAndScroll(AgentServiceDeceasedForm(formData),
              key: formData?.title);
        } else
*/
          if (formData is ClientFormData || formData is DeceasedFormData) {
          form = _addPaddingAndScroll(PropertiesListForm(formData),
              key: formData?.title, horizontalPadding: 0);
        } else if (formData is CemeterySelectorFormData) {
          form = CemeterySelectorForm(formData, _geoPosition);
/*
        } else if (formData is PackageSelectorFormData) {
          form = PackageSelectorForm(formData);
        } else if (formData is PlotSelectorFormData) {
          form = PlotSelectorForm(formData);
        } else if (formData is AddressFormData) {
          form =
              _addPaddingAndScroll(AddressForm(formData), key: formData?.title);
        } else if (formData is HallReservationFormData) {
          form = HallReservationForm(formData);
        } else if (formData is ExtraServiceSelectorFormData) {
          form = ExtraServiceSelectorForm(formData);
        } else if (formData is SummaryFormData) {
          form = SummaryForm(formData, _geoPosition);
        } else if (formData is PersonFormData) {
          form =
              _addPaddingAndScroll(PersonForm(formData), key: formData?.title);
*/
        } else {
          // in case we could not find appropriate view by form data type
          form = Container();
        }
        return Column(
          children: <Widget>[
            ScaffoldSubtitle(formData.title),
            Expanded(child: form),
            Material(
              color: const Color(0xFFF7F7F7),
              elevation: 8.0,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 50),
                child: PageNavigator(
                    preorderEditorBloc.currentPageIndex,
                    preorderEditorBloc.pagesData.map<Stream<bool>>((formData) {
                      return formData.isValid;
                    }).toList(),
                    preorderEditorBloc.enableChanges, onPageTap: (pageIndex) {
                  preorderEditorBloc.page = pageIndex;
                }, onPrevTap: () {
                  preorderEditorBloc.page = snapshot.data - 1;
                }, onNextTap: () {
                  preorderEditorBloc
                      .pagesData[snapshot.data].showValidationMsg = true;
                  preorderEditorBloc.page = snapshot.data + 1;
                }),
              ),
            )
          ],
        );
      },
      stream: preorderEditorBloc.currentPageIndex,
    );
  }

  Widget _addPaddingAndScroll(Widget content,
      {Object key = '',
      Color bgColor = Colors.white,
      double horizontalPadding = 16}) {
    return Ink(
        key: ValueKey(key ?? ''),
        color: bgColor,
        child: SingleChildScrollView(
            padding: EdgeInsets.only(
                left: horizontalPadding,
                right: horizontalPadding,
                top: 8,
                bottom: 8),
            child: content));
  }
}

/*  !!
Future<Point> logOrderStartEvent(
    BuildContext context, OrderType orderType, String geoLocationReason) async {
  final parameters = <String, dynamic>{
    'datetime': DateTime.now().toIso8601String()
  };
  Point _geoPosition;
  try {
    parameters.addAll(DeviceInfo.instance.deviceData);
    final location = Location();
    final currentLocation = await location.getLocation();
    _geoPosition = Point(currentLocation.longitude, currentLocation.latitude);
    // Если успешно получили координаты, то добавляем их к логированию в Firebase analytics
    parameters['type'] = 'Point';
    parameters['longitude'] = _geoPosition.longitude;
    parameters['latitude'] = _geoPosition.latitude;
    // Отправляем событие на запись
    await FirebaseAnalytics().logEvent(
        name:
            mapOrderTypeDisplayName(orderType, inEnglish: true) + 'OrderStart',
        parameters: parameters);
  } catch (e) {
    // Отправляем событие на запись без указания на координаты
    try {
      await FirebaseAnalytics().logEvent(
          name: mapOrderTypeDisplayName(orderType, inEnglish: true) +
              'OrderStart',
          parameters: parameters);
    } catch (e) {
      print('Failed to log order start event: $e');
    }
    unawaited(showInfoDialog(
        context,
        'Внимание',
        'Пожалуйста, разрешите приложению'
                ' определять Ваше местоположение в настройках телефона ' +
            geoLocationReason));
  }
  return _geoPosition;
}
*/
