import 'package:flutter/material.dart';

/// Объект навигации, позволяющий менять параметры отображения страницы.
///
/// В частности позволяет устанавливать цвет фона.
class CustomizablePopupRoute<T> extends PopupRoute<T> {
  /// Builds the primary contents of the route.
  final WidgetBuilder builder;

  final Color _barrierColor;

  CustomizablePopupRoute(
      {RouteSettings settings,
      @required this.builder,
      Color barrierColor = const Color(0x00000001)})
      : _barrierColor = barrierColor,
        assert(builder != null),
        super(settings: settings);

  @override
  Color get barrierColor => _barrierColor;

  @override
  bool get barrierDismissible => false;

  @override
  String get barrierLabel => '';

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    final result = builder(context);
    assert(() {
      if (result == null) {
        throw FlutterError(
            'The builder for route "${settings.name}" returned null.\n'
            'Route builders must never return null.');
      }
      return true;
    }());
    return Semantics(
      scopesRoute: true,
      explicitChildNodes: true,
      child: result,
    );
  }

  @override
  Duration get transitionDuration => Duration(milliseconds: 300);
}
