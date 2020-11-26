import 'package:flutter/material.dart';
import 'package:left_scroll_actions/cupertinoLeftScroll.dart';
import 'package:left_scroll_actions/global/actionListener.dart';
import 'package:left_scroll_actions/leftScroll.dart';
import 'package:yiapp/complex/class/debug_log.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/const/const_int.dart';
import 'package:yiapp/complex/const/const_string.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/cus_routes.dart';
import 'package:yiapp/complex/type/bool_utils.dart';
import 'package:yiapp/complex/widgets/cus_complex.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_button.dart';
import 'package:yiapp/complex/widgets/flutter/cus_dialog.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/complex/widgets/flutter/cus_toast.dart';
import 'package:yiapp/model/dicts/account.dart';
import 'package:yiapp/service/api/api-account.dart';
import 'package:yiapp/ui/mine/fund_account/add_fund_account.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/23 18:50
// usage ：个人支付账号
// ------------------------------------------------------

class FundListPage extends StatefulWidget {
  FundListPage({Key key}) : super(key: key);

  @override
  _FundListPageState createState() => _FundListPageState();
}

class _FundListPageState extends State<FundListPage> {
  var _future;
  List<Account> _l = []; // 个人支付账号列表

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  _fetch() async {
    try {
      var res = await ApiAccount.accountList();
      if (res != null) _l = res;
    } catch (e) {
      Debug.logError("获取个人支付账号列表出现异常：$e");
    }
  }

  /// 设置为默认账号
  void _doDefault(int accountType) async {
    try {
      bool ok = await ApiAccount.accountSetDefault(accountType);
      if (ok) {
        CusToast.toast(context, text: "设置成功");
        _refresh();
      }
    } catch (e) {
      Debug.logError("设置默认账号出现异常：$e");
    }
  }

  /// 删除账号
  void _doRm(int accountType) async {
    CusDialog.err(context, title: "确认删除该账号吗？", onApproval: () async {
      try {
        bool ok = await ApiAccount.accountRm(accountType);
        if (ok) {
          CusToast.toast(context, text: "删除成功");
          _refresh();
        }
      } catch (e) {
        Debug.logError("删除账号出现异常：$e");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "个人支付账号"),
      body: FutureBuilder(
        future: _future,
        builder: (context, snap) {
          if (!snapDone(snap)) {
            return Center(child: CircularProgressIndicator());
          }
          if (_l.isEmpty) return _emptyCtr();
          return _lv();
        },
      ),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return ScrollConfiguration(
      behavior: CusBehavior(),
      child: Column(
        children: <Widget>[
          SizedBox(height: Adapt.px(20)),
          Expanded(
            child: ListView(
              children: <Widget>[
                ..._l.map((e) => _accountItem(e)),
              ],
            ),
          ),
          if (_l.isNotEmpty)
            CusRaisedBtn(
              text: "添加账号",
              minWidth: double.infinity,
              backgroundColor: Colors.blueGrey,
              pdVer: 15,
              onPressed: _pushPage,
            ),
        ],
      ),
    );
  }

  Widget _accountItem(Account src) {
    bool def = src.is_default == 1;
    bool isAliPay = src.account_type == pay_alipay;
    return Card(
      elevation: 0,
      margin: EdgeInsets.only(bottom: 10),
      child: CupertinoLeftScroll(
        buttonWidth: Adapt.px(150),
        key: Key(src.id.toString()),
        closeTag: LeftScrollCloseTag("AccountType"),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          // 未解之谜：把color放到盒子里整个item都可点击，放到Card中只有左半部分可以点击
          color: fif_primary,
          child: Row(
            children: <Widget>[
              // 支付类型标识（该段代码先注释掉，用Icon先代替）
//              CusAvatar(url: src.icon_ref),
              Icon(
                IconData(isAliPay ? 0xe638 : 0xe607, fontFamily: ali_font),
                color: Color(isAliPay ? 0xFF4C9FE3 : 0xFF5AB535),
                size: Adapt.px(140),
              ),
              SizedBox(width: Adapt.px(30)),
              CusText(src.account_code, t_gray, 30), // 账号名称
              Spacer(),
              if (def)
                CusText("默认", t_gray, 30), // 是否默认账号
              SizedBox(width: Adapt.px(30)),
            ],
          ),
        ),
        buttons: <Widget>[
          if (!def)
            LeftScrollItem(
              text: '默认',
              color: t_ji,
              onTap: () => _doDefault(src.account_type),
            ),
          LeftScrollItem(
            text: '删除',
            color: t_yi,
            onTap: () => _doRm(src.account_type),
          ),
        ],
      ),
    );
  }

  /// 如果没有添加过支付账号，显示添加功能
  Widget _emptyCtr() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CusText("暂未添加账号，", t_gray, 32),
          SizedBox(width: Adapt.px(10)),
          InkWell(
            onTap: _pushPage,
            child: CusText("现在添加", Colors.lightBlue, 32),
          ),
        ],
      ),
    );
  }

  /// 跳转路由后的回调
  void _pushPage() {
    CusRoutes.push(context, AddFundAccount()).then((val) {
      if (val != null) _refresh();
    });
  }

  /// 添加或者删除刷新数据
  void _refresh() async {
    _l.clear();
    await _fetch();
    setState(() {});
  }
}
