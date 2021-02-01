import 'package:flutter/material.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/util/screen_util.dart';

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
  final List<String> hadL;
  final FnPair fnPair;

  FnDialog(
    BuildContext context, {
    this.sex: 0,
    this.groupValue: -1,
    this.l,
    this.hadL,
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

  /// 单个选项组件
  Widget _conItem({int select, String name, VoidCallback onTap}) {
    bool had = false;
    if (hadL != null) {
      had = hadL.contains(name);
    }
    return InkWell(
      onTap: had
          ? null
          : () {
              Log.info("选择的sex:$sex,select:$select,name:$name");
              if (fnPair != null) fnPair(sex, select, name);
            },
      child: Container(
        color: had ? Colors.grey[300] : Colors.transparent,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                SizedBox(width: S.w(10)),
                Text(name, style: TextStyle(fontSize: S.sp(15))),
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
      ),
    );
  }
}
