import 'package:aahitest/global_services.dart';
import 'package:aahitest/model/cemetery.dart';
import 'package:aahitest/model/geo/point.dart';
import 'package:aahitest/model/order/order_type.dart';
import 'package:aahitest/services/cemeteries_cache.dart';
import 'package:aahitest/services/helpers.dart';
import 'package:aahitest/widgets/extended_state.dart';
import 'package:aahitest/widgets/search_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/scheduler.dart';
import 'package:quiver/strings.dart';

/// Виджет выбора кладбища при создании предзаказа
class CemeterySelector extends StatefulWidget {
  final CemeteryId initialValue;
  final OrderType orderType;
  final ValueChanged<CemeteryId> onChanged;

  /// Геопозиция оформления предзаказа
  final Point geoPosition;

  CemeterySelector(
      {Key key,
      this.initialValue,
      this.geoPosition,
      @required this.orderType,
      this.onChanged})
      : super(key: key);

  @override
  CemeterySelectorState createState() => CemeterySelectorState();
}

class CemeterySelectorState extends ExtendedState<CemeterySelector> {
  List<Cemetery> _cemeteries = [];
  CemeteryId _selectedCemeteryId;
  ScrollController _scrollController;
  String _searchWord = '';

  @override
  void initState() {
    super.initState();
    _selectedCemeteryId = widget.initialValue;
    _scrollController = ScrollController();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      wrapLoader(_loadData);
    });
  }

  Future<void> _loadData() async {
    _cemeteries = await service<CemeteriesCache>().find(widget.orderType);
    scrollToSelectedCemetery();
  }

  /// Анимирует скролл к выбранному кладбищу
  void scrollToSelectedCemetery() {
    if (mounted &&
        _scrollController.hasClients &&
        _selectedCemeteryId != null) {
      final indexToScrollTo = (_cemeteries ?? [])
          .indexWhere((cemetery) => cemetery.id == _selectedCemeteryId);
      if (indexToScrollTo > -1) {
        _scrollController.animateTo(
            CemeteryListTile.listTileHeight * indexToScrollTo,
            duration: Duration(milliseconds: 800),
            curve: Curves.ease);
      }
    }
  }

  @override
  Widget buildContent(BuildContext context) {
    var _actualCemeteries = <Cemetery>[];
    if (_searchWord.isNotEmpty) {
      _cemeteries.forEach((Cemetery cemetery) {
        if (cemetery.name
            .toLowerCase()
            .contains(_searchWord.toLowerCase().trim())) {
          _actualCemeteries.add(cemetery);
        }
      });
    } else {
      _actualCemeteries = _cemeteries;
    }
    final separator = Divider(height: 1);
    return Column(children: <Widget>[
      Material(
        color: Colors.white,
        elevation: 4,
        child: SearchField(
            hint: 'Начните вводить название кладбища',
            onChanged: (newValue) {
              if (mounted) {
                setState(() {
                  _searchWord = newValue;
                });
              }
            }),
      ),
      Expanded(
        child: ListView.separated(
            itemBuilder: (BuildContext context, int index) {
              final cemetery = _actualCemeteries[index];
              return CemeteryListTile(
                selected: cemetery.id == _selectedCemeteryId,
                title: cemetery.name,
                subtitle: widget.geoPosition != null &&
                        cemetery.border?.centroid != null
                    ? _formatDistance(
                        widget.geoPosition.distanceTo(cemetery.border.centroid))
                    : null,
                onTap: () {
                  setState(() {
                    _selectedCemeteryId = cemetery.id;
                  });
                  if (widget.onChanged != null) {
                    widget.onChanged(_selectedCemeteryId);
                  }
                },
              );
            },
            separatorBuilder: (context, index) => separator,
            controller: _scrollController,
            itemCount: _actualCemeteries.length),
      )
    ]);
  }

  /// Возвращает количество километров в виде строки
  String _formatDistance(double distanceInMeters) {
    return (distanceInMeters / 1000).toStringAsFixed(0) + ' км';
  }
}

class CemeteryListTile extends StatelessWidget {
  static const selectedTextColor = Color(0xFFF7F7F7);
  static const subtitleTextColor = Color(0xFF717171);
  static const listTileHeight = 72.0;

  final bool selected;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const CemeteryListTile(
      {Key key, this.title, this.subtitle, this.selected, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: listTileHeight,
      child: Ink(
        color: selected ?? false ? Theme.of(context).accentColor : Colors.white,
        child: InkWell(
          onTap: onTap,
          child: Container(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    if (isNotEmpty(title))
                      OneLineText(title,
                          style: TextStyle(
                              fontSize: 16,
                              color: selected ?? false
                                  ? selectedTextColor
                                  : null)),
                    if (isNotEmpty(subtitle))
                      Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: OneLineText(
                            subtitle,
                            style: TextStyle(
                                fontSize: 12,
                                color: selected ?? false
                                    ? selectedTextColor
                                    : subtitleTextColor),
                          ))
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
