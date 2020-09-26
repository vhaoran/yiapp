import 'dart:async';
import 'package:flutter/material.dart';
import 'package:yiapp/complex/class/debug_log.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/api_state.dart';
import 'package:yiapp/complex/type/bool_utils.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/model/bbs/bbs-Prize.dart';
import 'package:yiapp/service/api/api-bbs-prize.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/ui/question/com_post/post_header.dart';
import 'package:yiapp/ui/question/com_post/post_input.dart';
import 'package:yiapp/ui/question/com_post/post_reply.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/23 14:56
// usage ：帖子内容组件
// ------------------------------------------------------

class PostContent extends StatefulWidget {
  final String id;

  PostContent({this.id, Key key}) : super(key: key);

  @override
  _PostContentState createState() => _PostContentState();
}

class _PostContentState extends State<PostContent> {
  var _bbsPrize = BBSPrize();
  var _future;
  bool _isPoster = false; // 是否发帖人
  var _scrollCtrl = ScrollController();

  @override
  void initState() {
    _future = _fetch();
    _isPoster = _bbsPrize.uid == ApiBase.uid;
    super.initState();
  }

  /// 查询单条帖子内容
  _fetch() async {
    try {
      BBSPrize res = await ApiBBSPrize.bbsPrizeGet(widget.id);
      if (res != null) {
        Debug.log("单条帖子的详情：${res.toJson()}");
        _bbsPrize = res;
      }
    } catch (e) {
      Debug.logError("查询单条悬赏帖出现异常：$e");
    }
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
          return Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  controller: _scrollCtrl,
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: Adapt.px(20)),
                  children: <Widget>[
                    PostHeader(data: _bbsPrize), // 帖子头部信息
                    ...List.generate(
                      _bbsPrize.reply.length,
                      (i) => PostReply(
                        reply: _bbsPrize.reply[i],
                        level: i + 1,
                      ),
                    ),
                  ],
                ),
              ),
              // 大师和发帖人可以回复
              if (ApiState.isMaster || _isPoster)
                PostInput(
                  data: _bbsPrize,
                  onSend: () async {
                    await _refresh();
                    Timer(
                      Duration(milliseconds: 100),
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
    await _fetch();
    setState(() {});
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }
}
