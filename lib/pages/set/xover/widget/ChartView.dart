/*
 * @Author: your name
 * @Date: 2021-05-18 15:00:53
 * @LastEditTime: 2022-08-29 15:35:10
 * @LastEditors: kashjack kashjack@163.com
 * @Description: In User Settings Edit
 * @FilePath: /CarBlueTooth/lib/pages/setting/xover/ChartView.dart
 */

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_app/helper/FlutterBlue/JKSetting.dart';
import 'package:flutter_app/helper/config/config.dart';
import 'package:flutter_app/helper/config/size.dart';
import 'package:flutter_app/pages/set/xover/XOverModel.dart';

/// 自定义折线图
/// 作者:kashjack
///

class LineChartWidget extends CustomPainter {
  //折线图的背景颜色
  Color bgColor;
  //x轴与y轴的颜色
  Color xyColor;
  //是否显示x轴与y轴的基准线
  bool showBaseline;
  //实际的数据
  List<JKPoint> dataList;
  //x轴之间的间隔
  double columnSpace;
  //表格距离左边的距离
  int paddingLeft;
  //表格距离顶部的距离
  int paddingTop;
  //表格距离底部的距离
  int paddingBottom;
  //绘制x轴、y轴、标记文字的画笔
  Paint linePaint = Paint();
  //标记线的长度
  int markLineLength;
  //y轴数据最大值
  int maxYValue;
  //y轴分多少行
  int yCount;
  //折线的颜色
  Color polygonalLineColor;
  //x轴所有内容的偏移量，用来在滑动的时候改变内容的位置
  double xOffset;
  //该值保证最后一条数据的底部文字能正常显示出来
  int paddingRight = 30;
  //内部折线图的实际宽度
  double realChartRectWidth = 0;
  //斜率
  int slope = 0;
  int hSlope = 0;

  List<XOverModel> xLineList = [
    XOverModel("", 0),
    //
    XOverModel("20Hz", px(22)),
    XOverModel("", px(15)),
    XOverModel("", px(12)),
    XOverModel("50Hz", px(11)),
    XOverModel("", px(10)),
    XOverModel("", px(8)),
    XOverModel("", px(7)),
    XOverModel("100Hz", px(6)),
    XOverModel("", px(4)),
    //
    XOverModel("200Hz", px(22)),
    XOverModel("", px(15)),
    XOverModel("", px(12)),
    XOverModel("500Hz", px(11)),
    XOverModel("", px(10)),
    XOverModel("", px(8)),
    XOverModel("", px(7)),
    XOverModel("", px(6)),
    XOverModel("1kHz", px(4)),
    //
    XOverModel("2kHz", px(22)),
    XOverModel("", px(15)),
    XOverModel("", px(12)),
    XOverModel("5kHz", px(11)),
    XOverModel("", px(10)),
    XOverModel("", px(8)),
    XOverModel("", px(7)),
    XOverModel("10kHz", px(6)),
    XOverModel("", px(4)),
    //
    XOverModel("20kHz", px(22)),
  ];

  List<double> xPointList = [];
  List<double> yPointList = [];

  LineChartWidget({
    required this.dataList,
    required this.maxYValue,
    required this.yCount,
    this.bgColor = Colors.white,
    this.xyColor = Colors.black,
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
  }) {
    linePaint = Paint()
      ..color = xyColor
      ..strokeWidth = 1.5;
    realChartRectWidth = (dataList.length - 1) * columnSpace;
  }

