import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/model/bbs/bbs_vie.dart';
import 'package:yiapp/service/api/api-bbs-vie.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/post_com/post_com_detail.dart';
import 'package:yiapp/widget/post_com/post_com_header.dart';
import 'package:yiapp/widget/refresh_hf.dart';
import 'package:yiapp/widget/small/empty_container.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/21 下午7:40
// usage ：会员闪断帖已取消订单详情
// ------------------------------------------------------

class UserVieCancelledPage extends StatefulWidget {
  final String postId;

  UserVieCancelledPage({this.postId, Key key}) : super(key: key);

  @override
  _UserVieCancelledPageState createState() => _UserVieCancelledPageState();
}

class _UserVieCancelledPageState extends State<UserVieCancelledPage>
    with AutomaticKeepAliveClientMixin {
  var _future;
  BBSVie _bbsVie; // 闪断帖已取消详情

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  _fetch() async {
    try {
      BBSVie res = await ApiBBSVie.bbsVieHisGet(widget.postId);
      if (res != null) {
        _bbsVie = res;
        Log.info("当前闪断帖已取消详情：${_bbsVie.toJson()}");
        setState(() {});
      }
    } catch (e) {
      Log.error("查询闪断帖已取消详情出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: CusAppBar(text: "问题详情"),
      body: FutureBuilder(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }
          return _lv();
        },
      ),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return EasyRefresh(
      header: CusHeader(),
      footer: CusFooter(),
      onRefresh: () async => await _fetch(),
      child: ListView(
        children: [
          if (_bbsVie == null) EmptyContainer(text: "帖子已被删除"),
          if (_bbsVie != null) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: S.w(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  PostComHeader(vie: _bbsVie), // 帖子顶部信息
                  PostComDetail(vie: _bbsVie), // 帖子基本信息
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
