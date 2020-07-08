import 'dart:async';

import 'package:aahitest/model/cemetery.dart';
import 'package:aahitest/model/client.dart';
import 'package:aahitest/model/deceased.dart';
import 'package:aahitest/model/order/order_type.dart';
import 'package:aahitest/model/person.dart';
import 'package:aahitest/model/phone.dart';
import 'package:aahitest/services/helpers.dart';
import 'package:aahitest/services/property_controller.dart';
import 'package:aahitest/services/validators.dart';
import 'package:aahitest/widgets/phone_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:quiver/strings.dart';
import 'package:rxdart/rxdart.dart';

/// Базовый класс для value объектов с данными для форм.
class FormData {
  final String _title;
  final String formDescription;
  final _subscriptions = CompositeSubscription();
  final List<PropertyController> controllers = [];
  final List<Subject> _subjects = [];
  BehaviorSubject<bool> _isControllerDataValid;
  BehaviorSubject<bool> _isControllerDataChanged;

  FormData(String title,
      {List<PropertyController> initControllers, this.formDescription})
      : _title = title,
        assert(title != null) {
    if (initControllers?.isNotEmpty ?? false) {
      controllers.addAll(initControllers);
    }
  }

  String get title => _title;

  factory FormData.copy(FormData formData) {
    assert(formData != null);
    return FormData(formData.title,
        initControllers: formData.controllers
            .map<PropertyController>((origController) => origController.clone())
            .toList());
  }

  Stream<bool> get isValid {
    if (_isControllerDataValid == null) {
      addSubject(_isControllerDataValid = BehaviorSubject<bool>());
      addSubscription(combineBooleanStreamsAnd(
          controllers.map<Stream<bool>>((controller) => controller.isValid),
          _isControllerDataValid));
    }
    return _isControllerDataValid;
  }

  Stream<bool> get isDataChanged {
    if (_isControllerDataChanged == null) {
      addSubject(_isControllerDataChanged = BehaviorSubject<bool>());
      addSubscription(combineBooleanStreamsOr(
          controllers
              .map<Stream<bool>>((controller) => controller.isDataChanged),
          _isControllerDataChanged));
    }
    return _isControllerDataChanged;
  }

  set showValidationMsg(bool newValue) {
    controllers.forEach((controller) {
      controller.showValidationMsg.add(newValue);
    });
  }

  @mustCallSuper
  void dispose() {
    _subscriptions.dispose();
    _subjects.forEach((subject) => subject?.close());
    controllers.forEach((controller) => controller?.dispose());
  }

  void addSubscription(StreamSubscription subscription) {
    if (subscription != null) {
      _subscriptions.add(subscription);
    }
  }

  void addController(PropertyController controller) {
    if (controller != null) {
      controllers.add(controller);
    }
  }

  void addSubject(Subject subject) {
    if (subject != null) {
      _subjects.add(subject);
    }
  }
}

/// Объект с контроллерами для полей формы [PersonForm].
class PersonFormData extends FormData {
  PropertyController<String> _firstName;
  PropertyController<String> _lastName;
  PropertyController<String> _patronymic;

  PersonFormData(String title, Person person, {String formDescription})
      : super(title, formDescription: formDescription) {
    addController(_lastName = PropertyController<String>(person?.lastName,
        caption: 'Фамилия',
        valueType: ValueType.lastName,
        showValidationMsg: person != null,
        valueFilter: stringValueFilter,
        validator: isNotBlankAndValidName));
    addController(_firstName = PropertyController<String>(person?.firstName,
        caption: 'Имя',
        valueType: ValueType.firstName,
        showValidationMsg: person != null,
        valueFilter: stringValueFilter,
        validator: isNotBlankAndValidName));
    addController(_patronymic = PropertyController<String>(person?.patronymic,
        caption: 'Отчество',
        comment: 'Введите Отчество, если оно есть',
        valueType: ValueType.patronymic,
        showValidationMsg: person != null,
        valueFilter: stringValueFilter,
        validator: isValidName));
  }

  PropertyController<String> get firstName => _firstName;

  PropertyController<String> get lastName => _lastName;

  PropertyController<String> get patronymic => _patronymic;
}

class DeceasedFormData extends PersonFormData {
  PropertyController<DateTime> _birthDate;
  PropertyController<DateTime> _deathDate;

