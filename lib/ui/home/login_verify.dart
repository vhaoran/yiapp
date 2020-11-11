import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yiapp/complex/class/debug_log.dart';
import 'package:yiapp/complex/function/shopcart_func.dart';
import 'package:yiapp/complex/provider/master_state.dart';
import 'package:yiapp/complex/provider/user_state.dart';
import 'package:yiapp/complex/tools/api_state.dart';
import 'package:yiapp/model/dicts/master-info.dart';
import 'package:yiapp/model/login/login_result.dart';
import 'package:yiapp/service/api/api-master.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/service/login/login_utils.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/11/11 14:25
// usage ：获取到登录信息后，统一要执行的
// ------------------------------------------------------

class LoginVerify {
  static void init(LoginResult login, BuildContext context) async {
    Debug.log("用户登录结果：${login.toJson()}");
    context.read<UserInfoState>().init(login.user_info);
    await setLoginInfo(login);
    // TODO 这里应该把大师信息也存储到本地数据库
    if (ApiState.isMaster) _fetchMaster(context);
    // TODO 这里将会用购物车本地数据库代替之前用 KV 实现的
    ShopKV.key = "shop${ApiBase.uid}";
  }

  /// 如果是大师，获取大师基本资料
  static void _fetchMaster(context) async {
    Debug.log("是大师");
    try {
      MasterInfo res = await ApiMaster.masterInfoGet(ApiBase.uid);
      if (res != null) {
        context.read<MasterInfoState>().init(res);
      }
    } catch (e) {
      Debug.logError("获取大师个人信息出现异常：$e");
    }
  }
}
