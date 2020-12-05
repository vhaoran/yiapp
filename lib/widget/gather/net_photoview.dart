import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yiapp/util/screen_util.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/8 17:36
// usage ：适合查看七牛云上的图片，点击图片后可左右滑动、放大缩小
// ------------------------------------------------------

class NetPhotoView extends StatefulWidget {
  final List imageList; // List格式为{'url的key':xxx}的格式
  final int index;
  final String path;

  NetPhotoView({
    this.imageList,
    this.index: 0,
    this.path: "path", // 适应后端定义的url字段
    Key key,
  }) : super(key: key);

  @override
  _NetPhotoViewState createState() => _NetPhotoViewState();
}

class _NetPhotoViewState extends State<NetPhotoView> {
  int curIndex = 0; // 当前选中图片的索引

  @override
  void initState() {
    curIndex = widget.index;
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // 取消默认的返回按钮
        backgroundColor: Colors.black,
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.black),
        constraints:
            BoxConstraints.expand(height: MediaQuery.of(context).size.height),
        child: _photoBuilder(),
      ),
    );
  }

  /// 显示图片界面
  Widget _photoBuilder() {
    return InkWell(
      child: Stack(
        children: <Widget>[
          PhotoViewGallery.builder(
            onPageChanged: _onPageChanged, // 根据当前选中图片的索引显示页面
            scrollDirection: Axis.horizontal, // 左右滑动
            itemCount: widget.imageList.length,
            backgroundDecoration: BoxDecoration(color: Colors.black),
            pageController: PageController(initialPage: curIndex),
            scrollPhysics: const BouncingScrollPhysics(),
            loadingBuilder: (context, event) {
              return Center(
                child: CircularProgressIndicator(),
              );
            },
            builder: (context, index) {
              return PhotoViewGalleryPageOptions(
                imageProvider:
                    NetworkImage(widget.imageList[index][widget.path]),
                initialScale: PhotoViewComputedScale.contained * 1,
                minScale: PhotoViewComputedScale.contained * 0.3,
                maxScale: PhotoViewComputedScale.contained * 2,
              );
            },
          ),
          Align(
            alignment: Alignment(0, 0.9),
            child: Text(
              '${curIndex + 1} / ${widget.imageList.length}',
              style: TextStyle(color: Colors.white, fontSize: S.sp(17)),
            ),
          ),
        ],
      ),
      onTap: () => Navigator.of(context).pop(),
      onLongPress: () {
//        var item = widget.imageList[curIndex];
//        _showBottomSheet(item['key'], item[widget.path]);
      },
    );
  }

  void _onPageChanged(int index) {
    curIndex = index;
    setState(() {});
  }

  /// 底部弹框
  void _showBottomSheet(String key, path) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15), topRight: Radius.circular(15)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
                title: Text('收藏', textAlign: TextAlign.center),
                onTap: () async {
                  Navigator.pop(context);
//                  String res = await Cus.addFavorite(
//                      source: Favorite_SOURCE_IMAGE, key: key, path: path);
//                  if (res != null || res?.isNotEmpty) {
//                    CusToast.toast(context, text: '收藏成功');
//                  }
                }),
            Divider(height: 0, thickness: 1),
            ListTile(
              title: Text('取消', textAlign: TextAlign.center),
              onTap: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }
}