  DeceasedFormData(String title, {Deceased deceased})
      : super(
            title,
            deceased == null
                ? null
                : Person(
                    lastName: deceased?.lastName,
                    firstName: deceased?.firstName,
                    patronymic: deceased?.patronymic)) {
    addController(_birthDate = PropertyController<DateTime>(deceased?.birthDate,
        caption: 'Дата рождения',
        valueType: ValueType.birthDate,
        valueFormatter: dateValueFormatter,
        showValidationMsg: deceased != null,
        valueFilter: dateValueFilter,
        validator: _validateBirthDate));
    addController(_deathDate = PropertyController<DateTime>(deceased?.deathDate,
        caption: 'Дата смерти',
        valueType: ValueType.deathDate,
        valueFormatter: dateValueFormatter,
        showValidationMsg: deceased != null,
        valueFilter: dateValueFilter,
        validator: _validateDeathDate));
    _birthDate.validate();
    addSubscription(_deathDate.valueOutput.skip(1).listen((data) {
      _birthDate.validate();
    }));
    addSubscription(_birthDate.valueOutput.skip(1).listen((data) {
      _deathDate.validate();
    }));
  }

  Deceased get deceased {
    return Deceased(
        firstName: _firstName.value,
        lastName: _lastName.value,
        patronymic: _patronymic.value,
        birthDate: _birthDate.value,
        deathDate: _deathDate.value);
  }

  PropertyController<DateTime> get birthDate => _birthDate;

  PropertyController<DateTime> get deathDate => _deathDate;

  String _validateBirthDate(DateTime birthDate) {
    var result = isNotNull(birthDate);
    result ??= _checkBirthBeforeDeath(birthDate, _deathDate?.value);
    result ??= isDateInFuture(birthDate);
    return result;
  }

  String _validateDeathDate(DateTime deathDate) {
    var result = isNotNull(deathDate);
    result ??= _checkBirthBeforeDeath(_birthDate?.value, deathDate);
    result ??= isDateInFuture(deathDate);
    return result;
  }

  String _checkBirthBeforeDeath(DateTime birthDate, DateTime deathDate) {
    String result;
    if (birthDate != null &&
        deathDate != null &&
        birthDate.isAfter(deathDate)) {
      result = 'Дата рождения должна быть раньше даты смерти';
    }
    return result;
  }
}

/*
class AgentServiceDeceasedFormData extends DeceasedFormData {
  PropertyController<Education> _education;
  PropertyController<MaritalStatus> _maritalStatus;
  PropertyController<Employment> _employment;
  PropertyController<PlaceOfDeath> _placeOfDeath;
  PropertyController<String> _placeOfBurialOrCremation;
  PropertyController<DadataAddress> _certificateIssueAddress;

  AgentServiceDeceasedFormData(String title, {Deceased deceased})
      : super(title, deceased: deceased) {
    addController(_education = PropertyController<Education>(
        deceased?.education,
        showValidationMsg: deceased != null,
        validator: isNotNull));
    addController(_maritalStatus = PropertyController<MaritalStatus>(
        deceased?.maritalStatus,
        showValidationMsg: deceased != null,
        validator: isNotNull));
    addController(_employment = PropertyController<Employment>(
        deceased?.employment,
        showValidationMsg: deceased != null,
        validator: isNotNull));
    addController(_placeOfDeath = PropertyController<PlaceOfDeath>(
        deceased?.placeOfDeath,
        showValidationMsg: deceased != null,
        validator: isNotNull));
    addController(_placeOfBurialOrCremation = PropertyController<String>(
        deceased?.placeOfBurialOrCremation,
        showValidationMsg: deceased != null,
        valueFilter: stringValueFilter,
        validator: isNotBlankField));
    addController(_certificateIssueAddress = PropertyController<DadataAddress>(
        deceased?.certificateIssueAddress,
        showValidationMsg: deceased != null,
        validator: isNotNull));
  }

  @override
  Deceased get deceased {
    final deceased = super.deceased;
    deceased.education = _education.value;
    deceased.maritalStatus = _maritalStatus.value;
    deceased.employment = _employment.value;
    deceased.placeOfDeath = _placeOfDeath.value;
    deceased.placeOfBurialOrCremation = _placeOfBurialOrCremation.value;
    deceased.certificateIssueAddress = _certificateIssueAddress.value;
    return deceased;
  }

  PropertyController<Education> get education => _education;

  PropertyController<MaritalStatus> get maritalStatus => _maritalStatus;

  PropertyController<Employment> get employment => _employment;

  PropertyController<PlaceOfDeath> get placeOfDeath => _placeOfDeath;

  PropertyController<String> get placeOfBurialOrCremation =>
      _placeOfBurialOrCremation;

  PropertyController<DadataAddress> get certificateIssueAddress =>
      _certificateIssueAddress;
}
*/
const String prettyPhoneFormat = '+# (###) ###-##-##';

