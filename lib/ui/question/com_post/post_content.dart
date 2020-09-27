import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/complex/class/debug_log.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/api_state.dart';
import 'package:yiapp/complex/type/bool_utils.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/model/bbs/bbs-Prize.dart';
import 'package:yiapp/model/bbs/bbs-Reply.dart';
import 'package:yiapp/model/msg/msg_body.dart';
import 'package:yiapp/service/api/api-bbs-prize.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/service/bus/im-bus.dart';
import 'package:yiapp/ui/question/com_post/post_event.dart';
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
  var _bbsPrize = BBSPrize(); // 帖子全部内容
  List<BBSReply> _l = []; // 帖子评论列表
  var _future;
  var _scrollCtrl = ScrollController();
  var _easyCtrl = EasyRefreshController();
  int _count = 0;
//  StreamSubscription<PostEvent> _busSub;
  StreamSubscription<MsgBody> _busSub;

  int _pageNo = 0;
  int _rowsCount = 0;

  @override
  void initState() {
    _prepareBusEvent(); // 初始化监听
    _future = _fetch();
    super.initState();
  }

  _prepareBusEvent() {
    Debug.log("这里是消息监听");
//    _busSub = glbEventBus.on<PostEvent>().listen((event) {
//      Debug.log("event:${event.action == "suxing"}");
//      _fetch();
//    });
    _busSub = glbEventBus.on<MsgBody>().listen((event) {
      if (event.content_type == "comment") {
        Debug.log("有人发布评论了");
        Debug.log("发帖的详情：${event.toJson()}");
      }
    });
  }

  /// 查询单条帖子内容
  _fetch() async {
    try {
      BBSPrize bbsPrize = await ApiBBSPrize.bbsPrizeGet(widget.id);
      if (bbsPrize != null) {
        _bbsPrize = bbsPrize;
        _rowsCount = _bbsPrize.reply.length;
        Debug.log("帖子总长度：$_rowsCount");
        if (_l.isEmpty) {
          _fetchAll();
        } else {
          _l.add(_bbsPrize.reply.last);
        }
      }
    } catch (e) {
      Debug.logError("查询单条悬赏帖出现异常：$e");
    }
  }

  void _fetchAllReply() async {
    try {
      List<BBSReply> res = await ApiBBSPrize.bbsPrizeReplyList(widget.id);
      if (res != null) {}
    } catch (e) {
      Debug.logError("获取帖子所有的回复内容时出现异常：$e");
    }
  }

  /// 模拟分页添加评论列表
  void _fetchAll() async {
    if (_pageNo * 5 > _rowsCount) return;
    _pageNo++;
    _l = _bbsPrize.reply.take(_pageNo * 5).toList();
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
          return Column(
            children: <Widget>[
              Expanded(
                child: EasyRefresh(
                  controller: _easyCtrl,
                  child: ListView(
                    controller: _scrollCtrl,
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: Adapt.px(20)),
                    children: <Widget>[
                      // 帖子头部信息
                      PostHeader(data: _bbsPrize),
                      // 帖子评论区域
                      PostReply(l: _l, uid: _bbsPrize.uid),
                    ],
                  ),
                  onLoad: () async {
                    await Future.delayed(Duration(milliseconds: 100));
                    await _fetchAll();
//                    _easyCtrl.finishLoad(
//                        noMore: _l.length >= _bbsPrize.reply.length);
                  },
                ),
              ),
              // 大师和发帖人可以回复
              if (ApiState.isMaster || _bbsPrize.uid == ApiBase.uid)
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
    _busSub.cancel();
    _scrollCtrl.dispose();
    _easyCtrl.dispose();
    super.dispose();
  }
}
