import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/model/orders/refund_res.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/gather/net_photoview.dart';
import 'package:yiapp/widget/small/cus_avatar.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/29 下午6:33
// usage ：投诉订单通用的内容组件，含投诉摘要、详情、是否退款以及图片
// ------------------------------------------------------

class RefundComContent extends StatefulWidget {
  final RefundRes refundRes;
  RefundComContent({this.refundRes, Key key}) : super(key: key);

  @override
  _RefundComContentState createState() => _RefundComContentState();
}

class _RefundComContentState extends State<RefundComContent> {
  final List _l = []; // 用户提供的图片

  @override
  void initState() {
    widget.refundRes.images.forEach((e) => _l.add({"path": e}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: S.h(10)),
        Divider(height: 0, color: t_gray, thickness: 0.2),
        SizedBox(height: S.h(5)),
        _contentWt(title: "投诉摘要", subtitle: widget.refundRes.brief),
        _contentWt(title: "投诉详情", subtitle: widget.refundRes.detail),
        _contentWt(
          title: "是否退款",
          subtitle: widget.refundRes.draw_back
              ? "需要退款，应退${widget.refundRes.amt}元宝"
              : "无需退款",
        ),
        Divider(height: 0, color: t_gray, thickness: 0.2),
        SizedBox(height: S.h(5)),
        Text(
          "用户提供的图片",
          style: TextStyle(color: t_primary, fontSize: S.sp(15)),
        ),
        // 提供的照片
        GridView.count(
          shrinkWrap: true,
          crossAxisCount: 3,
          children: List.generate(
            widget.refundRes.images.length,
            (index) => _showPhotos(widget.refundRes.images[index], index),
          ),
        ),
      ],
    );
  }

  /// 显示用户提供的图片
  Widget _showPhotos(String e, int i) {
    return InkWell(
      onTap: () => CusRoute.push(
        context,
        NetPhotoView(imageList: _l, index: i),
      ),
      child: CusAvatar(url: e, rate: 20, size: (S.screenW() - 100) / 3),
    );
  }

  Widget _contentWt({String title, String subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(color: t_primary, fontSize: S.sp(15)),
        ),
        SizedBox(height: S.h(5)),
        Text(
          subtitle,
          style: TextStyle(color: t_gray, fontSize: S.sp(15)),
        ),
        SizedBox(height: S.h(5)),
      ],
    );
  }
}
