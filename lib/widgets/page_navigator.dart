import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class PageNavigator extends StatelessWidget {
  final Stream<int> currentPage;
  final Stream<bool> changesEnabled;
  final List<Stream<bool>> pagesEnabled;

  final void Function(int) onPageTap;
  final VoidCallback onPrevTap;
  final VoidCallback onNextTap;

  const PageNavigator(this.currentPage, this.pagesEnabled, this.changesEnabled,
      {Key key, this.onPageTap, this.onPrevTap, this.onNextTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    VoidCallback makeOnTapCallback(int pageIndex) {
      return onPageTap == null
          ? null
          : () {
              onPageTap(pageIndex);
            };
    }

    var counter = 0;
    final pageIndicators = <Widget>[];
    final prevPagesEnabled = <Stream<bool>>[changesEnabled];
    for (final isPageEnabled in pagesEnabled) {
      pageIndicators.add(PageIndicator(counter, currentPage,
          _combineBooleanStreams(List.of(prevPagesEnabled)),
          onTap: makeOnTapCallback(counter)));
      prevPagesEnabled.add(isPageEnabled);
      counter++;
    }

    Widget prevButton;
    Widget nextButton;
    if (onPrevTap != null) {
      prevButton = StreamBuilder<bool>(
          stream: _combineBooleanStreams([
            changesEnabled,
            currentPage.transform<bool>(
                StreamTransformer<int, bool>.fromHandlers(
                    handleData: (int value, EventSink<bool> sink) =>
                        sink.add(value > 0)))
          ]),
          builder: (context, snapshot) {
            return NavigationButton(
                text: 'Назад',
                onPressed: snapshot.data ?? false ? onPrevTap : null,
                showLeftArrow: true);
          });
    }
    if (onNextTap != null) {
      final isNotLastPage = currentPage.transform<bool>(
          StreamTransformer<int, bool>.fromHandlers(
              handleData: (int value, EventSink<bool> sink) =>
                  sink.add(value < pagesEnabled.length - 1)));
      nextButton = StreamBuilder<bool>(
          stream: isNotLastPage,
          builder: (context, isNotLastPageSnapshot) {
            return StreamBuilder<bool>(
                stream: _combineBooleanStreams([changesEnabled, isNotLastPage]),
                builder: (context, isEnabledSnapshot) {
                  return NavigationButton(
                      text: isNotLastPageSnapshot.data ?? true
                          ? 'Далее'
                          : 'Готово',
                      onPressed:
                          isEnabledSnapshot.data ?? false ? onNextTap : null,
                      showRightArrow: isNotLastPageSnapshot.data ?? true);
                });
          });
    }

    return Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
      if (prevButton != null)
        Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: prevButton,
        ),
      Expanded(
          child: Row(
        children: pageIndicators
            .map<Widget>((pageIndicator) => Flexible(
                  child: pageIndicator,
                ))
            .toList(),
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
      )),
      if (nextButton != null)
        Padding(
          padding: const EdgeInsets.only(right: 4.0),
          child: nextButton,
        ),
    ]);
  }

  Stream<bool> _combineBooleanStreams(List<Stream<bool>> streams) =>
      CombineLatestStream<bool, bool>(streams, (values) {
        return values.reduce((prev, element) => prev && element);
      });
}

class PageIndicator extends StatefulWidget {
  final Color enabledPageColor;
  final Color disabledPageColor;
  final double pagePinSize;
  final double currentPagePinSize;
  final int pageIndex;
  final double maxWidth;
  final Stream<int> currentPage;
  final Stream<bool> isPageEnabled;
  final VoidCallback onTap;

  PageIndicator(this.pageIndex, this.currentPage, this.isPageEnabled,
      {Key key,
      this.maxWidth = 50,
      this.pagePinSize = 10,
      this.currentPagePinSize = 14,
      this.disabledPageColor = const Color(0xFFE5E5E5),
      this.enabledPageColor = const Color(0xFF808080),
      this.onTap})
      : super(key: key);

  @override
  _PageIndicatorState createState() => _PageIndicatorState();
}

class _PageIndicatorState extends State<PageIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController animation;

  @override
  void initState() {
    super.initState();
    animation =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    widget.currentPage.listen((newPageIndex) {
      if (newPageIndex == widget.pageIndex) {
        animation.forward();
      } else if (newPageIndex != widget.pageIndex) {
        animation.reverse();
      }
    });
  }

  @override
  void dispose() {
    animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final animatedChild =
        _createCircle(widget.currentPagePinSize, Theme.of(context).accentColor);
    return ConstrainedBox(
        constraints: BoxConstraints(maxWidth: widget.maxWidth),
        child: StreamBuilder<bool>(
            stream: widget.isPageEnabled,
            builder: (context, snapshot) {
              final isEnabled = snapshot.data ?? false;
              return InkResponse(
                  onTap: isEnabled ? widget.onTap : null,
                  child: Stack(children: <Widget>[
                    Center(
                        child: _createCircle(
                            widget.pagePinSize,
                            isEnabled
                                ? widget.enabledPageColor
                                : widget.disabledPageColor)),
                    Center(
                        child: FadeTransition(
                            opacity: CurvedAnimation(
                                curve: Curves.easeInQuint,
                                parent: animation,
                                reverseCurve: Curves.easeOutQuint),
                            child: animatedChild)),
                  ]));
            }));
  }

  Widget _createCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class NavigationButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool showLeftArrow;
  final bool showRightArrow;

  NavigationButton(
      {this.text,
      this.onPressed,
      this.showLeftArrow = false,
      this.showRightArrow = false});

  @override
  Widget build(BuildContext context) {
    final mqData = MediaQuery.of(context);
    final isSmallScreen = mqData.size.width <= 320.0;
    final btnPadding = isSmallScreen ? 5.0 : 8.0;
    return FlatButton(
        textColor: Theme.of(context).accentColor,
        padding: EdgeInsets.symmetric(horizontal: btnPadding),
        child: Row(
          children: <Widget>[
            if (showLeftArrow)
              Icon(
                Icons.chevron_left,
                size: isSmallScreen ? 18.0 : 24.0,
              ),
            Text(
              text.toUpperCase(),
              style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
            ),
            if (showRightArrow)
              Icon(
                Icons.chevron_right,
                size: isSmallScreen ? 18.0 : 24.0,
              ),
          ],
        ),
        onPressed: onPressed);
  }
}
