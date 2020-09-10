import 'package:yiapp/model/bbs/bbs-Prize.dart';
import 'package:yiapp/model/bbs/bbs-Reply.dart';

import 'api_base.dart';

class ApiBBSPrize {
  static final String pre = "/yi/trade/";

  //-----------w悬赏贴分页查询v-------------------------------------
  static bbsPrizePage(Map<String, dynamic> pb) async {
    var url = pre + "BBSPrizePage";
    return await ApiBase.postPage(url, pb, (m) => BBSPrize.fromJson(m));
  }

  //-----------悬赏贴   历史 ---分页查询v-------------------------------------
  static bbsPrizeHisPage(Map<String, dynamic> pb) async {
    var url = pre + "BBSPrizeHisPage";
    return await ApiBase.postPage(url, pb, (m) => BBSPrize.fromJson(m));
  }

//-----------w单个悬赏贴get v-------------------------------------
  static Future<BBSPrize> bbsPrizeGet(String id) async {
    var url = pre + "BBSPrizeGet";
    var data = {"id": id};
    return await ApiBase.postObj(url, data, (m) {
      return BBSPrize.fromJson(m);
    }, enableJwt: true);
  }

  //-----------单个悬赏历史 get v-------------------------------------
  static Future<BBSPrize> bbsPrizeHisGet(String id) async {
    var url = pre + "BBSPrizeHisGet";
    var data = {"id": id};
    return await ApiBase.postObj(url, data, (m) {
      return BBSPrize.fromJson(m);
    }, enableJwt: true);
  }

//-----------w查询贴子中所有的回复内容v-------------------------------------
  static Future<List<BBSReply>> bbsPrizeReplyList(String id) async {
    var url = pre + "BBSPrizeReplyList";
    var data = {
      "id": id,
    };

    return await ApiBase.postList(url, data, (l) {
      return l.map((e) => BBSReply.fromJson(e)).toList();
    }, enableJwt: true);
  }

//-----------w发布悬赏贴--用户使用v-------------------------------------
  static Future<BBSPrize> bbsPrizeAdd(Map<String, dynamic> m) async {
    var url = pre + "BBSPrizeAdd";
    var data = m;
    return await ApiBase.postObj(url, data, (m) {
      return BBSPrize.fromJson(m);
    }, enableJwt: true);
  }

//-----------w取消 悬赏贴v----在没有人回复的情况下---------------------------------
  static Future<bool> bbsPrizeCancel(String id) async {
    var url = pre + "BBSPrizeCancel";
    var data = {"id": id};
    return await ApiBase.postValue<bool>(url, data, enableJwt: true);
  }

  //-----------w悬赏贴打赏,兑现分值v-------------------------------------
  static Future<bool> bbsPrizeDue(Map<String, dynamic> m) async {
    var url = pre + "BBSPrizeDue";
    var data = m;
    return await ApiBase.postValue<bool>(url, data, enableJwt: true);
  }
}
