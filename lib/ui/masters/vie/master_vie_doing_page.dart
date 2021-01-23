import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/model/bbs/bbs_vie.dart';
import 'package:yiapp/service/api/api-bbs-vie.dart';
import 'package:yiapp/ui/masters/vie/master_vie_input.dart';
import 'package:yiapp/ui/masters/vie/master_vie_reply_area.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/post_com/post_com_detail.dart';
import 'package:yiapp/widget/post_com/post_com_header.dart';
import 'package:yiapp/widget/refresh_hf.dart';
import 'package:yiapp/widget/small/empty_container.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/23 上午9:46
// usage ：大师闪断帖处理中订单详情
// ------------------------------------------------------

class MasterVieDoingPage extends StatefulWidget {
  final String postId;

  MasterVieDoingPage({this.postId, Key key}) : super(key: key);

  @override
  _MasterVieDoingPageState createState() => _MasterVieDoingPageState();
}

class _MasterVieDoingPageState extends State<MasterVieDoingPage>
    with AutomaticKeepAliveClientMixin {
  var _future;
  BBSVie _vie; // 闪断帖处理中详情

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  _fetch() async {
    try {
      BBSVie res = await ApiBBSVie.bbsVieGet(widget.postId);
      if (res != null) {
        _vie = res;
        Log.info("大师查看当前闪断帖处理中详情：${_vie.toJson()}");
        setState(() {});
      }
    } catch (e) {
      Log.error("大师查询闪断帖处理中详情出现异常：$e");
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
    return Column(
      children: [
        Expanded(
          child: EasyRefresh(
            header: CusHeader(),
            footer: CusFooter(),
            onRefresh: () async => await _fetch(),
            child: ListView(
              children: [
                if (_vie == null) EmptyContainer(text: "帖子已被删除"),
                if (_vie != null) ...[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: S.w(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        PostComHeader(vie: _vie), // 帖子顶部信息
                        PostComDetail(vie: _vie), // 帖子基本信息
                      ],
                    ),
                  ),
                  // 帖子评论区
                  MasterVieReplyArea(vie: _vie),
                ],
              ],
            ),
          ),
        ),
        // 大师回复帖子
        if (_vie != null) MasterVieInput(vie: _vie, onSend: _fetch),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
