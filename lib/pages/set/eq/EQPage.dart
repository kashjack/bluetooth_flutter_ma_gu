/*
 * @Author: kashjack
 * @Date: 2021-05-13 11:56:13
 * @LastEditTime: 2022-11-17 11:57:57
 * @LastEditors: kashjack kashjack@163.com
 * @Description: In User Settings Edit
 * @FilePath: /CarBlueTooth/lib/pages/setting/eq/EQPage.dart
 */
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_app/bean/EQBean.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/helper/FlutterBlue/JKBluetooth.dart';
import 'package:flutter_app/helper/FlutterBlue/JKSetting.dart';
import 'package:flutter_app/helper/config/config.dart';
import 'package:flutter_app/helper/config/image.dart';
import 'package:flutter_app/helper/config/size.dart';
import 'package:flutter_app/pages/set/alignment/AlignmentPage.dart';
import 'package:flutter_app/pages/set/audioSet/AudioSetPage.dart';
import 'package:flutter_app/pages/set/faba/FabaPage.dart';
import 'package:flutter_app/pages/set/speaker/SpeakerPage.dart';
import 'package:flutter_app/pages/set/widget/CustomSlide.dart';
import 'package:flutter_app/pages/set/widget/SettingView.dart';
import 'package:flutter_app/route/BasePage.dart';

class EQPage extends BaseWidget {
  BaseWidgetState<BaseWidget> getState() => _EQPageState();
}

class _EQPageState extends BaseWidgetState<EQPage> with TickerProviderStateMixin {
  AnimationController? controller;
  Animation<Offset>? offsetAnimation;
  Animation<double>? angleAnimation;
  StateSetter? dialogState;
  bool isShow = false;
  List<EQSlideItem> slideList = [
    EQSlideItem(
        key: GlobalKey(), id: 0, leftText: "50Hz", rightText: "0", min: -9, max: 9),
    EQSlideItem(
        key: GlobalKey(), id: 1, leftText: "62.5Hz", rightText: "0", min: -9, max: 9),
    EQSlideItem(
        key: GlobalKey(), id: 2, leftText: "80Hz", rightText: "0", min: -9, max: 9),
    EQSlideItem(
        key: GlobalKey(), id: 3, leftText: "100Hz", rightText: "0", min: -9, max: 9),
    EQSlideItem(
        key: GlobalKey(), id: 4, leftText: "125Hz", rightText: "0", min: -9, max: 9),
    EQSlideItem(
        key: GlobalKey(), id: 5, leftText: "200Hz", rightText: "0", min: -9, max: 9),
    EQSlideItem(
        key: GlobalKey(), id: 6, leftText: "250Hz", rightText: "0", min: -9, max: 9),
    EQSlideItem(
        key: GlobalKey(), id: 7, leftText: "315Hz", rightText: "0", min: -9, max: 9),
    EQSlideItem(
        key: GlobalKey(), id: 8, leftText: "400Hz", rightText: "0", min: -9, max: 9),
    EQSlideItem(
        key: GlobalKey(), id: 9, leftText: "500Hz", rightText: "0", min: -9, max: 9),
    EQSlideItem(
        key: GlobalKey(), id: 10, leftText: "630Hz", rightText: "0", min: -9, max: 9),
    EQSlideItem(
        key: GlobalKey(), id: 11, leftText: "800Hz", rightText: "0", min: -9, max: 9),
    EQSlideItem(
        key: GlobalKey(), id: 12, leftText: "1.25KHz", rightText: "0", min: -9, max: 9),
    EQSlideItem(
        key: GlobalKey(), id: 13, leftText: "2KHz", rightText: "0", min: -9, max: 9),
    EQSlideItem(
        key: GlobalKey(), id: 14, leftText: "3.15KHz", rightText: "0", min: -9, max: 9),
    EQSlideItem(
        key: GlobalKey(), id: 15, leftText: "5KHz", rightText: "0", min: -9, max: 9),
    EQSlideItem(
        key: GlobalKey(), id: 16, leftText: "6.3KHz", rightText: "0", min: -9, max: 9),
    EQSlideItem(
        key: GlobalKey(), id: 17, leftText: "10KHz", rightText: "0", min: -9, max: 9),
    EQSlideItem(
        key: GlobalKey(), id: 18, leftText: "12.5KHz", rightText: "0", min: -9, max: 9),
    EQSlideItem(
        key: GlobalKey(), id: 19, leftText: "16KHz", rightText: "0", min: -9, max: 9),
  ];

