import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/model/orders/refund_res.dart';
import 'package:yiapp/service/api/api-yi-order.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/gather/net_photoview.dart';
import 'package:yiapp/widget/small/cus_avatar.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/5 上午11:49
// usage ：查看投诉大师订单的详情
// ------------------------------------------------------

class ComplaintsDetailPage extends StatefulWidget {
  final bool isHis;
  final String id; // 投诉大师订单id

  ComplaintsDetailPage({this.isHis: false, this.id, Key key}) : super(key: key);

  @override
  _ComplaintsDetailPageState createState() => _ComplaintsDetailPageState();
}

class _ComplaintsDetailPageState extends State<ComplaintsDetailPage> {
  var _future;
  RefundRes _res; // 单条投诉单详情
  List _images = []; // 用户提供的图片

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  _fetch() async {
    String tip = widget.isHis ? "已完成" : "处理中";
    try {
      var res = widget.isHis
          ? await ApiYiOrder.refundOrderHisGet(widget.id)
          : await ApiYiOrder.refundOrderGet(widget.id);
      if (res != null) {
        _res = res;
        _res.images.forEach((e) => _images.add({"path": e}));
        Log.info("_images.length：${_images.length}");
        Log.info("当前$tip投诉大师订单详情:${_res.toJson()}");
      }
    } catch (e) {
      Log.error("获取单个$tip投诉大师订单出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "投诉详情"),
      body: _buildFb(),
      backgroundColor: primary,
    );
  }

  Widget _buildFb() {
    return FutureBuilder(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }
        if (_res == null) {
          return Center(
            child: Text("~订单不存在",
                style: TextStyle(color: t_gray, fontSize: S.sp(15))),
          );
        }
        return _lv();
      },
    );
  }

  Widget _lv() {
    return ScrollConfiguration(
      behavior: CusBehavior(),
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: S.w(10)),
        children: <Widget>[
          if (_res.uid == ApiBase.uid) _userView(),
          if (_res.master_id == ApiBase.uid) _masterView(),
          // 显示主要内容
          _contentCtr(),
          SizedBox(height: S.h(5)),
          Divider(height: S.h(20), color: t_gray, thickness: 0.2),
          Text(
            "用户提供的图片",
            style: TextStyle(color: t_primary, fontSize: S.sp(15)),
          ),
          // 提供的照片
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 3,
            children: List.generate(
              _res.images.length,
              (index) => _showPhotos(_res.images[index], index),
            ),
          ),
        ],
      ),
    );
  }

  /// 显示用户提供的图片
  Widget _showPhotos(String e, int i) {
    return InkWell(
      onTap: () => CusRoute.push(
        context,
        NetPhotoView(imageList: _images, index: i),
      ),
      child: CusAvatar(url: e, rate: 20, size: (S.screenW() - 100) / 3),
    );
  }

  /// 显示主要内容
  Widget _contentCtr() {
    var tGray = TextStyle(color: t_gray, fontSize: S.sp(15));
    var tPrimary = TextStyle(color: t_primary, fontSize: S.sp(15));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Divider(height: S.h(20), color: t_gray, thickness: 0.2),
        Text("投诉摘要", style: tPrimary),
        Padding(
          padding: EdgeInsets.symmetric(vertical: S.h(5)),
          child: Text(_res.brief, style: tGray),
        ),
        Text("投诉详情", style: tPrimary),
        Padding(
          padding: EdgeInsets.symmetric(vertical: S.h(5)),
          child: Text(_res.detail, style: tGray),
        ),
        Text("是否退款", style: tPrimary),
        SizedBox(height: S.h(5)),
        Text(
          _res.draw_back ? "需要退款，应退${_res.amt}元宝" : "无需退款",
          style: tGray,
        ),
      ],
    );
  }

  /// 投诉人看到的
  Widget _userView() {
    Log.info("是投诉人");
    var tGray = TextStyle(color: t_gray, fontSize: S.sp(15));
    return Column(
      children: <Widget>[
        Text(
          "被投诉大师",
          style: TextStyle(color: t_primary, fontSize: S.sp(15)),
        ),
        SizedBox(height: S.h(5)),
        Row(
          children: <Widget>[
            CusAvatar(url: _res.master_icon, rate: 20),
            SizedBox(width: S.w(10)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(_res.master_nick, style: tGray), // 昵称
                  SizedBox(height: S.h(15)),
                  Text("投诉时间", style: tGray),
                  Text(_res.create_date, style: tGray),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 大师看到的
  Widget _masterView() {
    Log.info("是投诉的大师");
    var tGray = TextStyle(color: t_gray, fontSize: S.sp(15));
    return Column(
      children: <Widget>[
        Text(
          "投诉人",
          style: TextStyle(color: t_primary, fontSize: S.sp(15)),
        ),
        SizedBox(height: S.h(5)),
        Row(
          children: <Widget>[
            CusAvatar(url: _res.icon, rate: 20),
            SizedBox(width: S.w(10)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(_res.nick, style: tGray), // 昵称
                  SizedBox(height: S.h(15)),
                  Text("投诉时间", style: tGray),
                  Text(_res.create_date, style: tGray),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
