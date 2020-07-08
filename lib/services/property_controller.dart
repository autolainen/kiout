import 'dart:async';

import 'package:rxdart/rxdart.dart';

/// Тип для функции валидации значения
typedef Validator<T> = String Function(T value);

/// Контроллер поля на форме.
///
/// Позволяет получать от поля уведомления об изменении значения.
/// Позволяет валидировать значение поля и транслировать сообщение об ошибке валидации.
class PropertyController<T> {
  final ValueType valueType;
  final String caption;
  final String comment;
  final _input = StreamController<T>();
  BehaviorSubject<T> _valueOutput;
  BehaviorSubject<String> _formattedValueOutput;
  BehaviorSubject<String> _validationMsgOutput;
  BehaviorSubject<bool> _isValidOutput;
  BehaviorSubject<bool> _isDataChangedOutput;
  BehaviorSubject<bool> _showValidationMsg;
  final Validator<T> _validator;
  String Function(T) _valueFormatter;
  T Function(T) _valueFilter;
  final _subscriptions = CompositeSubscription();

  PropertyController(T initValue,
      // TODO make valueType mandatory
      {this.caption = '',
      this.comment,
      this.valueType,
      bool showValidationMsg = true,
      Validator<T> validator,
      String Function(T) valueFormatter,
      T Function(T) valueFilter})
      : _validator = validator {
    _valueFilter = valueFilter ?? (value) => value;
    _valueFormatter = valueFormatter ?? (T param) => param?.toString();
    _valueOutput = BehaviorSubject<T>.seeded(_valueFilter(initValue));
    _formattedValueOutput =
        BehaviorSubject<String>.seeded(_valueFormatter(_valueOutput.value));
    _subscriptions.add(_valueOutput.stream.listen((data) {
      _formattedValueOutput.add(_valueFormatter(data));
    }));

    _showValidationMsg = BehaviorSubject<bool>.seeded(showValidationMsg);
    final validationMsg = _createValidationMsg(initValue);

    _validationMsgOutput = BehaviorSubject<String>.seeded(
        showValidationMsg ? validationMsg : null);

    _isValidOutput = BehaviorSubject<bool>.seeded(validationMsg == null);
    _isDataChangedOutput = BehaviorSubject<bool>.seeded(false);

    _subscriptions.add(_input.stream.listen((data) {
      _valueOutput.add(_valueFilter(data));
      _isDataChangedOutput.add(true);
      validate();
    }));

    _subscriptions
        .add(_showValidationMsg.distinct().listen((showValidationMsgValue) {
      _validationMsgOutput.add(showValidationMsgValue
          ? _createValidationMsg(_valueOutput.value)
          : null);
    }));
  }

  PropertyController<T> clone() {
    return PropertyController<T>(value,
        caption: caption,
        valueType: valueType,
        showValidationMsg: _showValidationMsg.value,
        validator: _validator,
        valueFormatter: _valueFormatter,
        valueFilter: _valueFilter);
  }

  void validate() {
    final validationMsg = _createValidationMsg(_valueOutput.value);
    _isValidOutput.add(validationMsg == null);
    _validationMsgOutput.add(_showValidationMsg.value ? validationMsg : null);
  }

  T get value => _valueOutput.value;

  BehaviorSubject<String> get formattedValue => _formattedValueOutput;

  Sink<T> get input => _input.sink;

  Stream<String> get validationMsg => _validationMsgOutput.distinct();

  Stream<T> get valueOutput => _valueOutput.distinct();

  Stream<bool> get isValid => _isValidOutput.distinct();

  bool get isValidValue => _isValidOutput.value;

  bool get isMandatory {
    return _createValidationMsg(null) != null;
  }

  Stream<bool> get isDataChanged => _isDataChangedOutput.distinct();

  BehaviorSubject<bool> get showValidationMsg => _showValidationMsg;

  String _createValidationMsg(T value) {
    return _validator == null ? null : _validator(value);
  }

  void dispose() {
    _input.close();
    _subscriptions.dispose();
    _showValidationMsg.close();
    _validationMsgOutput.close();
    _isValidOutput.close();
    _valueOutput.close();
  }
}

enum ValueType {
  firstName,
  lastName,
  patronymic,
  phone,
  email,
  birthDate,
  deathDate,
  farewellDate,
}
