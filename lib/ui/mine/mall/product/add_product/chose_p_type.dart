import 'package:flutter/material.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/widgets/flutter/cus_button.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/complex/widgets/flutter/rect_field.dart';
import 'package:yiapp/complex/widgets/fn/fn_wrap_dialog.dart';
import 'package:yiapp/model/dicts/ProductCate.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/7 17:21
// usage ：选择商品类别
// ------------------------------------------------------

class ChoseProductType extends StatefulWidget {
  final List<Category> l;

  ChoseProductType({this.l, Key key}) : super(key: key);

  @override
  _ChoseProductTypeState createState() => _ChoseProductTypeState();
}

class _ChoseProductTypeState extends State<ChoseProductType> {
  int _selected = -1; // 选择过的商品种类序号(非商品的id)
  Category _category = Category(); // 选择过的商品详情

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: Adapt.px(30)),
      margin: EdgeInsets.symmetric(vertical: Adapt.px(10)),
      decoration: BoxDecoration(
          color: fif_primary, borderRadius: BorderRadius.circular(10)),
      child: _buildView(),
    );
  }

  Widget _buildView() {
    return Row(
      children: <Widget>[
        CusText("商品种类", t_yi, 30),
        Expanded(
          child: CusRectField(
            hintText: _selected == -1 ? "请选择商品种类" : _category.name,
            textAlign: _selected == -1 ? TextAlign.start : TextAlign.center,
            autofocus: false,
            hideBorder: true,
            enable: false,
          ),
        ),
        CusRaisedBtn(
          text: "选择",
          pdVer: 0,
          pdHor: 10,
          fontSize: 28,
          textColor: Colors.black,
          backgroundColor: t_gray,
          onPressed: () => FnWrapDialog(
            context,
            selected: _selected,
            l: widget.l,
            fnWrap: (int selected, dynamic data) {
              if (selected == null && data == null) return;
              setState(() {
                _selected = selected;
                _category = data as Category;
              });
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }
}
