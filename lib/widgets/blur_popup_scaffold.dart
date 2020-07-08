import 'dart:ui';

import 'package:flutter/material.dart';

class BlurPopupScaffold extends StatelessWidget {
  final VoidCallback onOkPressed;
  final VoidCallback onClosePressed;
  final Widget child;

  const BlurPopupScaffold(
      {Key key, this.onOkPressed, this.onClosePressed, this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appBarBtnColor = const Color(0xFF3B3B3B);
    return Material(
      color: const Color.fromARGB(178, 247, 247, 247),
      child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  automaticallyImplyLeading: false,
                  leading: IconButton(
                      tooltip: 'Закрыть',
                      icon: Icon(Icons.close, color: appBarBtnColor),
                      onPressed: onClosePressed ??
                          () {
                            Navigator.of(context).pop();
                          }),
                  actions: onOkPressed == null
                      ? null
                      : <Widget>[
                          IconButton(
                              tooltip: 'Сохранить',
                              color: appBarBtnColor,
                              disabledColor: const Color(0x1F000000),
                              icon: Icon(Icons.check),
                              onPressed: onOkPressed)
                        ]),
              body: child)),
    );
  }
}
