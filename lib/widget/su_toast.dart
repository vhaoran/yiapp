import 'dart:collection';
import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/animation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/11/30 下午4:18
// usage ：自定义 toast
// ------------------------------------------------------

enum SuToastPosition { center, top, bottom }

enum SuToastStyle { dark, light }

typedef SuToastContentBuilder = Widget Function(BuildContext context);

// 目前该Toast存在双击输入框出现异常，暂时先不用
class SuToast {
  /// 文本
  static void text({
    String text,
    Duration showDuration,
    SuToastPosition position,
    SuToastStyle style,
    VoidCallback onDismissed,
  }) {
    _showToast(
      text,
      showDuration: showDuration,
      position: position,
      style: style,
      type: _SuToastType.text,
      onDismissed: onDismissed,
    );
  }

  /// 带感叹号的提示
  static void info({
    @required String text,
    Duration showDuration,
    SuToastPosition position,
    SuToastStyle style,
    VoidCallback onDismissed,
  }) {
    _showToast(
      text,
      showDuration: showDuration,
      position: position,
      style: style,
      type: _SuToastType.info,
      onDismissed: onDismissed,
    );
  }

  /// 成功提示
  static void success({
    String text,
    Duration showDuration,
    SuToastPosition position,
    SuToastStyle style,
    VoidCallback onDismissed,
  }) {
    _showToast(
      text,
      showDuration: showDuration,
      position: position,
      style: style,
      type: _SuToastType.success,
      onDismissed: onDismissed,
    );
  }

  /// 错误提示
  static void error({
    String text,
    Duration showDuration,
    SuToastPosition position,
    SuToastStyle style,
    VoidCallback onDismissed,
  }) {
    _showToast(text,
        showDuration: showDuration,
        position: position,
        style: style,
        type: _SuToastType.error,
        onDismissed: onDismissed);
  }

  /// 加载类型的弹框
  static Function loading({
    String text,
    SuToastPosition position,
    SuToastStyle style,
  }) {
    _showToast(
      text,
      position: position,
      style: style,
      type: _SuToastType.loading,
    );
  }
}

class SuToastDefaults {
  const SuToastDefaults({
    this.showDuration = const Duration(milliseconds: 1500),
    this.darkColor = Colors.white,
    this.darkBackgroundColor = Colors.black87,
    this.backgroundOpacity = 0.8,
    this.lightColor = const Color(0xFF2F2F2F),
    this.lightBackgroundColor = const Color(0xFFE0E0E0),
    this.position = SuToastPosition.center,
    this.style = SuToastStyle.dark,
    this.dismissOtherToast = true,
    this.hideWithTap = true,
    this.textDirection = TextDirection.ltr,
    this.topOffset = kToolbarHeight + 10,
    this.bottomOffset = 10,
  });

  final Duration showDuration;
  final Color darkColor; // include text & icon
  final Color darkBackgroundColor;
  final double backgroundOpacity;
  final Color lightColor; // include text & icon
  final Color lightBackgroundColor;
  final SuToastPosition position;
  final SuToastStyle style;
  final bool dismissOtherToast;
  final bool hideWithTap;
  final TextDirection textDirection;
  final double topOffset;
  final double bottomOffset;
}

class SuToastProvider extends StatefulWidget {
  final SuToastDefaults defaults;
  final Widget child;

  SuToastProvider({
    this.defaults = const SuToastDefaults(),
    @required this.child,
    Key key,
  })  : assert(defaults != null),
        assert(child != null),
        super(key: key);

  @override
  State<SuToastProvider> createState() => _SuToastProviderState();
}

class _SuToastProviderState extends State<SuToastProvider> {
  @override
  void initState() {
    super.initState();
    GestureBinding.instance.pointerRouter.addGlobalRoute(_handlePointerEvent);
  }

  void _handlePointerEvent(PointerEvent event) {
    if (!widget.defaults.hideWithTap) return;

    if (!_toastManager.hasShowingToast()) return;

    if (event is PointerUpEvent || event is PointerCancelEvent) {
      _toastManager.dismissAllToast();
    }
  }

