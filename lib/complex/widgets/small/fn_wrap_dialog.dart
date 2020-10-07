import 'package:flutter/material.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/model/dicts/ProductCate.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/7 17:37
// usage ：布局为 Wrap 的 dialog 回调
// ------------------------------------------------------

/// [selected] 已选择过的 、[current] 当前选择 、[data] 选择的数据
typedef FnWrap = void Function(int selected, int current, dynamic data);

class FnWrapDialog {
  final int selected; // 已选择的
  final int groupValue;
  final List<dynamic> l;
  final FnWrap fnWrap;

  FnWrapDialog(
    BuildContext context, {
    this.selected: 0,
    this.groupValue: -1,
    this.l,
    this.fnWrap,
  }) {
    _selectValue(context);
  }

  /// 选择
  void _selectValue(BuildContext context) {
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
                child: Wrap(
                  runSpacing: 10,
                  children: <Widget>[
                    ...l.map(
                      (e) => InkWell(
                        onTap: () {
                          print(">>>选择的详情：${e.name}");
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: Adapt.px(20)),
                          padding: EdgeInsets.symmetric(
                            horizontal: Adapt.px(20),
                            vertical: Adapt.px(10),
                          ),
                          child: CusText(_curType(e), Colors.black, 30),
                          color: t_gray,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// 根据传入的数据类型返回字符串
  String _curType(val) {
    if (val is String) {
      return val;
    } else if (val is Category) {
      return val.name;
    }
    return "默认值";
  }

  /// 单个星座组件
  Widget _conItem({int select, String name, VoidCallback onTap}) {
    return InkWell(
      onTap: () {
        if (fnWrap != null) {
          fnWrap(selected, select, name);
        }
      },
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              SizedBox(width: Adapt.px(20)),
              Text(name, style: TextStyle(fontSize: Adapt.px(30))),
              Spacer(),
              Radio(
                value: select,
                groupValue: groupValue,
                onChanged: (value) {
                  if (fnWrap != null) {
                    fnWrap(selected, select, name);
                  }
                },
              ),
            ],
          ),
          Divider(thickness: 0.4, height: 0, color: Colors.grey),
        ],
      ),
    );
  }
}
