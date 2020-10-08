import 'package:flutter/material.dart';
import 'package:yiapp/complex/tools/adapt.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/26 20:12
// usage ：dialog 弹框选择的回调(如选择星座、问命类型等)
// ------------------------------------------------------

typedef FnPair = void Function(int sex, int select, String name);

class FnDialog {
  final int sex;
  final int groupValue;
  final List<String> l;
  final FnPair fnPair;

  FnDialog(
    BuildContext context, {
    this.sex: 0,
    this.groupValue: -1,
    this.l,
    this.fnPair,
  }) {
    _selectPair(context);
  }

  /// 选择配对
  void _selectPair(BuildContext context) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, state) {
            return Container(
              child: Dialog(
                insetPadding: EdgeInsets.symmetric(horizontal: 35),
                backgroundColor: Colors.grey[100],
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: List.generate(
                    l.length,
                    (i) => _conItem(
                      select: i + 1,
                      name: "${l[i]}",
                      onTap: () => state(() {}),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// 单个星座组件
  Widget _conItem({int select, String name, VoidCallback onTap}) {
    return InkWell(
      onTap: () {
        if (fnPair != null) {
          fnPair(sex, select, name);
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
                  if (fnPair != null) {
                    fnPair(sex, select, name);
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
