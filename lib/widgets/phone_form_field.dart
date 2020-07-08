import 'dart:math';

import 'package:aahitest/services/form_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiver/strings.dart';

class PhoneFormField extends StatefulWidget {
  final bool autofocus;
  final VoidCallback onLostFocus;
  final ValueChanged<String> onChanged;
  final String phonePrefix;
  final String initValue;
  final String errorText;
  final InputDecoration decoration;
  final TextStyle style;
  final TextInputAction textInputAction;
  final ValueChanged<String> onSubmitted;
  final TextAlignVertical textAlignVertical;

  const PhoneFormField(
      {Key key,
      this.onLostFocus,
      this.phonePrefix = '+7',
      this.initValue = '',
      this.errorText,
      this.onChanged,
      this.decoration,
      this.autofocus = false,
      this.style,
      this.textInputAction = TextInputAction.next,
      this.onSubmitted,
      this.textAlignVertical})
      : super(key: key);

  @override
  _PhoneFormFieldState createState() => _PhoneFormFieldState();
}

class _PhoneFormFieldState extends State<PhoneFormField> {
  final phoneFocusNode = FocusNode();
  TextEditingController phoneTextController;
  final phoneTextInputFormatter = PhoneTextInputFormatter(prettyPhoneFormat);

  @override
  void initState() {
    super.initState();
    final initPhoneValue =
        (widget.initValue ?? '').replaceAll(RegExp(r'\D'), '');
    final textEditingValue = TextEditingValue(
        text: initPhoneValue,
        selection: TextSelection.collapsed(offset: initPhoneValue.length));
    phoneTextController = TextEditingController.fromValue(
        isEmpty(initPhoneValue)
            ? textEditingValue
            : phoneTextInputFormatter.formatEditUpdate(null, textEditingValue));
    phoneFocusNode.addListener(() {
      if (phoneFocusNode.hasFocus && isEmpty(phoneTextController.text)) {
        final _phonePrefix = widget.phonePrefix ?? '';
        phoneTextController.value = TextEditingValue(
            text: _phonePrefix,
            selection: TextSelection.collapsed(offset: _phonePrefix.length));
      }
      if (!phoneFocusNode.hasFocus && widget.onLostFocus != null) {
        widget.onLostFocus();
      }
    });
    phoneTextController.addListener(() {
      if (widget.onChanged != null) {
        widget.onChanged(phoneTextController.text);
      }
    });
    if (widget.autofocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        phoneFocusNode?.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    phoneFocusNode?.dispose();
    phoneTextController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        textAlignVertical: widget.textAlignVertical,
        style: widget.style,
        controller: phoneTextController,
        focusNode: phoneFocusNode,
        decoration: widget.decoration ??
            InputDecoration(labelText: 'Телефон', errorText: widget.errorText),
        keyboardType: TextInputType.number,
        autocorrect: false,
        inputFormatters: <TextInputFormatter>[
          WhitelistingTextInputFormatter.digitsOnly,
          phoneTextInputFormatter
        ],
        textInputAction: widget.textInputAction,
        onFieldSubmitted: widget.onSubmitted);
  }
}

/// Форматтер телефонного номера по шаблону.
///
/// В качестве шаблона принимает строку, где символом '#' отмечены места для цифр.
///
/// На входе метода [formatEditUpdate] ожидает строку, состоящую
/// из одних только цифр. В списке форматтеров ставить его после
/// WhitelistingTextInputFormatter.digitsOnly, который сохраняет положение курсора.
class PhoneTextInputFormatter extends TextInputFormatter {
  final Pattern _placeholderPattern = RegExp(r'(.*?)#');
  final String _pattern, _dialPrefix;

  PhoneTextInputFormatter(String pattern, {String dialPrefix = '7'})
      : _pattern = pattern,
        _dialPrefix = dialPrefix;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var selectionStart = max<int>(newValue?.selection?.start ?? 0, 0);
    var digitsOnly = newValue?.text ?? '';
    if (isNotEmpty(_dialPrefix)) {
      if (!digitsOnly.startsWith(_dialPrefix)) {
        digitsOnly = '$_dialPrefix$digitsOnly';
        selectionStart++;
      }
    }
    final sb = StringBuffer();
    var position = 0;
    var adjustedSelectionStart = selectionStart;
    for (var value in _placeholderPattern.allMatches(_pattern)) {
      if (position < digitsOnly.length) {
        final group1 = value.group(1);
        if (position == selectionStart) {
          adjustedSelectionStart = sb.length;
        }
        sb.write(group1);
        sb.write(digitsOnly.substring(position, position + 1));
        position++;
      } else {
        break;
      }
    }
    if (selectionStart >= position) {
      adjustedSelectionStart = sb.length;
    }
    return TextEditingValue(
        text: sb.toString(),
        selection: TextSelection.collapsed(offset: adjustedSelectionStart));
  }
}
