import 'package:flutter/material.dart';
import 'package:yiapp/func/const/const_color.dart';
import 'package:yiapp/func/adapt.dart';
import 'package:yiapp/func/cus_callback.dart';
import 'package:yiapp/complex/widgets/flutter/cus_button.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/complex/widgets/flutter/rect_field.dart';
import 'package:yiapp/complex/widgets/fn/fn_wrap_dialog.dart';
import 'package:yiapp/model/dicts/ProductCate.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/9 15:13
// usage ：修改已上线的商品类别
// ------------------------------------------------------

class ChLineProductType extends StatefulWidget {
  final String type; // 显示当前商品的种类
  final List<Category> pTypes; // 已有的商品分类
  final FnCategory fnCategory; // 当前选择的商品种类信息

  ChLineProductType({
    this.type,
    this.pTypes,
    this.fnCategory,
    Key key,
  }) : super(key: key);

  @override
  _ChLineProductTypeState createState() => _ChLineProductTypeState();
}

class _ChLineProductTypeState extends State<ChLineProductType> {
  int _selected = -1; // 选择过的商品种类序号(非商品的id)
  Category _category; // 选择过的商品详情

  @override
  void initState() {
    // 找到当前类型在商品种类列表中的索引
    List<String> l = [];
    widget.pTypes.forEach((e) => l.add(e.name));
    int index = l.indexOf(widget.type);
    if (index != -1) _selected = index;
    super.initState();
  }

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
            hintText: _category == null ? widget.type : _category.name,
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
            l: widget.pTypes,
            fnWrap: (int selected, dynamic data) {
              if (selected == null && data == null) return;
              setState(() {
                _selected = selected;
                _category = data as Category;
                if (widget.fnCategory != null) {
                  widget.fnCategory(_category);
                }
              });
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }
}
