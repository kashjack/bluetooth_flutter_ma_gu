/*
 * @Author: your name
 * @Date: 2021-05-11 16:48:01
 * @LastEditTime: 2022-08-30 22:41:14
 * @LastEditors: kashjack kashjack@163.com
 * @Description: In User Settings Edit
 * @FilePath: /CarBlueTooth/lib/pages/rgb/colorPickView.dart
 */
import 'package:flutter/material.dart';
import 'package:flutter_app/helper/config/image.dart';
import 'package:flutter_app/helper/config/size.dart';
import 'dart:math';

// ignore: must_be_immutable
class ColorPickView extends StatefulWidget {
  Size size;
  double? selectRadius;
  double? padding;
  Color selectColor;
  Color? selectRingColor;
  final Function(Color color)? selectColorCallBack;

  ColorPickView(
      {required this.size,
      this.selectColorCallBack,
      this.selectRadius,
      this.padding,
      this.selectRingColor,
      required this.selectColor}) {
    assert((size.height == size.width), '控件宽高必须相等');
  }

  @override
  State<StatefulWidget> createState() {
    return ColorPickState();
  }
}

class ColorPickState extends State<ColorPickView> {
  double radius = 0;
  Color currentColor = Color(0xff00ff);
  Offset? currentOffset;
  Offset? topLeftPosition;
  Offset? selectPosition;

  GlobalKey globalKey = new GlobalKey();
  bool isTap = false;

