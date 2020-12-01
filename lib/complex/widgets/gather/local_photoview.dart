import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yiapp/func/adapt.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/8 17:37
// usage ：(暂时不用)适合查看本地图片，点击图片后，可左右滑动、放大缩小
// ------------------------------------------------------

/// PhotoView 中 imageProvider 属性只支持 AssetImage 和 NetworkImage
/// 但这两种都无法预览本地的图片，后面自己写一个预览本地图片的
class LocalPhotoView extends StatefulWidget {
  final List<Asset> imageList;
  final int index;

  LocalPhotoView({this.imageList, this.index = 0});

  @override
  _LocalPhotoViewState createState() => _LocalPhotoViewState();
}

class _LocalPhotoViewState extends State<LocalPhotoView> {
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
                imageProvider: NetworkImage(widget.imageList[index].name),
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
              style: TextStyle(color: Colors.white, fontSize: Adapt.px(35)),
            ),
          ),
        ],
      ),
      onTap: () => Navigator.of(context).pop(),
      onLongPress: () {
//        var item = widget.imageList[curIndex];
      },
    );
  }

  void _onPageChanged(int index) {
    curIndex = index;
    setState(() {});
  }
}
