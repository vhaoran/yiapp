import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_int.dart';
import 'package:yiapp/model/complex/yi_date_time.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/ui/question/ask_question/que_container.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/util/swicht_util.dart';
import 'package:yiapp/util/time_util.dart';
import 'package:yiapp/widget/cus_button.dart';
import 'package:yiapp/widget/cus_time_picker/picker_mode.dart';
import 'package:yiapp/widget/cus_time_picker/time_picker.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';
import 'package:yiapp/widget/flutter/rect_field.dart';
import 'package:yiapp/model/bbs/question_res.dart';
import 'package:yiapp/model/liuyaos/liuyao_result.dart';
import 'package:yiapp/ui/question/ask_question/post_liuyao.dart';
import 'package:yiapp/ui/question/ask_question/question_detail.dart';

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

  AskQuestionPage({
    this.content_type,
    this.res,
    this.l,
    this.guaTime,
    this.user_nick,
    Key key,
  }) : super(key: key);

  @override
  _AskQuestionPageState createState() => _AskQuestionPageState();
}

class _AskQuestionPageState extends State<AskQuestionPage> {
  String _err; // 提示信息
  bool _isLunar = false; // 是否选择了阴历
  bool _isLiuYao = false; // 类型是否为六爻

  // 交互数据用到的
  var _nameCtrl = TextEditingController(); // 姓名
  var _titleCtrl = TextEditingController(); // 帖子标题
  var _briefCtrl = TextEditingController(); // 帖子摘要
  YiDateTime _birth; // 出生日期
  int _male = 1; // 性别
  String _barName = ""; // 根据问命类型显示标题
  String _timeStr = "选择出生日期";

  @override
  void initState() {
    _isLiuYao = widget.content_type == post_liuyao ? true : false;
    _barName = "问" + SwitchUtil.contentType(widget.content_type);
    super.initState();
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
    if (_isLiuYao) {
      String code = ""; // 六爻编码
      widget.l.forEach((e) => code += e.toString());
      queLiuyao = QueLiuyao(
        year: widget.guaTime.year,
        month: widget.guaTime.month,
        day: widget.guaTime.day,
        hour: widget.guaTime.hour,
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
      name: _nameCtrl.text,
      is_male: _male == male ? true : false,
      year: _birth.year,
      month: _birth.month,
      day: _birth.day,
      hour: _birth.hour,
      minutes: _birth.minute,
    );
    // 发帖时的数据格式
    QuestionRes data = QuestionRes(
      amt: 0, // 发帖页面设置金额和金额id的具体值，这里暂设为0,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: _barName),
      body: _lv(),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return ListView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: S.w(10)),
      children: <Widget>[
        _tip(text: "请填写你的基本信息"),
        // 姓名
        _nameView(),
        // 性别
        _sexView(),
        // 出生日期
        _birthView(),
        _tip(text: "请说明你要咨询的问题"),
        // 帖子标题
        _titleView(),
        // 帖子摘要
        _briefView(),
        CusRaisedButton(child: Text("下一步"), onPressed: _verify),
      ],
    );
  }

  /// 姓名
  Widget _nameView() {
    Widget nameInput = CusRectField(
      controller: _nameCtrl,
      fromValue: "苏醒",
      hintText: "输入你的姓名",
      onlyChinese: true,
      autofocus: false,
      hideBorder: true,
      maxLength: 8,
    );
    return QueContainer(
      title: "姓名",
      child: Expanded(child: nameInput),
    );
  }

  /// 性别
  Widget _sexView() {
    return QueContainer(
      title: "性别",
      child: Row(
        children: <Widget>[
          Radio(
            value: male,
            groupValue: _male,
            activeColor: t_gray,
            onChanged: (val) => setState(() => _male = val),
          ),
          Text("男", style: TextStyle(color: t_gray, fontSize: S.sp(16))),
          Radio(
            value: female,
            groupValue: _male,
            activeColor: t_gray,
            onChanged: (val) => setState(() => _male = val),
          ),
          Text("女", style: TextStyle(color: t_gray, fontSize: S.sp(16))),
        ],
      ),
    );
  }

  /// 出生日期
  Widget _birthView() {
    return InkWell(
      onTap: _selectTime,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: S.w(15), vertical: S.h(12)),
        decoration: BoxDecoration(
          color: fif_primary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("出生日期", style: TextStyle(color: t_yi, fontSize: S.sp(16))),
            Text(_timeStr, style: TextStyle(color: t_gray, fontSize: S.sp(15))),
            Icon(FontAwesomeIcons.calendarAlt, color: t_yi),
          ],
        ),
      ),
    );
  }

  /// 选择出生日期
  void _selectTime() {
    if (_isLunar != false) _isLunar = false; // 重置阴阳历
    TimePicker(
      context,
      pickMode: PickerMode.full,
      showLunar: true,
      isLunar: (bool val) => setState(() => _isLunar = val),
      onConfirm: (YiDateTime yiDate) => setState(() {
        if (yiDate == null) return;
        _birth = yiDate;
        _timeStr =
            TimeUtil.YMDHM(isSolar: !_isLunar, comment: true, date: _birth);
      }),
    );
  }

  /// 帖子标题
  Widget _titleView() {
    return QueContainer(
      title: "帖子标题",
      child: Expanded(
        child: CusRectField(
          controller: _titleCtrl,
          hintText: "请输入帖子标题",
          fromValue: "我想问一下，金银花喝着怎么样？",
          autofocus: false,
          hideBorder: true,
        ),
      ),
    );
  }

  /// 帖子摘要
  Widget _briefView() {
    return Container(
      padding: EdgeInsets.only(left: S.w(15)),
      margin: EdgeInsets.only(bottom: S.h(10)),
      decoration: BoxDecoration(
        color: fif_primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: CusRectField(
        controller: _briefCtrl,
        hintText: "该区域填写你的帖子内容，问题描述的越清晰，详尽，大师们才能更完整、更高质量的为你解答",
        fromValue: "大师，帮我测算一下，金银花有什么效果，喝了可以赚很多钱吗？",
        autofocus: false,
        hideBorder: true,
        maxLines: 10,
        pdHor: 0,
      ),
    );
  }

  /// 基本信息和咨询问题标题
  Widget _tip({String text}) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: S.h(5)),
      child: Text(text, style: TextStyle(color: t_primary, fontSize: S.sp(16))),
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
