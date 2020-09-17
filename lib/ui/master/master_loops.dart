import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:yiapp/complex/class/debug_log.dart';
import 'package:yiapp/complex/const/const_double.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/api_state.dart';
import 'package:yiapp/complex/tools/cus_tool.dart';
import 'package:yiapp/complex/widgets/cus_bg_wall.dart';
import 'package:yiapp/complex/widgets/flutter/cus_bottom_sheet.dart';
import 'package:yiapp/complex/widgets/flutter/cus_dialog.dart';
import 'package:yiapp/complex/widgets/flutter/cus_toast.dart';
import 'package:yiapp/model/dicts/master-images.dart';
import 'package:yiapp/service/api/api-master.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/17 17:24
// usage ：大师轮播图
// ------------------------------------------------------

class MasterLoops extends StatefulWidget {
  List<MasterImages> l; // 大师轮播图
  final VoidCallback onChanged; // 轮播图更改

  MasterLoops({this.l, this.onChanged, Key key}) : super(key: key);

  @override
  _MasterLoopsState createState() => _MasterLoopsState();
}

class _MasterLoopsState extends State<MasterLoops> {
  @override
  Widget build(BuildContext context) {
    // 是否已经添加过轮播图
    return widget.l.isEmpty ? _defBgWall() : _masterBgWall();
  }

  /// 默认背景墙
  Widget _defBgWall() {
    return BackgroundWall(
      height: bgWallH + 45,
      onTap: ApiState.isMaster
          ? () => CusBottomSheet(context, OnFile: _doAddImage)
          : null,
    );
  }

  /// 大师轮播图
  Widget _masterBgWall() {
    return Swiper(
      itemCount: widget.l.length,
      itemBuilder: (context, i) {
        MasterImages e = widget.l[i];
        return BackgroundWall(
          url: e.image_path,
          boxFit: BoxFit.fitWidth,
          onTap: () {
            print(">>>点的第${i + 1}张");
            CusDialog.normal(
              context,
              title: "您希望对图片进行",
              textAgree: "修改",
              agreeColor: Colors.black,
              onApproval: () {},
              textCancel: "删除",
              cancelColor: Colors.red,
              onCancel: () => _doRmImage(e.id),
              barrierDismissible: true,
            );
          },
        );
      },
//      autoplay: true,
      pagination: SwiperPagination(
        builder: DotSwiperPaginationBuilder(
          color: Colors.black,
          activeColor: Colors.white, // 激活颜色
          size: Adapt.px(18),
          activeSize: Adapt.px(18),
        ),
      ),
    );
  }

  /// 添加图片
  void _doAddImage(File file) async {
    if (file == null) return;
    try {
      String url = await CusTool.fileUrl(file);
      if (url != null && url.isNotEmpty) {
        var m = {"image_path": url, "sort_no": 1};
        MasterImages res = await ApiMaster.masterImageAdd(m);
        if (res != null) {
          CusToast.toast(context, text: "添加成功");
          if (widget.onChanged != null) widget.onChanged();
        }
      }
    } catch (e) {
      print("<<<添加大师图片出现异常：$e");
    }
  }

  /// 删除图片
  void _doRmImage(num id) async {
    try {
      bool ok = await ApiMaster.masterImageRm(id);
      Debug.log("删除大师图片结果：$ok");
      if (ok) {
        CusToast.toast(context, text: "删除成功");
        if (widget.onChanged != null) widget.onChanged();
        setState(() {});
      }
    } catch (e) {
      Debug.logError("删除图片出现异常：$e");
    }
  }
}
