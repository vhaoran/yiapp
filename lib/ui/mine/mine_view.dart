import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yiapp/const/gao_server.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/cus/cus_role.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/ui/broker/broker_apply.dart';
import 'package:yiapp/ui/master/master_apply.dart';
import 'package:yiapp/ui/masters/master_console.dart';
import 'package:yiapp/ui/master/master_info_page.dart';
import 'package:yiapp/ui/masters/master_post_his_page.dart';
import 'package:yiapp/ui/masters/refund/master_refund_main_page.dart';
import 'package:yiapp/ui/masters/yiorder/master_yiorder_his_list_page.dart';
import 'package:yiapp/ui/mine/post_orders/poster_console.dart';
import 'package:yiapp/ui/mine/user_pro_info.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';
import 'package:yiapp/widget/small/cus_box.dart';
import 'account_safe/account_safe_page.dart';
import 'bind_service_code.dart';
import 'fund_account/fund_main.dart';
import 'fund_account/master_fund_main.dart';
import 'my_orders/other_orders_main.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/11 下午2:55
// usage ：根据不同的身份，显示不同的个人主页
// ------------------------------------------------------

class MineIdentityView extends StatefulWidget {
  MineIdentityView({Key key}) : super(key: key);

  @override
  _MineIdentityViewState createState() => _MineIdentityViewState();
}

class _MineIdentityViewState extends State<MineIdentityView> {
  @override
  Widget build(BuildContext context) {
    return _mineView();
  }

  /// 根据身份显示个人主页
  Widget _mineView() {
    // 如果是大师
    if (ApiBase.loginInfo.is_master) return _masterView();
    // 如果是运营商管理员
    if (ApiBase.loginInfo.is_broker_admin) return _brokerAdminView();
    // 如果是普通会员
    if (ApiBase.loginInfo.isVip()) return _vipView();
    // 如果是游客
    if (ApiBase.loginInfo.isGuest()) return _guestView();
    // 如果是系统管理员
    if (ApiBase.loginInfo.is_admin) {
      return SizedBox.shrink(); // 系统管理员暂不考虑显示
    }
    return SizedBox.shrink();
  }

  /// 大师视图
  Widget _masterView() {
    Log.info("身份：大师 ${ApiBase.uid}");
    return Column(
      children: <Widget>[
        NormalBox(
          title: "大师控制台",
          onTap: () => CusRoute.push(context, MasterConsole()),
        ),
        NormalBox(
          title: "大师信息",
          onTap: () => CusRoute.push(
            context,
            MasterInfoPage(masterId: ApiBase.uid),
          ),
        ),
        NormalBox(
          title: "大师已完成帖子订单",
          onTap: () => CusRoute.push(context, MasterPostHisPage()),
        ),
        NormalBox(
          title: "大师已完成订单",
          onTap: () => CusRoute.push(context, MasterYiOrderHisListPage()),
        ),
        NormalBox(
          title: "大师资金账号",
          onTap: () => CusRoute.push(context, MasterFundMain()),
        ),
        NormalBox(
          title: "被投诉订单",
          onTap: () => CusRoute.push(context, MasterRefundMainPage()),
        ),
        NormalBox(
          title: "账户与安全",
          onTap: () => CusRoute.push(context, AccountSafePage()),
        ),
      ],
    );
  }

  /// 如果是普通会员
  Widget _vipView() {
    Log.info("身份：普通会员 ${ApiBase.uid}");
    return Column(
      children: <Widget>[
        NormalBox(
          title: "帖子订单",
          onTap: () => CusRoute.push(context, PosterConsole()),
        ),
        NormalBox(
          title: "其它订单",
          onTap: () => CusRoute.push(context, OtherOrdersMain()),
        ),
        NormalBox(
          title: "我的商品",
          onTap: () => CusRoute.push(context, UserProductInfo()),
        ),
        NormalBox(
          title: "个人资金账号",
          onTap: () => CusRoute.push(context, FundMain()),
        ),
        NormalBox(
          title: "账户与安全",
          onTap: () => CusRoute.push(context, AccountSafePage()),
        ),
        NormalBox(
          title: "申请大师",
          onTap: () => CusRoute.push(context, ApplyMasterPage()),
        ),
        NormalBox(
          title: "申请运营商",
          onTap: () => CusRoute.push(context, ApplyBrokerPage()),
        ),
      ],
    );
  }

  /// 运营商或者运营商管理员
  Widget _brokerAdminView() {
    Log.info("身份：运营商或者运营商管理员 ${ApiBase.uid}");
    return Column(
      children: <Widget>[
        NormalBox(
          title: "帖子订单",
          onTap: () => CusRoute.push(context, PosterConsole()),
        ),
        NormalBox(
          title: "其它订单",
          onTap: () => CusRoute.push(context, OtherOrdersMain()),
        ),
        NormalBox(
          title: "我的商品",
          onTap: () => CusRoute.push(context, UserProductInfo()),
        ),
        NormalBox(
          title: "个人资金账号",
          onTap: () => CusRoute.push(context, FundMain()),
        ),
        NormalBox(
          title: "账户与安全",
          onTap: () => CusRoute.push(context, AccountSafePage()),
        ),
        NormalBox(
          title: "服务码",
          subtitle: CusRole.service_code,
          onTap: () async {
            String serviceCode = "code=${CusRole.service_code}"; // 运营商服务码
            String brokerId = "broker_id=${CusRole.broker_id}"; // 运营商id
            final url = GaoServer.inviteCode + "?$serviceCode&$brokerId";
            Log.info("url:$url");
            await Clipboard.setData(ClipboardData(text: url));
            CusToast.toast(context, text: "已复制服务码");
          },
        )
      ],
    );
  }

  Widget _guestView() {
    Log.info("身份：游客 ${ApiBase.uid}");
    return Column(
      children: <Widget>[
        NormalBox(
          title: "绑定运营商",
          onTap: () => CusRoute.push(context, BindSerCodePage()),
        ),
        NormalBox(
          title: "申请大师",
          onTap: () => CusRoute.push(context, ApplyMasterPage()),
        ),
        NormalBox(
          title: "申请运营商",
          onTap: () => CusRoute.push(context, ApplyBrokerPage()),
        ),
      ],
    );
  }
}
