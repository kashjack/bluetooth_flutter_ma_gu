/*
 * @Descripttion:
 * @version:
 * @Author: kashjack
 * @Date: 2021-01-04 18:40:19
 * @LastEditors: kashjack kashjack@163.com
 * @LastEditTime: 2022-08-30 22:39:06
 */

import 'package:flutter/material.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/helper/FlutterBlue/JKBluetooth.dart';
import 'package:flutter_app/helper/FlutterBlue/JKSetting.dart';
import 'package:flutter_app/helper/config/config.dart';
import 'package:flutter_app/helper/config/image.dart';
import 'package:flutter_app/helper/config/size.dart';
import 'package:flutter_app/pages/rgb/widget/ColorPickView.dart';
import 'package:flutter_app/route/BasePage.dart';

class RGBPage extends BaseWidget {
  BaseWidgetState<BaseWidget> getState() => _RGBPageState();
}

class _RGBPageState extends BaseWidgetState<RGBPage> {
  int redValue = 10;
  int blueValue = 20;
  int greenValue = 30;
  bool isAuto = true;

  Widget buildVerticalLayout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        this.initTopView(S.current.RGB),
        this.initColorView(),
        this.initSlideView(),
        this.initColorBtnRow(),
        this.initSwitchRow(),
      ],
    );
  }

  Widget buildHorizontalLayout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        this.initTopView(S.current.RGB),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            this.initColorView(),
            Expanded(
              child: Container(
                height: JKSize.instance.height - px(120),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    this.initSlideView(),
                    this.initColorBtnRow(),
                    this.initSwitchRow(),
                  ],
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  initData() {
    JKBluetooth.instance.stateCallback = (value) {
      if (value == "rgb") {
        Color nowColor = JKSetting.instance.currentRGB;
        redValue = nowColor.red;
        blueValue = nowColor.blue;
        greenValue = nowColor.green;
        isAuto = JKSetting.instance.isAuto;
      }
      this.setState(() {});
    };
    JKSetting.instance.getRGB();
  }

  Widget initColorView() {
    return Container(
      margin: EdgeInsets.only(left: isPortrait ? 0 : px(20)),
      child: ColorPickView(
        size: Size(px(300), px(300)),
        selectRadius: px(30),
        selectColor:
            Color.fromRGBO(this.redValue, this.greenValue, this.blueValue, 1),
        selectColorCallBack: (color) {
          if (isAuto) {
            return;
          }
          printLog(color);
          setState(() {
            this.redValue = color.red;
            this.greenValue = color.green;
            this.blueValue = color.blue;
            JKSetting.instance.currentRGB =
                Color.fromARGB(0xFF, redValue, greenValue, blueValue);
            JKSetting.instance.currentRgbIndex = 0;
            JKSetting.instance.setRGB();
          });
        },
      ),
    );
  }

  Widget initSlideView() {
    return Container(
      margin:
          EdgeInsets.only(left: 50 * this.px, right: 50 * this.px, bottom: 10),
      child: Column(
        children: [
          this.initSlide('R'),
          this.initSlide('G'),
          this.initSlide('B'),
        ],
      ),
    );
  }

  Widget initSlide(colorType) {
    int value = 0;
    Color color = Colors.red;
    if (colorType == 'R') {
      value = this.redValue;
      color = Colors.red;
    } else if (colorType == 'G') {
      value = this.greenValue;
      color = Colors.green;
    } else if (colorType == 'B') {
      value = this.blueValue;
      color = Colors.blue;
    }
    return Container(
      height: 40,
      child: Row(
        children: [
          Container(
            width: 25,
            child: Text(
              colorType,
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Mont',
                  fontStyle: FontStyle.italic,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 3,
                thumbColor: color,
                activeTrackColor: Colors.white,
                inactiveTrackColor: Color(0xff666666),
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5),
                overlayShape: SliderComponentShape.noOverlay,
              ),
              child: Slider(
                value: value.toDouble(),
                min: 0,
                max: 255,
                onChanged: (value) {
                  if (isAuto) {
                    return;
                  }
                  setState(() {
                    if (colorType == 'R') {
                      this.redValue = value.toInt();
                    } else if (colorType == 'G') {
                      this.greenValue = value.toInt();
                    } else if (colorType == 'B') {
                      this.blueValue = value.toInt();
                    }
                    JKSetting.instance.currentRGB =
                        Color.fromARGB(0xFF, redValue, greenValue, blueValue);
                    JKSetting.instance.currentRgbIndex = 0;
                    JKSetting.instance.setRGB();
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget initColorBtnRow() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: JKSetting.instance.autoRGBList
            .asMap()
            .map((index, color) =>
                MapEntry(index, this.initColorBtn(index, color)))
            .values
            .toList(),
      ),
    );
  }

  Widget initColorBtn(int index, color) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(13 * this.px),
      ),
      height: 26 * this.px,
      width: 26 * this.px,
      child: TextButton(
        child: Container(),
        onPressed: () {
          if (isAuto) {
            return;
          }
          this.setState(() {
            this.redValue = color.red;
            this.greenValue = color.green;
            this.blueValue = color.blue;
            JKSetting.instance.currentRgbIndex = index + 1;
            JKSetting.instance.currentRGB =
                Color.fromARGB(0xFF, redValue, greenValue, blueValue);
            JKSetting.instance.setRGB();
          });
        },
      ),
    );
  }

  Widget initSwitchRow() {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            S.current.Manual,
            style: TextStyle(
              color: isAuto ? Colors.white : Color(0xFFF01140),
              fontFamily: 'Mont',
              fontSize: 15,
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 30,
                width: 57,
                margin: EdgeInsets.only(left: 20, right: 20),
                // padding: EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(20)),
              ),
              Container(
                width: 65,
                child: Switch(
                  value: isAuto,
                  activeColor: Colors.red,
                  activeTrackColor: Colors.transparent,
                  inactiveThumbColor: Colors.red,
                  inactiveTrackColor: Colors.transparent,
                  onChanged: (bool value) {
                    this.setState(() {
                      isAuto = value;
                      JKSetting.instance.isAuto = value;
                      JKSetting.instance.setRGB();
                    });
                  },
                ),
              ),
            ],
          ),
          Text(
            S.current.Auto,
            style: TextStyle(
              color: isAuto ? Color(0xFFF01140) : Colors.white,
              fontFamily: 'Mont',
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    JKBluetooth.instance.stateCallback = null;
  }
}
