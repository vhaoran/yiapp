import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/util/adapt.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/widget/admin/group_batch_member.dart';
import 'package:yiapp/widget/admin/search_admin.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/flutter/cus_dialog.dart';
import 'package:yiapp/widget/flutter/cus_text.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';
import 'package:yiapp/model/dicts/broker-admin.dart';
import 'package:yiapp/model/login/userInfo.dart';
import 'package:yiapp/model/pagebean.dart';
import 'package:yiapp/service/api/api-broker.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/ui/broker/broker_item.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/19 14:07
// usage ：运营商管理员页面
// ------------------------------------------------------

class BrokerAdminPage extends StatefulWidget {
  BrokerAdminPage({Key key}) : super(key: key);

  @override
  _BrokerAdminPageState createState() => _BrokerAdminPageState();
}

class _BrokerAdminPageState extends State<BrokerAdminPage> {
  var _future;
  List<BrokerAdmin> _adminBrokers; // 运营商管理员列表
  List<UserInfo> _brokers = []; // 运营商列表

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  /// 获取运营商管理员列表
  _fetch() async {
    try {
      var res = await ApiBroker.brokerAdminList();
      if (res != null) _adminBrokers = res;
    } catch (e) {
      _adminBrokers = [];
      Log.error("获取运营商管理员列表出现异常,是否暂未添加：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(
        text: "运营商管理员",
        actions: <Widget>[
          FlatButton(
            onPressed: () async {
              await _fetchBrokers(); // 查询全部运营商
              List<SearchAdminData> l = _brokers
                  .map(
                    (e) => SearchAdminData(
                        uid: e.id,
                        user_code: e.user_code,
                        nick: e.nick,
                        url: e.icon),
                  )
                  .toList();
              List<num> uids = _adminBrokers.map((e) => e.uid).toList();
              CusRoute.push(
                context,
                GroupBatchPage(
                  l: l,
                  uids: uids,
                  barTitle: "添加运营商管理员",
                  onClick: (l) => _addAdminCall(context, l),
                ),
              );
            },
            child: CusText("添加管理员", t_gray, 28),
          ),
        ],
      ),
      body: _lv(),
      backgroundColor: primary,
    );
  }

  /// 添加管理员
  void _addAdminCall(context, List<SearchAdminData> l) async {
    Log.info("添加的第一个人的昵称:${l.first.nick}，id:${l.first.uid}");
    if (l == null || l.isEmpty) return;
    try {
      int tmp = 0;
      for (var i = 0; i < l.length; i++) {
        var m = {
          "uid": l[i].uid,
          "user_code_ref": l[i].user_code,
          "nick": l[i].nick,
          "icon": l[i].url,
          "enabled": 1,
        };
        var res = await ApiBroker.brokerAdminAdd(m);
        Log.info("添加第 $i 个提现审核员结果：${res.uid}");
        if (res != null) tmp++;
      }
      if (tmp == l.length) {
        await _refresh();
        CusToast.toast(context, text: "添加成功");
        Navigator.pop(context);
      } else {
        print(">>> tmp：$tmp 、l：${l.length} 两者不相等");
      }
    } catch (e) {
      Log.error("添加运营商管理员出现异常：$e");
    }
  }

  Widget _lv() {
    return FutureBuilder(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }
        if (_adminBrokers.isEmpty) {
          return Center(child: CusText("暂未添加管理员", t_gray, 30));
        }
        return ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            SizedBox(height: Adapt.px(20)),
            ..._adminBrokers
                .map((e) => BrokerUserItem(b: e, fnRm: _doRmBroker)),
          ],
        );
      },
    );
  }

  /// 移除运营商管理员
  void _doRmBroker(int uid) {
    if (uid == null) return;
    CusDialog.err(context, title: "确定移除该管理员吗?", onApproval: () async {
      try {
        bool ok = await ApiBroker.brokerAdminRm(uid);
        Log.info("移除运营商管理员结果：$ok");
        if (ok) {
          CusToast.toast(context, text: "移除成功");
          _refresh();
        }
      } catch (e) {
        Log.error("移除运营商管理员出现异常：$e");
      }
    });
  }

  /// 添加新管理员的时候，先查询前全部成员信息，这里先设置为1000
  _fetchBrokers() async {
    var m = {"page_no": 1, "rows_per_page": 1000};
    try {
      PageBean pb = await ApiBroker.brokerUserInfoPage(m);
      if (pb != null) {
        var l = pb.data.map((e) => e as UserInfo).toList();
        _brokers = l;
        _brokers.removeWhere((e) => e.id == ApiBase.uid); // 移除运营商自己
        setState(() {});
      }
    } catch (e) {
      Log.error("点击添加管理员时，分页查询运营商管理员出现异常：$e");
    }
  }

  /// 添加或者删除审核后后，重新加载数据
  void _refresh() async {
    _brokers.clear();
    await _fetch();
    setState(() {});
  }
}
