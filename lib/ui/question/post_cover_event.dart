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
  Post _p;

  @override
  void initState() {
    _p = widget.post;
    super.initState();
  }

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
          "${TimeUtil.parseYMD(_p.data.create_date)}", // 发帖时间
          style: TextStyle(color: t_gray, fontSize: S.sp(15)),
        ),
        Spacer(),
        // 查看帖子详情按钮，所有角色可见
        _eventBtn(text: "详情", onPressed: _comJump),
        // 如果是发帖人
        if (_p.data.uid == ApiBase.uid)
          _posterView(),
        // 如果是大师
        if (CusRole.is_master)
          _masterView(),
      ],
    );
  }

  /// 发帖人可点击事件（取消、支付）
  Widget _posterView() {
    // 悬赏帖回复评论是 master_reply ,闪断帖回复评论是 reply
    List l = _p.is_vie ? _p.data.reply : _p.data.master_reply;
    // 因为闪断帖没有 bbs_aim 已抢单的状态，所以这里区分下
    bool rep = _p.is_vie ? _p.data.stat == bbs_aim : _p.data.stat == bbs_paid;
    return Row(
      children: <Widget>[
        // 帖子待付款，显示支付按钮
        if (_p.data.stat == bbs_init) ...[
          SizedBox(width: S.w(5)),
          _eventBtn(
            text: "支付",
            onPressed: () {
              var payData = PayData(
                  amt: _p.data.amt, b_type: b_bbs_prize, id: _p.data.id);
              BalancePay(context, data: payData);
            },
          ),
        ],
        // 帖子已付款，且没有评论时，显示取消按钮
        if (_p.data.stat == bbs_paid && l.isEmpty) ...[
          SizedBox(width: S.w(5)),
          _eventBtn(text: "取消", onPressed: _doCancel),
        ],
        // 帖子已付款，有评论时，且是处理中状态
        if (rep && l.isNotEmpty && _p.is_ing) ...[
          SizedBox(width: S.w(5)),
          _eventBtn(text: "回复", onPressed: _comJump),
        ],
      ],
    );
  }

  /// 大师可点击事件（详情）
  Widget _masterView() {
    return Row(
      children: <Widget>[
        SizedBox(width: S.w(5)),
        // 帖子已付款
        if (_p.data.stat == bbs_paid)
          _eventBtn(text: "抢单", onPressed: _doAim),
        // 已抢帖子
        if (_p.data.stat == bbs_aim)
          _eventBtn(text: "回复", onPressed: _comJump)
      ],
    );
  }

  /// 抢单(悬赏帖、闪断帖)
  void _doAim() async {
    String tip = _p.is_vie ? "闪断帖" : "悬赏帖";
    Log.info("当前抢$tip单的 id：${_p.data.id}");
    var data;
    try {
      data = _p.is_vie
          ? await ApiBBSVie.bbsVieAim(_p.data.id)
          : await ApiBBSPrize.bbsPrizeMasterAim(_p.data.id);
      if (data != null) {
        CusToast.toast(context, text: "抢单成功");
        if (widget.onChanged != null) widget.onChanged();
      }
    } catch (e) {
      if (_p.is_vie && e.toString() == "操作错误已存在，不需要再次添加") {
        CusToast.toast(context, text: "你已经抢过了");
      }
      Log.error("大师抢闪断帖出现异常：$e");
    }
  }

  /// 取消订单(悬赏帖、闪断帖)
  void _doCancel() {
    String tip = _p.is_vie ? "闪断帖" : "悬赏帖";
    CusDialog.normal(context, title: "确定取消该订单吗?", onApproval: () async {
      try {
        bool ok = _p.is_vie
            ? await ApiBBSVie.bbsVieCancel(_p.data.id)
            : await ApiBBSPrize.bbsPrizeCancel(_p.data.id);
        if (ok) {
          Log.info("取消$tip订单结果：$ok");
          CusToast.toast(context, text: "取消成功");
          if (widget.onChanged != null) widget.onChanged();
        }
      } catch (e) {
        CusToast.toast(context, text: "订单信息异常");
        Log.error("取消$tip订单出现异常：$e");
      }
    });
  }

  /// 详情、回复时的通用跳转路由
  void _comJump() {
    Post post = Post(is_vie: _p.is_vie, is_his: _p.is_his, is_ing: _p.is_ing);
    CusRoute.push(context, PostContent(post: post, id: _p.data.id));
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
