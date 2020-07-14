import 'dart:async';
import 'dart:math';

import 'package:kiouttest/model/order/order_type.dart';
import 'package:kiouttest/services/form_data.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

/// Базовый класс для BLoC-объектов предзаказов разных типов.
///
/// Содержит механизм переключения текущей страницы
abstract class PreorderEditorBloc {
  final PreorderEditorBlocMode _mode;
  final _pagesData = <FormData>[];
  final _currentPageIndex = BehaviorSubject<int>.seeded(0);
  final _enableChanges = BehaviorSubject<bool>.seeded(true);
  BehaviorSubject<bool> _isDataChanged;
  StreamSubscription _isDataChangedSubscription;

  PreorderEditorBloc(PreorderEditorBlocMode mode) : _mode = mode;

  PreorderEditorBlocMode get mode => _mode;

  OrderType get orderType;

  List<FormData> get pagesData => _pagesData;

  BehaviorSubject<bool> get isDataChanged {
    if (_isDataChanged == null) {
      _isDataChanged = BehaviorSubject<bool>.seeded(false);
      _isDataChangedSubscription =
          combineBooleanStreamsOr(_pagesData.map<Stream<bool>>((formData) {
        return formData.isDataChanged;
      }), _isDataChanged);
    }
    return _isDataChanged;
  }

  BehaviorSubject<int> get currentPageIndex => _currentPageIndex;

  BehaviorSubject<bool> get enableChanges => _enableChanges;

  set page(int pageIndex) {
    if (pageIndex == 0) {
      _currentPageIndex.add(pageIndex);
    } else {
      final _pageIndex = min<int>(pagesData.length - 1, pageIndex);
      CombineLatestStream<bool, bool>(
          pagesData.getRange(0, _pageIndex).map<Stream<bool>>((formData) {
            return formData.isValid;
          }).toList(), (values) {
        return values.reduce((val, element) => val && element);
      }).first.then((previousFormsValid) {
        if (previousFormsValid) {
          _currentPageIndex.add(_pageIndex);
        }
      });
    }
  }

  @mustCallSuper
  void dispose() {
    _isDataChangedSubscription?.cancel();
    _isDataChanged?.close();
    _pagesData?.forEach((formData) {
      formData.dispose();
    });
    _currentPageIndex.close();
    _enableChanges.close();
  }
}

/// Режимы работы BLoC-объекта предзаказа.
///
/// [createBlank] - создание нового предзаказа
/// [createByTemplate] - создание нового предзаказа по образцу
/// [edit] - редактирование предзаказа
enum PreorderEditorBlocMode { createBlank, createByTemplate, edit }
