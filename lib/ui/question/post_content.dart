import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/service/api/api-bbs-vie.dart';
import 'package:yiapp/ui/question/post_header.dart';
import 'package:yiapp/ui/question/post_input.dart';
import 'package:yiapp/ui/question/post_reply.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/refresh_hf.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/cus/cus_role.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/model/bbs/bbs-Reply.dart';
import 'package:yiapp/service/api/api-bbs-prize.dart';
import 'package:yiapp/service/api/api_base.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/10 上午10:56
// usage ：单条帖子详情（分查询单条帖子、单条历史帖子）
// ------------------------------------------------------

class PostContent extends StatefulWidget {
  final String id;
  final bool isHis; // 是否查询帖子历史
  final bool isVie; // 是否查询的闪断帖

  PostContent({this.id, this.isVie: false, this.isHis: false, Key key})
      : super(key: key);

  @override
  _PostContentState createState() => _PostContentState();
}

class _PostContentState extends State<PostContent> {
  var _data; // 单条帖子数据
  var _future;
  int _pageNo = 0;
  int _replyNum = 0; // 回复评论的个数
  bool _loadAll = false; // 是否加载完毕
  var _scrollCtrl = ScrollController();
  var _easyCtrl = EasyRefreshController();
  List<BBSReply> _l = []; // 帖子评论列表

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  /// 获取单条帖子详情
  _fetch() async {
    _whatPost(); // 打印帖子类型
    var data;
    try {
      if (widget.isHis) {
        data = widget.isVie
            ? await ApiBBSVie.bbsVieHisGet(widget.id)
            : await ApiBBSPrize.bbsPrizeHisGet(widget.id);
      } else {
        data = widget.isVie
            ? await ApiBBSVie.bbsVieGet(widget.id)
            : await ApiBBSPrize.bbsPrizeGet(widget.id);
      }
      if (data != null) {
        _data = data;
        _replyNum = _data.reply.length;
        Log.info("帖子评论总长度：$_replyNum");
        if (_l.isEmpty) _fetchReply();
      }
    } catch (e) {
      Log.error("查询单条帖子出现异常：$e");
    }
  }

  /// 模拟分页加载评论列表
  void _fetchReply() async {
    if (_pageNo * 20 > _replyNum) {
      setState(() => _loadAll = true);
      return;
    }
    _pageNo++;
    _l = _data.reply.take(_pageNo * 20).toList();
    Log.info("当前已加载评论长度：${_l.length}");
    setState(() {});
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
        if (_data == null) {
          return Center(
              child: Text(
            "帖子找不到了~",
            style: TextStyle(color: t_gray, fontSize: S.sp(15)),
          ));
        }
        return Column(
          children: <Widget>[
            Expanded(child: _lv()),
            _postInput(), //  回帖输入框
          ],
        );
      },
    );
  }

  /// 回帖输入框
  Widget _postInput() {
    // 查看历史帖子时不需要显示回帖输入框
    if (!widget.isHis) {
      // 大师和发帖人可以回复
      if (CusRole.is_master || _data.uid == ApiBase.uid) {
        return PostInput(
          data: _data,
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

  Widget _lv() {
    return EasyRefresh(
      header: CusHeader(),
      footer: CusFooter(),
      controller: _easyCtrl,
      child: ListView(
        controller: _scrollCtrl,
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          PostHeader(data: _data), // 帖子头部信息
          PostReply(data: _data), // 帖子评论区域
        ],
      ),
      onLoad: _loadAll
          ? null
          : () async {
              await Future.delayed(Duration(milliseconds: 100));
              _fetchReply();
            },
      onRefresh: () async => _refresh(),
    );
  }

  void _refresh() async {
    _l.clear();
    _pageNo = _replyNum = 0;
    _loadAll = false;
    await _fetch();
    setState(() {});
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    _easyCtrl.dispose();
    super.dispose();
  }

  /// 打印帖子类型
  void _whatPost() {
    String type = widget.isVie ? '闪断帖' : '悬赏帖';
    String his = widget.isHis ? '历史' : '';
    Log.info("------------- 查询单条$type$his的内容 -------------");
  }
}
