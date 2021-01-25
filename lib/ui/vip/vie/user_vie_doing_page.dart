import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/model/bbs/bbs_vie.dart';
import 'package:yiapp/service/api/api-bbs-vie.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/ui/vip/vie/user_vie_input.dart';
import 'package:yiapp/ui/vip/vie/user_vie_reply_area.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/flutter/cus_dialog.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';
import 'package:yiapp/widget/post_com/post_com_detail.dart';
import 'package:yiapp/widget/post_com/post_com_header.dart';
import 'package:yiapp/widget/refresh_hf.dart';
import 'package:yiapp/widget/small/empty_container.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/22 上午11:55
// usage ：会员闪断帖已完成订单详情
// ------------------------------------------------------

class UserVieDoingPage extends StatefulWidget {
  final String postId;
  final String backData;

  UserVieDoingPage({this.postId, this.backData, Key key}) : super(key: key);

  @override
  _UserVieDoingPageState createState() => _UserVieDoingPageState();
}

class _UserVieDoingPageState extends State<UserVieDoingPage>
    with AutomaticKeepAliveClientMixin {
  var _future;
  BBSVie _vie; // 闪断帖已完成详情
  bool _isOwner = false;

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
        _isOwner = _vie.uid == ApiBase.uid;
        Log.info("当前闪断帖已完成详情：${_vie.toJson()}");
        setState(() {});
      }
    } catch (e) {
      Log.error("查询闪断帖已完成详情出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: _appBarWt(),
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
                  UserVieReplyArea(vie: _vie),
                ],
              ],
            ),
          ),
        ),
        if (_vie != null && _isOwner) UserVieInput(vie: _vie, onSend: _fetch),
      ],
    );
  }

  Widget _appBarWt() {
    return CusAppBar(
      text: "问题详情",
      backData: widget.backData,
      actions: [
        // 有大师回复时，显示打赏按钮
        if (_isOwner && _vie.reply.isNotEmpty)
          FlatButton(
            child:
                Text("打赏", style: TextStyle(color: t_gray, fontSize: S.sp(15))),
            onPressed: () {
              CusDialog.normal(
                context,
                title: "问题已解决，现在打赏?",
                onApproval: () async {
                  var m = {
                    "id": _vie.id,
                    "score": _vie.amt,
                    "master_id": _vie.master_id,
                  };
                  try {
                    bool ok = await ApiBBSVie.bbsVieDue(m);
                    if (ok) {
                      Log.info("打赏大师 ${_vie.master_id} 的结果:$ok");
                      CusToast.toast(context, text: "打赏成功");
                      Navigator.of(context).pop("");
                    }
                  } catch (e) {
                    Log.error("打赏大师 ${_vie.master_id} 出现异常：$e");
                  }
                },
              );
            },
          ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
