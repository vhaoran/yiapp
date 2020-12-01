import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_int.dart';
import 'package:yiapp/model/complex/yi_date_time.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/flutter/cus_button.dart';
import 'package:yiapp/widget/flutter/cus_text.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';
import 'package:yiapp/widget/flutter/rect_field.dart';
import 'package:yiapp/model/bbs/question_res.dart';
import 'package:yiapp/model/liuyaos/liuyao_result.dart';
import 'package:yiapp/ui/question/ask_question/post_liuyao.dart';
import 'package:yiapp/ui/question/ask_question/question_detail.dart';
import 'post_sex.dart';
import 'post_time.dart';

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
  String _err; // 提示信息
  bool _isLunar = false; // 是否选择了阴历
  bool _isLiuYao = false; // 类型是否为六爻

  var _nameCtrl = TextEditingController(); // 姓名
  var _titleCtrl = TextEditingController(); // 帖子标题
  var _briefCtrl = TextEditingController(); // 帖子摘要
  YiDateTime _birth; // 出生日期
  int _male = 1; // 性别
  String _barName = ""; // 问命标题
  String _timeStr = "";

  @override
  void initState() {
    _isLiuYao = widget.content_type == post_liuyao ? true : false;
    _barName = "问${_isLiuYao ? '六爻' : widget.barName}";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: _barName),
      body: _lv(),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: 5),
                  child: CusText("请填写您的基本信息", t_primary, 32),
                ),
                // 姓名
                _inputContainer(
                  child: Row(
                    children: <Widget>[
                      CusText("姓名", t_yi, 30),
                      Expanded(
                        child: CusRectField(
                          controller: _nameCtrl,
                          fromValue: "苏醒",
                          hintText: "输入您的姓名",
                          autofocus: false,
                          hideBorder: true,
                          maxLength: 8,
                        ),
                      ),
                    ],
                  ),
                ),
                // 性别
                PostSexCtr(onChanged: (int val) => setState(() => _male = val)),
                // 出生日期
                PostTimeCtr(
                  yiDate: (YiDateTime val) => setState(() => _birth = val),
                  isLunar: (bool val) => setState(() => _isLunar = val),
                  timeStr: (val) => setState(() => _timeStr = val),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: 10),
                  child: CusText("请说明您要咨询的问题", t_primary, 32),
                ),
                // 帖子标题
                _inputContainer(
                  child: Row(
                    children: <Widget>[
                      CusText("帖子标题", t_yi, 30),
                      Expanded(
                        child: CusRectField(
                          controller: _titleCtrl,
                          hintText: "请输入帖子标题",
                          fromValue: "我想问一下，金银花喝着怎么样？",
                          autofocus: false,
                          hideBorder: true,
                        ),
                      ),
                    ],
                  ),
                ),
                // 帖子摘要
                _inputContainer(
                  child: CusRectField(
                    controller: _briefCtrl,
                    hintText: "该区域填写您的帖子内容，问题描述的越清晰，详尽，大师们才能更完整、更高质量的为您解答",
                    fromValue: "大师，帮我测算一下，金银花有什么效果，喝了可以赚很多钱吗？",
                    autofocus: false,
                    hideBorder: true,
                    maxLines: 10,
                    pdHor: 0,
                  ),
                ),
              ],
            ),
          ),
          CusRaisedBtn(
            text: "下一步",
            onPressed: _verify,
            minWidth: double.infinity,
          ),
        ],
      ),
    );
  }

  /// 验证输入信息
  void _verify() {
    setState(() {
      _err = null; // 清空错误信息
      if (_nameCtrl.text.isEmpty) {
        _err = "姓名不能为空";
      } else if (_birth == null) {
        _err = "请选择出生日期";
      } else if (_titleCtrl.text.isEmpty) {
        _err = "帖子标题不能为空";
      } else if (_briefCtrl.text.isEmpty) {
        _err = "帖子内容不能为空";
      }
    });
    // 不满足发帖条件
    if (_err != null) {
      CusToast.toast(context, text: _err, milliseconds: 1800);
      return;
    }
    QueLiuyao queLiuyao; // 六爻数据
    PostLiuYaoCtr liuYaoView; // 六爻结果视图
    String code = ""; // 六爻编码
    if (_isLiuYao) {
      widget.l.forEach((e) => code += e.toString());
      queLiuyao = QueLiuyao(
        year: _isLiuYao ? widget.guaTime.year : 0,
        month: _isLiuYao ? widget.guaTime.month : 0,
        day: _isLiuYao ? widget.guaTime.day : 0,
        hour: _isLiuYao ? widget.guaTime.hour : 0,
        yao_code: code,
      );
      liuYaoView = PostLiuYaoCtr(
        res: widget.res,
        l: widget.l,
        guaTime: widget.guaTime,
        user_nick: widget.user_nick,
      );
    }
    // 发帖内容
    QueContent queContent = QueContent(
      is_solar: !_isLunar,
      name: _nameCtrl.text.trim(),
      is_male: _male == male ? true : false,
      year: _birth.year,
      month: _birth.month,
      day: _birth.day,
      hour: _birth.hour,
      minutes: _birth.minute,
    );
    QuestionRes data = QuestionRes(
      // 暂时将金额和金额id设置为空,发帖页面赋值
//      amt: 0,
      level_id: 0,
      title: _titleCtrl.text.trim(),
      brief: _briefCtrl.text.trim(),
      content_type: widget.content_type,
      content_liuyao: queLiuyao,
      content: queContent,
    );
    CusRoute.push(
      context,
      QueDetailPage(
        data: data,
        barName: _barName,
        timeStr: _timeStr,
        liuYaoView: liuYaoView,
      ),
    );
  }

  /// 输入框外围盒子
  Widget _inputContainer({Widget child}) {
    return Container(
      padding: EdgeInsets.only(left: 15),
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: fif_primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _titleCtrl.dispose();
    _briefCtrl.dispose();
    super.dispose();
  }
}
