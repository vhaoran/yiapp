import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/const/con_int.dart';
import 'package:yiapp/const/con_string.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/model/bbs/bbs_prize.dart';
import 'package:yiapp/model/bbs/prize_master_reply.dart';
import 'package:yiapp/model/complex/post_trans.dart';
import 'package:yiapp/service/api/api-bbs-vie.dart';
import 'package:yiapp/ui/master/master_console/master_prize_content.dart';
import 'package:yiapp/ui/mine/my_orders/complaints_add.dart';
import 'package:yiapp/ui/question/post_header.dart';
import 'package:yiapp/ui/question/post_input.dart';
import 'package:yiapp/ui/question/post_prize_reply.dart';
import 'package:yiapp/ui/question/post_vie_reply.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/flutter/cus_dialog.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';
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
  BBSPrizeReply _userSelectReply; // 用户当前点击的哪个大师的评论
  Post _p;
  bool _overBtn = false; // 是否隐藏结单按钮，赏金发完显示结单按钮，隐藏打赏大师按钮

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
        if (!_p.is_vie) {
          BBSPrize res = _data as BBSPrize;
          num money = 0;
          res.master_reply.forEach((e) => {money += e.amt});
          _overBtn = res.amt == money ? true : false;
        }
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
      appBar: CusAppBar(
        text: "问题详情",
        actions: <Widget>[
          if (_data != null) _appBarAction(),
        ],
      ),
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
              post: _p,
              overBtn: _overBtn,
              fnBBSReply: (val) => setState(() => _userSelectReply = val),
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
      userSelectReply: _userSelectReply,
      onSend: () async {
        await _fetch();
        Timer(
          Duration(milliseconds: 500),
          () => _scrollCtrl.jumpTo(_scrollCtrl.position.maxScrollExtent),
        );
      },
    );
  }

  Widget _appBarAction() {
    var style = TextStyle(color: t_gray, fontSize: S.sp(15));
    // 帖子暂时没有投诉功能
//    String bType = _p.is_vie ? b_bbs_vie : b_bbs_prize;
//    // 发帖人是本人,且已打赏，显示投诉功能
//    if (_data.uid == ApiBase.uid && _data.stat == bbs_ok) {
//      return FlatButton(
//        child: Text("投诉", style: style),
//        onPressed: () {
//          CusRoute.push(context, RefundOrderAdd(data: _data, b_type: bType));
//        },
//      );
//    }
    // 悬赏帖要显示的
    if (!_p.is_vie) {
      // 大师处理中的，且帖子已经有评论，显示查看详情按钮
      if (CusRole.is_master && _p.is_ing && _data.last_reply != null)
        return FlatButton(
          child: Text("详情", style: style),
          onPressed: () {
            CusRoute.push(
              context,
              MasterPrizeContent(post: _p, id: widget.id),
            );
          },
        );
      // 本人帖子，且悬赏金已经发完，显示结单按钮
      if (_data.uid == ApiBase.uid && _overBtn)
        return FlatButton(
          child: Text("结单", style: style),
          onPressed: () {
            CusDialog.normal(context, title: "确定结束该订单吗?", onApproval: () async {
              try {
                bool ok = await ApiBBSPrize.bbsPrizeDue(_data.id);
                if (ok) {
                  CusToast.toast(context, text: "结单成功");
                  Navigator.of(context).pop("");
                }
              } catch (e) {
                Log.error("用户悬赏帖结单出现异常：$e");
              }
            });
          },
        );
    }
    return SizedBox.shrink();
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    _easyCtrl.dispose();
    super.dispose();
  }
}
