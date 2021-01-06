import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/model/pays/bankcard_res.dart';
import 'package:yiapp/service/api/api-account.dart';
import 'package:yiapp/ui/master/master_fund/add_and_ch_bankcard.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/small/cus_box.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/6 上午10:57
// usage ：显示大师提现账号
// ------------------------------------------------------

class BankCardPage extends StatefulWidget {
  BankCardPage({Key key}) : super(key: key);

  @override
  _BankCardPageState createState() => _BankCardPageState();
}

class _BankCardPageState extends State<BankCardPage> {
  var _future;
  BankCardRes _card; // 提现账号

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  /// 获取提现账号
  _fetch() async {
    try {
      var res = await ApiAccount.bankCardInfoGet();
      if (res != null) _card = res;
    } catch (e) {
      Log.error("大师查询提现账号出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "提现账号", actions: [
        FlatButton(
          child: Text(
            "修改",
            style: TextStyle(color: t_gray, fontSize: S.sp(15)),
          ),
          onPressed: () => CusRoute.push(
            context,
            AddAndChBankCard(card: _card),
          ).then((value) {
            if (value != null) Navigator.pop(context);
          }),
        ),
      ]),
      body: _buildFb(),
      backgroundColor: primary,
    );
  }

  Widget _buildFb() {
    return FutureBuilder(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }
        if (_card == null) return _addBankCard();
        return ScrollConfiguration(
          behavior: CusBehavior(),
          child: _lv(),
        );
      },
    );
  }

  Widget _lv() {
    return ListView(
      children: <Widget>[
        NormalBox(title: "姓名", subtitle: _card.full_name, showBtn: false),
        NormalBox(title: "开户行", subtitle: _card.bank_name, showBtn: false),
        NormalBox(title: "卡号", subtitle: _card.card_code, showBtn: false),
        NormalBox(
          title: "开户行地址",
          subtitle: _card.branch_bank_addr,
          showBtn: false,
        ),
        NormalBox(
          title: "开户行id",
          subtitle: _card.branch_band_id,
          showBtn: false,
        ),
      ],
    );
  }

  /// 添加提现银行卡
  Widget _addBankCard() {
    return Center(
      child: Row(
        children: <Widget>[
          Text(
            "没有提现账号，",
            style: TextStyle(color: t_gray, fontSize: S.sp(15)),
          ),
          InkWell(
            onTap: () =>
                CusRoute.push(context, AddAndChBankCard()).then((value) {
              if (value != null) Navigator.pop(context);
            }),
            child: Text(
              "现在添加",
              style: TextStyle(color: Colors.lightBlue, fontSize: S.sp(15)),
            ),
          ),
        ],
      ),
    );
  }
}
