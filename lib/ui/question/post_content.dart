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
import 'package:yiapp/model/bbs/bbs_reply.dart';
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
  int _pageNo = 0;
  int _replyNum = 0; // 回复评论的条数
  bool _loadAll = false; // 是否加载完毕
  var _scrollCtrl = ScrollController();
  var _easyCtrl = EasyRefreshController();
  List<BBSReply> _l = []; // 帖子评论列表
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
        Log.info("当前$_whatPos的详情：${_data.toJson()}");
        // 如果是闪断帖
        if (_l.isEmpty && _p.is_vie) {
          _replyNum = _data.data.length;
          Log.info("当前$_whatPos评论总条数：$_replyNum");
          _fetchVieReply();
        }
      }
    } catch (e) {
      Log.error("查询单条$_whatPos出现异常：$e");
    }
  }

  /// 如果是闪断帖，则模拟分页加载评论列表
  void _fetchVieReply() async {
    final int count = 20; // 默认每次加载20条
    if (_pageNo * count > _replyNum) {
      setState(() => _loadAll = true);
      return;
    }
    _pageNo++;
    _l = _data.data.take(_pageNo * count).toList();
    Log.info("当前闪断帖已加载评论条数：${_l.length}");
    setState(() {});
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
    var child = Column(
      children: <Widget>[
        Expanded(
          child: EasyRefresh(
            header: CusHeader(),
            footer: CusFooter(),
            controller: _easyCtrl,
            child: _lv(),
            onLoad: _onVieLoad,
            onRefresh: () async => await _refresh(),
          ),
        ),
        if (_p.is_ing) _postInput(),
      ],
    );
    // 有帖子数据时
    return Scaffold(
      appBar: _appBar(),
      body: _data == null ? _noData() : child,
      backgroundColor: primary,
    );
  }

  /// 闪断帖的话，模拟分页加载评论数据
  Future<void> _onVieLoad() async {
    if (!_p.is_vie || _loadAll) return;
    await Future.delayed(Duration(milliseconds: 100));
    _fetchVieReply();
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
        if (!_p.is_vie) // 悬赏帖评论区
          PostPrizeReply(
            data: _data,
            fnBBSReply: (val) => setState(() => _selectReply = val),
            onSuccess: _refresh,
          ),
        if (_p.is_vie) // 闪断帖评论区
          PostVieReply(data: _data, onSuccess: _refresh),
      ],
    );
  }

  /// 回帖输入框
  Widget _postInput() {
    // 查看历史帖子时不需要显示回帖输入框
    if (!_p.is_his) {
      // 大师和发帖人可以回复
      if (CusRole.is_master || _data.uid == ApiBase.uid) {
        return PostInput(
          post: Post(data: _data, is_vie: widget.post.is_vie),
          reply: _selectReply,
          onSend: () async {
            _refresh();
            Timer(
              Duration(milliseconds: 500),
              () => _scrollCtrl.jumpTo(_scrollCtrl.position.maxScrollExtent),
            );
          },
        );
      }
    }
    return SizedBox.shrink();
  }

  Future<void> _refresh() async {
    _l.clear();
    _pageNo = _replyNum = 0;
    _loadAll = false;
    await _fetch();
    setState(() {});
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

  /// 没有帖子数据时的显示
  Widget _noData() {
    return Container(
      alignment: Alignment.center,
      child: Text(
        "帖子已被删除",
        style: TextStyle(color: t_yi, fontSize: S.sp(16)),
      ),
      padding: EdgeInsets.only(bottom: (S.screenH() / 4)),
    );
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    _easyCtrl.dispose();
    super.dispose();
  }

  /// 打印帖子类型
  String get _whatPos {
    String type = _p.is_vie ? '闪断帖' : '悬赏帖';
    String his = _p.is_his ? '历史' : '';
    return "$type$his";
  }
}