  @override
  Widget build(BuildContext context) {
    Overlay overlay = Overlay(
      initialEntries: [
        OverlayEntry(builder: (BuildContext context) {
          _contextMap[this] = context;
          return widget.child;
        })
      ],
    );

    return _SuToastDefaultsWidget(
      defaults: widget.defaults,
      child: Directionality(
        textDirection: widget.defaults.textDirection,
        child: Stack(
          children: <Widget>[
            overlay,
            Positioned.fill(
                child: IgnorePointer(
              child: Container(
                color: Colors.black.withOpacity(0),
              ),
            ))
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _contextMap.remove(this);
    GestureBinding.instance.pointerRouter
        .removeGlobalRoute(_handlePointerEvent);
    super.dispose();
  }
}

LinkedHashMap<_SuToastProviderState, BuildContext> _contextMap =
    LinkedHashMap();
final _SuToastManager _toastManager = _SuToastManager._();
final EdgeInsetsGeometry _padding =
    const EdgeInsets.symmetric(horizontal: 20, vertical: 13);
final double _iconSize = 36.0;
final double _toastMarginHorizontal = 10;

enum _SuToastType { text, loading, success, error, info, custom }

Function _showToast(
  String text, {
  Duration showDuration,
  SuToastPosition position,
  SuToastStyle style,
  _SuToastType type,
  SuToastContentBuilder contentBuilder,
  VoidCallback onDismissed,
}) {
  BuildContext context = _contextMap.values.first;
  OverlayEntry entry;
  SuToastDefaults defaults = _SuToastDefaultsWidget.of(context);

  position ??= defaults.position;
  style ??= defaults.style;
  Color color =
      (style == SuToastStyle.dark) ? defaults.darkColor : defaults.lightColor;
  Color backgroundColor = (style == SuToastStyle.dark)
      ? defaults.darkBackgroundColor
      : defaults.lightBackgroundColor;
  double backgroundOpacity = defaults.backgroundOpacity;
  double topOffset = defaults.topOffset;
  double bottomOffset = defaults.bottomOffset;
  showDuration ??= (type == _SuToastType.custom) ? null : defaults.showDuration;
  if (type == _SuToastType.loading)
    showDuration = null; //loading type no duration
  Widget slotWidget = _typeWidget(type, color);

  GlobalKey<_SuToastViewState> key = GlobalKey();

  _SuToastView toastView = _SuToastView(
    key: key,
    color: color,
    backgroundColor: backgroundColor,
    backgroundOpacity: backgroundOpacity,
    text: text,
    padding: _padding,
    showDuration: showDuration,
    slotWidget: slotWidget,
    slotBuilder: contentBuilder,
    canBeAutoClear: type != _SuToastType.loading,
    position: position,
    style: style,
    topOffset: topOffset,
    bottomOffset: bottomOffset,
    onDismissed: onDismissed,
  );
  entry = OverlayEntry(builder: (BuildContext context) => toastView);

  if (defaults.dismissOtherToast == true) {
    _toastManager.dismissAllToast(immediately: true);
  }

  Overlay.of(context).insert(entry);
  _toastManager.addToast(_SuToastPack(key: key, entry: entry));
  SemanticsService.tooltip(text);

  return () {
    key.currentState?._dismiss();
  };
}

class _SuToastPack {
  _SuToastPack({this.key, this.entry});

  final Key key;
  final OverlayEntry entry;
}

Widget _typeWidget(_SuToastType type, Color tintColor) {
  if (type == _SuToastType.loading) {
    return CircularProgressIndicator(
      strokeWidth: 3.0,
      valueColor: AlwaysStoppedAnimation(tintColor),
    );
  } else if (type == _SuToastType.success) {
    return Icon(
      Icons.check_circle_outline,
      size: _iconSize,
      color: tintColor,
    );
  } else if (type == _SuToastType.info) {
    return Icon(
      Icons.info_outline,
      size: _iconSize,
      color: tintColor,
    );
  } else if (type == _SuToastType.error) {
    return Icon(
      Icons.highlight_off,
      size: _iconSize,
      color: tintColor,
    );
  }
  return null;
}

class _SuToastManager {
  _SuToastManager._();

  Map<GlobalKey<_SuToastViewState>, _SuToastPack> _toastMap = Map();

  bool hasShowingToast() => _toastMap.length > 0;

  void dismissAllToast({bool immediately = false}) {
    if (_toastMap.length == 0) {
      return;
    }

    _toastMap.forEach((key, pack) {
      if (key.currentState != null && key.currentState._showing) {
        _SuToastView toastView = key.currentWidget;
        if (toastView.canBeAutoClear) {
          key.currentState._dismiss(immediately: immediately);
        }
      }
    });
  }

  void addToast(_SuToastPack pack) {
    _toastMap[pack.key] = pack;
  }

  void removeToast(Key key) {
    if (!_toastMap.containsKey(key)) {
      return;
    }

    _toastMap.remove(key);
  }

  void removeEntry(Key key) {
    if (!_toastMap.containsKey(key)) {
      return;
    }

    _SuToastPack pack = _toastMap[key];
    pack.entry?.remove();
  }
}

class _SuToastDefaultsWidget extends InheritedWidget {
  const _SuToastDefaultsWidget({
    Key key,
    this.defaults,
    Widget child,
  }) : super(key: key, child: child);

  final SuToastDefaults defaults;

  @override
  bool updateShouldNotify(_SuToastDefaultsWidget oldWidget) =>
      this.defaults != oldWidget.defaults;

  static SuToastDefaults of(BuildContext context) {
    _SuToastDefaultsWidget defaultsWidget = context
        .dependOnInheritedWidgetOfExactType(aspect: _SuToastDefaultsWidget);
    return defaultsWidget.defaults;
  }
}

class _SuToastView extends StatefulWidget {
  _SuToastView(
      {Key key,
      this.text,
      this.padding,
      this.slotWidget,
      this.slotBuilder,
      this.color,
      this.backgroundColor,
      this.backgroundOpacity,
      this.showDuration,
      this.canBeAutoClear = true,
      this.position,
      this.style,
      this.topOffset,
      this.bottomOffset,
      this.onDismissed})
      : assert(slotWidget != null || text != null || slotBuilder != null),
        super(key: key);

  final String text;
  final EdgeInsetsGeometry padding;
  final Widget slotWidget;
  final SuToastContentBuilder slotBuilder;
  final Color color;
  final Color backgroundColor;
  final double backgroundOpacity;
  final Duration showDuration;
  final bool canBeAutoClear;
  final SuToastPosition position;
  final SuToastStyle style;
  final double topOffset;
  final double bottomOffset;
  final VoidCallback onDismissed;

  @override
  State<_SuToastView> createState() => _SuToastViewState();
}

class _SuToastViewState extends State<_SuToastView>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  // duration follow tooltip
  static const Duration _fadeInDuration = Duration(milliseconds: 150);
  static const Duration _fadeOutDuration = Duration(milliseconds: 75);
  static const Duration _waitDuration = Duration(milliseconds: 0);
  AnimationController _controller;
  Timer _showTimer;
  Timer _hideTimer;
  bool _showing = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: _fadeInDuration,
        reverseDuration: _fadeOutDuration,
        vsync: this)
      ..addStatusListener(_handleStatusChanged);
    WidgetsBinding.instance.addObserver(this);
    _show();
  }

  void _handleStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.dismissed) {
      _dismiss(immediately: true);
      if (widget.onDismissed != null) {
        widget.onDismissed();
      }
    }
  }

  void _dismiss({bool immediately = false}) {
    _showTimer?.cancel();
    _showTimer = null;
    if (immediately) {
      _toastManager.removeEntry(widget.key);
      _showing = false;
      return;
    }
    _controller.reverse();
  }

  void _show() {
    _hideTimer?.cancel();
    _hideTimer = null;
    _showTimer ??= Timer(_waitDuration, () {
      _showTimer?.cancel();
      _showTimer = null;
      _controller.forward();
      _showing = true;
      if (widget.showDuration != null) {
        _hideTimer = Timer(widget.showDuration, _dismiss);
      }
    });
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    setState(() {});
  }

  @override
  void deactivate() {
    if (_showing) {
      _dismiss(immediately: true);
    }
    _toastManager.removeToast(widget.key);
    super.deactivate();
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _hideTimer = null;
    _showTimer?.cancel();
    _showTimer = null;
    _controller.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQueryData.fromWindow(ui.window);
    final double marginTop = widget.topOffset + mediaQueryData.padding.top;
    final double marginBottom =
        widget.bottomOffset + mediaQueryData.padding.bottom;
    MainAxisAlignment alignment = MainAxisAlignment.center;
    if (widget.position == SuToastPosition.top)
      alignment = MainAxisAlignment.start;
    else if (widget.position == SuToastPosition.bottom)
      alignment = MainAxisAlignment.end;

    final List<Widget> children = <Widget>[];
    // add custom slot
    if (widget.slotWidget != null) {
      children.add(widget.slotWidget);
      if (widget.text != null) {
        children.add(SizedBox(height: 8.0));
      }
    }
    // custom slot builder
    if (widget.slotBuilder != null) {
      children.add(widget.slotBuilder(context));
      if (widget.text != null) {
        children.add(SizedBox(height: 8.0));
      }
    }
    // add text
    if (widget.text != null) {
      children.add(Text(widget.text,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: widget.color,
              fontSize: 17,
              decoration: TextDecoration.none)));
    }

    return AbsorbPointer(
      child: FadeTransition(
        opacity: _controller,
        child: Column(
          mainAxisAlignment: alignment,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                  top: marginTop,
                  bottom: marginBottom,
                  left: _toastMarginHorizontal,
                  right: _toastMarginHorizontal),
              decoration: BoxDecoration(
                  color: widget.backgroundColor
                      .withOpacity(widget.backgroundOpacity),
                  borderRadius: BorderRadius.circular(5.0)),
              padding: widget.padding,
              child: Column(mainAxisSize: MainAxisSize.min, children: children),
            ),
          ],
        ),
      ),
    );
  }
}
