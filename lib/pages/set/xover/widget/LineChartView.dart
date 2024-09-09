/*
 * @Author: your name
 * @Date: 2021-05-18 15:10:37
 * @LastEditTime: 2022-08-29 15:35:11
 * @LastEditors: kashjack kashjack@163.com
 * @Description: In User Settings Edit
 * @FilePath: /CarBlueTooth/lib/pages/setting/xover/LineChartView.dart
 */

import 'package:flutter/material.dart';
import 'package:flutter_app/pages/set/xover/XOverModel.dart';
import 'package:flutter_app/pages/set/xover/widget/ChartView.dart';

// ignore: must_be_immutable
class LineChart extends StatefulWidget {
  final double width;
  final double height;
  //柱状图的背景颜色
  final Color bgColor;
  //x轴与y轴的颜色
  final Color xyColor;
  //柱状图的颜色
  final Color columnarColor;
  //是否显示x轴与y轴的基准线
  final bool showBaseline;
  //实际的数据
  final List<JKPoint> dataList;
  //每列之间的间隔
  final double columnSpace;
  //控件距离左边的距离
  final int paddingLeft;
  //控件距离顶部的距离
  final int paddingTop;
  //控件距离底部的距离
  final int paddingBottom;
  //标记线的长度
  final int markLineLength;
  //y轴最大值
  final int maxYValue;
  //y轴分多少行
  final int yCount;
  //折线的颜色
  final Color polygonalLineColor;
  //x轴所有内容的偏移量
  final double xOffset;

  //斜率
  int slope = 0;
  int hSlope = 0;

  LineChart(
    this.width,
    this.height, {
    required this.dataList,
    required this.maxYValue,
    required this.yCount,
    this.bgColor = Colors.white,
    this.xyColor = Colors.black,
    this.columnarColor = Colors.blue,
    this.showBaseline = false,
    this.columnSpace = 60,
    this.paddingLeft = 40,
    this.paddingTop = 30,
    this.paddingBottom = 30,
    this.markLineLength = 10,
    this.polygonalLineColor = Colors.blue,
    this.xOffset = 0,
    this.slope = 0,
    this.hSlope = 0,
  });

  @override
  _LineChartState createState() => _LineChartState();
}

class _LineChartState extends State<LineChart> {
  double xOffset = 0;

  @override
  void initState() {
    xOffset = widget.xOffset;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomPaint(
        size: Size(widget.width, widget.height),
        painter: LineChartWidget(
          bgColor: widget.bgColor,
          xyColor: widget.xyColor,
          showBaseline: widget.showBaseline,
          dataList: widget.dataList,
          maxYValue: widget.maxYValue,
          yCount: widget.yCount,
          columnSpace: widget.columnSpace,
          paddingLeft: widget.paddingLeft,
          paddingTop: widget.paddingTop,
          paddingBottom: widget.paddingBottom,
          markLineLength: widget.markLineLength,
          polygonalLineColor: widget.polygonalLineColor,
          xOffset: xOffset,
          slope: widget.slope,
          hSlope: widget.hSlope,
        ),
      ),
    );
  }
}
