import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../const/const_color.dart';
import '../../tools/adapt.dart';
import '../../tools/cus_callback.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/7 10:39
// usage ：自定义组件盒(如右侧箭头功能、开关按钮等)
// ------------------------------------------------------

/// 适用于主标题必填，副标题和右则翻页箭头选填
class NormalBox extends StatefulWidget {
  final String title;
  final String subtitle;
  final bool showBtn; // 默认显示右箭头按钮
  final VoidCallback onTap;

  NormalBox({
    @required this.title,
    this.subtitle,
    this.showBtn = true,
    this.onTap,
  });

  @override
  _NormalBoxState createState() => _NormalBoxState();
}

class _NormalBoxState extends State<NormalBox> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: Adapt.px(2)),
      child: Material(
        color: Colors.transparent,
        child: Ink(
          color: fif_primary,
          child: InkWell(
            onTap: widget.onTap ?? null,
            child: Container(
                alignment: Alignment.center,
                constraints: BoxConstraints(maxHeight: Adapt.px(100)),
                padding:
                    EdgeInsets.only(left: Adapt.px(30), right: Adapt.px(20)),
                child: _row(widget.title, widget.subtitle)),
          ),
        ),
      ),
    );
  }

  Widget _row(String title, String subtitle) {
    return Row(
      children: <Widget>[
        Text(title, style: TextStyle(fontSize: Adapt.px(28), color: t_gray)),
        Spacer(flex: 1),
        if (subtitle != null)
          Container(
            constraints: BoxConstraints(maxWidth: Adapt.px(400)),
            padding: EdgeInsets.only(right: widget.showBtn ? Adapt.px(10) : 0),
            child: Text(
              subtitle,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                // color: Color(0xFF888888),
                color: t_gray,
                fontSize: Adapt.px(28),
              ),
            ),
          ),
        if (widget.showBtn)
          Icon(Icons.keyboard_arrow_right, size: Adapt.px(44), color: t_gray),
      ],
    );
  }
}

/// 适用于主副标题上下分布的布局，如发布群公告
class DiffLeveBox extends StatefulWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  DiffLeveBox({
    @required this.title,
    this.subtitle,
    this.onTap,
  });

  @override
  _DiffLeveBoxState createState() => _DiffLeveBoxState();
}

class _DiffLeveBoxState extends State<DiffLeveBox> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: Adapt.px(3)),
      child: Material(
        child: Ink(
          color: CusColors.terSystemBg(context),
          child: InkWell(
            onTap: widget.onTap ?? () {},
            child: Container(
                alignment: Alignment.center,
                constraints: BoxConstraints(maxHeight: Adapt.px(120)),
                padding: EdgeInsets.symmetric(horizontal: Adapt.px(30)),
                child: _row(widget.title, widget.subtitle)),
          ),
        ),
      ),
    );
  }

  Widget _row(String title, String subtitle) {
    return Row(
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(title, style: TextStyle(fontSize: Adapt.px(30))),
            Text(subtitle,
                style: TextStyle(
                    fontSize: Adapt.px(28),
                    color: CusColors.secLabel(context))),
          ],
        ),
        Spacer(flex: 1),
        Icon(Icons.keyboard_arrow_right, size: Adapt.px(40)),
      ],
    );
  }
}

/// 适用于一个主标题，一个开关的布局，如置顶聊天
class SwitchBox extends StatefulWidget {
  final String title;
  bool status;
  final Color backgroundColor;
  final FnBool fnBool;

  SwitchBox({
    @required this.title,
    this.status = false,
    this.backgroundColor: fif_primary,
    this.fnBool,
  });

  @override
  _SwitchBoxState createState() => _SwitchBoxState();
}

class _SwitchBoxState extends State<SwitchBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      constraints: BoxConstraints(maxHeight: Adapt.px(100)),
      padding: EdgeInsets.symmetric(horizontal: Adapt.px(30)),
      margin: EdgeInsets.only(bottom: Adapt.px(3)),
      color: widget.backgroundColor,
      child: _row(widget.title),
    );
  }

  Widget _row(String title) {
    return Row(
      children: <Widget>[
        Text(title, style: TextStyle(fontSize: Adapt.px(30), color: t_gray)),
        Spacer(flex: 1),
        CupertinoSwitch(
          value: widget.status,
          onChanged: (value) {
            setState(() {
              widget.status = value;
            });
            if (widget.fnBool != null) {
              widget.fnBool(widget.status);
            }
          },
        )
      ],
    );
  }
}

