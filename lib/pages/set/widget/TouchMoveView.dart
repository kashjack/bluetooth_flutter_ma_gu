/*
 * @Author: your name
 * @Date: 2021-05-19 11:29:09
 * @LastEditTime: 2022-08-29 15:47:33
 * @LastEditors: kashjack kashjack@163.com
 * @Description: In User Settings Edit
 * @FilePath: /CarBlueTooth/lib/pages/setting/faba/TouchMoveView.dart
 */

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app/helper/config/size.dart';

import 'SpeakView.dart';

typedef _Callback = void Function(
    int xOffsetRatio, int yOffsetRatio, Offset offset);

class TouchMoveView extends StatefulWidget {
  final _Callback? touchMoveCallback;
  final int xProgressCount; //x等分数
  final int yProgressCount; //y等分数
  final GlobalKey<SpeakViewState>? speakViewKey;

  const TouchMoveView(
      {Key? key,
      this.touchMoveCallback,
      this.xProgressCount = 0,
      this.yProgressCount = 0,
      this.speakViewKey})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TouchMoveState();
  }
}

class TouchMoveState extends State<TouchMoveView> {
  TouchMovePainter painter = TouchMovePainter();

  //静止状态下的offset
  Offset idleOffset = Offset(0, 0);

  //本次移动的offset
  Offset moveOffset = Offset(0, 0);

  //最后一次down事件的offset
  Offset lastStartOffset = Offset(0, 0);
  double _maxOffsetWidth = JKSize.instance.px * 50;
  double _maxOffsetHeight = JKSize.instance.px * 90;
  int _xProgressCount = 0;
  int _yProgressCount = 0;

  void onlyOneOffsetChange(int offsetRatio, bool isX) {
    setState(() {
      if (isX) {
        double dx = (1 - offsetRatio / _xProgressCount) * _maxOffsetWidth -
            JKSize.instance.px * 25;
        moveOffset = Offset(dx, idleOffset.dy);
        idleOffset = moveOffset;
      } else {
        double dy = offsetRatio / _yProgressCount * _maxOffsetHeight -
            JKSize.instance.px * 45;
        moveOffset = Offset(idleOffset.dx, dy);
        idleOffset = moveOffset;
      }
      widget.speakViewKey!.currentState!.reloadCenter(idleOffset);
    });
  }

  void allOffsetChange(int offsetXRatio, int offsetYRatio) {
    setState(() {
      double dx = (1 - offsetXRatio / _xProgressCount) * _maxOffsetWidth;
      double dy = offsetYRatio / _yProgressCount * _maxOffsetHeight;
      painter = TouchMovePainter();
      moveOffset =
          Offset(dx - JKSize.instance.px * 25, dy - JKSize.instance.px * 45);
      idleOffset = moveOffset;
      widget.speakViewKey!.currentState!.reloadCenter(idleOffset);
    });
  }

  @override
  void initState() {
    painter = TouchMovePainter();
    _xProgressCount = widget.xProgressCount;
    _yProgressCount = widget.yProgressCount;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: moveOffset,
      child: Container(
        height: JKSize.instance.px * 40,
        width: JKSize.instance.px * 40,
        child: GestureDetector(
          onPanStart: (detail) {
            setState(() {
              lastStartOffset = detail.globalPosition;
              painter = TouchMovePainter();
            });
          },
          onPanUpdate: (detail) {
            setState(() {
              moveOffset = detail.globalPosition - lastStartOffset + idleOffset;
              moveOffset = Offset(
                  min(max(0, (moveOffset.dx + JKSize.instance.px * 25)),
                          _maxOffsetWidth) -
                      JKSize.instance.px * 25,
                  min(max(0, (moveOffset.dy + JKSize.instance.px * 45)),
                          _maxOffsetHeight) -
                      JKSize.instance.px * 45);
              //新需求 改成移动的时候发送
              if (widget.touchMoveCallback != null) {
                int xOffsetRatio = ((moveOffset.dx + JKSize.instance.px * 25) /
                        _maxOffsetWidth *
                        _xProgressCount)
                    .toInt();
                int yOffsetRatio = ((moveOffset.dy + JKSize.instance.px * 45) /
                        _maxOffsetHeight *
                        _yProgressCount)
                    .toInt();
                if (widget.touchMoveCallback != null) {
                  widget.touchMoveCallback!(
                      _xProgressCount - xOffsetRatio, yOffsetRatio, moveOffset);
                }
              }
            });
          },
          onPanEnd: (detail) {
            setState(() {
              painter = TouchMovePainter();
              idleOffset = moveOffset * 1;
              //新需求 改成移动的时候发送
              // if (widget.touchMoveCallback != null) {
              //   int xOffsetRatio =
              //       (idleOffset.dx / _maxOffsetWidth * _xProgressCount).toInt();
              //   int yOffsetRatio =
              //       (idleOffset.dy / _maxOffsetHeight * _yProgressCount)
              //           .toInt();
              //   widget.touchMoveCallback
              //       .call(_xProgressCount - xOffsetRatio, yOffsetRatio);
              // }
            });
          },
          child: Container(
            decoration: BoxDecoration(
                color: Color(0xFFF01140),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: Colors.red,
                      blurRadius: 20.0, //阴影模糊程度
                      spreadRadius: 10.0 //阴影扩散程度
                      )
                ]),
            child: CustomPaint(
              painter: painter,
            ),
          ),
        ),
      ),
    );
  }
}

class TouchMovePainter extends CustomPainter {
  var painter = Paint();
  var painterColor = Color(0xFFF01140);

  @override
  void paint(Canvas canvas, Size size) {
    painter.color = painterColor;
    canvas.drawCircle(Offset(size.width / 2, size.height / 2),
        min(size.height, size.width) / 2, painter);
  }

  @override
  bool shouldRepaint(TouchMovePainter oldDelegate) {
    return oldDelegate.painterColor != painterColor;
  }
}
