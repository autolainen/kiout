import 'dart:math';

import 'package:aahitest/model/phone.dart';
import 'package:aahitest/services/dadata_component.dart';
import 'package:aahitest/services/exceptions.dart';
import 'package:aahitest/services/helpers.dart';
import 'package:aahitest/services/property_controller.dart';
import 'package:aahitest/widgets/blur_popup_scaffold.dart';
import 'package:aahitest/widgets/email_form_field.dart';
import 'package:aahitest/widgets/phone_form_field.dart';
import 'package:aahitest/widgets/suggestion_field.dart';
import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiver/strings.dart';
import 'package:rxdart/rxdart.dart';

class WizardPage extends StatefulWidget {
  static const disabledButtonColor = Color(0xFFE5E5E5);
  static const fieldErrorMsgStyle =
      TextStyle(fontSize: 12, color: Color(0xFFD95151));
  final List<PropertyController> controllers;

  final int fieldIndex;

  WizardPage({Key key, @required this.controllers, this.fieldIndex = 0})
      : assert(controllers?.isNotEmpty ?? false),
        super(key: key);

  @override
  _WizardPageState createState() => _WizardPageState();
}

class _WizardPageState extends State<WizardPage> {
  BehaviorSubject<int> _fieldIndex;

  @override
  void initState() {
    super.initState();
    _fieldIndex = BehaviorSubject<int>.seeded(widget.fieldIndex);
  }