/// 适用于单文本的布局，如退出登录
class SingleTextBox extends StatefulWidget {
  final String title;
  final Color color;
  final VoidCallback onTap;

  SingleTextBox({
    @required this.title,
    this.color = Colors.redAccent,
    this.onTap,
  });

  @override
  _SingleTextBoxState createState() => _SingleTextBoxState();
}

class _SingleTextBoxState extends State<SingleTextBox> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: Adapt.px(3)),
      child: Material(
        color: Colors.transparent,
        child: Ink(
          color: fif_primary,
          child: InkWell(
            onTap: widget.onTap ?? () {},
            child: Container(
              alignment: Alignment.center,
              constraints: BoxConstraints(maxHeight: Adapt.px(100)),
              child: Text(
                widget.title,
                style: TextStyle(
                  fontSize: Adapt.px(28),
                  color: widget.color,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 适用于左边一个widget，右边一个标题，右侧带有箭头或者Widget的布局
class ImageIconBox extends StatefulWidget {
  final Widget child;
  final Widget trailing; // 当showBtn为false时，显示末尾处组件
  final String title;
  final bool showBtn; // 默认显示尾部的箭头
  final VoidCallback onTap;

  ImageIconBox({
    @required this.child,
    @required this.title,
    this.trailing,
    this.showBtn = true,
    this.onTap,
  });

  @override
  _ImageIconBoxState createState() => _ImageIconBoxState();
}

class _ImageIconBoxState extends State<ImageIconBox> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: Adapt.px(5)),
      child: Material(
        child: Ink(
          color: CusColors.terSystemBg(context),
          child: InkWell(
            onTap: widget.onTap,
            child: Container(
              alignment: Alignment.center,
              constraints: BoxConstraints(maxHeight: Adapt.px(100)),
              padding: EdgeInsets.symmetric(horizontal: Adapt.px(30)),
              child: _row(widget.title, widget.child),
            ),
          ),
        ),
      ),
    );
  }

  Widget _row(String title, Widget child) {
    return Row(
      children: <Widget>[
        child,
        Padding(
          padding: EdgeInsets.only(left: Adapt.px(30)),
          child: Text(title, style: TextStyle(fontSize: Adapt.px(30))),
        ),
        Spacer(flex: 1),
        if (widget.showBtn)
          Icon(Icons.keyboard_arrow_right, size: Adapt.px(40)),
        if (!widget.showBtn) widget.trailing ?? SizedBox.shrink(),
      ],
    );
  }
}

/// 适用于一个主标题，中间是 Widget，右则翻页箭头的布局
class MidWidgetBox extends StatefulWidget {
  final String title;
  final Widget child;
  final IconData icon;
  final bool showBtn;
  final VoidCallback onTap;

  MidWidgetBox({
    @required this.title,
    this.child,
    this.icon,
    this.showBtn = true,
    this.onTap,
  });

  @override
  _MidWidgetBoxState createState() => _MidWidgetBoxState();
}

class _MidWidgetBoxState extends State<MidWidgetBox> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: Adapt.px(3)),
      child: Material(
        color: Colors.transparent,
        child: Ink(
          color: fif_primary,
          child: InkWell(
            onTap: widget.onTap,
            child: Container(
                alignment: Alignment.center,
                constraints: BoxConstraints(maxHeight: Adapt.px(100)),
                padding:
                    EdgeInsets.only(left: Adapt.px(30), right: Adapt.px(20)),
                child: _row(widget.title)),
          ),
        ),
      ),
    );
  }

  Widget _row(String title) {
    return Row(
      children: <Widget>[
        Text(title, style: TextStyle(fontSize: Adapt.px(28), color: t_gray)),
        Spacer(flex: 1),
        if (widget.child != null)
          Padding(
            padding: EdgeInsets.only(right: Adapt.px(10)),
            child: widget.child,
          ),
        if (widget.icon != null)
          Icon(widget.icon, color: Colors.grey, size: Adapt.px(35)),
        if (widget.showBtn)
          Icon(Icons.keyboard_arrow_right, size: Adapt.px(44), color: t_gray),
      ],
    );
  }
}
