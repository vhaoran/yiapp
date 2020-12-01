import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:yiapp/func/debug_log.dart';
import 'package:yiapp/func/const/const_color.dart';
import 'package:yiapp/func/const/const_double.dart';
import 'package:yiapp/func/adapt.dart';
import 'package:yiapp/func/api_state.dart';
import 'package:yiapp/complex/tools/cus_tool.dart';
import 'package:yiapp/complex/widgets/small/cus_bg_wall.dart';
import 'package:yiapp/complex/widgets/flutter/cus_bottom_sheet.dart';
import 'package:yiapp/complex/widgets/flutter/cus_toast.dart';
import 'package:yiapp/model/dicts/master-images.dart';
import 'package:yiapp/service/api/api-master.dart';
import 'package:yiapp/util/file_util.dart';

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
  File _file;
  @override
  Widget build(BuildContext context) {
    // 是否已经添加过轮播图
    return widget.l.isEmpty ? _defBgWall() : _masterBgWall();
  }

  /// 默认背景墙
  Widget _defBgWall() {
    return BackgroundWall(
      height: bgWallH + 45,
      onTap: ApiState.is_master
          ? () =>
              CusBottomSheet(context, OnFile: (file) => _doAddImage(file, 1))
          : null,
    );
  }

  /// 大师轮播图
  Widget _masterBgWall() {
    return Stack(
      children: <Widget>[
        Swiper(
          key: UniqueKey(),
          itemCount: widget.l.length,
          itemBuilder: (context, i) {
            MasterImages e = widget.l[i];
            return BackgroundWall(
              url: e.image_path,
              boxFit: BoxFit.fitWidth,
              onTap: () => CusBottomSheet(
                context,
                titles: ["替换", "删除", "取消"],
                fnLists: [
                  null, // 替换图片在 OnFile 回调
                  () => _doRmImage(e.id), // 删除图片
                  null, // 取消
                ],
                OnFile: (file) {
                  setState(() => _file = file);
                  if (_file != null) _doReplaceImage(_file, e);
                },
              ),
            );
          },
//          autoplay: widget.l.length == 1 ? false : true,
          pagination: SwiperPagination(
              builder: DotSwiperPaginationBuilder(
                color: Colors.black,
                activeColor: Colors.white, // 激活颜色
                size: Adapt.px(18),
                activeSize: Adapt.px(18),
              ),
              alignment: Alignment.bottomRight),
        ),
        Align(
          alignment: Alignment(1, -0.8),
          child: IconButton(
            icon: Icon(Icons.more_horiz, color: t_gray, size: Adapt.px(40)),
            onPressed: () => CusBottomSheet(
              context,
              titles: ["从相册添加", "拍摄", "取消"],
              fnLists: [
                () {}, // 添加图片在 OnFile 回调
                null,
                null, // 取消
              ],
              OnFile: (file) {
                setState(() => _file = file);
                if (_file != null) _doAddImage(_file, widget.l.length + 1);
              },
            ),
          ),
        ),
      ],
    );
  }

  /// 添加图片
  void _doAddImage(File file, num sort_no) async {
    if (file == null) return;
    try {
      String url = await FileUtil.singleFile(file);
      if (url != null && url.isNotEmpty) {
        var m = {"image_path": url, "sort_no": 1};
        MasterImages res = await ApiMaster.masterImageAdd(m);
        if (res != null) {
          CusToast.toast(context, text: "添加成功");
          if (widget.onChanged != null) widget.onChanged();
        }
      }
    } catch (e) {
      Debug.logError("添加大师图片出现异常：$e");
    }
  }

  /// 替换图片
  void _doReplaceImage(File file, MasterImages image) async {
    try {
      String url = await FileUtil.singleFile(file);
      if (url != null && url.isNotEmpty) {
        var m = {
          "id": image.id,
          "M": {"image_path": url, "sort_no": image.sort_no}
        };
        bool ok = await ApiMaster.masterImageCh(m);
        if (ok) {
          CusToast.toast(context, text: "替换成功");
          if (widget.onChanged != null) widget.onChanged();
        }
      }
    } catch (e) {
      Debug.logError("替换大师图片出现异常：$e");
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
