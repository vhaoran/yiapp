import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yiapp/complex/class/debug_log.dart';
import 'package:yiapp/complex/class/sticky_delegate.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/const/const_double.dart';
import 'package:yiapp/complex/provider/master_state.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/type/bool_utils.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/model/dicts/master-images.dart';
import 'package:yiapp/model/dicts/master-info.dart';
import 'package:yiapp/service/api/api-master.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/ui/master/master_nick_avatar.dart';
import 'package:yiapp/ui/master/master_service.dart';
import 'master_loops.dart';

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

class _MasterInfoPageState extends State<MasterInfoPage>
    with SingleTickerProviderStateMixin {
  MasterInfo _m; // 大师个人信息
  List<MasterImages> _l; // 大师图片列表
  List<String> _tabs = ["主页", "服务"];
  var _future;

  /// 获取大师图片列表
  _fetch() async {
    try {
      var res = await ApiMaster.masterImageList(ApiBase.uid);
      if (res != null) _l = res;
    } catch (e) {
      _l = [];
      Debug.logError("获取大师图片列表出现异常，是否暂未添加：$e");
    }
  }

  @override
  void initState() {
    _future = _fetch();
    super.initState();
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
              return NestedScrollView(
                physics: BouncingScrollPhysics(),
                headerSliverBuilder: (context, bool) => _buildHeader(),
                body: TabBarView(
                  children: <Widget>[
                    Center(child: CusText("主页", t_gray, 32)), // 大师主页
                    MasterServicePage(), // 大师服务
                  ],
                ),
              );
            }),
        backgroundColor: primary,
      ),
    );
  }

  /// 头部信息、含大师昵称、头像、轮播图
  List<Widget> _buildHeader() {
    return <Widget>[
      SliverAppBar(
        pinned: true, // SliverAppBar 控件可以实现页面头部区域展开、折叠的效果
        elevation: 0,
        expandedHeight: Adapt.px(bgWallH),
        backgroundColor: primary,
        title: Text("大师"),
        centerTitle: true,
        flexibleSpace: FlexibleSpaceBar(
          collapseMode: CollapseMode.pin,
          background: Stack(
            children: <Widget>[
              MasterLoops(l: _l, onChanged: _refresh), // 大师轮播图
              MasterNickAvatar(m: _m), // 大师昵称、头像
            ],
          ),
        ),
      ),
      SliverPersistentHeader(
        pinned: true,
        delegate: StickyTabBarDelegate(
          child: TabBar(
            labelColor: Colors.white,
            indicatorColor: t_primary,
            tabs: List.generate(
              _tabs.length,
              (i) => Tab(child: CusText(_tabs[i], Colors.white, 30)),
            ),
          ),
        ),
      ),
    ];
  }

  void _refresh() async {
    _l.clear();
    await _fetch();
    setState(() {});
  }
}
