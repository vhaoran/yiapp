import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/model/bbs/bbs_prize.dart';
import 'package:yiapp/model/bbs/prize_master_reply.dart';
import 'package:yiapp/service/api/api-bbs-prize.dart';
import 'package:yiapp/service/api/api-bbs-vie.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/cus_button.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';
import 'package:yiapp/widget/flutter/rect_field.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/22 下午3:19
// usage ：悬赏帖打赏大师页面
// ------------------------------------------------------

class RewardInput extends StatefulWidget {
  final BBSPrize data;
  final BBSPrizeReply reply; // 当前选择进行打赏的大师信息

  RewardInput({this.data, this.reply, Key key}) : super(key: key);

  @override
  _RewardInputState createState() => _RewardInputState();
}

class _RewardInputState extends State<RewardInput> {
  var _amtCtrl = TextEditingController();

  /// 已打赏悬赏金
  num get _hadReward {
    num money = 0;
    widget.data.master_reply.forEach((e) => {money += e.amt});
    return money;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "悬赏帖打赏"),
      body: _lv(),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    TextStyle gray = TextStyle(color: t_gray, fontSize: S.sp(15));
    TextStyle primary = TextStyle(color: t_primary, fontSize: S.sp(15));
    return ScrollConfiguration(
      behavior: CusBehavior(),
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: S.w(20)),
        children: <Widget>[
          SizedBox(height: S.h(10)),
          Text("总赏金：${widget.data.amt}元宝", style: gray),
          Text("已打赏：$_hadReward元宝", style: gray),
          Text("可打赏：${widget.data.amt - _hadReward}元宝", style: gray),
          SizedBox(height: S.h(10)),
          Row(
            children: <Widget>[
              Text("1、被打赏大师", style: primary),
              SizedBox(width: S.w(10)),
              Text("${widget.reply.master_nick}", style: gray),
            ],
          ),
          SizedBox(height: S.h(10)),
          Text("2、设置打赏金额", style: primary),
          SizedBox(height: S.h(5)),
          CusRectField(
            controller: _amtCtrl,
            hintText: "请输入打赏金额",
            onlyNumber: true,
          ),
          SizedBox(height: S.h(30)),
          CusRaisedButton(
            child: Text("确定"),
            onPressed: _doReward,
            borderRadius: 50,
          ),
        ],
      ),
    );
  }

  /// 打赏大师
  void _doReward() async {
    if (_amtCtrl.text.isEmpty) {
      CusToast.toast(context, text: "请输入打赏金额");
      return;
    }
    if (_amtCtrl.text == "0") {
      CusToast.toast(context, text: "打赏金额不能为0");
      return;
    }
    if (int.parse(_amtCtrl.text) > (widget.data.amt - _hadReward)) {
      CusToast.toast(context, text: "不能大于可打赏金额");
      return;
    }
    var m = {
      "id": widget.data.id,
      "master_id": widget.reply.master_id,
      "amt": num.parse(_amtCtrl.text.trim()),
    };
    Log.info("提交的打赏悬赏帖数据:$m");
    try {
      bool ok = await ApiBBSPrize.bbsPrizeSetMasterReward(m);
      Log.info("悬赏帖打赏大师的结果:$ok");
      if (ok) {
        CusToast.toast(context, text: "打赏成功");
        Navigator.of(context).pop("");
      }
    } catch (e) {
      Log.error("悬赏帖打赏大师出现异常：$e");
    }
  }

  @override
  void dispose() {
    _amtCtrl.dispose();
    super.dispose();
  }
}
