import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/util/adapt.dart';
import 'package:yiapp/widget/cus_time_picker/picker_main.dart';
import '../cus_complex.dart';
import 'picker_fn.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/29 16:51
// usage ：单列日期选择器模板
// ------------------------------------------------------

class PickerTemplate extends StatelessWidget {
  final PickerView pickView;
  final ScrollController scrollCtrl;
  final int flex;
  FnSelectStr fnSelectStr;
  ValueChanged<int> onScrolling;
  ValueChanged<int> onScrollEnd;
  ValueKey valueKey;

  PickerTemplate(
      {this.pickView,
      this.scrollCtrl,
      this.flex: 1,
      this.fnSelectStr,
      this.onScrolling,
      this.onScrollEnd,
      this.valueKey,
      Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: CusBehavior(),
      child: Expanded(
        flex: flex,
        child: Container(
          padding: EdgeInsets.all(6),
          height: pickView.itemHeight * (pickView.itemCount + 1),
          child: NotificationListener(
            onNotification: (ScrollNotification notification) {
              bool b = notification.depth == 0 &&
                  onScrollEnd != null &&
                  notification is ScrollEndNotification &&
                  notification.metrics is FixedExtentMetrics;
              if (b) {
                final FixedExtentMetrics metrics = notification.metrics;
                final int curItemIndex = metrics.itemIndex;
                onScrollEnd(curItemIndex);
              }
              return false;
            },
            child: CupertinoPicker.builder(
              key: key,
              backgroundColor: pickView.backgroundColor,
              scrollController: scrollCtrl,
              itemExtent: pickView.itemHeight,
              onSelectedItemChanged: (int index) => onScrolling(index),
              useMagnifier: true,
              magnification: pickView.factor,
              squeeze: pickView.squeeze,
              offAxisFraction: pickView.offset,
              itemBuilder: (BuildContext context, int index) {
                final String content = fnSelectStr(index);
                if (content == null) return null;
                return Container(
                  alignment: Alignment.center,
                  child: Text(
                    content,
                    style: TextStyle(
                        fontSize: Adapt.px(28), color: pickView.color),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
