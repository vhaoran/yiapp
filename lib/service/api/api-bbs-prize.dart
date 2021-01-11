import 'package:yiapp/model/bbs/bbs_prize.dart';
import 'package:yiapp/model/bbs/bbs_reply.dart';
import 'package:yiapp/model/bbs/prize_master_reply.dart';
import 'api_base.dart';

// ------------------------------------------------------
// author: whr    除本人外请勿更改，如果确有必要，请征得本人同意
// date  : 2020/9/11 09:19
// usage : 悬赏贴
//
// ------------------------------------------------------
class ApiBBSPrize {
  static final String pre = "/yi/trade/";

  //-----------w悬赏贴分页查询v-------------------------------------
  static bbsPrizePage(Map<String, dynamic> pb) async {
    var url = pre + "BBSPrizePage";
    return await ApiBase.postPage(url, pb, (m) => BBSPrize.fromJson(m));
  }

  //-----------w悬赏贴分页查询 可同时查询已打赏和已付款的-------------------------------------
  static bbsPrizePage2(Map<String, dynamic> pb) async {
    var url = pre + "BBSPrizePage2";
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
  static Future<bool> bbsPrizeSetMasterReward(Map<String, dynamic> m) async {
    var url = pre + "BBSPrizeSetMasterReward";
    var data = m;
    return await ApiBase.postValue<bool>(url, data, enableJwt: true);
  }

  //-----------悬赏帖结单---------------------------------
  static Future<bool> bbsPrizeDue(String id) async {
    var url = pre + "BBSPrizeDue";
    var data = {"id": id};
    return await ApiBase.postValue<bool>(url, data, enableJwt: true);
  }

  //-----------w单个悬赏贴回帖-------------------------------------
  static Future<bool> bbsPrizeReply(Map<String, dynamic> m) async {
    var url = pre + "BBSPrizeReply";
    var data = m;
    return await ApiBase.postValue<bool>(url, data, enableJwt: true);
  }

  /// ----------------- 大师抢悬赏帖 -----------------
  static Future<bool> bbsPrizeMasterAim(String id) async {
    var url = pre + "BBSPrizeMasterAim";
    var data = {"order_id": id};
    return await ApiBase.postValue<bool>(url, data, enableJwt: true);
  }

  /// ----------------- 处理中的悬赏贴 适用于大师 -----------------
  static Future<List<BBSPrize>> bbsPrizeMasterList(
      Map<String, dynamic> m) async {
    var url = pre + "BBSPrizeMasterList";
    return await ApiBase.postList(url, m, (l) {
      return l.map((e) => BBSPrize.fromJson(e)).toList();
    }, enableJwt: true);
  }
}
