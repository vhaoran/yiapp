import 'package:flutter/material.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/cus_routes.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/model/bbs/bbs-Reply.dart';
import 'package:yiapp/ui/question/com_post/all_reply.dart';
import 'package:yiapp/ui/question/com_post/first_reply.dart';
import 'package:yiapp/ui/question/com_post/reply_item.dart';
import 'package:yiapp/ui/question/com_post/temp_reply_data.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/23 17:47
// usage ：单条回帖的内容
// ------------------------------------------------------

class PostReply extends StatefulWidget {
  final List<BBSReply> l;
  final int level; // 楼层
  final bool showAll; // 是否显示全部评论

  PostReply({
    this.l,
    this.showAll: false,
    this.level,
    Key key,
  }) : super(key: key);

  @override
  _PostReplyState createState() => _PostReplyState();
}

class _PostReplyState extends State<PostReply> {
  List<BBSReply> _l = []; // 评论的数据

  @override
  void initState() {
    // 模拟回复数据
    if (widget.l.isEmpty) {
      for (var i = 0; i < 12; i++) {
        _l.insertAll(i, [BBSReply.fromJson(replyJson['reply'][i])]);
      }
    } else {
      _l = widget.l;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var tl = widget.showAll ? _l : _l.length >= 5 ? _l.take(5).toList() : _l;
    return Column(children: _buildView(tl));
  }

  List<Widget> _buildView(List<BBSReply> l) {
    return <Widget>[
      ...List.generate(
        l.length,
        (i) => Column(
          children: <Widget>[
            if (i == 0) // 大师的第一条评论
              FirstReply(data: l[i], level: widget.level),
            if (i != 0) // 剩余的评论
              ReplyItem(data: l[i]),
          ],
        ),
      ),
      // 根据评论长度是否大于 5，显示还有多少条回复
      if (_l.length >= 5 && !widget.showAll)
        Padding(
          padding: EdgeInsets.only(top: Adapt.px(10), bottom: Adapt.px(20)),
          child: InkWell(
            onTap: () => CusRoutes.push(
              context,
              AllReply(l: _l, level: widget.level),
            ),
            child: CusText("还有 ${_l.length - 5} 条回复...", Color(0xFF4D95E4), 28),
          ),
        ),
      Padding(
        padding: EdgeInsets.only(bottom: Adapt.px(20)), // 楼层间隔
        child: Divider(thickness: 0.4, height: 0, color: Colors.white),
      ),
    ];
  }
}