class ClientFormData extends PersonFormData {
  PropertyController<Phone> _phone;
  PropertyController<String> _email;
  final phoneFormatter = PhoneTextInputFormatter(prettyPhoneFormat);

  ClientFormData(String title,
      {Client client, Validator<Phone> phoneValidator, String formDescription})
      : super(
            title,
            client == null
                ? null
                : Person(
                    lastName: client?.lastName,
                    firstName: client?.firstName,
                    patronymic: client?.patronymic),
            formDescription: formDescription) {
    addController(_phone = PropertyController<Phone>(client?.phone,
        caption: 'Телефон',
        valueType: ValueType.phone,
        showValidationMsg: client != null,
        validator: phoneValidator, valueFormatter: (phone) {
      final phoneDigitsOnly =
          (phone?.phone ?? '').replaceAll(RegExp(r'\D'), '');
      final textEditingValue = TextEditingValue(
          text: phoneDigitsOnly,
          selection: TextSelection.collapsed(offset: phoneDigitsOnly.length));
      return phoneFormatter.formatEditUpdate(null, textEditingValue)?.text;
    }));
    addController(_email = PropertyController<String>(client?.email,
        caption: 'Эл. почта',
        comment: 'Введите e-mail, если он есть',
        valueType: ValueType.email,
        showValidationMsg: client != null,
        valueFilter: stringValueFilter,
        validator: isValidEmail));
  }

  Client get client {
    return Client(
        firstName: _firstName.value,
        lastName: _lastName.value,
        patronymic: _patronymic.value,
        phone: _phone.value,
        email: _email.value);
  }

  PropertyController<Phone> get phone => _phone;

  PropertyController<String> get email => _email;
}

class CemeterySelectorFormData extends FormData {
  PropertyController<CemeteryId> _cemeteryId;

  final OrderType _orderType;

  CemeterySelectorFormData(String title, OrderType orderType,
      {CemeteryId initValue})
      : _orderType = orderType,
        super(title) {
    addController(_cemeteryId = PropertyController<CemeteryId>(initValue,
        showValidationMsg: false, validator: (value) {
      return value == null ? 'Выберите кладбище' : null;
    }));
  }

  OrderType get orderType => _orderType;

  PropertyController<CemeteryId> get cemeteryId => _cemeteryId;
}