  void initData() {
    this.controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 360),
    );
    //animation第一种创建方式：
    this.offsetAnimation = Tween<Offset>(begin: Offset(270.0, 0.0), end: Offset(0.0, 0.0))
        .animate(controller!)
      ..addListener(() {
        setState(() {});
      });

    this.angleAnimation = Tween<double>(begin: 0, end: math.pi).animate(controller!)
      ..addListener(() {
        setState(() {});
      });
    JKBluetooth.instance.stateCallback = (value) {
      if (value == "eq") {
        for (var value in slideList) {
          if (value.key!.currentState != null) {
            value.key!.currentState!
                .changeProgress(JKSetting.instance.eqLongDbs[value.id].toDouble());
          }
        }
      }
      setState(() {});
      if (dialogState != null) {
        dialogState!(() {});
      }
    };
    JKSetting.instance.getEQInfo(true);
  }

  Widget buildVerticalLayout() {
    return Stack(
      children: [
        Column(
          children: [
            this.initTopView(S.current.EQ),
            this.initEQTitle(),
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return initSliderViewItem(slideList[index]);
                },
                separatorBuilder: (context, index) {
                  return Divider(
                    color: Colors.transparent,
                  );
                },
                itemCount: slideList.length,
                padding: EdgeInsets.only(top: 20),
              ),
            ),
            this.initBottomBtn()
          ],
        ),
        this._buildSettingView(),
        this._buildPopButton()
      ],
    );
  }

  Widget buildHorizontalLayout() {
    return Stack(
      children: [
        Column(
          children: [
            this.initTopView(S.current.EQ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: isPortrait ? 20 : 10),
                child: Row(
                  children: [
                    this.initHorizontalEQTitle(),
                    Container(
                      width: this.width - this.left - 50 - 50 - 20,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return this.initHorizontalSliderViewItem(slideList[index]);
                        },
                        itemCount: slideList.length,
                        separatorBuilder: (BuildContext context, int index) {
                          return Divider();
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
            initBottomBtn()
          ],
        ),
        _buildSettingView(),
        _buildPopButton()
      ],
    );
  }

  Widget _buildSettingView() {
    return Transform.translate(
      offset: Offset(this.offsetAnimation!.value.dx, this.offsetAnimation!.value.dy),
      child: Container(
        margin: EdgeInsets.only(right: 50),
        alignment: Alignment.centerRight,
        child: SettingView(
            selIndex: 0,
            selectTypeCallBack: (index) {
              this.controller!.reverse();
              this.isShow = false;
              if (index == 1) {
                this.pushReplacement(FabaPage());
              } else if (index == 2) {
                this.pushReplacement(AudioSetPage());
              } else if (index == 3) {
                this.pushReplacement(AlignmentPage());
              } else if (index == 4) {
                this.pushReplacement(SpeakerPage());
              }
            }),
      ),
    );
  }

  Widget _buildPopButton() {
    return Container(
      margin: EdgeInsets.only(right: 0),
      alignment: Alignment.centerRight,
      child: Transform.rotate(
        angle: this.angleAnimation!.value,
        child: Container(
          width: 50,
          child: TextButton(
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.all(Colors.transparent),
            ),
            child: Image.asset(
              JKImage.icon_left,
              height: 30,
              width: 30,
            ),
            onPressed: () {
              this.isShow ? this.controller!.reverse() : this.controller!.forward();
              this.isShow = !this.isShow;
            },
          ),
        ),
      ),
    );
  }

  Widget initEQTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 120,
          margin: EdgeInsets.only(top: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "-9db",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Mont',
                ),
              ),
              Text("0db",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Mont',
                  )),
              Text("9db",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Mont',
                  )),
            ],
          ),
        ),
        Container(
          width: 120,
          height: 6.2,
          margin: EdgeInsets.only(top: 2),
          child: CustomPaint(
            child: Container(),
            painter: GraduatePainter(),
          ),
        )
      ],
    );
  }

  Widget initHorizontalEQTitle() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 40,
          height: 150,
          margin: EdgeInsets.only(left: this.left + 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "-9db",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Mont',
                ),
              ),
              Text("0db",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Mont',
                  )),
              Text("9db",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Mont',
                  )),
            ],
          ),
        ),
        RotatedBox(
          quarterTurns: 3,
          child: Container(
            width: 150,
            height: 6.2,
            margin: EdgeInsets.only(top: 2),
            child: CustomPaint(
              child: Container(),
              painter: GraduatePainter(),
            ),
          ),
        )
      ],
    );
  }

  Widget initHorizontalSliderViewItem(EQSlideItem item) {
    return Container(
      width: 70,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Text(
              item.leftText,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Mont',
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            child: RotatedBox(
              quarterTurns: 3,
              child: Container(
                width: 160,
                margin: EdgeInsets.only(bottom: 20),
                child: EQSlider(
                  key: item.key,
                  min: item.min,
                  max: item.max,
                  progress: JKSetting.instance.eqLongDbs[item.id].toDouble(),
                  onChanged: (value) {
                    JKSetting.instance.eqLongDbs[item.id] = value.toInt();
                    if (JKSetting.instance.nowEQMode != 0) {
                      JKSetting.instance.nowEQMode = 0;
                    }
                    setState(() {});
                    JKSetting.instance.setEQInfo();
                  },
                ),
              ),
            ),
          ),
          Container(
            child: Text(
              "${JKSetting.instance.eqLongDbs[item.id]}",
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Mont',
              ),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }

  Widget initSliderViewItem(EQSlideItem item) {
    return Container(
      height: 40,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              item.leftText,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Mont',
              ),
              textAlign: TextAlign.center,
            ),
            flex: 4,
          ),
          Expanded(
            child: EQSlider(
              key: item.key,
              min: item.min,
              max: item.max,
              progress: JKSetting.instance.eqLongDbs[item.id].toDouble(),
              onChanged: (value) {
                JKSetting.instance.eqLongDbs[item.id] = value.toInt();
                if (JKSetting.instance.nowEQMode != 0) {
                  JKSetting.instance.nowEQMode = 0;
                }
                setState(() {});
                JKSetting.instance.setEQInfo();
              },
            ),
            flex: 5,
          ),
          Expanded(
            child: Text(
              "${JKSetting.instance.eqLongDbs[item.id]}",
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Mont',
              ),
              textAlign: TextAlign.center,
            ),
            flex: 4,
          )
        ],
      ),
    );
  }

  Widget initBottomBtn() {
    return Container(
      margin:
          EdgeInsets.only(bottom: JKSize.instance.px * 10, top: JKSize.instance.px * 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                JKSetting.instance.nowEQMode = (JKSetting.instance.nowEQMode + 1) % 5;
                JKSetting.instance.setEQMode();
              });
            },
            child: Text(
              JKSetting.instance.eqModes[JKSetting.instance.nowEQMode],
              style: TextStyle(color: Colors.white),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.transparent),
              shadowColor: MaterialStateProperty.all(Colors.transparent),
              side: MaterialStateProperty.all(
                  BorderSide(width: 1, color: Color(0xFFF11040))),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.47),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              JKSetting.instance.reset(0x01);
            },
            child: Text(
              S.current.Reset,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: 'Mont',
              ),
            ),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.transparent),
                shadowColor: MaterialStateProperty.all(Colors.transparent),
                side: MaterialStateProperty.all(
                    BorderSide(width: 1, color: Color(0xFFFFFFFF))),
                shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.47)))),
          ),
          ElevatedButton(
            onPressed: () {
              _factorAlert();
            },
            child: Text(
              S.current.Q_FACTOR,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: 'Mont',
              ),
            ),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.transparent),
                shadowColor: MaterialStateProperty.all(Colors.transparent),
                side:
                    MaterialStateProperty.all(BorderSide(width: 1, color: JKColor.main)),
                shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.47)))),
          ),
        ],
      ),
    );
  }

  _factorAlert() {
    List<Widget> a = (['Level 5']
        .map((e) => this._buildAlertButton(JKColor.ff767676, e, () {}))
        .toList());
    a.add(SizedBox(
      width: 60,
    ));
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setDialogState) {
          this.dialogState = setDialogState;
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 250,
                  height: 90,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(
                      color: Colors.white,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        S.current.Value,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontFamily: 'Mont',
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: ['2', '3', '4'].asMap().entries.map((e) {
                          if (e.key + 1 == JKSetting.instance.eqQFactor) {
                            return this._buildAlertButton(JKColor.main, e.value, () {});
                          }
                          return this._buildAlertButton(Colors.transparent, e.value, () {
                            JKSetting.instance.eqQFactor = e.key + 1;
                            JKSetting.instance.setEQQFactor();
                            setDialogState(() {});
                          });
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
      },
    ).then((value) {
      this.dialogState = null;
    });
  }

  Widget _buildAlertButton(Color color, String title, GestureTapCallback callBack) {
    double width = 50;
    return InkWell(
      onTap: callBack,
      borderRadius: BorderRadius.all(Radius.circular(10)),
      child: Container(
        height: 25,
        width: width,
        decoration: BoxDecoration(
          border: Border.all(
            color: color,
            width: 1.5,
          ),
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontFamily: 'Mont',
              ),
            )
          ],
        ),
      ),
    );
  }

  void dispose() {
    this.controller!.dispose();
    super.dispose();
  }
}
