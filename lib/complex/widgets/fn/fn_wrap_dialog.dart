import 'package:flutter/material.dart';
import 'package:yiapp/func/const/const_color.dart';
import 'package:yiapp/func/adapt.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/model/dicts/ProductCate.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/7 17:37
// usage ：布局为 Wrap 的 dialog 回调
// ------------------------------------------------------

/// [selected] 已选择过的 、[data] 选择的数据
typedef FnWrap = void Function(int selected, dynamic data);

class FnWrapDialog {
  final int selected; // 已选择的
  final List<dynamic> l;
  final FnWrap fnWrap;

  FnWrapDialog(
    BuildContext context, {
    this.selected,
    this.l,
    this.fnWrap,
  }) {
    _select(context);
  }

  /// 选择
  void _select(BuildContext context) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, state) {
            return Dialog(
              insetPadding: EdgeInsets.symmetric(horizontal: 35),
              backgroundColor: Colors.grey[100],
              child: Container(
                padding: EdgeInsets.all(Adapt.px(20)),
                child: _buildWrap(),
              ),
            );
          },
        );
      },
    );
  }

  /// Wrap 布局的组件
  Widget _buildWrap() {
    return Wrap(
      runSpacing: 10,
      children: <Widget>[
        ...List.generate(
          l.length,
          (i) {
            var e = l[i];
            return InkWell(
              onTap: () {
                if (fnWrap != null) fnWrap(i, e); // 回调事件
              },
              child: Container(
                margin: EdgeInsets.only(right: Adapt.px(20)),
                padding: EdgeInsets.symmetric(
                    horizontal: Adapt.px(20), vertical: Adapt.px(10)),
                // 显示名称
                child: CusText(_curType(e),
                    selected == i ? Colors.white : Colors.black, 30),
                // 已选择和未选择的颜色
                color: selected == i ? Colors.blueGrey : t_gray,
              ),
            );
          },
        ),
      ],
    );
  }

  /// 根据传入的数据类型返回字符串
  String _curType(val) {
    if (val is String) {
      return val;
    }
    // 用于显示商品种类的
    else if (val is Category) {
      return val.name;
    }
    return "默认";
  }
}