  @override
  void dispose() {
    _fieldIndex.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    const fieldBorder = OutlineInputBorder();
    var focusedFieldBorder = fieldBorder.copyWith(
        borderSide: BorderSide(color: themeData.accentColor, width: 2));
    return Theme(
        data: themeData.copyWith(
            inputDecorationTheme: InputDecorationTheme(
                border: fieldBorder, focusedBorder: focusedFieldBorder)),
        child: Builder(builder: (BuildContext context) {
          return BlurPopupScaffold(
              child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Column(children: <Widget>[
                    Expanded(
                        child: StreamBuilder<int>(
                            initialData: widget.fieldIndex,
                            stream: _fieldIndex.distinct(),
                            builder: (context, fieldIndexSnapshot) {
                              final isLastField = fieldIndexSnapshot.data >=
                                  widget.controllers.length - 1;
                              final propertyController =
                                  widget.controllers[fieldIndexSnapshot.data];
                              return Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    Expanded(
                                        child: PageTransitionSwitcher(
                                            duration: const Duration(
                                                milliseconds: 500),
                                            reverse: false,
                                            transitionBuilder: (
                                              Widget child,
                                              Animation<double> animation,
                                              Animation<double>
                                                  secondaryAnimation,
                                            ) {
                                              return SharedAxisTransition(
                                                  child: child,
                                                  animation: animation,
                                                  secondaryAnimation:
                                                      secondaryAnimation,
                                                  transitionType:
                                                      SharedAxisTransitionType
                                                          .vertical);
                                            },
                                            child: Container(
                                                key: ValueKey(
                                                    fieldIndexSnapshot.data),
                                                child: _createWizardField(
                                                    propertyController:
                                                        propertyController,
                                                    isLastField: isLastField)))
/* experiments with animations
                                      AnimatedSwitcher(
                                          duration:
                                              const Duration(milliseconds: 500),
                                          transitionBuilder: (Widget child,
                                              Animation<double> animation) {
                                            return ScaleTransition(
                                                child: child, scale: animation);
                                          },
                                          child: Container(
                                              key:
                                                  ValueKey(fieldIndexSnapshot.data),
                                              child: _createWizardField(
                                                  propertyController:
                                                      propertyController,
                                                  isLastField: isLastField)))
*/
                                        ),
                                    _buildNotMandatoryFieldMessage(
                                        propertyController)
                                  ]);
                            })),
                    WizardBottomNavigation(
                        fieldIndex: _fieldIndex,
                        controllers: widget.controllers,
                        onNextPressed: _onNextPressed,
                        onPreviousPressed: () {
                          if (_fieldIndex.value > 0) {
                            _updateFieldIndex(-1);
                          }
                        })
                  ])));
        }));
  }

  void _onNextPressed() {
    final propertyController = widget.controllers[_fieldIndex.value];
    final isLastField = _fieldIndex.value >= widget.controllers.length - 1;
    propertyController.showValidationMsg.add(true);
    if (propertyController.isValidValue) {
      if (isLastField) {
        Navigator.of(context).pop();
      } else {
        _updateFieldIndex(1);
      }
    }
  }

  void _updateFieldIndex(int delta) {
    _fieldIndex.add(min<int>(
        max<int>(0, _fieldIndex.value + delta), widget.controllers.length - 1));
  }

  Widget _createWizardField(
      {PropertyController propertyController, @required bool isLastField}) {
    Widget result;
    final textInputAction =
        isLastField ? TextInputAction.done : TextInputAction.next;
    final onSubmitted = (value) {
      _onNextPressed();
    };
    switch (propertyController.valueType) {
      case ValueType.firstName:
      case ValueType.lastName:
      case ValueType.patronymic:
        result = _createDadataFioField(
            propertyController as PropertyController<String>,
            textInputAction,
            onSubmitted);
        break;
      case ValueType.phone:
        result = _createPhoneWizardField(
            propertyController as PropertyController<Phone>,
            textInputAction,
            onSubmitted);
        break;
      case ValueType.email:
        result = _createEmailWizardField(
            propertyController as PropertyController<String>,
            textInputAction,
            onSubmitted);
        break;
      case ValueType.deathDate:
      case ValueType.birthDate:
      case ValueType.farewellDate:
/*
        result = _createDateWizardField(
            propertyController as PropertyController<DateTime>);
        break;
*/
    }
    if (result == null) {
      throw ExtAppException(
          'No wizard field for valueType: ${propertyController?.valueType}');
    }
    return result;
  }

  Widget _createDadataFioField(PropertyController<String> propertyController,
      TextInputAction textInputAction, ValueChanged<String> onSubmitted) {
    Future<List<String>> Function(String url, String input) remoteCallProcessor;
    switch (propertyController.valueType) {
      case ValueType.firstName:
        remoteCallProcessor = invokeFirstNameSuggestions;
        break;
      case ValueType.lastName:
        remoteCallProcessor = invokeLastNameSuggestions;
        break;
      case ValueType.patronymic:
        remoteCallProcessor = invokePatronymicSuggestions;
        break;
      default:
        throw ExtAppException('Wrong ValueType');
    }

    return SuggestionField<String>(
        propertyController: propertyController,
        stringToValueMapper: (text) => isEmpty(text) ? null : text,
        autofocus: true,
        textCapitalization: TextCapitalization.words,
        inputFormatters: [
          WhitelistingTextInputFormatter(
              RegExp(r'[\p{L}]+[\s-]?', unicode: true)),
          NameInputFormatter()
        ],
        url: DadataComponent.fioUrl,
        remoteCallProcessor: remoteCallProcessor,
        textInputAction: textInputAction,
        onSubmitted: onSubmitted);
  }

  static const _fieldBorder = OutlineInputBorder();

  Widget _createPhoneWizardField(PropertyController<Phone> propertyController,
      TextInputAction textInputAction, ValueChanged<String> onSubmitted) {
    final phoneField = PhoneFormField(
        decoration: InputDecoration(
            labelText: propertyController.caption, border: _fieldBorder),
        initValue: propertyController.value?.phone,
        autofocus: true,
        onChanged: (newValue) {
          propertyController.input.add(Phone(newValue));
        },
        textInputAction: textInputAction,
        onSubmitted: onSubmitted);
    return _wrapRegularField(phoneField, propertyController);
  }

  Widget _createEmailWizardField(PropertyController<String> propertyController,
      TextInputAction textInputAction, ValueChanged<String> onSubmitted) {
    final emailField = EmailFormField(
        decoration: InputDecoration(
            border: _fieldBorder, labelText: propertyController.caption),
        initialValue: propertyController.value,
        autofocus: true,
        onChanged: (newValue) {
          propertyController.input.add(isEmpty(newValue) ? null : newValue);
        },
        textInputAction: textInputAction,
        onSubmitted: onSubmitted);
    return _wrapRegularField(emailField, propertyController);
  }

/*
  Widget _createDateWizardField(
      PropertyController<DateTime> propertyController) {
    var showNearPastDateButtons = false;
    var showNearFutureDateButtons = false;
    DateTime firstDate, lastDate;
    final now = DateTime.now();

    switch (propertyController.valueType) {
      case ValueType.birthDate:
        firstDate = now.subtract(Duration(days: 365 * 123));
        lastDate = now;
        break;
      case ValueType.deathDate:
        firstDate = (propertyController.value ?? now)
            .subtract(Duration(days: 365 * 10));
        lastDate = now;
        showNearPastDateButtons = true;
        break;
      case ValueType.farewellDate:
        final midnight = resetTimeToMidnight(now);
        firstDate = midnight;
        lastDate = midnight.add(SlotSelector.farewellDatePeriod);
        showNearFutureDateButtons = true;
        break;
      default:
        throw ExtAppException('Wrong ValueType');
    }
    final datePicker = SingleChildScrollView(
        child: DatePicker(
            title: propertyController.caption,
            initDateTime: propertyController.value,
            onChanged: (newDate) {
              propertyController.input.add(newDate);
            },
            showNearPastDateButtons: showNearPastDateButtons,
            showNearFutureDateButtons: showNearFutureDateButtons,
            firstDate: firstDate,
            lastDate: lastDate));
    return _wrapRegularField(datePicker, propertyController);
  }
*/

  Widget _wrapRegularField(
      Widget child, PropertyController propertyController) {
    return Align(
        alignment: Alignment.topLeft,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: child),
              ),
              buildFieldErrorMessage(propertyController)
            ]));
  }

  Widget _buildNotMandatoryFieldMessage(PropertyController propertyController) {
    var commentText = propertyController.comment?.isEmpty ?? true
        ? null
        : propertyController.comment;
    if (commentText == null && !propertyController.isMandatory) {
      commentText = 'Это необязательное поле, его можно пропустить';
    }
    return commentText?.isEmpty ?? true
        ? SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Text(commentText,
                textAlign: TextAlign.end,
                style:
                    TextStyle(fontSize: 12, color: const Color(0xFF808080))));
  }
}

