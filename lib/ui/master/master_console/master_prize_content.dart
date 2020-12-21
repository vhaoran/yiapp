import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/model/bbs/bbs_prize.dart';
import 'package:yiapp/model/bbs/bbs_reply.dart';
import 'package:yiapp/model/bbs/prize_master_reply.dart';
import 'package:yiapp/model/complex/post_trans.dart';
import 'package:yiapp/service/api/api-bbs-prize.dart';
import 'package:yiapp/ui/question/post_header.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/refresh_hf.dart';
import 'package:yiapp/widget/small/cus_avatar.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/21 下午4:03
// usage ：只用来大师查看当前悬赏帖的所有内容
// ------------------------------------------------------

class MasterPrizeContent extends StatefulWidget {
  final Post post;
  final String id; // 根据帖子id查询帖子最新信息

  MasterPrizeContent({this.post, this.id, Key key}) : super(key: key);

  @override
  _MasterPrizeContentState createState() => _MasterPrizeContentState();
}

class _MasterPrizeContentState extends State<MasterPrizeContent> {
  BBSPrize _data; // 单条帖子数据
  var _future;

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  /// 获取单条帖子详情
  _fetch() async {
    try {
      BBSPrize data = await ApiBBSPrize.bbsPrizeGet(widget.id);
      if (data != null) {
        _data = data;
        Log.info("大师查看当前悬赏帖所有详情结果：${_data.toJson()}");
      }
    } catch (e) {
      Log.error("大师查看当前悬赏帖所有详情出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "问题详情"),
      body: _buildFb(),
      backgroundColor: primary,
    );
  }

  Widget _buildFb() {
    return FutureBuilder(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }
        if (_data == null)
          return Center(
              child: Text(
            "帖子已被删除",
            style: TextStyle(color: t_yi, fontSize: S.sp(16)),
          ));
        return _lv();
      },
    );
  }

  Widget _lv() {
    return EasyRefresh(
      header: CusHeader(),
      footer: CusFooter(),
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          PostHeader(data: _data), // 帖子头部信息
          Divider(height: 0, thickness: 0.2, color: t_gray),
          Container(
            padding: EdgeInsets.symmetric(vertical: S.h(5)),
            alignment: Alignment.center,
            child: Text(
              _data.master_reply.isEmpty ? "暂无评论" : "评论区",
              style: TextStyle(color: t_primary, fontSize: S.sp(16)),
            ),
          ),
          ...List.generate(
            _data.master_reply.length,
            (i) => _commentItem(_data.master_reply[i], i + 1),
          ),
        ],
      ),
      onRefresh: () async => await _refresh(),
    );
  }

  /// 单条评论的内容
  Widget _commentItem(BBSPrizeReply rep, int level) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: S.w(10), vertical: S.h(5)),
      decoration: BoxDecoration(
        color: fif_primary,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.only(bottom: S.h(10)), // 评论间隔
      child: Column(
        children: <Widget>[
          _masterInfo(rep, level), // 大师头像、昵称、评论时间、所处楼层数
          SizedBox(height: S.h(5)),
          ...List.generate(
            rep.reply.length,
            (index) => _commentDetail(rep.reply[index], rep),
          ),
        ],
      ),
    );
  }

  /// 相互评论的详情，这里all中的master_nick和r中nick有时不一致，以all为主
  Widget _commentDetail(BBSReply r, BBSPrizeReply all) {
    TextStyle blue = TextStyle(color: Colors.lightBlue, fontSize: S.sp(15));
    TextStyle gray = TextStyle(color: t_gray, fontSize: S.sp(15));
    return Container(
      color: Colors.black12, // 单条评论背景色
      padding: EdgeInsets.symmetric(horizontal: S.w(10), vertical: S.h(5)),
      margin: EdgeInsets.only(top: S.h(4)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              // 大师给帖主的回复
              if (r.is_master) ...[
                Text("${all.master_nick}", style: blue), // 大师昵称
                Text("►", style: gray),
                Text("${_data.nick}", style: blue), // 帖主昵称
              ],
              // 帖主的回复
              if (!r.is_master)
                Text("${r.nick}", style: blue), // 帖主昵称
              Text(
                "（帖主）",
                style: TextStyle(color: t_gray, fontSize: S.sp(13)),
              ),
            ],
          ),
          SizedBox(height: S.h(5)),
          Text(r.text.first, style: gray), // 回复的内容
          SizedBox(height: S.h(5)),
          Container(
            alignment: Alignment.centerRight,
            child: Text(r.create_date, style: gray), // 回复的时间
          ),
        ],
      ),
    );
  }

  /// 大师头像、昵称、评论时间、所处楼层数
  Widget _masterInfo(BBSPrizeReply e, int level) {
    var style = TextStyle(color: t_gray, fontSize: S.sp(15));
    return Row(
      children: <Widget>[
        CusAvatar(url: e.master_icon ?? "", circle: true, size: 45),
        SizedBox(width: S.w(15)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    e.master_nick, // 大师昵称
                    style: TextStyle(color: t_primary, fontSize: S.sp(15)),
                  ),
                  Spacer(),
                  Text("$level楼", style: style), // 大师所处楼层数
                ],
              ),
              Text(e.reply.first.create_date, style: style) // 大师第一条评论的时间
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _refresh() async {
    await _fetch();
    setState(() {});
  }
}
