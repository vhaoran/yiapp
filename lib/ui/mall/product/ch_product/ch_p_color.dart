import 'package:flutter/material.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/cus_callback.dart';
import 'package:yiapp/complex/widgets/flutter/cus_button.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/complex/widgets/flutter/rect_field.dart';
import 'package:yiapp/model/dicts/product.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/8 18:28
// usage ：修改商品的价格和颜色
// ------------------------------------------------------

class ChProductColor extends StatefulWidget {
  final TextEditingController colorCtrl;
  final TextEditingController priceCtrl;
  final List<ProductColor> colorPrices; // 已添加商品的颜色和价格
  final FnColorPrices fnColorPrice; // 已添加商品颜色和价格的回调

  ChProductColor({
    this.colorCtrl,
    this.priceCtrl,
    this.colorPrices,
    this.fnColorPrice,
    Key key,
  }) : super(key: key);

  @override
  _ChProductColorState createState() => _ChProductColorState();
}

class _ChProductColorState extends State<ChProductColor> {
  List<ProductColor> _l = []; // 商品的颜色和价格列表
  bool _isChange = false; // 是否为修改商品
  int _idx = 0; // 修改时，修改的哪一个商品的颜色和价格

  @override
  void initState() {
    _l = widget.colorPrices;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: Adapt.px(30)),
          margin: EdgeInsets.symmetric(vertical: Adapt.px(10)),
          decoration: BoxDecoration(
              color: fif_primary, borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: <Widget>[
              Expanded(child: Column(children: _inputs())),
              CusRaisedBtn(
                text: _isChange ? "修改" : "添加",
                pdVer: 0,
                pdHor: 10,
                fontSize: 28,
                textColor: Colors.black,
                backgroundColor: t_gray,
                onPressed: _doAddOrCh,
              ),
            ],
          ),
        ),
        CusText("已添加颜色和价格表", t_yi, 30),
        SizedBox(height: Adapt.px(10)),
        _colorPrice(), // 显示已添加商品的颜色和价格
      ],
    );
  }

  ///  修改、添加商品的颜色和价格到列表中
  void _doAddOrCh() async {
    // 修改
    if (_isChange) {
      _l[_idx] = ProductColor(
        code: widget.colorCtrl.text.trim(),
        price: int.parse(widget.priceCtrl.text.trim()),
      );
      _isChange = false;
      _idx = 0;
    }
    // 添加
    else {
      if (widget.colorCtrl.text.isNotEmpty &&
          widget.priceCtrl.text.isNotEmpty) {
        await _l.add(
          ProductColor(
            code: widget.colorCtrl.text.trim(),
            price: num.parse(widget.priceCtrl.text.trim()),
          ),
        );
      }
    }
    if (widget.fnColorPrice != null) {
      widget.fnColorPrice(_l);
    }
    widget.colorCtrl.clear();
    widget.priceCtrl.clear();
    setState(() {});
  }

  /// 显示已添加商品的颜色和价格
  Widget _colorPrice() {
    if (_l.isNotEmpty)
      return Column(
        children: List.generate(
          _l.length,
          (i) {
            var e = _l[i];
            return Row(
              children: <Widget>[
                CusText("第 ${i + 1} 种", t_gray, 30),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Adapt.px(20)),
                  child: CusText("颜色：${e.code}", t_gray, 28),
                ),
                CusText("价格：${e.price}", t_gray, 28),
                Spacer(),
                // 修改
                InkWell(
                  onTap: () async {
                    _isChange = true;
                    widget.colorCtrl.text = e.code;
                    widget.priceCtrl.text = "${e.price}";
                    _idx = i;
                    setState(() {});
                  },
                  child: CusText("修改", t_ji, 28),
                ),
                SizedBox(width: Adapt.px(50)),
                // 删除
                InkWell(
                  onTap: () async {
                    await _l.remove(e);
                    setState(() {});
                  },
                  child: CusText("删除", t_yi, 28),
                ),
              ],
            );
          },
        ),
      );
    return SizedBox.shrink();
  }

  // 商品颜色和价格的输入框
  List<Widget> _inputs() {
    return <Widget>[
      Row(
        children: <Widget>[
          CusText("商品颜色", t_yi, 30),
          Expanded(
            child: CusRectField(
              controller: widget.colorCtrl,
              hintText: "请输入商品颜色",
              autofocus: false,
              hideBorder: true,
            ),
          ),
        ],
      ),
      Row(
        children: <Widget>[
          CusText("商品价格", t_yi, 30),
          Expanded(
            child: CusRectField(
              controller: widget.priceCtrl,
              hintText: "请输入商品价格",
              autofocus: false,
              hideBorder: true,
              onlyNumber: true,
            ),
          ),
        ],
      ),
    ];
  }
}
