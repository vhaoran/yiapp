import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_int.dart';
import 'package:yiapp/const/con_string.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/model/bo/broker_master_cate.dart';
import 'package:yiapp/model/orders/sizhu_content.dart';
import 'package:yiapp/model/orders/yiOrder-dart.dart';
import 'package:yiapp/model/pays/order_pay_data.dart';
import 'package:yiapp/service/api/api-yi-order.dart';
import 'package:yiapp/ui/vip/sizhu/sizhu_content_ui.dart';
import 'package:yiapp/ui/vip/yiorder/user_yiorder_doing_page.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/balance_pay.dart';
import 'package:yiapp/widget/cus_button.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';
import 'package:yiapp/widget/small/cus_loading.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/29 上午9:15
// usage ：约聊大师详情
// ------------------------------------------------------

class TalkAboutMasterDetail extends StatefulWidget {
  final SiZhuContent siZhuContent;
  final BrokerMasterCate cateData;
  final String comment;

  TalkAboutMasterDetail(
      {this.siZhuContent, this.cateData, this.comment, Key key})
      : super(key: key);

  @override
  _TalkAboutMasterDetailState createState() => _TalkAboutMasterDetailState();
}

class _TalkAboutMasterDetailState extends State<TalkAboutMasterDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "约聊大师"),
      body: _lv(),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return Column(
      children: <Widget>[
        Expanded(
            child: ScrollConfiguration(
          behavior: CusBehavior(),
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: S.w(10)),
            children: <Widget>[
              // TODO 这里需要显示大师的资料
//              YiOrderComHeader(yiOrder: ),
              SiZhuContentUI(siZhuContent: widget.siZhuContent),
              Padding(
                padding: EdgeInsets.symmetric(vertical: S.h(3)),
                child: Text(
                  "问题描述:  ${widget.comment}",
                  style: TextStyle(color: t_gray, fontSize: S.sp(16)),
                ),
              )
            ],
          ),
        )),
        SizedBox(
          width: S.screenW(),
          child: CusRaisedButton(
            child: Text("提交"),
            borderRadius: 50,
            onPressed: _doYiOrder,
          ),
        ),
      ],
    );
  }

  void _doYiOrder() async {
    SpinKit.threeBounce(context);
    var m = {
      "master_id": widget.cateData.master_id,
      "yi_cate_id": widget.cateData.yi_cate_id,
      "comment": widget.comment,
      "content_type": submit_sizhu,
      "content": widget.siZhuContent.toJson(),
    };
    try {
      YiOrder order = await ApiYiOrder.yiOrderAdd(m);
      if (order != null) {
        Navigator.pop(context);
        Log.info("用户下单后返回的订单id：${order.id}");
        CusToast.toast(context, text: "下单成功", pos: ToastPos.bottom);
        var payData = PayData(
            amt: widget.cateData.price, b_type: b_yi_order, id: order.id);
        BalancePay(context, data: payData, onSuccess: () {
          CusRoute.pushReplacement(
            context,
            UserYiOrderDoingPage(yiOrderId: order.id, backData: ""),
          );
        });
      }
    } catch (e) {
      Log.error("出现异常：$e");
    }
  }
}
