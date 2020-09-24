import 'package:flutter/material.dart';
import 'package:yiapp/complex/class/debug_log.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/widgets/cus_avatar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/model/bbs/bbs-Reply.dart';
import 'package:yiapp/ui/question/com_post/sim_reply_data.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/23 17:47
// usage ：单条回帖的内容
// ------------------------------------------------------

class PostReply extends StatefulWidget {
  final List<BBSReply> l;

  PostReply({this.l, Key key}) : super(key: key);

  @override
  _PostReplyState createState() => _PostReplyState();
}

class _PostReplyState extends State<PostReply> {
  List<BBSReply> _l = []; // 评论的数据

  @override
  void initState() {
    // 模拟回复数据
    if (widget.l.isEmpty) {
      for (var i = 0; i < 4; i++) {
        _l.insertAll(i, [BBSReply.fromJson(replyJson['reply'][i])]);
      }
    } else {
      _l = widget.l;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_l.isEmpty) return Container();
    return Column(
      children: List.generate(
        _l.length,
        (i) => Column(
          children: <Widget>[
            if (i == 0) _maFirstComment(_l[i]), // 大师的第一条评论
            if (i != 0)
              _otherReply(_l[i]), // 剩余的评论
          ],
        ),
      ),
    );
  }

  /// 大师第一条评论中的头像，昵称，评论时间
  Widget _maFirstComment(BBSReply e) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: CusAvatar(
            url: e.icon ?? "", // 大师头像
            circle: true,
            size: 50,
          ),
          // 大师昵称
          title: CusText(e.nick.isEmpty ? "唐僧" : e.nick, t_primary, 28),
          subtitle: Padding(
            padding: EdgeInsets.only(top: Adapt.px(10)),
            child: CusText(e.create_date, t_gray, 28), // 大师评论时间
          ),
          contentPadding: EdgeInsets.all(0),
        ),
        InkWell(
          onTap: () {},
          child: Text(
            e.text.first, // 大师评论内容
            style: TextStyle(color: t_gray, fontSize: Adapt.px(28)),
          ),
        ),
        SizedBox(height: Adapt.px(40)),
      ],
    );
  }

  /// 剩余的评论
  Widget _otherReply(BBSReply e) {
    return Column(
      children: <Widget>[
        InkWell(
          onTap: () {
            Debug.log("当前评论人的uid:${e.uid}");
          },
          child: Container(
            color: fif_primary,
            width: double.infinity,
            padding: EdgeInsets.symmetric(
                horizontal: Adapt.px(20), vertical: Adapt.px(15)),
            margin: EdgeInsets.only(bottom: Adapt.px(5)), // 评论间隔
            child: Text(
              e.text.first,
              style: TextStyle(color: t_gray, fontSize: Adapt.px(28)),
            ),
          ),
        ),
      ],
    );
  }
}
