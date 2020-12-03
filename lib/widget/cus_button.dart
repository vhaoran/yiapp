import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/11/30 下午3:36
// usage ：自定义 RaisedButton 按钮
// ------------------------------------------------------

class CusRaisedButton extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final ShapeBorder shape;
  final Color backgroundColor; // 默认空，不为空时按钮为单个颜色
  final Color textColor;
  final Color disabledTextColor;
  final Color splashColor; // 点击按钮时的颜色
  final double radius; // 按钮半径
  final List<Color> colors; // 线性颜色
  final VoidCallback onPressed;

  CusRaisedButton({
    @required this.child,
    this.padding,
    this.shape,
    this.backgroundColor,
    this.textColor: Colors.white,
    this.disabledTextColor,
    this.splashColor,
    this.radius: 0,
    this.colors: const [t_yi, t_red],
    @required this.onPressed,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _CusRaisedButton.buildButton(this);
  }
}

class _CusRaisedButton extends MaterialButton {
  final Gradient gradient;

  _CusRaisedButton({
    Widget child,
    EdgeInsetsGeometry padding,
    ShapeBorder shape,
    Color textColor,
    Color disabledTextColor,
    Color splashColor,
    VoidCallback onPressed,
    this.gradient,
    Key key,
  }) : super(
          child: child,
          padding: padding,
          shape: shape,
          textColor: textColor,
          disabledTextColor: disabledTextColor,
          splashColor: splashColor,
          onPressed: onPressed,
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      button: true,
      child: Focus(
        focusNode: focusNode,
        child: DecoratedBox(
          decoration: ShapeDecoration(
            gradient: gradient,
            shape: ButtonTheme.of(context).getShape(this),
          ),
          child: _buttonChild(context),
        ),
      ),
    );
  }

  Widget _buttonChild(context) {
    final ButtonThemeData buttonTheme = ButtonTheme.of(context);
    final TextStyle textStyle = Theme.of(context)
        .textTheme
        .button
        .copyWith(color: buttonTheme.getTextColor(this));
    final double currentElevation = (enabled ? elevation : disabledElevation) ??
        buttonTheme.getElevation(this);
    return ConstrainedBox(
      constraints: buttonTheme.getConstraints(this),
      child: Material(
        elevation: currentElevation,
        textStyle: textStyle,
        shape: buttonTheme.getShape(this),
        type: MaterialType.transparency,
        animationDuration: buttonTheme.getAnimationDuration(this),
        clipBehavior: clipBehavior ?? Clip.none,
        child: InkWell(
          splashColor: buttonTheme.getSplashColor(this),
          onTap: onPressed,
          customBorder: buttonTheme.getShape(this),
          child: IconTheme.merge(
            data: IconThemeData(color: textStyle?.color),
            child: Container(
              padding: buttonTheme.getPadding(this),
              child: Center(widthFactor: 1, heightFactor: 1, child: child),
            ),
          ),
        ),
      ),
    );
  }

  static Widget buildButton(CusRaisedButton button) {
    List<Color> colors = button.backgroundColor == null
        ? button.colors
        : [button.backgroundColor, button.backgroundColor];
    final LinearGradient gradient = LinearGradient(
      colors: colors,
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      tileMode: TileMode.clamp,
    );
    final ShapeBorder shape = button.radius != 0
        ? RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(button.radius)),
          )
        : button.shape;
    return _CusRaisedButton(
      child: button.child,
      padding: button.padding,
      shape: shape,
      textColor: button.textColor,
      disabledTextColor: button.disabledTextColor,
      splashColor: button.splashColor,
      onPressed: button.onPressed,
      gradient: gradient,
    );
  }
}
