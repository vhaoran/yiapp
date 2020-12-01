import 'package:flutter/material.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/util/adapt.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/widget/small/cus_avatar.dart';
import 'package:yiapp/widget/flutter/cus_dialog.dart';
import 'package:yiapp/widget/flutter/cus_text.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';
import 'package:yiapp/model/dicts/ProductCate.dart';
import 'package:yiapp/service/api/api-product.dart';
import 'ch_product_type.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/6 16:26
// usage ：单个商品种类封面
// ------------------------------------------------------

class ProductTypeCover extends StatefulWidget {
  final Category category;
  final VoidCallback onChanged;

  ProductTypeCover({this.category, this.onChanged, Key key}) : super(key: key);

  @override
  _ProductTypeCoverState createState() => _ProductTypeCoverState();
}

class _ProductTypeCoverState extends State<ProductTypeCover> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: fif_primary,
      child: Padding(
        padding: EdgeInsets.all(Adapt.px(20)),
        child: Row(
          children: <Widget>[
            CusAvatar(url: widget.category.icon, rate: 8), // 商品图片
            SizedBox(width: Adapt.px(40)),
            Expanded(
                child: CusText("${widget.category.name}", t_gray, 30)), // 商品类别
            PopupMenuButton<String>(
              color: t_gray,
              offset: Offset(0, 40),
              onSelected: (val) {
                switch (val) {
                  case "修改":
                    CusRoute.push(
                            context, ChProductType(category: widget.category))
                        .then((val) {
                      if (val != null && widget.onChanged != null)
                        widget.onChanged();
                    });
                    break;
                  case "删除":
                    _doCategoryRm(widget.category);
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
            )
          ],
        ),
      ),
    );
  }

  /// 移除商品分类
  void _doCategoryRm(Category e) {
    CusDialog.err(context, title: "确定删除${e.name}分类吗", onApproval: () async {
      try {
        bool ok = await ApiProduct.categoryRm(e.id);
        if (ok) {
          CusToast.toast(context, text: "移除成功");
          if (widget.onChanged != null) widget.onChanged();
        }
      } catch (e) {
        Log.error("移除商品分类出现异常：$e");
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
