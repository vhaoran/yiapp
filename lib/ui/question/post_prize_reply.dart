import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:left_scroll_actions/left_scroll_actions.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_string.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/model/bbs/bbs_prize.dart';
import 'package:yiapp/model/bbs/bbs_reply.dart';
import 'package:yiapp/model/bbs/prize_master_reply.dart';
import 'package:yiapp/service/api/api-bbs-vie.dart';
import 'package:yiapp/ui/home/home_page.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/flutter/cus_dialog.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';
import 'package:yiapp/widget/small/cus_avatar.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/19 上午11:55
// usage ：悬赏帖回帖的内容
// ------------------------------------------------------

typedef FnBBSReply = Function(BBSReply reply);

class PostPrizeReply extends StatefulWidget {
  final BBSPrize data;
  final FnBBSReply fnBBSReply;
  final VoidCallback onSuccess;

  PostPrizeReply({this.data, this.fnBBSReply, this.onSuccess, Key key})
      : super(key: key);

  @override
  _PostPrizeReplyState createState() => _PostPrizeReplyState();
}

class _PostPrizeReplyState extends State<PostPrizeReply> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(vertical: S.h(5)),
          alignment: Alignment.center,
          child: Text(
            widget.data.master_reply.isEmpty ? "暂无评论" : "评论区",
            style: TextStyle(color: t_primary, fontSize: S.sp(16)),
          ),
        ),
        if (widget.data.master_reply.isNotEmpty)
          ...List.generate(
            widget.data.master_reply.length,
            (i) => _tmpItem(widget.data.master_reply[i], i + 1),
          ),
      ],
    );
  }

  /// 单条评论的内容
  Widget _tmpItem(BBSPrizeReply rep, int level) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: S.w(10), vertical: S.h(5)),
      decoration: BoxDecoration(
        color: fif_primary,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.only(bottom: S.h(10)), // 评论间隔
      child: Column(
        children: <Widget>[
          /// 大师基本信息、楼层数
          _masterInfo(rep, level),
          SizedBox(height: S.h(5)),
          ...List.generate(
            rep.reply.length,
            (index) => _commentDetail(rep.reply[index]),
          ),
        ],
      ),
    );
  }

  /// 相互评论的详情
  Widget _commentDetail(BBSReply r) {
    var blue = TextStyle(color: Colors.lightBlue, fontSize: S.sp(15));
    var gray = TextStyle(color: t_gray, fontSize: S.sp(15));
    return InkWell(
      onTap: () {
        Log.info("点击评论的详情：${r.toJson()}");
        if (r.is_master && widget.fnBBSReply != null) widget.fnBBSReply(r);
      },
      child: Container(
        color: Colors.black12,
        padding: EdgeInsets.symmetric(horizontal: S.w(10), vertical: S.h(5)),
        margin: EdgeInsets.only(top: S.h(4)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                // 大师给帖主的回复
                if (r.is_master) ...[
                  Text("${r.nick}", style: blue),
                  Text("►", style: gray),
                  Text("${widget.data.nick}", style: blue),
                ],
                // 帖主的回复
                if (!r.is_master)
                  Text("${r.nick}", style: blue),
                Text(
                  "（帖主）",
                  style: TextStyle(color: t_gray, fontSize: S.sp(13)),
                ),
              ],
            ),
            SizedBox(height: S.h(5)),
            Text(r.text.first, style: gray), // 回复的内容
            SizedBox(height: S.h(5)),
            Container(
              alignment: Alignment.centerRight,
              child: Text(r.create_date, style: gray), // 回复的时间
            ),
          ],
        ),
      ),
    );
  }

  Widget _masterInfo(BBSPrizeReply e, int level) {
    var style = TextStyle(color: t_gray, fontSize: S.sp(15));
    return Row(
      children: <Widget>[
        CusAvatar(url: e.master_icon ?? "", circle: true, size: 45),
        SizedBox(width: S.w(15)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    e.master_nick, // 大师昵称
                    style: TextStyle(color: t_primary, fontSize: S.sp(15)),
                  ),
                  Spacer(),
                  Text("$level楼", style: style), // 大师所处楼层数
                ],
              ),
              Text(e.reply.first.create_date, style: style) // 大师第一条评论的时间
            ],
          ),
        ),
      ],
    );
  }

  /// 打赏大师
  void _doReward(BBSReply reply) {
    CusDialog.normal(
      context,
      title: "确定给大师【${reply.nick}】打赏${widget.data.amt}$yuan_bao吗",
      onApproval: () async {
        var m = {
          "id": widget.data.id,
          "score": widget.data.amt,
          "master_id": reply.uid,
        };
        try {
          bool ok = await ApiBBSVie.bbsVieDue(m);
          if (ok) {
            Log.info("给大师 ${reply.uid} 打赏的结果:$ok");
            CusToast.toast(context, text: "打赏成功");
            CusRoute.pushReplacement(context, HomePage());
            if (widget.onSuccess != null) widget.onSuccess();
            LeftScrollGlobalListener.instance
                ?.targetStatus(
                  LeftScrollCloseTag("vie_reply"),
                  Key(reply.create_date.toString()),
                )
                ?.value = true;
          }
        } catch (e) {
          Log.error("打赏id为${reply.uid}大师出现异常：$e");
        }
      },
    );
  }
}
