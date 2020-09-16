import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/const/const_double.dart';
import 'package:yiapp/complex/provider/master_state.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/api_state.dart';
import 'package:yiapp/complex/tools/cus_routes.dart';
import 'package:yiapp/complex/type/bool_utils.dart';
import 'package:yiapp/complex/widgets/cus_avatar.dart';
import 'package:yiapp/complex/widgets/cus_bg_wall.dart';
import 'package:yiapp/complex/widgets/cus_complex.dart';
import 'package:yiapp/complex/widgets/flutter/cus_bottom_sheet.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/complex/widgets/flutter/cus_toast.dart';
import 'package:yiapp/model/dicts/master-images.dart';
import 'package:yiapp/model/dicts/master-info.dart';
import 'package:yiapp/service/api/api-master.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/service/api/api_image.dart';
import 'package:yiapp/ui/master/master_service.dart';
import 'package:yiapp/ui/mine/personal_info/ch_nick.dart';

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
  MasterInfo _m; // 大师个人信息
  List<MasterImages> _l; // 大师图片列表
  List<String> _tabs = ["主页", "大师服务"];
  var _future;

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  /// 获取大师图片列表
  _fetch() async {
    try {
      var res = await ApiMaster.masterImageList(ApiBase.uid);
      print(">>>大师第一张图片列表：${res.first.toJson()}");
      if (res != null) _l = res;
    } catch (e) {
      _l = [];
      print("<<<获取大师图片列表出现异常，是否暂未添加：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    _m = context.watch<MasterInfoState>()?.masterInfo ?? MasterInfo();
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        body: FutureBuilder(
            future: _future,
            builder: (context, snap) {
              if (!snapDone(snap)) {
                return Center(child: CircularProgressIndicator());
              }
              return _co();
            }),
        backgroundColor: primary,
      ),
    );
  }

  Widget _co() {
    return Column(
      children: <Widget>[
        _masterInfo(), // 大师背景墙、头像、昵称
        // 大师主页、服务
        TabBar(
          indicatorWeight: Adapt.px(6),
          indicatorSize: TabBarIndicatorSize.label,
          indicatorColor: t_yi,
          labelPadding: EdgeInsets.all(Adapt.px(8)),
          labelColor: t_yi,
          unselectedLabelColor: t_gray,
          tabs: List.generate(
            _tabs.length,
            (i) => CusText(_tabs[i], t_primary, 28),
          ),
        ),
        Expanded(
          flex: 1,
          child: TabBarView(
            children: <Widget>[
              Text("主页"),
              MasterServicePage(),
            ],
          ),
        ),
      ],
    );
  }

  /// 大师背景墙、头像、昵称
  Widget _masterInfo() {
    return Container(
      height: Adapt.px(bgWallH),
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          BackgroundWall(url: ""), // 背景墙
          if (ApiState.isMaster)
            Align(
              alignment: Alignment(-0.95, -0.8), // 返回按钮
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          Align(
            alignment: Alignment(0, 0), // 头像
            child: InkWell(
              child: CusAvatar(url: _m.icon ?? "", circle: true),
              onTap: ApiState.isMaster
                  ? () => CusBottomSheet(context, OnFile: (file) {
                        if (file != null) {
                          _doChIcon(file);
                          setState(() => {});
                        }
                      })
                  : null,
            ),
          ),
          Align(
            alignment: Alignment(0, 0.75),
            child: InkWell(
              child: CusText(_m.nick, t_primary, 28),
              onTap: ApiState.isMaster
                  ? () => CusRoutes.push(context, ChUserNick(nick: _m.nick))
                  : null,
            ),
          ),
        ],
      ),
    );
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