  @override
  void paint(Canvas canvas, Size size) {
    //画背景颜色
    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height), Paint()..color = bgColor);
    //创建一个矩形，方便后续绘制
    Rect innerRect = Rect.fromPoints(
      Offset(paddingLeft.toDouble(), paddingTop.toDouble()),
      Offset(size.width, size.height - paddingBottom),
    );
    //画y轴标记
    double ySpace = innerRect.height / yCount;
    double startY;
    this.yPointList = [];
    this.xPointList = [];
    for (int i = 0; i < yCount + 1; i++) {
      startY = innerRect.topLeft.dy + i * ySpace;
      this.yPointList.add(startY);

      // 画X轴平行线
      canvas.drawLine(
        Offset(innerRect.topLeft.dx - markLineLength + 10, startY),
        Offset(innerRect.topLeft.dx + innerRect.width - 10, startY),
        linePaint,
      );
      drawYText(
        (i * maxYValue ~/ yCount - 24).toString(),
        Offset(innerRect.topLeft.dx - markLineLength,
            innerRect.bottomLeft.dy - i * ySpace),
        canvas,
      );
    }
    //画x轴标记
    double startX = innerRect.bottomLeft.dx;
    startY = innerRect.bottom + markLineLength;
    for (int i = 0; i < this.xLineList.length; i++) {
      startX += this.xLineList[i].db;
      if (innerRect.bottomLeft.dx + xOffset < innerRect.left) {
        canvas.save();
        canvas.clipRect(
          Rect.fromLTWH(
            innerRect.left,
            innerRect.top,
            innerRect.width,
            innerRect.height,
          ),
        );
      }

      // 画Y轴平行线
      canvas.drawLine(
        Offset(startX, innerRect.top),
        Offset(startX, startY - 10),
        linePaint,
      );
      if (innerRect.bottomLeft.dx + xOffset < innerRect.left) {
        canvas.restore();
      }
      drawXText(
        this.xLineList[i].hz,
        Offset(startX, startY),
        canvas,
      );
      this.xPointList.add(startX);
    }

    //保存每个实际数据的值在屏幕中的x、y坐标值
    List<Pair<double, double>> pointList = [];
    List<Pair<double, double>> pointList2 = [];
    for (int index = 0; index < this.dataList.length; index++) {
      JKPoint point = this.dataList[index];
      double xUnit =
          this.xPointList[point.x.ceil()] - this.xPointList[point.x.truncate()];
      double yUnit = (yPointList[1] - yPointList[0]) / 6;
      double x = this.xPointList[point.x.toInt()] +
          (point.x - point.x.truncate()) * xUnit;
      double y = yPointList.first + (12 - point.y) * yUnit;
      if (JKSetting.instance.aisle == 1) {
        if (JKSetting.instance.is2WAY) {
          switch (index) {
            case 0:
            case 1:
              pointList.add(Pair(x, y));
              pointList2.add(Pair(x, y));
              break;
            case 2:
              pointList.add(Pair(x + px(20), y));
              break;
            case 3:
              if (!(point.x == 0 && point.y == 0)) {
                pointList.add(Pair(x, y));
              }
              break;
            case 4:
              pointList2.add(Pair(x + px(20), y));
              break;
            case 5:
              pointList2.add(Pair(x, y));
              break;
            default:
          }
        } else {
          if (index == 0) {
            if (this.slope == 0) {
              x = x - px(60);
            } else if (this.slope == 1) {
              x = x - px(30);
            } else if (this.slope == 2) {
              x = x - px(20);
            } else if (this.slope == 3) {
              x = x - px(15);
            }
          }
        }
      } else if (JKSetting.instance.aisle == 2) {
        if (JKSetting.instance.is2WAY) {
          if (index == 0) {
            if (this.slope == 0) {
              x = x - px(60);
            } else if (this.slope == 1) {
              x = x - px(30);
            } else if (this.slope == 2) {
              x = x - px(20);
            } else if (this.slope == 3) {
              x = x - px(15);
            }
          }
        } else {
          // 32
          if (index == 0) {
            switch (this.hSlope) {
              case 0:
                x = x - px(60);
                break;
              case 1:
                x = x - px(30);
                break;
              case 2:
                x = x - px(20);
                break;
              case 3:
                x = x - px(15);
                break;
              default:
            }
          } else if (index == 3) {
            switch (this.slope) {
              case 0:
                x = x + px(60);
                break;
              case 1:
                x = x + px(30);
                break;
              case 2:
                x = x + px(20);
                break;
              case 3:
                x = x + px(15);
                break;
              default:
            }
          }
        }
      } else if (JKSetting.instance.aisle == 3) {
        if (JKSetting.instance.is2WAY) {
          if (index == 0) {
            if (this.slope == 0) {
              x = x - px(60);
            } else if (this.slope == 1) {
              x = x - px(30);
            } else if (this.slope == 2) {
              x = x - px(20);
            } else if (this.slope == 3) {
              x = x - px(15);
            }
          }
        } else {
          if (index == 2) {
            if (this.slope == 0) {
              x = x + px(60);
            } else if (this.slope == 1) {
              x = x + px(30);
            } else if (this.slope == 2) {
              x = x + px(20);
            } else if (this.slope == 3) {
              x = x + px(15);
            }
          }
        }
      } else {
        if (index == 2) {
          if (this.slope == 0) {
            x = x + px(60);
          } else if (this.slope == 1) {
            x = x + px(30);
          } else if (this.slope == 2) {
            x = x + px(20);
          } else if (this.slope == 3) {
            x = x + px(15);
          }
        }
      }
      if (JKSetting.instance.is2WAY && JKSetting.instance.aisle == 1) {
        continue;
      }
      pointList.add(Pair(x, y));
    }
    // 画折线
    canvas.save();
    canvas.clipRect(
      Rect.fromLTWH(
        paddingLeft.toDouble(),
        paddingTop.toDouble(),
        innerRect.width,
        innerRect.height,
      ),
    );
    canvas.drawPoints(
      ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
      PointMode.polygon,
      pointList.map((pair) => Offset(pair.first, pair.last)).toList(),
      Paint()
        ..color = polygonalLineColor
        ..strokeWidth = 2,
    );
    canvas.drawPoints(
      ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
      PointMode.polygon,
      pointList2.map((pair) => Offset(pair.first, pair.last)).toList(),
      Paint()
        ..color = polygonalLineColor
        ..strokeWidth = 2,
    );
    canvas.restore();
  }

  List getTextPainterAndSize(String text, double fontSize) {
    TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontFamily: 'Mont',
        ),
      ),
    );
    textPainter.layout();
    Size size = textPainter.size;
    return [textPainter, size];
  }

  void drawYText(String text, Offset topLeftOffset, Canvas canvas) {
    List list = getTextPainterAndSize(text + 'DB', 12);
    list[0].paint(
        canvas, topLeftOffset.translate(-list[1].width, -list[1].height / 2));
  }

  void drawXText(String text, Offset topLeftOffset, Canvas canvas) {
    List list = getTextPainterAndSize(text, 8);
    list[0].paint(canvas, topLeftOffset.translate(-list[1].width / 2, 0));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}

class Pair<E, F> {
  E first;
  F last;

  Pair(this.first, this.last);

  String toString() => '($first, $last)';

  bool operator ==(other) {
    if (other is! Pair) return false;
    return other.first == first && other.last == last;
  }

  int get hashCode => first.hashCode ^ last.hashCode;
}
