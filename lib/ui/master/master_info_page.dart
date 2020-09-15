import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/provider/master_state.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/cus_routes.dart';
import 'package:yiapp/complex/widgets/cus_avatar.dart';
import 'package:yiapp/complex/widgets/cus_box.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_bottom_sheet.dart';
import 'package:yiapp/complex/widgets/flutter/cus_toast.dart';
import 'package:yiapp/model/dicts/master-info.dart';
import 'package:provider/provider.dart';
import 'package:yiapp/service/api/api-master.dart';
import 'package:yiapp/service/api/api_image.dart';
import 'package:yiapp/ui/master/ch_master_nick.dart';
import 'package:yiapp/ui/master/master_service.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/14 10:12
// usage ：大师个人信息页面
// ------------------------------------------------------

class MasterInfoPage extends StatefulWidget {
  MasterInfoPage({Key key}) : super(key: key);

  @override
  _MasterInfoPageState createState() => _MasterInfoPageState();
}

class _MasterInfoPageState extends State<MasterInfoPage> {
  MasterInfo _m;

  @override
  Widget build(BuildContext context) {
    _m = context.watch<MasterInfoState>()?.masterInfo ?? MasterInfo();
    return Scaffold(
      appBar: CusAppBar(text: '大师信息'),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: _lv(),
      ),
      backgroundColor: primary,
    );
  }

  List<Widget> _lv() {
    return <Widget>[
      SizedBox(height: Adapt.px(20)),
      MidWidgetBox(
        title: "头像",
        child: CusAvatar(url: _m.icon ?? "", size: 40, circle: true),
        onTap: () => CusBottomSheet(context, OnFile: (file) {
          if (file != null) {
            _doChIcon(file);
            setState(() => {});
          }
        }),
      ),
      NormalBox(
        title: "昵称",
        subtitle: _m.nick,
        onTap: () => CusRoutes.push(
          context,
          ChMasterNick(nick: _m.nick, id: _m.id),
        ),
      ),
      NormalBox(
        title: "服务",
        onTap: () => CusRoutes.push(context, MasterServicePage()),
      ),
    ];
  }

  /// 修改大师头像地址
  void _doChIcon(File file) async {
    try {
      String key = await ApiImage.uploadQiniu(file);
      String url = await ApiImage.GetVisitURL(key);
      print(">>>这里的key是：$key,url是：$url");
      var m = {
        "id": _m.id,
        "M": {"icon": url}
      };
      bool ok = await ApiMaster.masterInfoCh(m);
      if (ok) {
        print(">>>修改大师头像成功");
        context.read<MasterInfoState>().chIcon(url);
        CusToast.toast(context, text: "修改成功");
      }
    } catch (e) {
      print("<<<修改大师头像出现异常：$e");
    }
  }
}