class WizardBottomNavigation extends StatelessWidget {
  final List<PropertyController> controllers;

  final BehaviorSubject<int> fieldIndex;
  final VoidCallback onPreviousPressed;
  final VoidCallback onNextPressed;

  const WizardBottomNavigation(
      {Key key,
      @required this.controllers,
      @required this.fieldIndex,
      this.onNextPressed,
      this.onPreviousPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 74,
        child: Padding(
            padding: const EdgeInsets.all(16),
            child: StreamBuilder<int>(
                stream: fieldIndex,
                initialData: fieldIndex.value,
                builder: (context, fieldIndexSnapshot) {
                  final isManyControllers = controllers.length > 1;
                  return Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        if (isManyControllers)
                          SizedBox(
                              width: 42,
                              child: OutlineButton(
                                  padding: EdgeInsets.all(0),
                                  highlightedBorderColor:
                                      Theme.of(context).accentColor,
                                  textColor: Theme.of(context).accentColor,
                                  child: Icon(Icons.chevron_left),
                                  onPressed: fieldIndexSnapshot.data > 0
                                      ? onPreviousPressed
                                      : null)),
                        if (isManyControllers)
                          Expanded(
                              child: Center(
                                  child: Text(
                            '${fieldIndexSnapshot.data + 1}/${controllers.length}',
                            style: TextStyle(
                                fontSize: 16, color: const Color(0xFF717171)),
                          ))),
                        _createForwardButton(fieldIndexSnapshot.data)
                      ]);
                })));
  }

  Widget _createForwardButton(int fieldIndexValue) {
    final propertyController = controllers[fieldIndexValue];
    final isLastField = fieldIndexValue >= controllers.length - 1;

    return SizedBox(
        width: 152,
        child: StreamBuilder<bool>(
            stream: propertyController.showValidationMsg,
            initialData: propertyController.showValidationMsg.value,
            builder: (context, showValidationMsgSnapshot) {
              return StreamBuilder<bool>(
                  stream: propertyController.isValid,
                  initialData: propertyController.isValidValue,
                  builder: (context, isValidSnapshot) {
                    VoidCallback onPressed;
                    if (!showValidationMsgSnapshot.data ||
                        isValidSnapshot.data) {
                      onPressed = onNextPressed;
                    }
                    return RaisedButton(
                        child: Text(isLastField ? 'ГОТОВО' : 'ДАЛЕЕ'),
                        color: Theme.of(context).accentColor,
                        disabledTextColor: Colors.white,
                        onPressed: onPressed);
                  });
            }));
  }
}

Widget buildFieldErrorMessage(PropertyController propertyController,
    {EdgeInsetsGeometry padding =
        const EdgeInsets.only(top: 8, bottom: 4, left: 16, right: 16)}) {
  return StreamBuilder<String>(
      stream: propertyController.validationMsg,
      builder: (context, errorMsgSnapshot) {
        return isEmpty(errorMsgSnapshot.data)
            ? SizedBox.shrink()
            : Padding(
                padding: padding,
                child: Text(errorMsgSnapshot.data,
                    textAlign: TextAlign.end,
                    style: WizardPage.fieldErrorMsgStyle));
      });
}

/// Форматтер ФИО.
class NameInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, // unused
      TextEditingValue newValue) {
    return TextEditingValue(
        text: _capAllWords(newValue.text), selection: newValue.selection);
  }

  String _capAllWords(String value) {
    return value?.replaceAllMapped(RegExp(r'[\p{L}]+', unicode: true), (match) {
      String result;
      if (match != null) {
        result = capFirstLowRest(match[0]);
      }
      return result ?? '';
    });
  }
}
