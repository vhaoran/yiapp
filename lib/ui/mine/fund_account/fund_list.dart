import 'package:flutter/material.dart';
import 'package:left_scroll_actions/cupertinoLeftScroll.dart';
import 'package:left_scroll_actions/leftScroll.dart';
import 'package:yiapp/complex/class/debug_log.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/cus_routes.dart';
import 'package:yiapp/complex/type/bool_utils.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/complex/widgets/small/cus_avatar.dart';
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

  /// 删除账号
  void _doRm() async {
    Debug.log("移除");
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
    return ListView(
      children: <Widget>[
        SizedBox(height: Adapt.px(30)),
        ..._l.map((e) => _accountItem(e)),
      ],
    );
  }

  Widget _emptyCtr() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CusText("暂未添加账号，", t_gray, 32),
          SizedBox(width: Adapt.px(10)),
          InkWell(
            onTap: () => CusRoutes.push(context, AddFundAccount()),
            child: CusText("现在添加", Colors.lightBlue, 32),
          ),
        ],
      ),
    );
  }

  Widget _accountItem(Account src) {
    return Card(
      elevation: 0,
      color: Colors.grey,
      margin: EdgeInsets.only(bottom: 5),
      key: Key(src.id.toString()),
      child: CupertinoLeftScroll(
        buttonWidth: Adapt.px(120),
        child: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: CusAvatar(url: ""),
            ),
            SizedBox(width: Adapt.px(30)),
            CusText(src.account_code, Colors.black, 30),
            Spacer(),
            CusText(src.is_default == 1 ? "默认" : "", Colors.black, 30),
            SizedBox(width: Adapt.px(30)),
          ],
        ),
        buttons: <Widget>[
          LeftScrollItem(
            text: '删除',
            color: Colors.red,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
