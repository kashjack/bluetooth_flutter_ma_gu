import 'package:flutter/material.dart';
import 'package:flutter_app/bean/RadioBean.dart';
import 'package:flutter_app/helper/config/image.dart';
import 'package:flutter_app/helper/config/size.dart';

typedef _CallBack = void Function(int value);
typedef _ControlCallBack = void Function(bool isAdd, int value);

class RadioSliderController extends StatefulWidget {
  const RadioSliderController({
    Key? key,
    this.lineHeight = 3,
    this.cursorWidth = 4,
    this.cursorHeight = 20,
    this.graduateWidth = 2,
    this.graduateHeight = 10,
    this.progress = 0,
    this.min = 0,
    this.max = 2,
    this.graduateCount = 0,
    this.addCallback,
    this.minusCallback,
    this.controlCallBack,
    this.longControlCallBack,
    this.upTips,
    this.downTips,
  }) : super(key: key);

  final double lineHeight;
  final double cursorWidth; //指针宽度
  final double cursorHeight; //指针高度
  final double graduateWidth; //刻度宽度
  final double graduateHeight; //刻度高度
  final int? progress; //进度
  final int min; //最小值
  final int max; //最大值
  final int graduateCount; //刻度数量
  final _CallBack? addCallback; //添加按钮监听
  final _CallBack? minusCallback; //减少按钮监听
  final _ControlCallBack? controlCallBack; //控制添加减少
  final _ControlCallBack? longControlCallBack; //长按控制添加减少
  final List<String>? upTips; //上面的文字提示
  final List<String>? downTips; //下面的文字提示

  @override
  RadioSliderControllerState createState() => RadioSliderControllerState();
}

class RadioSliderControllerState extends State<RadioSliderController> {
  int _progress = 0;
  RadioSliderConfig? _radioSliderConfig;
  List<String> _upTips = [];
  List<String> _downTips = [];

  reloadProgress(int progress) {
    setState(() {
      _progress = progress;
    });
  }

  @override
  void initState() {
    super.initState();
    _progress = widget.progress ?? widget.min;
    _upTips = widget.upTips ?? [];
    _downTips = widget.downTips ?? [];
    _radioSliderConfig = RadioSliderConfig(
        lineHeight: widget.lineHeight,
        cursorWidth: widget.cursorWidth,
        cursorHeight: widget.cursorHeight,
        graduateWidth: widget.graduateWidth,
        graduateHeight: widget.graduateHeight,
        min: widget.min,
        max: widget.max,
        graduateCount: widget.graduateCount);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: JKSize.instance.px * 110,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(
                  JKSize.instance.px * 60, 0, JKSize.instance.px * 60, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _upTips
                    .map((str) => Text(
                          str,
                          style: TextStyle(
                            fontFamily: 'Mont',
                            color: Colors.red,
                            fontSize: 14,
                          ),
                        ))
                    .toList(),
              ),
            ),
            Row(
              children: [
                Container(
                  width: 50,
                  child: GestureDetector(
                    onTap: () {
                      if (widget.controlCallBack != null) {
                        widget.controlCallBack!(false, _progress);
                      }
                      if (widget.minusCallback != null) {
                        setState(() {
                          _progress--;
                          if (_progress < widget.min) {
                            _progress = widget.min;
                          }
                          widget.minusCallback!(_progress);
                        });
                      }
                    },
                    onLongPressStart: (e) {
                      if (widget.longControlCallBack != null) {
                        widget.longControlCallBack!(false, 0);
                      }
                    },
                    onLongPressEnd: (e) {
                      if (widget.longControlCallBack != null) {
                        widget.longControlCallBack!(false, 1);
                      }
                    },
                    child: Container(
                      child: TextButton(
                        child: Image.asset(
                          JKImage.icon_radio_left,
                          height: 20,
                          width: 20,
                          fit: BoxFit.contain,
                        ),
                        onPressed: null,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: _RadioSlider(
                      radioSliderConfig: _radioSliderConfig!,
                      progress: _progress,
                    ),
                  ),
                ),
                Container(
                  width: 50,
                  child: GestureDetector(
                    onTap: () {
                      if (widget.controlCallBack != null) {
                        widget.controlCallBack!(true, _progress);
                      }
                      if (widget.addCallback != null) {
                        setState(() {
                          _progress++;
                          if (_progress > widget.max) {
                            _progress = widget.max;
                          }
                          widget.addCallback!(_progress);
                        });
                      }
                    },
                    onLongPressStart: (e) {
                      if (widget.longControlCallBack != null) {
                        widget.longControlCallBack!(true, 0);
                      }
                    },
                    onLongPressEnd: (e) {
                      if (widget.longControlCallBack != null) {
                        widget.longControlCallBack!(true, 1);
                      }
                    },
                    child: Container(
                      child: TextButton(
                        child: Image.asset(
                          JKImage.icon_radio_right,
                          height: 20,
                          width: 20,
                          fit: BoxFit.contain,
                        ),
                        onPressed: null,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.fromLTRB(
                  JKSize.instance.px * 60, 0, JKSize.instance.px * 60, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _downTips
                    .map((str) => Text(
                          str,
                          style: TextStyle(
                            fontFamily: 'Mont',
                            color: Colors.red,
                            fontSize: 14,
                          ),
                        ))
                    .toList(),
              ),
            ),
          ],
        ));
  }
}

class _RadioSlider extends StatelessWidget {
  const _RadioSlider(
      {Key? key, required this.radioSliderConfig, required this.progress})
      : super(key: key);

  final RadioSliderConfig radioSliderConfig;
  final int progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomPaint(
        child: Container(),
        painter: _RadioSliderPainter(
            radioSliderConfig: radioSliderConfig, progress: progress),
      ),
    );
  }
}

class _RadioSliderPainter extends CustomPainter {
  _RadioSliderPainter(
      {required this.radioSliderConfig, required this.progress});

  final RadioSliderConfig radioSliderConfig;
  final int progress;

  @override
  void paint(Canvas canvas, Size size) {
    double width = size.width;
    double height = size.height;
    //画底线
    var paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = radioSliderConfig.lineHeight
      ..color = Colors.grey[600]!;
    canvas.drawLine(Offset(0, height / 2), Offset(width, height / 2), paint);

    //画刻度
    paint..strokeWidth = radioSliderConfig.graduateWidth;
    int max = radioSliderConfig.max;
    int min = radioSliderConfig.min;
    int graduateCount = radioSliderConfig.graduateCount;
    //未规定刻度数量情况下使用max - min作为刻度数量
    if (graduateCount == 0) {
      graduateCount = max - min;
    }
    double graduateHeight = radioSliderConfig.graduateHeight;
    double cursorHeight = radioSliderConfig.cursorHeight;
    double singleGraduateWidth = width / graduateCount;
    for (int i = 1; i < graduateCount; i++) {
      double dx = singleGraduateWidth * i;
      canvas.drawLine(Offset(dx, height / 2 - graduateHeight / 2),
          Offset(dx, height / 2 + graduateHeight / 2), paint);
    }

    //画指针
    paint
      ..strokeWidth = radioSliderConfig.cursorWidth
      ..color = Color(0xFFF01140);
    double singleCursorWidth = width / max - min;
    canvas.drawLine(
        Offset(singleCursorWidth * progress, height / 2 - cursorHeight / 2),
        Offset(singleCursorWidth * progress, height / 2 + cursorHeight / 2),
        paint);
  }

  @override
  bool shouldRepaint(_RadioSliderPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
