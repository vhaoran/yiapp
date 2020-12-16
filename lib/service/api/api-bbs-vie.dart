import 'package:yiapp/model/bbs/bbs_reply.dart';
import 'package:yiapp/model/bbs/bbs-vie.dart';
import 'api_base.dart';

// ------------------------------------------------------
// author: whr    除本人外请勿更改，如果确有必要，请征得本人同意
// date  : 2020/9/11 09:19
// usage : 闪断帖
//
// ------------------------------------------------------
class ApiBBSVie {
  static final String pre = "/yi/trade/";

  //-----------w闪断帖分页查询v-------------------------------------
  static bbsViePage(Map<String, dynamic> pb) async {
    var url = pre + "BBSViePage";
    return await ApiBase.postPage(url, pb, (m) => BBSVie.fromJson(m));
  }

  //-----------闪断帖   历史 ---分页查询v-------------------------------------
  static bbsVieHisPage(Map<String, dynamic> pb) async {
    var url = pre + "BBSVieHisPage";
    return await ApiBase.postPage(url, pb, (m) => BBSVie.fromJson(m));
  }

//-----------w单个闪断帖get v-------------------------------------
  static Future<BBSVie> bbsVieGet(String id) async {
    var url = pre + "BBSVieGet";
    var data = {"id": id};
    return await ApiBase.postObj(url, data, (m) {
      return BBSVie.fromJson(m);
    }, enableJwt: true);
  }

  //-----------单个悬赏历史 get v-------------------------------------
  static Future<BBSVie> bbsVieHisGet(String id) async {
    var url = pre + "BBSVieHisGet";
    var data = {"id": id};
    return await ApiBase.postObj(url, data, (m) {
      return BBSVie.fromJson(m);
    }, enableJwt: true);
  }

//-----------w查询贴子中所有的回复内容v-------------------------------------
  static Future<List<BBSReply>> bbsVieReplyList(String id) async {
    var url = pre + "BBSVieReplyList";
    var data = {
      "id": id,
    };

    return await ApiBase.postList(url, data, (l) {
      return l.map((e) => BBSReply.fromJson(e)).toList();
    }, enableJwt: true);
  }

//-----------w发布闪断帖--用户使用v-------------------------------------
  static Future<BBSVie> bbsVieAdd(Map<String, dynamic> m) async {
    var url = pre + "BBSVieAdd";
    var data = m;
    return await ApiBase.postObj(url, data, (m) {
      return BBSVie.fromJson(m);
    }, enableJwt: true);
  }

//-----------w取消 闪断帖v----在没有人回复的情况下---------------------------------
  static Future<bool> bbsVieCancel(String id) async {
    var url = pre + "BBSVieCancel";
    var data = {"id": id};
    return await ApiBase.postValue<bool>(url, data, enableJwt: true);
  }

  //-----------w闪断帖打赏,兑现分值v-------------------------------------
  static Future<bool> bbsVieDue(Map<String, dynamic> m) async {
    var url = pre + "BBSVieDue";
    var data = m;
    return await ApiBase.postValue<bool>(url, data, enableJwt: true);
  }

  //-------抢单--------------------
  static Future<BBSVie> bbsVieAim(String id) async {
    var url = pre + "BBSVieAim";
    var data = {"id": id};
    return await ApiBase.postObj(url, data, (m) {
      return BBSVie.fromJson(m);
    }, enableJwt: true);
  }

  //-----------w回贴-------------------------------------
  //------------------------------------------------
  static Future<bool> bbsVieReply(Map<String, dynamic> m) async {
    var url = pre + "BBSVieReply";
    var data = m;
    return await ApiBase.postValue<bool>(url, data, enableJwt: true);
  }
}
