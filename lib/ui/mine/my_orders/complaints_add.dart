import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_string.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/model/orders/yiOrder-dart.dart';
import 'package:yiapp/service/api/api-yi-order.dart';
import 'package:yiapp/util/file_util.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/util/swicht_util.dart';
import 'package:yiapp/widget/cus_button.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/flutter/cus_dialog.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';
import 'package:yiapp/widget/flutter/rect_field.dart';
import 'package:yiapp/widget/fn/fn_multi_files.dart';
import 'package:yiapp/widget/small/cus_avatar.dart';
import 'package:yiapp/widget/small/cus_loading.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/30 下午3:15
// usage ：投诉大师订单
// ------------------------------------------------------

class ComplaintsAdd extends StatefulWidget {
  final YiOrder yiOrder;

  ComplaintsAdd({this.yiOrder, Key key}) : super(key: key);

  @override
  _ComplaintsAddState createState() => _ComplaintsAddState();
}

class _ComplaintsAddState extends State<ComplaintsAdd> {
  var _briefCtrl = TextEditingController(); // 投诉摘要
  var _detailCtrl = TextEditingController(); // 投诉详情
  bool _drawBack = false; // 是否退款，默认不退款
  List<Asset> _assets = []; // 返回选择的图片

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "投诉大师订单"),
      body: _lv(),
      backgroundColor: primary,
    );
  }

  /// 投诉大师
  _doRefund() async {
    if (_briefCtrl.text.trim().isEmpty || _detailCtrl.text.trim().isEmpty) {
      CusToast.toast(context, text: "投诉的摘要或详情都不能为空");
      return;
    }
    if (_assets.isEmpty) {
      CusToast.toast(context, text: "未选择图片");
      return;
    }
    // 上传图片到七牛云
    SpinKit.threeBounce(context);
    List<Map> l = await FileUtil.multipleFiles(_assets);
    Navigator.pop(context);
    // 选择的图片地址
    List<String> images = [];
    l.forEach((e) => images.add(e['path']));
    try {
      var m = {
        "master_id": widget.yiOrder.master_id,
        "brief": _briefCtrl.text.trim(),
        "detail": _detailCtrl.text.trim(),
        "images": images,
        "draw_back": _drawBack,
        "b_type": b_yi_order,
        "order_id": widget.yiOrder.id,
      };
      var res = await ApiYiOrder.refundOrderAdd(m);
      if (res != null) {
        CusDialog.tip(
          context,
          title: "投诉成功，请等待结果",
          onApproval: () => Navigator.pop(context),
        );
      }
    } catch (e) {
      Log.error("投诉大师时出现异常：$e");
    }
  }

  Widget _lv() {
    return ScrollConfiguration(
      behavior: CusBehavior(),
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: S.w(20)),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: S.h(10)),
            child: _masterInfo(), // 被投诉大师
          ),
          Text("投诉摘要", style: TextStyle(color: t_primary, fontSize: S.sp(16))),
          SizedBox(height: S.h(5)),
          CusRectField(
            controller: _briefCtrl,
            hintText: "请填写投诉摘要...",
            autofocus: false,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: S.h(5)),
            child: Text(
              "投诉内容",
              style: TextStyle(color: t_primary, fontSize: S.sp(16)),
            ),
          ),
          CusRectField(
            controller: _detailCtrl,
            hintText: "请填写投诉内容...",
            autofocus: false,
            maxLines: 8,
          ),
          SizedBox(height: S.h(15)),
          Container(
            height: S.h(22),
            padding: EdgeInsets.only(right: S.screenW() - 170),
            child: CusRaisedButton(
              child: Text("可选添加图片", style: TextStyle(color: Colors.black)),
              borderRadius: 50,
              backgroundColor: t_primary,
              onPressed: () async {
                _assets = await multiImages();
                setState(() {});
              },
            ),
          ),
          SizedBox(height: S.h(10)),
          if (_assets != null && _assets.isNotEmpty)
            ShowMultiImages(images: _assets),
          CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.all(0),
            title: Text("是否退款", style: TextStyle(color: t_primary)),
            value: _drawBack,
            onChanged: (value) => setState(() => _drawBack = value),
          ),
          SizedBox(height: S.h(30)),
          CusRaisedButton(
            child: Text("确定"),
            borderRadius: 50,
            onPressed: _doRefund,
          ),
        ],
      ),
    );
  }

  /// 被投诉大师头像、昵称以及投诉项目
  Widget _masterInfo() {
    TextStyle tGray = TextStyle(color: t_gray, fontSize: S.sp(15));
    TextStyle tPrimary = TextStyle(color: t_primary, fontSize: S.sp(15));
    String type = SwitchUtil.serviceType(widget.yiOrder.yi_cate_id);
    return Row(
      children: <Widget>[
        CusAvatar(url: widget.yiOrder.master_icon_ref), // 大师头像
        SizedBox(width: S.w(10)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text("投诉大师：", style: tPrimary),
                  Text(widget.yiOrder.master_nick_ref, style: tGray),
                ],
              ),
              SizedBox(height: S.h(5)),
              Row(
                children: <Widget>[
                  Text("投诉项目：", style: tPrimary),
                  Text(type, style: tGray),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _briefCtrl.dispose();
    _detailCtrl.dispose();
    super.dispose();
  }
}