/*
class AddressFormData extends FormData {
  PropertyController<DateTime> _meetingDate;
  PropertyController<TimeOfDay> _meetingTime;
  PropertyController<DadataAddress> _agentMeetingAddress;

  AddressFormData(String title,
      {DateTime meetingAt,
      DadataAddress agentMeetingAddress,
      bool showValidationMsg = true})
      : super(title) {
    addController(_meetingDate = PropertyController<DateTime>(
        resetTimeToMidnight(meetingAt),
        showValidationMsg: showValidationMsg,
        valueFilter: dateValueFilter,
        validator: _validateMeetingDate));
    addController(_meetingTime = PropertyController<TimeOfDay>(
        meetingAt == null ? null : TimeOfDay.fromDateTime(meetingAt),
        showValidationMsg: showValidationMsg,
        validator: isNotNull));
    addController(_agentMeetingAddress = PropertyController<DadataAddress>(
        agentMeetingAddress,
        showValidationMsg: showValidationMsg,
        validator: isNotNull));
  }

  String _validateMeetingDate(DateTime meetingDate) {
    var result = isNotNull(meetingDate);
    result ??= isDateInPast(meetingDate);
    return result;
  }

  PropertyController<DateTime> get meetingDate => _meetingDate;

  PropertyController<TimeOfDay> get meetingTime => _meetingTime;

  PropertyController<DadataAddress> get agentMeetingAddress =>
      _agentMeetingAddress;

  DateTime get meetingAt {
    DateTime result;
    if (_meetingDate.value != null && _meetingTime.value != null) {
      result = resetTimeToMidnight(_meetingDate.value).add(Duration(
          hours: _meetingTime.value.hour, minutes: _meetingTime.value.minute));
    }
    return result;
  }
}

class PackageSelectorFormData extends FormData {
  PropertyController<Package> _package;
  final OrderType orderType;
  final PropertyController<CemeteryId> _cemeteryId;
  final PreorderId preorderId;

  PackageSelectorFormData(String title, this.orderType,
      {PropertyController<CemeteryId> cemeteryId,
      Package initValue,
      Validator<Package> validator,
      this.preorderId})
      : _cemeteryId = cemeteryId,
        super(title) {
    addController(_package = PropertyController<Package>(initValue,
        showValidationMsg: false, validator: validator));
    addSubscription(cemeteryId?.valueOutput?.skip(1)?.listen((data) {
      _package.input.add(null);
    }));
  }

  PropertyController<Package> get package => _package;

  PropertyController<CemeteryId> get cemeteryId => _cemeteryId;
}

class HallReservationFormData extends FormData {
  PropertyController<Map<int, HallReservation>> _hallReservations;
  PropertyController<Item> _farewellService;
  final PropertyController<Package> package;
  final PreorderId preorderId;

  HallReservationFormData(String title,
      {@required this.package,
      OrderItem farewellService,
      @required this.preorderId})
      : assert(package != null),
        assert(preorderId != null),
        super(title) {
    addController(_hallReservations =
        PropertyController<Map<int, HallReservation>>(null,
            showValidationMsg: false, validator: (value) {
      return value?.isEmpty ?? true
          ? 'Необходимо выбрать дату и время прощания'
          : null;
    }));
    addController(_farewellService = PropertyController<Item>(farewellService,
        showValidationMsg: false, validator: (value) {
      return value == null ? 'Необходима услуга прощания' : null;
    }));
    addSubscription(package.valueOutput.skip(1).listen((data) {
      _farewellService.input.add(null);
    }));
  }

  PropertyController<Map<int, HallReservation>> get hallReservations =>
      _hallReservations;

  PropertyController<Item> get farewellService => _farewellService;
}

class PlotSelectorFormData extends FormData {
  PropertyController<Point> _point;
  PropertyController<List<Attachment<File>>> _photos;
  final OrderType orderType;
  final Stream<CemeteryId> cemeteryId;
  final Stream<Package> package;
  final VoidCallback _onSkip;

  PlotSelectorFormData(String title, this.orderType, this.cemeteryId,
      {this.package,
      VoidCallback onSkip,
      Point pointInitValue,
      List<Attachment<File>> photosInitValue})
      : _onSkip = onSkip,
        super(title) {
    addController(_point = PropertyController<Point>(pointInitValue,
        showValidationMsg: false,
        validator: onSkip != null
            ? null
            : (value) {
                return value == null ? 'Необходимо указать участок' : null;
              }));
    addController(
        _photos = PropertyController<List<Attachment<File>>>(photosInitValue,
            showValidationMsg: false,
            validator: onSkip != null
                ? null
                : (value) {
                    return value?.isEmpty ?? true
                        ? 'Необходимо приложить фото участка'
                        : null;
                  }));
    if (package != null) {
      addSubscription(package?.skip(1)?.listen(_removePlotData));
    } else {
      addSubscription(cemeteryId.skip(1).listen(_removePlotData));
    }
  }

  bool get showMap => _onSkip == null;

  void onSkip() {
    _point.input.add(null);
    _photos.input.add(null);
    if (_onSkip != null) {
      _onSkip();
    }
  }

  PropertyController<Point> get point => _point;

  PropertyController<List<Attachment<File>>> get photos => _photos;

  /// Удаляет данные выбранного участка, в том числе фото
  void _removePlotData(_) {
    _point.input.add(null);
    _photos.value?.forEach((attachment) {
      if (attachment.file?.existsSync() ?? false) {
        attachment.file.delete();
      }
    });
    _photos.input.add(null);
  }
}

class ExtraServiceSelectorFormData extends FormData {
  final OrderType orderType;
  final WorkType selectedWorkType;
  PropertyController<List<CatalogItem>> _items;

  ExtraServiceSelectorFormData(String title, this.orderType,
      {List<CatalogItem> itemsInitValue, this.selectedWorkType})
      : super(title) {
    addController(_items = PropertyController<List<CatalogItem>>(itemsInitValue,
        showValidationMsg: false));
  }

  PropertyController<List<CatalogItem>> get items => _items;

  void removeItem(CatalogItem catalogItem) {
    _items.input.add(_items.value?.where((_item) {
      return _item.id != catalogItem.id;
    })?.toList());
  }
}

class SummaryFormData extends FormData {
  final OrderType orderType;
  final PreorderEditorBlocMode mode;
  final PreorderId preorderId;
  final ClientFormData clientFormData;
  final ClientFormData representativeFormData;
  final DeceasedFormData deceasedFormData;
  final AddressFormData addressFormData;
  final CemeterySelectorFormData cemeterySelectorFormData;
  final PackageSelectorFormData packageSelectorFormData;
  final PlotSelectorFormData plotSelectorFormData;

  final HallReservationFormData hallReservationFormData;
  final ExtraServiceSelectorFormData extraServiceSelectorFormData;
  final BehaviorSubject<bool> enableChanges;
  PropertyController<String> _comment;
  final _isSummaryDataValid = BehaviorSubject<bool>();
  final _isSummaryDataChanged = BehaviorSubject<bool>();

  SummaryFormData(String title, this.orderType, this.mode,
      {this.preorderId,
      @required this.clientFormData,
      this.representativeFormData,
      @required this.deceasedFormData,
      this.addressFormData,
      this.cemeterySelectorFormData,
      this.packageSelectorFormData,
      this.plotSelectorFormData,
      this.extraServiceSelectorFormData,
      this.hallReservationFormData,
      @required this.enableChanges})
      : assert(mode == PreorderEditorBlocMode.edit ||
                orderType == OrderType.cremation
            ? preorderId != null
            : true),
        super(title) {
    addSubject(_isSummaryDataValid);
    addSubject(_isSummaryDataChanged);
    addController(_comment = PropertyController<String>(null,
        showValidationMsg: false, valueFilter: stringValueFilter));
    addSubscription(combineBooleanStreamsAnd([
      clientFormData.isValid,
      if (representativeFormData != null) representativeFormData.isValid,
      deceasedFormData.isValid,
      if (addressFormData != null) addressFormData.isValid,
      if (cemeterySelectorFormData != null) cemeterySelectorFormData.isValid,
      if (packageSelectorFormData != null) packageSelectorFormData.isValid,
      if (plotSelectorFormData != null) plotSelectorFormData.isValid,
      if (extraServiceSelectorFormData != null)
        extraServiceSelectorFormData.isValid,
      if (hallReservationFormData != null) hallReservationFormData.isValid,
      _comment.isValid
    ], _isSummaryDataValid));
    addSubscription(combineBooleanStreamsOr([
      clientFormData.isDataChanged,
      if (representativeFormData != null) representativeFormData.isDataChanged,
      deceasedFormData.isDataChanged,
      if (addressFormData != null) addressFormData.isDataChanged,
      if (cemeterySelectorFormData != null)
        cemeterySelectorFormData.isDataChanged,
      if (packageSelectorFormData != null)
        packageSelectorFormData.isDataChanged,
      if (plotSelectorFormData != null) plotSelectorFormData.isDataChanged,
      if (extraServiceSelectorFormData != null)
        extraServiceSelectorFormData.isDataChanged,
      if (hallReservationFormData != null)
        hallReservationFormData.isDataChanged,
      _comment.isDataChanged
    ], _isSummaryDataChanged));
  }

  PropertyController<String> get comment => _comment;

  @override
  set showValidationMsg(bool newValue) {
    // do nothing here
  }

  @override
  Stream<bool> get isValid => _isSummaryDataValid;

  @override
  BehaviorSubject<bool> get isDataChanged => _isSummaryDataChanged;
}
*/

StreamSubscription<bool> combineBooleanStreamsAnd(
    Iterable<Stream<bool>> streams, BehaviorSubject<bool> resultStream) {
  return _combineBooleanStreams(
      streams, resultStream, (prev, element) => prev && element);
}

StreamSubscription<bool> combineBooleanStreamsOr(
    Iterable<Stream<bool>> streams, BehaviorSubject<bool> resultStream) {
  return _combineBooleanStreams(
      streams, resultStream, (prev, element) => prev || element);
}

StreamSubscription<bool> _combineBooleanStreams(
    Iterable<Stream<bool>> streams,
    BehaviorSubject<bool> resultStream,
    bool Function(bool value, bool element) combine) {
  return CombineLatestStream<bool, bool>(streams, (values) {
    return values.reduce(combine);
  }).listen((data) {
    resultStream.add(data);
  });
}

final String Function(DateTime) dateValueFormatter = (DateTime date) {
  return date == null ? null : DateFormat.yMd('ru_RU').format(date);
};

final DateTime Function(DateTime) dateValueFilter = (DateTime date) {
  return resetTimeToMidnight(date);
};

final String Function(String) stringValueFilter = (String value) {
  final trimmedValue = value?.trim();
  return isEmpty(value) ? null : trimmedValue;
};
