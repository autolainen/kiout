import 'package:flutter/material.dart';

/// Разметка для большинства элементов списка
///
/// Позволяет разместить иконку, текст в две строки и элемент справа от текста.
/// Любой из элементов может отсутствовать.
class BaseListTile extends StatelessWidget {
  final double minHeight;
  final double maxHeight;
  final Widget leading;
  final Widget title;
  final Widget content;
  final Widget trailing;

  const BaseListTile(
      {Key key,
      this.leading,
      this.title,
      this.content,
      this.trailing,
      this.minHeight = 0.0,
      this.maxHeight = double.infinity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints: BoxConstraints(minHeight: minHeight, maxHeight: maxHeight),
        child: Row(children: <Widget>[
          if (leading != null) leading,
          Expanded(
              child: Center(
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                if (title != null) title,
                if (content != null) content
              ]))),
          if (trailing != null) trailing
        ]));
  }
}
