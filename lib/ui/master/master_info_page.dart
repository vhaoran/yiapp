import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/model/dicts/master-images.dart';
import 'package:yiapp/model/dicts/master-info.dart';
import 'package:yiapp/service/api/api-master.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/ui/master/master_nick_avatar.dart';
import 'package:yiapp/ui/master/master_service.dart';
import 'package:yiapp/ui/provider/master_state.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/sticky_delegate.dart';
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
      Log.error("获取大师图片列表出现异常，是否暂未添加：$e");
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
      child: Scaffold(body: _buildFb(), backgroundColor: primary),
    );
  }

  Widget _buildFb() {
    return FutureBuilder(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }
        return NestedScrollView(
          physics: BouncingScrollPhysics(),
          headerSliverBuilder: (context, bool) => _buildHeader(),
          body: TabBarView(
            children: <Widget>[
              // 大师主页
              Text("这是大师主页",
                  style: TextStyle(color: Colors.white, fontSize: S.sp(15))),
              // 大师服务
              MasterServicePage(),
              // 这里将服务放到后面，是因为放中间滑动时，红色的左滑删除按钮会在
              // 切换选项卡的时候显示出来，故临时先设置其位置到最后
            ],
          ),
        );
      },
    );
  }

  /// 头部信息、含大师昵称、头像、轮播图
  List<Widget> _buildHeader() {
    return <Widget>[
      // SliverAppBar 控件可以实现页面头部区域展开、折叠的效果
      SliverAppBar(
        pinned: true,
        elevation: 0,
        expandedHeight: S.h(180),
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
            indicatorWeight: 3,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: t_primary,
            labelPadding: EdgeInsets.only(bottom: 3),
            labelColor: Colors.white,
            tabs: List.generate(
              _tabs.length,
              (i) => Tab(
                child: Text(_tabs[i],
                    style: TextStyle(color: Colors.white, fontSize: S.sp(15))),
              ),
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
