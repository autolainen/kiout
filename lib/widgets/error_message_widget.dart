import 'dart:io' as io;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quiver/strings.dart';

/// Сообщение об ошибке с кнопкой повтора
class ErrorMessageWidget extends StatefulWidget {
  static const errorMessageColor = Color(0xE97EBB84);

  final ErrorMessage errorMessage;

  const ErrorMessageWidget({
    Key key,
    this.errorMessage = const ErrorMessage(),
  }) : super(key: key);

  @override
  _ErrorMessageWidgetState createState() => _ErrorMessageWidgetState();
}

class _ErrorMessageWidgetState extends State<ErrorMessageWidget>
    with TickerProviderStateMixin {
  static const _actionBtnWidth = 56.0;
  static const _exclamationMarkWidth = 56.0;
  static const _exclamationMarkHeight = 64.0;
  static const _actionBtnHeight = 64.0;
  static const _textVerticalSpacing = 10.0;
  bool _showTechDetails = false;

  @override
  Widget build(BuildContext context) {
    final hasActionButton = widget.errorMessage?.hasAction ?? false;
    return Material(
        elevation: 6,
        color: Color(0x00FFFFFF),
        child: Ink(
            color: ErrorMessageWidget.errorMessageColor,
            child: Stack(children: <Widget>[
              ConstrainedBox(
                constraints: BoxConstraints(minHeight: _actionBtnHeight),
                child: InkWell(
                  onTap: isBlank(widget.errorMessage?.techDetails)
                      ? null
                      : () {
                          setState(() {
                            _showTechDetails = !_showTechDetails;
                          });
                        },
                  child: Padding(
                    padding: EdgeInsets.only(
                        right: hasActionButton ? _actionBtnWidth : 0,
                        left: _exclamationMarkWidth),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        ConstrainedBox(
                            constraints:
                                BoxConstraints(minHeight: _actionBtnHeight),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: _textVerticalSpacing),
                                    child: Text(
                                        widget.errorMessage?.title ?? '',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  if (isNotBlank(widget.errorMessage?.subtitle))
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: _textVerticalSpacing),
                                        child: Text(
                                            widget.errorMessage.subtitle,
                                            style: TextStyle(
                                                color: Colors.white))),
                                ],
                              ),
                            )),
                        if (isNotBlank(widget.errorMessage?.techDetails))
                          SizeChangedLayoutNotifier(
                            child: AnimatedSize(
                                duration: Duration(milliseconds: 300),
                                vsync: this,
                                child: _showTechDetails
                                    ? Padding(
                                        padding: EdgeInsets.only(
                                          bottom: _textVerticalSpacing,
                                        ),
                                        child: Text(
                                            widget.errorMessage.techDetails,
                                            style:
                                                TextStyle(color: Colors.white)))
                                    : Container()),
                          )
                      ],
                    ),
                  ),
                ),
              ),
              if (hasActionButton)
                Positioned(
                    right: 0,
                    child: InkResponse(
                        child: SizedBox(
                            width: _actionBtnWidth,
                            height: _actionBtnHeight,
                            child: Icon(
                                widget.errorMessage.onClose == null
                                    ? Icons.autorenew
                                    : Icons.close,
                                color: Colors.white)),
                        onTap: widget.errorMessage.onClose ??
                            widget.errorMessage.onReload)),
              Positioned(
                  left: 0,
                  child: IgnorePointer(
                      child: SizedBox(
                          width: _exclamationMarkWidth,
                          height: _exclamationMarkHeight,
                          child: Icon(Icons.error, color: Colors.white))))
            ])));
  }
}

class ErrorMessage {
  final String title;
  final String subtitle;
  final String techDetails;
  final VoidCallback onReload;
  final VoidCallback onClose;

  const ErrorMessage(
      {this.title = 'Ошибка загрузки',
      this.subtitle,
      this.techDetails,
      this.onReload,
      this.onClose});

  ErrorMessage copyWith({String title, String subtitle}) {
    return ErrorMessage(
        title: title ?? this.title,
        subtitle: subtitle ?? this.subtitle,
        techDetails: techDetails,
        onReload: onReload,
        onClose: onClose);
  }

  factory ErrorMessage.forException(Object exception,
      {VoidCallback onReload, VoidCallback onClose}) {
    const retryOrContactManager =
        'Попробуйте еще раз через некоторое время или свяжитесь с менеджером';
    ErrorMessage result;
    if (exception is io.HttpException) {
      result = ErrorMessage(
          title: 'Ошибка сервера',
          subtitle: retryOrContactManager,
          techDetails: exception.toString(),
          onReload: onReload,
          onClose: onClose);
/*
    } else if (exception is HttpException) {
      result = ErrorMessage(
          title: 'Ошибка',
          subtitle: exception.data['userMessage']?.toString() ??
              retryOrContactManager,
          techDetails: exception.toString(),
          onReload: onReload,
          onClose: onClose);
*/
    } else if (exception is io.IOException) {
      result = ErrorMessage(
          title: 'Ошибка соединения',
          subtitle: 'Проверьте сеть и повторите попытку',
          techDetails: exception.toString(),
          onReload: onReload,
          onClose: onClose);
/*
    } else if (exception is ExtAppException) {
      result = ErrorMessage(
          title: 'Ошибка',
          subtitle: exception.toString(),
          techDetails: exception.details?.toString(),
          onReload: onReload,
          onClose: onClose);
*/
    } else {
      result = ErrorMessage(
          title: 'Ошибка',
          subtitle: retryOrContactManager,
          techDetails: exception?.toString() ?? 'null',
          onReload: onReload,
          onClose: onClose);
    }
    return result;
  }

  bool get hasAction {
    return onReload != null || onClose != null;
  }
}
