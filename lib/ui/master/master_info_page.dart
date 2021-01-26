import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/model/dicts/master-images.dart';
import 'package:yiapp/model/dicts/master-info.dart';
import 'package:yiapp/service/api/api-master.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/ui/master/master_home.dart';
import 'package:yiapp/ui/master/master_nick_avatar.dart';
import 'package:yiapp/ui/master/master_services.dart';
import 'package:yiapp/ui/provider/master_state.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/sticky_delegate.dart';
import 'master_loops.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/14 10:12
// usage ：大师个人信息页面
// ------------------------------------------------------

class MasterInfoPage extends StatefulWidget {
  final int masterId;
  final dynamic yiOrderData;

  MasterInfoPage({this.masterId, this.yiOrderData, Key key}) : super(key: key);

  @override
  _MasterInfoPageState createState() => _MasterInfoPageState();
}

class _MasterInfoPageState extends State<MasterInfoPage>
    with SingleTickerProviderStateMixin {
  MasterInfo _m; // 大师个人信息
  List<MasterImages> _l = []; // 大师轮播图列表
  List<String> _tabs = ["主页", "服务"];
  var _future;
  bool _isSelf = false; //  是否大师本人

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  /// 获取大师图片列表
  _fetch() async {
    try {
      List<MasterImages> l = await ApiMaster.masterImageList(widget.masterId);
      if (l != null) _l = l;
      // 这里是为了用户查看大师信息
      MasterInfo masterInfo = await ApiMaster.masterInfoGet(widget.masterId);
      if (masterInfo != null) {
        if (masterInfo.uid == ApiBase.uid) _isSelf = true;
        if (!_isSelf) _m = masterInfo;
        Log.info("是否大师本人查看大师主页:$_isSelf");
      }
      setState(() {});
    } catch (e) {
      Log.error("获取大师图片列表或者获取大师出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // 如果是大师，则从状态里读取数据
    if (_isSelf) {
      _m = context.watch<MasterInfoState>()?.masterInfo ?? MasterInfo();
    }
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
        if (_m == null)
          return Scaffold(
            appBar: CusAppBar(text: "大师"),
            body: Center(
                child: Text(
              "大师信息异常",
              style: TextStyle(color: t_gray, fontSize: S.sp(16)),
            )),
            backgroundColor: primary,
          );
        return NestedScrollView(
          physics: BouncingScrollPhysics(),
          headerSliverBuilder: (context, bool) => _buildHeader(),
          body: TabBarView(
            children: <Widget>[
              // 大师主页(目前显示的不需要区分用户还是大师)
              MasterHome(m: _m),
              MasterServices(
                master_id: widget.masterId,
                isSelf: _isSelf,
                yiOrderData: widget.yiOrderData,
              ),
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
              MasterLoops(l: _l, onChanged: _refresh, isSelf: _isSelf), // 大师轮播图
              MasterNickAvatar(m: _m, isSelf: _isSelf), // 大师昵称、头像
            ],
          ),
        ),
      ),
      SliverPersistentHeader(
        pinned: true,
        delegate: StickyTabBarDelegate(
          child: TabBar(
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: t_primary,
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
  }
}
