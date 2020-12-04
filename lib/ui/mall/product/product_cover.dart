import 'package:flutter/material.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/util/adapt.dart';
import 'package:yiapp/global/cus_fn.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/widget/small/cus_avatar.dart';
import 'package:yiapp/widget/flutter/cus_dialog.dart';
import 'package:yiapp/widget/flutter/cus_text.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';
import 'package:yiapp/model/dicts/product.dart';
import 'package:yiapp/service/api/api-product.dart';
import 'ch_product/ch_product.dart';
import 'product_detail/product_details.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/7 10:58
// usage ：单个商品封面
// ------------------------------------------------------

class ProductCover extends StatefulWidget {
  final Product product;
  final FnString onChange;
  final FnString onRemove;

  ProductCover({
    this.product,
    this.onChange,
    this.onRemove,
    Key key,
  }) : super(key: key);

  @override
  _ProductCoverState createState() => _ProductCoverState();
}

class _ProductCoverState extends State<ProductCover> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => CusRoute.push(context, ProductDetails()),
      child: _items(),
    );
  }

  Widget _items() {
    Product p = widget.product;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        // 商品主图片
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Adapt.px(10)),
          child:
              CusAvatar(url: p.image_main, rate: 10, size: Adapt.screenW() / 2),
        ),
        Container(
          color: CusColors.systemGrey6(context),
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(width: Adapt.px(5)),
              // 商品名称
              Flexible(
                flex: 2,
                child: CusText("${p.name}", Colors.black, 30),
              ),
              // 商品价格
              CusText("￥${p.colors.first.price}", t_yi, 32),
              Flexible(
                flex: 1,
                child: PopupMenuButton<String>(
                  color: t_gray,
                  offset: Offset(0, 40),
                  padding: EdgeInsets.all(0),
                  onSelected: (val) {
                    switch (val) {
                      case "修改":
                        CusRoute.push(context, ChProduct(id: p.id_of_es))
                            .then((val) {
                          if (val != null && widget.onChange != null)
                            widget.onChange(val);
                        });
                        break;
                      case "删除":
                        _doProductRm(p);
                        break;
                      default:
                        break;
                    }
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  icon: Icon(Icons.more_horiz, color: Colors.grey),
                  itemBuilder: (context) => _buildPopup(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 移除商品
  void _doProductRm(Product e) {
    CusDialog.err(context, title: "确定删除商品《${e.name}》吗", onApproval: () async {
      try {
        bool ok = await ApiProduct.productRm(e.id_of_es);
        if (ok) {
          CusToast.toast(context, text: "移除成功");
          if (widget.onRemove != null) widget.onRemove(e.id_of_es);
        }
      } catch (e) {
        Log.error("移除商品出现异常：$e");
      }
    });
  }

  /// 修改，删除弹框
  List<Widget> _buildPopup() {
    double h = Adapt.px(60);
    return <PopupMenuEntry<String>>[
      PopupMenuItem<String>(
        value: "修改",
        child: CusText("修改", Colors.black, 28),
        height: h,
      ),
      PopupMenuDivider(),
      PopupMenuItem<String>(
        value: "删除",
        child: CusText("删除", Colors.red, 28),
        height: h,
      ),
      PopupMenuDivider(),
      PopupMenuItem<String>(
        value: "取消",
        child: CusText("取消", Colors.black, 28),
        height: h,
      ),
    ];
  }
}
