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
import 'package:yiapp/model/bbs/bbs-Reply.dart';
import 'package:yiapp/model/bbs/bbs-vie.dart';
import 'package:yiapp/service/api/api-bbs-vie.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'flash_header.dart';
import 'flash_input.dart';
import 'flash_reply.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/28 11:16
// usage ：闪断帖内容
// ------------------------------------------------------

class FlashContent extends StatefulWidget {
  final String id;

  FlashContent({this.id, Key key}) : super(key: key);

  @override
  _FlashContentState createState() => _FlashContentState();
}

class _FlashContentState extends State<FlashContent> {
  BBSVie _bbsVie; // 帖子全部内容
  List<BBSReply> _l = []; // 帖子评论列表
  var _future;
  var _scrollCtrl = ScrollController();
  var _easyCtrl = EasyRefreshController();

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
      BBSVie bbsPrize = await ApiBBSVie.bbsVieGet(widget.id);
      if (bbsPrize != null) {
        _bbsVie = bbsPrize;
        _rowsCount = _bbsVie.reply.length;
        Debug.log("帖子评论总长度：$_rowsCount");
        if (_l.isEmpty) _fetchAll();
      }
    } catch (e) {
      Debug.logError("查询单条悬赏帖出现异常：$e");
    }
  }

  /// 模拟分页添加评论列表
  void _fetchAll() async {
    if (_pageNo * 20 > _rowsCount) return;
    _pageNo++;
    _l = _bbsVie.reply.take(_pageNo * 20).toList();
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
          if (_bbsVie == null) {
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
                      FlashHeader(data: _bbsVie),
                      // 帖子评论区域
                      FlashReply(data: _bbsVie),
                    ],
                  ),
                  onLoad: () async {
                    await Future.delayed(Duration(milliseconds: 100));
                    await _fetchAll();
                  },
                  onRefresh: () async {
                    await _refresh();
                  },
                ),
              ),
              // 大师和发帖人可以回复
              if (ApiState.isMaster || _bbsVie.uid == ApiBase.uid)
                FlashInput(
                  data: _bbsVie,
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
