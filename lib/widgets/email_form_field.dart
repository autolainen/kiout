import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EmailFormField extends StatefulWidget {
  final TextStyle style;
  final String initialValue;
  final InputDecoration decoration;
  final String errorText;
  final bool autofocus;
  final ValueChanged<String> onChanged;
  final VoidCallback onLostFocus;
  final TextInputAction textInputAction;
  final ValueChanged<String> onSubmitted;

  const EmailFormField(
      {Key key,
      this.style,
      this.initialValue,
      this.decoration,
      this.errorText,
      this.autofocus = false,
      this.onChanged,
      this.onLostFocus,
      this.textInputAction = TextInputAction.next,
      this.onSubmitted})
      : super(key: key);

  @override
  _EmailFormFieldState createState() => _EmailFormFieldState();
}

class _EmailFormFieldState extends State<EmailFormField> {
  final emailFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    emailFocusNode.addListener(() {
      if (!emailFocusNode.hasFocus && widget.onLostFocus != null) {
        widget.onLostFocus();
      }
    });
    if (widget.autofocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        emailFocusNode?.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    emailFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        style: widget.style,
        initialValue: widget.initialValue,
        decoration: widget.decoration ??
            InputDecoration(
                labelText: 'Эл. почта', errorText: widget.errorText),
        keyboardType: TextInputType.emailAddress,
        autocorrect: false,
        inputFormatters: [
          WhitelistingTextInputFormatter(
              RegExp("[a-zA-Z0-9@\\-_.!#\$%&'*+-/=?^`{|}~]")),
          BlacklistingTextInputFormatter(RegExp('[,]'))
        ],
        focusNode: emailFocusNode,
        onChanged: widget.onChanged,
        textInputAction: widget.textInputAction,
        onFieldSubmitted: widget.onSubmitted);
  }
}
