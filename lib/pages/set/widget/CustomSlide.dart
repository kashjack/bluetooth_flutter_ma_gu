/*
 * @Author: kashjack
 * @Date: 2022-04-09 21:59:27
 * @LastEditTime: 2022-08-29 15:26:31
 * @LastEditors: kashjack kashjack@163.com
 * @Description: 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 * @FilePath: /CarBlueTooth/lib/pages/radio/widget/Swiper.dart
 */

import 'package:flutter/material.dart';

class EQSlider extends StatefulWidget {
  const EQSlider({
    Key? key,
    required this.onChanged,
    this.min = 0,
    this.max = 100,
    this.progress = 30,
    this.isSliderTop = true,
  }) : super(key: key);

  final double min;
  final double max;
  final double progress;
  final ValueChanged<double> onChanged;
  final bool isSliderTop;

  @override
  EQSliderState createState() => EQSliderState();
}

class EQSliderState extends State<EQSlider> {
  double _progress = 0;

  void changeProgress(double progress) {
    setState(() {
      _progress = progress;
    });
  }

  @override
  void initState() {
    super.initState();
    _progress = widget.progress;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 0),
      child: Stack(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 40,
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 3,
                thumbColor: Color(0xFFF01140),
                activeTrackColor: Colors.white,
                inactiveTrackColor: Color(0xff666666),
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5),
                overlayShape: SliderComponentShape.noOverlay,
              ),
              child: Slider(
                value: _progress,
                min: widget.min,
                max: widget.max,
                onChanged: (value) {
                  widget.onChanged.call(value);
                  setState(() {
                    _progress = value;
                  });
                },
              ),
            ),
          ),
          Container(
            height: 12,
            padding: EdgeInsets.only(left: 5, right: 5),
            margin: widget.isSliderTop
                ? EdgeInsets.only(top: 30)
                : EdgeInsets.only(top: 0),
            child: CustomPaint(
              child: Container(),
              painter: GraduatePainter(),
            ),
          )
        ],
      ),
    );
  }
}

class GraduatePainter extends CustomPainter {
  final int lineCount; //线的数量
  final double lineWidth; //线的宽度
  final int defaultLineColor; //普通的线的颜色
  final int specialLineColor; //两边和中间线的颜色

  GraduatePainter(
      {this.lineCount = 15,
      this.lineWidth = 1.5,
      this.defaultLineColor = 0xFF767676,
      this.specialLineColor = 0xFFAB2828});

  @override
  void paint(Canvas canvas, Size size) {
    this.buildHorizontalLayout(canvas, size);
  }

  buildVerticalLayout(Canvas canvas, Size size) {
    double width = size.width;
    double height = size.height;
    //先画红线
    var paint = Paint()
      ..isAntiAlias = true
      ..color = Color(specialLineColor)
      ..style = PaintingStyle.stroke
      ..strokeWidth = lineWidth;
    int correctLineCount = lineCount;
    //线的数量必须是奇数，否则中间红线画不了
    if (correctLineCount % 2 == 0) {
      correctLineCount = correctLineCount + 1;
    }
    for (int i = 0; i < 3; i++) {
      double dx = width / 2 * i;
      canvas.drawLine(Offset(dx, 0), Offset(dx, height), paint);
    }

    //再画黑线
    paint..color = Color(defaultLineColor);
    for (int i = 0; i < correctLineCount; i++) {
      if (i == 0 ||
          (i == (correctLineCount - 1) / 2) ||
          (i == correctLineCount - 1)) {
        continue;
      }
      double dx = width / (correctLineCount - 1) * i;
      canvas.drawLine(Offset(dx, 0), Offset(dx, height), paint);
    }
  }

  buildHorizontalLayout(Canvas canvas, Size size) {
    double width = size.width;
    double height = size.height;
    //先画红线
    var paint = Paint()
      ..isAntiAlias = true
      ..color = Color(specialLineColor)
      ..style = PaintingStyle.stroke
      ..strokeWidth = lineWidth;
    int correctLineCount = lineCount;
    //线的数量必须是奇数，否则中间红线画不了
    if (correctLineCount % 2 == 0) {
      correctLineCount = correctLineCount + 1;
    }
    for (int i = 0; i < 3; i++) {
      double dx = width / 2 * i;
      canvas.drawLine(Offset(dx, 0), Offset(dx, height), paint);
    }

    //再画黑线
    paint..color = Color(defaultLineColor);
    for (int i = 0; i < correctLineCount; i++) {
      if (i == 0 ||
          (i == (correctLineCount - 1) / 2) ||
          (i == correctLineCount - 1)) {
        continue;
      }
      double dx = width / (correctLineCount - 1) * i;
      canvas.drawLine(Offset(dx, 0), Offset(dx, height), paint);
    }
  }

  @override
  bool shouldRepaint(GraduatePainter oldDelegate) {
    return false;
  }
}
