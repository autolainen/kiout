import 'package:flutter/material.dart';
import 'package:quiver/strings.dart';

/// Виджет для отображения нередактируемого текстового поля в форме
class ImmutableTextFormField extends StatelessWidget {
  final String value;
  final InputDecoration decoration;
  final VoidCallback onTap;
  final TextStyle style;
  final double horizontalPadding;

  const ImmutableTextFormField(
      {Key key,
      this.value,
      this.onTap,
      this.decoration = const InputDecoration(),
      this.style = const TextStyle(fontSize: 16),
      this.horizontalPadding = 16})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: InputDecorator(
                decoration: decoration,
                isEmpty: isEmpty(value),
                child: Text(value ?? '', maxLines: 2, style: style))),
        onTap: onTap);
  }
}
