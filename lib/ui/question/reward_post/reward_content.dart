import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/complex/class/debug_log.dart';
import 'package:yiapp/complex/class/refresh_hf.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/api_state.dart';
import 'package:yiapp/complex/type/bool_utils.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/model/bbs/bbs-Prize.dart';
import 'package:yiapp/model/bbs/bbs-Reply.dart';
import 'package:yiapp/service/api/api-bbs-prize.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/ui/question/reward_post/reward_header.dart';
import 'package:yiapp/ui/question/reward_post/reward_input.dart';
import 'package:yiapp/ui/question/reward_post/reward_reply.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/23 14:56
// usage ：悬赏帖内容
// ------------------------------------------------------

class RewardContent extends StatefulWidget {
  final String id;

  RewardContent({this.id, Key key}) : super(key: key);

  @override
  _RewardContentState createState() => _RewardContentState();
}

class _RewardContentState extends State<RewardContent> {
  BBSPrize _bbsPrize; // 帖子全部内容
  List<BBSReply> _l = []; // 帖子评论列表
  var _future;
  var _scrollCtrl = ScrollController();
  var _easyCtrl = EasyRefreshController();
  bool _loadAll = false; // 是否加载完毕

  int _pageNo = 0;
  int _rowsCount = 0;

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  /// 查询单条帖子内容
  _fetch() async {
    try {
      BBSPrize bbsPrize = await ApiBBSPrize.bbsPrizeGet(widget.id);
      if (bbsPrize != null) {
        _bbsPrize = bbsPrize;
        _rowsCount = _bbsPrize.reply.length;
        Debug.log("帖子总长度：$_rowsCount");
        if (_l.isEmpty) _fetchAll();
      }
    } catch (e) {
      Debug.logError("查询单条悬赏帖出现异常：$e");
    }
  }

  /// 模拟分页添加评论列表
  void _fetchAll() async {
    Debug.log("_pageNO是多少：${_pageNo}");
    if (_pageNo * 20 > _rowsCount) {
      setState(() => _loadAll = true);
      return;
    }
    _pageNo++;
    _l = _bbsPrize.reply.take(_pageNo * 20).toList();
    Debug.log("_l的长度：${_l.length}");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "问题详情"),
      body: FutureBuilder(
        future: _future,
        builder: (context, snap) {
          if (!snapDone(snap)) {
            return Center(child: CircularProgressIndicator());
          }
          if (_bbsPrize == null) {
            return Center(child: CusText("帖子找不到了~", t_gray, 32));
          }
          return Column(
            children: <Widget>[
              Expanded(
                child: EasyRefresh(
                  header: CusHeader(),
                  footer: CusFooter(),
                  controller: _easyCtrl,
                  child: ListView(
                    controller: _scrollCtrl,
                    physics: BouncingScrollPhysics(),
                    children: <Widget>[
                      // 帖子头部信息
                      RewardHeader(data: _bbsPrize),
                      // 帖子评论区域
                      RewardReply(data: _bbsPrize),
                    ],
                  ),
                  onLoad: _loadAll
                      ? null
                      : () async {
                          await Future.delayed(Duration(milliseconds: 100));
                          await _fetchAll();
                        },
                  onRefresh: () async {
                    await _refresh();
                  },
                ),
              ),
              // 大师和发帖人可以回复
              if (ApiState.is_master || _bbsPrize.uid == ApiBase.uid)
                RewardInput(
                  data: _bbsPrize,
                  onSend: () async {
                    await _refresh();
                    Timer(
                      Duration(milliseconds: 500),
                      () => _scrollCtrl
                          .jumpTo(_scrollCtrl.position.maxScrollExtent),
                    );
                  },
                ),
            ],
          );
        },
      ),
      backgroundColor: primary,
    );
  }

  void _refresh() async {
    _l.clear();
    _pageNo = _rowsCount = 0;
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
}
