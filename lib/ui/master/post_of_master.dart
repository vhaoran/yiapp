import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/ui/question/post_data_page.dart';
import 'package:yiapp/util/screen_util.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/12 上午11:18
// usage ：大师查看悬赏闪断帖
// ------------------------------------------------------

class PostOfMaster extends StatefulWidget {
  PostOfMaster({Key key}) : super(key: key);

  @override
  _PostOfMasterState createState() => _PostOfMasterState();
}

class _PostOfMasterState extends State<PostOfMaster>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final List<String> _tabsName = ["悬赏帖", "闪断帖"];

  @override
  void initState() {
    Log.info("大师查看悬赏和闪断帖");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
      length: _tabsName.length,
      child: _bodyCtr(),
    );
  }

  Widget _bodyCtr() {
    return Column(
      children: <Widget>[
        TabBar(
          indicatorWeight: 3,
          indicatorSize: TabBarIndicatorSize.label,
          indicatorColor: t_primary,
          labelPadding: EdgeInsets.only(bottom: 3),
          labelColor: t_primary,
          unselectedLabelColor: t_gray,
          tabs: List.generate(
            _tabsName.length,
            (i) => Text(_tabsName[i], style: TextStyle(fontSize: S.sp(16))),
          ),
        ),
        SizedBox(height: S.h(5)),
        Expanded(
            child: TabBarView(
          children: <Widget>[
            PostDataPage(),
            PostDataPage(isVie: true),
          ],
        )),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
