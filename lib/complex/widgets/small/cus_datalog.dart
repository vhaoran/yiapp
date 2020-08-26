import 'package:flutter/material.dart';
import 'package:yiapp/complex/tools/adapt.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/26 20:12
// usage ：星座、生肖配通用的 dialog 回调
// ------------------------------------------------------

typedef FnPair = void Function(int value, int sex, String name);

class PairDialog {
  final int sex;
  final List<String> l;
  final FnPair fnPair;

  PairDialog(
    BuildContext context, {
    this.sex,
    this.l,
    this.fnPair,
  }) {
    _selectCon(context);
  }

  void _selectCon(BuildContext context) {
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
                      value: i,
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
  Widget _conItem({int value, String name, VoidCallback onTap}) {
    return InkWell(
      onTap: () {
        if (fnPair != null) {
          fnPair(value, sex, name);
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
                value: value,
                groupValue: 1,
                onChanged: (value) {
                  if (fnPair != null) {
                    fnPair(value, sex, name);
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
