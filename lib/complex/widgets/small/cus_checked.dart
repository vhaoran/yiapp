import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/26 18:08
// usage ：自定义单选按钮
// ------------------------------------------------------

class CusChecked extends StatefulWidget {
  // 这两个是核心
  num fromValue; // 外部动态改变的值
  final num defValue; // 默认值
  final num groupValue; // 不同单选按钮之间的联系
  // 下面是自定义外观的设置
  final Color activeColor; // 激活时的背景颜色
  final Color defColor; // 未被激活时的颜色
  final double size;
  final bool circular; // 默认形状为圆形
  final Widget icon; // 勾选标识，默认白色对勾

  CusChecked({
    this.fromValue: -1,
    this.defValue: -2,
    this.groupValue,
    this.activeColor: const Color(0xFF5AB535),
    this.defColor: Colors.grey,
    this.size: 20,
    this.circular: true,
    this.icon:
        const Icon(FontAwesomeIcons.check, size: 12, color: Colors.white),
    Key key,
  }) : super(key: key);

  @override
  _CusCheckedState createState() => _CusCheckedState();
}

class _CusCheckedState extends State<CusChecked> {
  int _tmp = 0;

  @override
  void initState() {
    _tmp = widget.fromValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool checked = widget.defValue == _tmp;
    print(">>>checked:$checked");
    return Container(
      // 这里不加对齐，在ListView中会忽略宽度，导致单选按钮被拉长
      alignment: Alignment.center,
      child: InkWell(
        onTap: () {
          print(">>>默认：${widget.defValue}");
          print(">>>传值：${_tmp}");
          if (_tmp != widget.defValue) {
            _tmp = widget.defValue;
          } else {
            _tmp = -1;
          }
          setState(() {});
        },
        child: Container(
          height: widget.size,
          width: widget.size,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.circular ? 60 : 0),
              color: checked ? widget.activeColor : widget.defColor),
          child: checked ? widget.icon : null,
        ),
      ),
    );
  }

  /// 恢复默认
  void _reset() {
    widget.fromValue = -1;
    setState(() {});
  }
}
