import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_app/helper/config/size.dart';

class SpeakView extends StatefulWidget {
  const SpeakView({Key? key, this.centerDx = 0, this.centerDy = 0})
      : super(key: key);

  final double centerDx;
  final double centerDy;

  @override
  SpeakViewState createState() =>
      SpeakViewState(centerDx: centerDx, centerDy: centerDy);
}

class SpeakViewState extends State<SpeakView> {
  SpeakViewState({this.centerDx = 0, this.centerDy = 0});

  double centerDx;
  double centerDy;

  reloadCenter(Offset offset) {
    setState(() {
      centerDx = offset.dx;
      centerDy = offset.dy;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: JKSize.instance.px * 10,
          vertical: JKSize.instance.px * 40),
      child: Container(
        width: JKSize.instance.px * 260,
        height: JKSize.instance.px * 300,
        child: CustomPaint(
          painter: _SpeakPainter(centerDx: centerDx, centerDy: centerDy),
        ),
      ),
    );
  }
}

class _SpeakPainter extends CustomPainter {
  _SpeakPainter({this.centerDx = 0, this.centerDy = 0});

  double centerDx;
  double centerDy;

  @override
  void paint(Canvas canvas, Size size) {
    double centerX = size.width / 2 + centerDx;
    double centerY = size.height / 2 + centerDy;
    var paint = Paint()
      ..isAntiAlias = true
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    //中间点与原点连线与y轴相交的角度
    double angle0 = atan(size.width / size.height);
    //第一个弧角度的1/2
    double angle1 = pi / 2 - 5 * angle0 / 4;
    //第一个弧半径
    double r1 = JKSize.instance.px * 40;
    //第一个弧长
    double l1 = 2 * angle1 * r1;

    //左上区域最大半径
    double leftTopLine = sqrt(pow(centerX, 2) + pow(centerY, 2));
    //间距15
    double leftTopSum = (leftTopLine - r1) / (JKSize.instance.px * 15);
    //左上区域
    for (int i = 0; i < leftTopSum; i++) {
      double r = r1 + JKSize.instance.px * 15.0 * i;
      double l = l1 * (leftTopSum - i) / leftTopSum;
      Rect rect1 = Rect.fromCircle(center: Offset(centerX, centerY), radius: r);
      double sweepAngle = -l / r;
      double startAngle1 = 3 * pi / 2 - atan(centerX / centerY) + l / 2 / r;
      canvas.drawArc(rect1, startAngle1, sweepAngle, false, paint);
    }
    //左下区域最大半径
    double leftBottomLine =
        sqrt(pow(centerX, 2) + pow((size.height - centerY), 2));
    //间距15
    double leftBottomSum = (leftBottomLine - r1) / (JKSize.instance.px * 15);
    //左下区域
    for (int i = 0; i < leftBottomSum; i++) {
      double r = r1 + JKSize.instance.px * 15.0 * i;
      double l = l1 * (leftBottomSum - i) / leftBottomSum;
      Rect rect1 = Rect.fromCircle(center: Offset(centerX, centerY), radius: r);
      double sweepAngle = l / r;
      double startAngle1 =
          pi / 2 + atan(centerX / (size.height - centerY)) - l / 2 / r;
      canvas.drawArc(rect1, startAngle1, sweepAngle, false, paint);
    }
    //右上区域最大半径
    double rightTopLine = sqrt(pow(size.width - centerX, 2) + pow(centerY, 2));
    //间距15
    double rightTopSum = (rightTopLine - r1) / (JKSize.instance.px * 15);
    //右上区域
    for (int i = 0; i < rightTopSum; i++) {
      double r = r1 + JKSize.instance.px * 15.0 * i;
      double l = l1 * (rightTopSum - i) / rightTopSum;
      Rect rect1 = Rect.fromCircle(center: Offset(centerX, centerY), radius: r);
      double sweepAngle = l / r;
      double startAngle1 =
          3 * pi / 2 + atan((size.width - centerX) / centerY) - l / 2 / r;
      canvas.drawArc(rect1, startAngle1, sweepAngle, false, paint);
    }
    //右下区域最大半径
    double rightBottomLine =
        sqrt(pow(size.width - centerX, 2) + pow((size.height - centerY), 2));
    //间距15
    double rightBottomSum = (rightBottomLine - r1) / (JKSize.instance.px * 15);
    //右下区域
    for (int i = 0; i < rightBottomSum; i++) {
      double r = r1 + JKSize.instance.px * 15.0 * i;
      double l = l1 * (rightBottomSum - i) / rightBottomSum;
      Rect rect1 = Rect.fromCircle(center: Offset(centerX, centerY), radius: r);
      double sweepAngle = -l / r;
      double startAngle1 = pi / 2 -
          atan((size.width - centerX) / (size.height - centerY)) +
          l / 2 / r;
      canvas.drawArc(rect1, startAngle1, sweepAngle, false, paint);
    }
  }

  @override
  bool shouldRepaint(_SpeakPainter oldDelegate) {
    return (oldDelegate.centerDx != centerDx) ||
        (oldDelegate.centerDy != centerDy);
  }
}
