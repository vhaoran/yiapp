import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_int.dart';
import 'package:yiapp/model/login/cus_login_res.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/11 上午11:09
// usage ：显示用户信息
// ------------------------------------------------------

class DemoShowUserPage extends StatefulWidget {
  final List<SqliteLoginRes> l;

  DemoShowUserPage({this.l, Key key}) : super(key: key);

  @override
  _DemoShowUserPageState createState() => _DemoShowUserPageState();
}

class _DemoShowUserPageState extends State<DemoShowUserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "用户主要信息"),
      body: _lv(),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return ScrollConfiguration(
      behavior: CusBehavior(),
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: S.w(10)),
        children: <Widget>[
          SizedBox(height: S.h(5)),
          ...List.generate(
            widget.l.length,
            (index) => _userItem(widget.l[index], index + 1),
          ),
        ],
      ),
    );
  }

  Widget _userItem(SqliteLoginRes user, int i) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "第 $i 个用户",
          style: TextStyle(color: Colors.pinkAccent, fontSize: S.sp(15)),
        ),
        SizedBox(height: S.h(5)),
        _commonShow(desc: "昵称", data: user.nick),
        _commonShow(desc: "uid", data: "${user.uid}"),
        _commonShow(desc: "user_code", data: "${user.user_code}"),
        _commonShow(desc: "性别", data: user.sex == male ? "男" : "女"),
        // 身份
        if (user.is_admin == 1) _commonShow(desc: "身份", data: "系统管理员"),
        if (user.is_broker_admin == 1) _commonShow(desc: "身份", data: "运营商管理员"),
        if (user.is_master == 1) _commonShow(desc: "身份", data: "大师"),
        if (_isVip(user)) _commonShow(desc: "身份", data: "会员"),
        if (_isGuest(user)) _commonShow(desc: "身份", data: "游客"),
        _commonShow(
          desc: "商城",
          data: user.enable_mall == 1 ? "已开启" : "未开启",
        ),
        _commonShow(
          desc: "大师",
          data: user.enable_master == 1 ? "已开启" : "未开启",
        ),
        _commonShow(
          desc: "悬赏帖",
          data: user.enable_prize == 1 ? "已开启" : "未开启",
        ),
        _commonShow(
          desc: "闪断帖",
          data: user.enable_vie == 1 ? "已开启" : "未开启",
        ),
        Divider(height: 20, thickness: 0.2, color: t_gray),
      ],
    );
  }

  /// 通用显示组件[desc]描述、[data]结果
  Widget _commonShow({String desc, String data}) {
    return Padding(
      padding: EdgeInsets.only(bottom: S.h(3)),
      child: Row(
        children: <Widget>[
          Text(
            desc + ":",
            style: TextStyle(color: t_primary, fontSize: S.sp(15)),
          ),
          SizedBox(width: S.w(5)),
          Text(
            data,
            style: TextStyle(color: t_gray, fontSize: S.sp(15)),
          ),
        ],
      ),
    );
  }

  /// 是否会员
  bool _isVip(SqliteLoginRes user) {
    return user.is_admin == 0 &&
        user.is_broker_admin == 0 &&
        user.is_master == 0 &&
        user.broker_id > 0;
  }

  /// 是否游客
  bool _isGuest(SqliteLoginRes user) {
    return user.is_admin == 0 &&
        user.is_broker_admin == 0 &&
        user.is_master == 0 &&
        user.broker_id <= 0;
  }
}
