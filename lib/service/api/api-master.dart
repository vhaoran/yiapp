import 'package:yiapp/model/dicts/master-apply.dart';
import 'package:yiapp/model/dicts/master-cate.dart';
import 'package:yiapp/model/dicts/master-images.dart';
import 'package:yiapp/model/dicts/master-info-full.dart';
import 'package:yiapp/model/dicts/master-info.dart';

import 'api_base.dart';

class ApiMaster {
  static final String pre = "/yi/user/";

  //---大师信息-----分页查询
  static masterInfoPage(Map<String, dynamic> pb) async {
    var url = pre + "MasterInfoPage";
    return await ApiBase.postPage(url, pb, (m) => MasterInfo.fromJson(m));
  }

  //---------w获取大师全部信息------------------
  static Future<MasterInfoFull> masterInfoFullGet(int masterID) async {
    var url = pre + "MasterInfoFullGet";
    var data = {"master_id": masterID};
    return await ApiBase.postObj(url, data, (m) {
      return MasterInfoFull.fromJson(m);
    }, enableJwt: true);
  }

  //---------w获取大师基本信息------------------
  static Future<MasterInfo> masterInfoGet(int masterID) async {
    var url = pre + "MasterInfoGet";
    var data = {"master_id": masterID};
    return await ApiBase.postObj(url, data, (m) {
      return MasterInfo.fromJson(m);
    }, enableJwt: true);
  }

  //--------------------w大师申请 ----------------------------
  static Future<String> masterInfoApplyHandIn(Map<String, dynamic> m) async {
    var url = pre + "MasterInfoApplyHandIn";
    var data = m;
    return await ApiBase.postValue<String>(url, data, enableJwt: true);
  }

  //--------------------w大师申请 传入一个数据结构 ----------------------------
  static Future<String> masterInfoApplyHandInStruct(MasterInfoApply src) async {
    var url = pre + "MasterInfoApplyHandIn";
    var data = src?.toJson();
    return await ApiBase.postValue<String>(url, data, enableJwt: true);
  }

  //-----w大师申请分页查询---分页查询
  static masterInfoApplyPage(Map<String, dynamic> pb) async {
    var url = pre + "MasterInfoApplyPage";
    return await ApiBase.postPage(url, pb, (m) => MasterInfoApply.fromJson(m));
  }

  //-----w审批大师申请 适用于后台管理员-------------------------------------------
  static Future<bool> masterInfoApplyAudit(String id, int stat) async {
    var url = pre + "MasterInfoApplyAudit";
    var data = {
      "id": id,
      "stat": stat,
      // "comment": "输入的id是返回的申请信息返回的id",
      // "comment2": "stat 为1 代表通过申请,其他的数值为驳回申请",
      // "comment3": "若某用户已经成为大师,再次通过申请时会提示大师已经存在",
      // "comment4": "jwt中的数据大于0即可"
    };
    return await ApiBase.postValue<bool>(url, data, enableJwt: true);
  }

  //--------w启用或停用某大师----------------------------------------
  static Future<bool> masterSetEnable(int masterID, int enabled) async {
    var url = pre + "MasterSetEnable";
    var data = {
      "master_id": masterID,
      "enabled": enabled,
      // "comment": "JWT必须存在, 大于0即可",
      // "comment2": "Enable为0 代表停用,1代表激活, 不允许输入其他值"
    };
    return await ApiBase.postValue<bool>(url, data, enableJwt: true);
  }

  //---------w大师信息更改----必须由大师本人操作-----------------------------------
  static Future<bool> masterInfoCh(Map<String, dynamic> m) async {
    var url = pre + "MasterInfoCh";
    var data = m;
    return await ApiBase.postValue<bool>(url, data, enableJwt: true);
  }

  //-----w大师图片列表- -列表查询--------------
  static Future<List<MasterImages>> masterImageList(int masterID) async {
    var url = pre + "MasterImageList";
    var data = {
      "uid": masterID,
    };

    return await ApiBase.postList(url, data, (l) {
      return l.map((e) => MasterImages.fromJson(e)).toList();
    }, enableJwt: true);
  }

  //----------w大师图片添加-----------------
  static Future<MasterImages> masterImageAdd(Map<String, dynamic> m) async {
    var url = pre + "MasterImageAdd";
    var data = m;
    return await ApiBase.postObj(url, data, (m) {
      return MasterImages.fromJson(m);
    }, enableJwt: true);
  }

  //-----------w大师图片修改-------------------------------------
  static Future<bool> masterImageCh(Map<String, dynamic> m) async {
    var url = pre + "MasterImageCh";
    var data = m;
    return await ApiBase.postValue<bool>(url, data, enableJwt: true);
  }

//-----------w大师图片删除-------------------------------------
  static Future<bool> masterImageRm(int id) async {
    var url = pre + "MasterImageRm";
    var data = {
      "id": id,
      // "comment": "必须是大师本人才能进行操作:id所对应的uid与jwt一致",
      // "comment2":"此时出入的id是图片的id"
    };
    return await ApiBase.postValue<bool>(url, data, enableJwt: true);
  }

  //-----------w大师服务项目列表-------------------------------------
  static Future<List<MasterCate>> masterItemList(int uid) async {
    var url = pre + "MasterItemList";
    var data = {
      "uid": uid,
    };

    return await ApiBase.postList(url, data, (l) {
      return l.map((e) => MasterCate.fromJson(e)).toList();
    }, enableJwt: true);
  }

  //------------w大师服务项目增加---------------
  static Future<MasterCate> masterItemAdd(Map<String, dynamic> m) async {
    var url = pre + "MasterItemAdd";
    var data = m;
    return await ApiBase.postObj(url, data, (m) {
      return MasterCate.fromJson(m);
    }, enableJwt: true);
  }

//-----------w大师 服务 项目修改-------------------------------------
  static Future<bool> masterItemCh(Map<String, dynamic> m) async {
    var url = pre + "MasterItemCh";
    var data = m;
    return await ApiBase.postValue<bool>(url, data, enableJwt: true);
  }

  //----------w大师服务项目删除-------------------------------------
  static Future<bool> masterItemRm(int id) async {
    var url = pre + "MasterItemRm";
    var data = {
      "id": id,
      //"comment": "必须是本人对营业范围进行操作,即id对应的uid是JWT中的数据",
    };
    return await ApiBase.postValue<bool>(url, data, enableJwt: true);
  }

//------------------------------------------------
}