  @override
  Widget build(BuildContext context) {
    widget.selectRadius ??= 10;
    widget.padding ??= 20;
    widget.selectRingColor ??= Colors.black;
    // assert(
    //     widget.size == null ||
    //         (widget.size != null && screenSize.width >= widget.size.width),
    //     '控件宽度太宽');
    radius = widget.size.width / 2 - widget.padding!;
    currentOffset ??= Offset(radius, radius);
    _setColor(widget.selectColor);
    _initLeftTop();
    return GestureDetector(
      key: globalKey,
      child: Container(
        width: widget.size.width,
        height: widget.size.width,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
                padding: EdgeInsets.all(JKSize.instance.px * 18),
                child: Image.asset(JKImage.icon_rgb_bg)),
            CustomPaint(
              painter: ColorPick(radius: radius),
              size: widget.size,
            ),
            Positioned(
              left: isTap
                  ? currentOffset!.dx -
                      (topLeftPosition == null
                          ? 0
                          : (topLeftPosition!.dx + widget.selectRadius! / 2))
                  : (selectPosition == null
                      ? radius
                      : selectPosition!.dx + widget.selectRadius! / 2),
              top: isTap
                  ? currentOffset!.dy -
                      (topLeftPosition == null
                          ? 0
                          : (topLeftPosition!.dy + widget.selectRadius! / 2))
                  : (selectPosition == null
                      ? radius
                      : selectPosition!.dy + widget.selectRadius! / 2),
              //这里减去80，是因为上下边距各40 所以需要减去还有半径
              child: Container(
                width: widget.selectRadius,
                height: widget.selectRadius,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(widget.selectRadius!),
                  border: Border.fromBorderSide(
                      BorderSide(color: widget.selectRingColor!)),
                ),
                child: ClipOval(
                  child: Container(
                    color: currentColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      onTapDown: (e) {
        setState(() {
          // isTap = true;
          _initLeftTop();
          if (!isOutSide(e.globalPosition.dx, e.globalPosition.dy)) {
            currentColor =
                getColorAtPoint(e.globalPosition.dx, e.globalPosition.dy);
            currentOffset = e.globalPosition;
            if (widget.selectColorCallBack != null) {
              widget.selectColorCallBack!(currentColor);
            }
          }
        });
      },
      onPanUpdate: (e) {
        // isTap = true;
        _initLeftTop();
        setState(() {
          if (!isOutSide(e.globalPosition.dx, e.globalPosition.dy)) {
            currentOffset = e.globalPosition;
            currentColor =
                getColorAtPoint(e.globalPosition.dx, e.globalPosition.dy);
            if (widget.selectColorCallBack != null) {
              widget.selectColorCallBack!(currentColor);
            }
          }
        });
      },
    );
  }

  void _initLeftTop() {
    if (globalKey.currentContext != null && topLeftPosition == null) {
      final RenderBox box =
          globalKey.currentContext!.findRenderObject() as RenderBox;
      topLeftPosition = box.localToGlobal(Offset.zero);
    }
  }

  bool isOutSide(double eventX, double eventY) {
    double x = eventX - (topLeftPosition!.dx + radius + widget.padding!);
    double y = eventY - (topLeftPosition!.dy + radius + widget.padding!);
    double r = sqrt(x * x + y * y);
    if (r >= radius) return true;
    return false;
  }

  void _setColor(Color color) {
    //设置颜色值
    var hsvColor = HSVColor.fromColor(color);
    double r = hsvColor.saturation * radius;
    double radian = hsvColor.hue / -180.0 * pi;
    _updateSelector(r * cos(radian), -r * sin(radian));
    currentColor = color;
  }

  void _updateSelector(double eventX, double eventY) {
    //更新选中颜色值

    double r = sqrt(eventX * eventX + eventY * eventY);
    double x = eventX, y = eventY;
    if (r > radius) {
      x *= radius / r;
      y *= radius / r;
    }
    this.setState(() {
      selectPosition = Offset(
          x + radius + widget.padding! - 30, y + radius + widget.padding! - 30);
    });
  }

  Color getColorAtPoint(double eventX, double eventY) {
    //获取坐标在色盘中的颜色值
    double x = eventX - (topLeftPosition!.dx + radius + widget.padding!);
    double y = eventY - (topLeftPosition!.dy + radius + widget.padding!);
    double r = sqrt(x * x + y * y);
    List<double> hsv = [0.0, 0.0, 1.0];
    hsv[0] = (atan2(-y, -x) / pi * 180).toDouble() + 180;
    hsv[1] = max(0, min(1, (r / radius)));
    return HSVColor.fromAHSV(1.0, hsv[0], hsv[1], hsv[2]).toColor();
  }
}

class ColorPick extends CustomPainter {
  Paint mPaint = Paint();
  Paint saturationPaint = Paint();
  final List<Color> mCircleColors = [];
  final List<Color> mStatColors = [];
  SweepGradient? hueShader;
  final radius;
  RadialGradient? saturationShader;

  ColorPick({this.radius}) {
    _init();
  }

  void _init() {
    //{Color.RED, Color.YELLOW, Color.GREEN, Color.CYAN, Color.BLUE, Color.MAGENTA, Color.RED}
    mPaint = new Paint();
    saturationPaint = new Paint();
    mCircleColors.add(Color.fromARGB(255, 255, 0, 0));
    mCircleColors.add(Color.fromARGB(255, 255, 255, 0));
    mCircleColors.add(Color.fromARGB(255, 0, 255, 0));
    mCircleColors.add(Color.fromARGB(255, 0, 255, 255));
    mCircleColors.add(Color.fromARGB(255, 0, 0, 255));
    mCircleColors.add(Color.fromARGB(255, 255, 0, 255));
    mCircleColors.add(Color.fromARGB(255, 255, 0, 0));

    mStatColors.add(Color.fromARGB(255, 255, 255, 255));
    mStatColors.add(Color.fromARGB(0, 255, 255, 255));
    hueShader = SweepGradient(colors: mCircleColors);
    saturationShader = RadialGradient(colors: mStatColors);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTRB(0.0, 0.0, size.width, size.height);
    mPaint.shader = hueShader!.createShader(rect);
    saturationPaint.shader = saturationShader!.createShader(rect);
    // 注意这一句
    canvas.clipRect(rect);
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), radius, mPaint);
    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), radius, saturationPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
