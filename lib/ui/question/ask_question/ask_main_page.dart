import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yiapp/complex/class/debug_log.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/const/const_int.dart';
import 'package:yiapp/complex/const/const_string.dart';
import 'package:yiapp/complex/model/yi_date_time.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/api_state.dart';
import 'package:yiapp/complex/tools/cus_routes.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_dialog.dart';
import 'package:yiapp/complex/widgets/flutter/cus_snackbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/complex/widgets/flutter/cus_toast.dart';
import 'package:yiapp/complex/widgets/small/cus_loading.dart';
import 'package:yiapp/model/liuyaos/liuyao_result.dart';
import 'package:yiapp/service/api/api-bbs-prize.dart';
import 'package:yiapp/service/api/api-bbs-vie.dart';
import 'package:yiapp/ui/home/home_page.dart';
import 'package:yiapp/ui/mine/com_pay_page.dart';
import 'package:yiapp/ui/question/ask_question/post_liuyao.dart';
import 'post_brief_input.dart';
import 'post_name_input.dart';
import 'post_score_input.dart';
import 'post_sex.dart';
import 'post_time.dart';
import 'post_title_input.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/21 17:19
// usage ：我要提问 0 其他 1 六爻 2 四柱 3 合婚
// ------------------------------------------------------

class AskQuestionPage extends StatefulWidget {
  final int content_type; // 提问类型
  // 如果是六爻
  final LiuYaoResult res;
  final List<int> l; // 六爻编码
  final YiDateTime guaTime;
  final String user_nick; // 卦主姓名
  final String barName;

  AskQuestionPage({
    this.content_type,
    this.res,
    this.l,
    this.guaTime,
    this.user_nick,
    this.barName: "",
    Key key,
  }) : super(key: key);

  @override
  _AskQuestionPageState createState() => _AskQuestionPageState();
}

class _AskQuestionPageState extends State<AskQuestionPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _snackErr; // 提示信息
  bool _isLunar = false; // 是否选择了阴历
  bool _isLiuYao = false; // 类型是否为六爻

  var _nameCtrl = TextEditingController(); // 姓名
  var _scoreCtrl = TextEditingController(); // 悬赏金额
  var _titleCtrl = TextEditingController(); // 帖子标题
  var _briefCtrl = TextEditingController(); // 帖子摘要
  YiDateTime _birth; // 出生日期
  int _male = 1; // 性别

  @override
  void initState() {
    _isLiuYao = widget.content_type == post_liuyao ? true : false;
    super.initState();
  }

  /// 满足发帖条件
  void _doPost(m) async {
    CusLoading(context);
    Navigator.pop(context);
    try {
      var data;
      data = ApiState.isFlash
          ? await ApiBBSVie.bbsVieAdd(m)
          : await ApiBBSPrize.bbsPrizeAdd(m);
      if (data != null) {
        Debug.log("发帖成功，详情：${data.toJson()}");
        CusToast.toast(
          context,
          text: "发帖成功，即将跳转到支付界面",
          milliseconds: 1500,
        );
        Future.delayed(Duration(milliseconds: 1500)).then(
          (value) => CusRoutes.pushReplacement(
            context,
            ComPayPage(
              tip: ApiState.isFlash ? "闪断帖付款" : "悬赏帖付款",
              b_type: ApiState.isFlash ? b_bbs_vie : b_bbs_prize,
              orderId: data.id,
              amt: num.parse(_scoreCtrl.text.trim()),
            ),
          ),
        );
      }
    } catch (e) {
      if (e.toString().contains("余额")) {
        CusDialog.normal(
          context,
          title: "余额不足，请充值",
          textAgree: "充值",
          onApproval: () => Debug.log("前往充值页面"),
        );
      }
      Debug.logError("我要提问出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(
        text: "我要提问 ${_isLiuYao ? '六爻' : widget.barName}",
        actions: <Widget>[
          FlatButton(onPressed: _verify, child: CusText("发帖", t_gray, 28)),
        ],
      ),
      body: _lv(),
      key: _scaffoldKey,
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return ListView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: Adapt.px(25)),
      children: <Widget>[
        if (_isLiuYao) // 六爻排盘信息
          PostLiuYaoCtr(
            res: widget.res,
            l: widget.l,
            guaTime: widget.guaTime,
            user_nick: widget.user_nick,
          ),
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(top: Adapt.px(10)),
          child: CusText("填写您的基本信息", t_primary, 32),
        ),
        // 姓名
        PostNameInput(controller: _nameCtrl),
        // 出生日期
        PostTimeCtr(
          yiDate: (YiDateTime val) => setState(() => _birth = val),
          isLunar: (bool val) => setState(() => _isLunar = val),
        ),
        // 性别
        PostSexCtr(onChanged: (int val) => setState(() => _male = val)),
        // 设置悬赏金
        PostScoreInput(controller: _scoreCtrl),
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: Adapt.px(30)),
          child: CusText("输入您要咨询的问题", t_primary, 32),
        ),
        // 帖子标题
        PostTitleInput(controller: _titleCtrl),
        // 帖子摘要
        PostBriefInput(controller: _briefCtrl),
      ],
    );
  }

  /// 验证输入信息
  void _verify() {
    setState(() {
      if (_snackErr != null) _snackErr = null; // 清空错误信息
      if (_nameCtrl.text.isEmpty) {
        _snackErr = "姓名不能为空";
      } else if (_birth == null) {
        _snackErr = "请选择出生日期";
      } else if (_scoreCtrl.text.isEmpty) {
        _snackErr = "悬赏金额不能为空";
      } else if (_titleCtrl.text.isEmpty) {
        _snackErr = "帖子标题不能为空";
      } else if (_briefCtrl.text.isEmpty) {
        _snackErr = "帖子内容不能为空";
      }
    });
    // 不满足发帖条件
    if (_snackErr != null) {
      CusSnackBar(
        context,
        scaffoldKey: _scaffoldKey,
        text: _snackErr,
        milliseconds: 1200,
        backgroundColor: primary,
      );
    } else {
      String code = ""; // 六爻编码
      if (_isLiuYao) {
        widget.l.forEach((e) => code += e.toString());
      }
      var m = {
        "score": num.parse(_scoreCtrl.text.trim()),
        "title": _titleCtrl.text.trim(),
        "brief": _briefCtrl.text.trim(),
        "content_type": widget.content_type,
        "content_liuyao": {
          "year": _isLiuYao ? widget.guaTime.year : 0,
          "month": _isLiuYao ? widget.guaTime.month : 0,
          "day": _isLiuYao ? widget.guaTime.day : 0,
          "hour": _isLiuYao ? widget.guaTime.hour : 0,
          "yao_code": code,
        },
        "content": {
          "is_solar": !_isLunar,
          "name": _nameCtrl.text.trim(),
          "is_male": _male == male ? true : false,
          "year": _birth.year,
          "month": _birth.month,
          "day": _birth.day,
          "hour": _birth.hour,
          "minutes": _birth.minute,
          "nick": "苏醒",
        },
      };
      Debug.log("发帖详情：${m.toString()}");
      _doPost(m); // 满足发帖条件
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _scoreCtrl.dispose();
    _titleCtrl.dispose();
    _briefCtrl.dispose();
    super.dispose();
  }
}
