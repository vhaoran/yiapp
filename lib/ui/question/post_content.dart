import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/const/con_int.dart';
import 'package:yiapp/const/con_string.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/model/bbs/prize_master_reply.dart';
import 'package:yiapp/model/complex/post_trans.dart';
import 'package:yiapp/service/api/api-bbs-vie.dart';
import 'package:yiapp/ui/master/master_console/master_prize_content.dart';
import 'package:yiapp/ui/mine/my_orders/refund_add.dart';
import 'package:yiapp/ui/question/post_header.dart';
import 'package:yiapp/ui/question/post_input.dart';
import 'package:yiapp/ui/question/post_prize_reply.dart';
import 'package:yiapp/ui/question/post_vie_reply.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/refresh_hf.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/cus/cus_role.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/service/api/api-bbs-prize.dart';
import 'package:yiapp/service/api/api_base.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/10 上午10:56
// usage ：单条帖子详情（1、查询单条帖子、2、查询单条帖子历史）
// ------------------------------------------------------

class PostContent extends StatefulWidget {
  final Post post;
  final String id; // 根据帖子id查询帖子最新信息

  PostContent({this.post, this.id, Key key}) : super(key: key);

  @override
  _PostContentState createState() => _PostContentState();
}

class _PostContentState extends State<PostContent> {
  var _data; // 单条帖子数据
  var _future;
  var _scrollCtrl = ScrollController();
  var _easyCtrl = EasyRefreshController();
  BBSPrizeReply _selectReply; // 用户当前点击的哪个大师的评论
  Post _p;

  @override
  void initState() {
    Log.info("当前 post 格式：${widget.post.toJson()}");
    _p = widget.post;
    _future = _fetch();
    super.initState();
  }

  /// 获取单条帖子详情
  _fetch() async {
    String type = _p.is_vie ? '闪断帖' : '悬赏帖';
    String his = _p.is_his ? '历史' : '';
    String tip = type + his;
    var data;
    try {
      if (_p.is_his) {
        data = _p.is_vie
            ? await ApiBBSVie.bbsVieHisGet(widget.id)
            : await ApiBBSPrize.bbsPrizeHisGet(widget.id);
      } else {
        data = _p.is_vie
            ? await ApiBBSVie.bbsVieGet(widget.id)
            : await ApiBBSPrize.bbsPrizeGet(widget.id);
      }
      if (data != null) {
        _data = data;
        setState(() {});
        Log.info("当前$tip的详情：${_data.toJson()}");
      }
    } catch (e) {
      Log.error("查询单条$tip出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // FutureBuilder在外部，因为是否显示投诉(_data.stat)需要先等_data有结果
    return FutureBuilder(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }
        return _scaffold();
      },
    );
  }

  Widget _scaffold() {
    // 帖子不存在
    var noData = Center(
      child: Text(
        "帖子已被删除",
        style: TextStyle(color: t_yi, fontSize: S.sp(16)),
      ),
    );
    // 帖子存在
    var child = Column(
      children: <Widget>[
        Expanded(
          child: EasyRefresh(
            header: CusHeader(),
            footer: CusFooter(),
            controller: _easyCtrl,
            child: _lv(),
            onRefresh: () async => await _fetch(),
          ),
        ),
        if (_p.is_ing) // 只有状态为处理中的帖子，才会显示输入框
          _postInput(),
      ],
    );
    return Scaffold(
      appBar: _appBar(),
      body: _data == null ? noData : child,
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    List l = _p.is_vie ? _data.reply : _data.master_reply;
    return ListView(
      controller: _scrollCtrl,
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        PostHeader(data: _data), // 帖子头部信息
        Divider(height: 0, thickness: 0.2, color: t_gray),
        Container(
          padding: EdgeInsets.symmetric(vertical: S.h(5)),
          alignment: Alignment.center,
          child: Text(
            l.isEmpty ? "暂无评论" : "评论区",
            style: TextStyle(color: t_primary, fontSize: S.sp(16)),
          ),
        ),
        // 至少有一个大师给了评论
        if (l.isNotEmpty) ...[
          if (!_p.is_vie) // 悬赏帖评论区
            PostPrizeReply(
              data: _data,
              fnBBSReply: (val) => setState(() => _selectReply = val),
              onReward: _fetch,
            ),
          if (_p.is_vie) // 闪断帖评论区
            PostVieReply(data: _data, onSuccess: _fetch),
        ],
      ],
    );
  }

  /// 回帖输入框
  Widget _postInput() {
    return PostInput(
      post: Post(data: _data, is_vie: widget.post.is_vie),
      reply: _selectReply,
      onSend: () async {
        await _fetch();
        Timer(
          Duration(milliseconds: 500),
          () => _scrollCtrl.jumpTo(_scrollCtrl.position.maxScrollExtent),
        );
      },
    );
  }

  Widget _appBar() {
    var u = _data;
    var style = TextStyle(color: t_gray, fontSize: S.sp(15));
    String bType = _p.is_vie ? b_bbs_vie : b_bbs_prize;
    return CusAppBar(
      text: "问题详情",
      actions: <Widget>[
        if (u != null)
          // 发帖人是自己，且订单已完成，显示投诉功能
          if (u.stat == bbs_ok && u.uid == ApiBase.uid)
            FlatButton(
              child: Text("投诉", style: style),
              onPressed: () {
                CusRoute.push(context, RefundOrderAdd(data: u, b_type: bType));
              },
            ),
        // 大师查看正在处理中的悬赏帖时，显示详情按钮
        if (!_p.is_vie)
          if (CusRole.is_master && _p.is_ing && _data.last_reply != null)
            FlatButton(
              child: Text("详情", style: style),
              onPressed: () {
                CusRoute.push(
                  context,
                  MasterPrizeContent(post: _p, id: widget.id),
                );
              },
            ),
      ],
    );
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    _easyCtrl.dispose();
    super.dispose();
  }
}
