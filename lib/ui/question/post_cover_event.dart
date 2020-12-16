import 'package:flutter/material.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_int.dart';
import 'package:yiapp/const/con_string.dart';
import 'package:yiapp/cus/cus_role.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/model/complex/post_trans.dart';
import 'package:yiapp/service/api/api-bbs-vie.dart';
import 'package:yiapp/ui/question/post_content.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/util/time_util.dart';
import 'package:yiapp/widget/cus_button.dart';
import 'package:yiapp/widget/flutter/cus_dialog.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';
import 'package:yiapp/widget/balance_pay.dart';
import 'package:yiapp/model/pays/order_pay_data.dart';
import 'package:yiapp/service/api/api-bbs-prize.dart';
import 'package:yiapp/service/api/api_base.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/10 下午3:14
// usage ：帖子封面上的按钮事件，含抢单、详情、取消、支付、回复
// ------------------------------------------------------

class PostCoverEvent extends StatefulWidget {
  final Post post;
  final VoidCallback onChanged; // 事件的回调

  PostCoverEvent({this.post, this.onChanged, Key key}) : super(key: key);

  @override
  _PostCoverEventState createState() => _PostCoverEventState();
}

class _PostCoverEventState extends State<PostCoverEvent> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: S.h(5)),
      child: _row(),
    );
  }

  Widget _row() {
    return Row(
      children: <Widget>[
        Text(
          "${TimeUtil.parseYMD(widget.post.data.create_date)}", // 发帖时间
          style: TextStyle(color: t_gray, fontSize: S.sp(15)),
        ),
        Spacer(),
        // 查看帖子详情按钮，所有角色可见
        _eventBtn(
          text: "详情",
          onPressed: () => CusRoute.push(
            context,
            PostContent(
                post: Post(
              is_vie: widget.post.is_vie,
              is_his: widget.post.is_his,
            )),
          ),
        ),
        // 如果是发帖人
        if (widget.post.data.uid == ApiBase.uid)
          _posterView(),
        // 如果是大师，显示抢单和详情按钮
        if (CusRole.is_master)
          _masterView(),
//        // 状态为已付款，是大师，并且该单没有被抢
//        if (widget.isVie &&
//            widget.data.stat == pay_paid &&
//            (CusRole.is_master && widget.data.master_id == 0))
//          _comBtn(text: "抢单", onPressed: _doRob),
      ],
    );
  }

  /// 发帖人可点击事件（取消、支付）
  Widget _posterView() {
    // 帖子待付款
    if (widget.post.data.stat == bbs_init) {
      return Row(
        children: <Widget>[
          SizedBox(width: S.w(5)),
          _eventBtn(text: "取消", onPressed: _doCancel),
          SizedBox(width: S.w(5)),
          _eventBtn(
              text: "支付", // 支付订单
              onPressed: () {
                var payData = PayData(
                  amt: widget.post.data.amt,
                  b_type: b_bbs_prize,
                  id: widget.post.data.id,
                );
                BalancePay(context, data: payData);
              }),
        ],
      );
    }
    return SizedBox.shrink();
  }

  /// 大师可点击事件（详情）
  Widget _masterView() {
    // 帖子已付款
    if (widget.post.data.stat == bbs_paid) {
      Widget child = widget.post.is_ing
          ? _eventBtn(text: "回复", onPressed: _doAim)
          : _eventBtn(text: "抢单", onPressed: _doAim);
      return Row(
        children: <Widget>[
          SizedBox(width: S.w(5)),
          child,
        ],
      );
    }
    return SizedBox.shrink();
  }

  /// 抢单(悬赏帖、闪断帖)
  void _doAim() async {
    String tip = widget.post.is_vie ? "闪断帖" : "悬赏帖";
    Log.info("当前抢单的$tip的 id：${widget.post.data.id}");
    var data;
    try {
      data = widget.post.is_vie
          ? await ApiBBSVie.bbsVieAim(widget.post.data.id)
          : await ApiBBSPrize.bbsPrizeMasterAim(widget.post.data.id);
      if (data != null) {
        CusToast.toast(context, text: "抢单成功");
        if (widget.onChanged != null) widget.onChanged();
      }
    } catch (e) {
      if (widget.post.is_vie && e.toString() == "操作错误已存在，不需要再次添加") {
        CusToast.toast(context, text: "你已经抢过了");
      }
      Log.error("大师抢闪断帖出现异常：$e");
    }
  }

  /// 取消订单
  void _doCancel() {
    CusDialog.normal(context, title: "确定取消该订单吗?", onApproval: () async {
      try {
        bool ok = await ApiBBSPrize.bbsPrizeCancel(widget.post.data.id);
        if (ok) {
          Log.info("取消订单结果：$ok");
          CusToast.toast(context, text: "取消成功");
          if (widget.onChanged != null) widget.onChanged();
        }
      } catch (e) {
        Log.error("取消订单出现异常：$e");
      }
    });
  }

  /// 通用的事件按钮
  Widget _eventBtn({String text, VoidCallback onPressed}) {
    return Container(
      width: S.w(70),
      constraints: BoxConstraints(maxHeight: S.h(30)),
      child: CusRaisedButton(
        child: Text(text, style: TextStyle(fontSize: S.sp(14))),
        onPressed: onPressed,
        borderRadius: 50,
        backgroundColor: primary,
      ),
    );
  }
}
