import 'package:aahitest/services/helpers.dart';
import 'package:flutter/material.dart';

/// Виджет с подзаголовком страницы
class ScaffoldSubtitle extends StatelessWidget {
  final String title;

  ScaffoldSubtitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints.expand(height: 48),
        child: Material(
            color: const Color(0xFFF7F7F7),
            elevation: 4,
            child: Center(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: OneLineText(title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).primaryTextTheme.caption),
            ))));
  }
}
