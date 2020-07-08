import 'dart:async';

import 'package:aahitest/global_services.dart';
import 'package:aahitest/services/events.dart';
import 'package:aahitest/widgets/error_message_widget.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

/// Базовый класс [State] с обработкой флага [loading] и сообщения об ошибке
abstract class ExtendedState<T extends StatefulWidget> extends State<T> {
  ErrorMessage _errorMessage;
  bool loading = false;
  String _subtitleSuffix;
  CompositeSubscription _subscriptions;

  Future<void> wrapLoader(Future Function() callback,
      {bool doRetry = true, VoidCallback onClose}) async {
    try {
      if (mounted) {
        setState(() => loading = true);
      }
      await callback();
    } catch (e, s) {
      eventBus.fire(ExceptionEvent(e, s, false));
      errorMessage = ErrorMessage.forException(e,
          onReload: doRetry
              ? () {
                  errorMessage = null;
                  wrapLoader(callback);
                }
              : null,
          onClose: doRetry
              ? null
              : () {
                  if (mounted) {
                    setState(() {
                      errorMessage = null;
                    });
                  }
                  if (onClose != null) {
                    onClose();
                  }
                });
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  Widget buildContent(BuildContext context);

  @override
  Widget build(BuildContext context) {
    final content = <Widget>[buildContent(context)];
    if (loading) {
      content.add(Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
        decoration: BoxDecoration(color: Color.fromARGB(30, 0, 0, 0)),
      ));
    }
    if (errorMessage != null) {
      final _errorMessage = _subtitleSuffix == null
          ? errorMessage
          : errorMessage.copyWith(
              subtitle: errorMessage.subtitle + _subtitleSuffix);
      if (_errorMessage.onReload != null) {
        content.add(Container(
            decoration: BoxDecoration(color: Color.fromARGB(30, 0, 0, 0))));
      }
      content.add(
          buildErrorMessage(ErrorMessageWidget(errorMessage: _errorMessage)));
    }
    return buildOuterContent(Stack(children: content));
  }

  Widget buildOuterContent(Widget child) {
    return Container(child: child);
  }

  Widget buildErrorMessage(Widget errorMessage) {
    return Positioned(top: 0, left: 0, right: 0, child: errorMessage);
  }

  set subtitleSuffix(String suffix) {
    if (mounted && errorMessage != null) {
      setState(() {
        _subtitleSuffix = suffix;
      });
    }
  }

  ErrorMessage get errorMessage => _errorMessage;

  set errorMessage(ErrorMessage value) {
    _errorMessage = value;
    _subtitleSuffix = null;
  }

  void addSubscription(StreamSubscription subscription) {
    if (subscription != null) {
      _subscriptions ??= CompositeSubscription();
      _subscriptions.add(subscription);
    }
  }

  @override
  void dispose() {
    _subscriptions?.dispose();
    super.dispose();
  }
}
