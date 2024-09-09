/*
 * @Descripttion:
 * @version:
 * @Author: kashjack
 * @Date: 2021-01-04 18:40:19
 * @LastEditors: kashjack kashjack@163.com
 * @LastEditTime: 2022-08-29 16:28:23
 */
import 'package:flutter/material.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/helper/FlutterBlue/JKBluetooth.dart';
import 'package:flutter_app/helper/FlutterBlue/JKSetting.dart';
import 'package:flutter_app/helper/config/image.dart';
import 'package:flutter_app/helper/config/size.dart';
import 'package:flutter_app/pages/set/faba/FabaPage.dart';
import 'package:flutter_app/route/BasePage.dart';

class CarAuxPage extends BaseWidget {
  BaseWidgetState<BaseWidget> getState() => _CarAuxPageState();
}

class _CarAuxPageState extends BaseWidgetState<CarAuxPage> {
  List<String> topBtnList = [S.current.SUB];
  List<String> typeBtnList = [S.current.LOUD];

  Widget buildVerticalLayout() {
    return Column(
      children: [
        this.initTopView(S.current.AUX),
        this.initTopButtonView(),
        this.initTypeButtonView(),
        this.initVoiceView(),
        this.initContentView(),
        this.initMuteView(),
      ],
    );
  }

  Widget buildHorizontalLayout() {
    return Stack(children: [
      this.initHorizontalContentView(),
      Column(
        children: [
          this.initTopView(S.current.AUX),
          this.initTopButtonView(),
          this.initTypeButtonView(),
          this.initVoiceView(),
          this.initMuteView(),
        ],
      ),
    ]);
  }

  void initData() {
    JKBluetooth.instance.stateCallback = (value) {
      setState(() {});
    };
    JKSetting.instance.getVolume().then((value) {
      return JKSetting.instance.getAux();
    });
  }

  Widget initTopButtonView() {
    if (this.topBtnList.length == 2) {
      this.topBtnList.removeLast();
    }
    String eqType = JKSetting.instance.eqModes[JKSetting.instance.nowEQMode];
    this.topBtnList.add(eqType);
    return Container(
      height: 50,
      width: px(350),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: this.topBtnList.map((string) {
          return Container(
            child: TextButton(
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Colors.transparent),
              ),
              child: Text(
                string,
                style: TextStyle(
                  fontFamily: 'Mont',
                  fontSize: 14,
                  color:
                      isStateChecked(string) ? Colors.white : Color(0xff8b8b8b),
                ),
              ),
              onPressed: null,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget initTypeButtonView() {
    return Container(
      height: 50,
      width: JKSize.instance.px * 350,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: this.typeBtnList.map((string) {
          return Container(
            width: this.px * 100,
            height: 30,
            child: TextButton(
              child: Text(
                string,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xff8b8b8b),
                  fontFamily: 'Mont',
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                    width: 1,
                    color:
                        JKSetting.instance.isLoud ? Colors.red : Colors.white),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                JKSetting.instance.isLoud = !JKSetting.instance.isLoud;
                JKSetting.instance.setAux();
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget initContentView() {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        child: Container(
          height: 140,
          width: 140,
          child: Image.asset(JKImage.icon_aux),
        ),
      ),
    );
  }

  Widget initHorizontalContentView() {
    return Container(
      margin: EdgeInsets.fromLTRB(
          JKSize.instance.px * 36, JKSize.instance.px * 90, right, bottom),
      child: Container(
        height: 140,
        width: 140,
        child: Image.asset(JKImage.icon_aux),
      ),
    );
  }

  Widget initMuteView() {
    return Container(
      height: 100,
      width: this.px * 350,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 50,
            child: TextButton(
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Colors.transparent),
              ),
              child: Image.asset(
                JKSetting.instance.isAuxMute
                    ? JKImage.icon_radio_mute
                    : JKImage.icon_radio_voice,
                height: 30,
                width: 30,
                fit: BoxFit.contain,
              ),
              onPressed: () {
                JKSetting.instance.isAuxMute = !JKSetting.instance.isAuxMute;
                JKSetting.instance.setAux();
              },
            ),
          ),
          Container(
            width: 50,
            child: TextButton(
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Colors.transparent),
              ),
              child: Image.asset(
                JKImage.icon_radio_setting,
                height: 30,
                width: 30,
                fit: BoxFit.contain,
              ),
              onPressed: () {
                this.push(FabaPage());
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget initVoiceView() {
    return Container(
      height: 50,
      width: this.px * 350,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 50,
            child: TextButton(
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Colors.transparent),
              ),
              child: Image.asset(
                JKImage.icon_voice_small,
                fit: BoxFit.fill,
              ),
              onPressed: null,
            ),
          ),
          Expanded(
            child: Container(
              // color: Colors.red,
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 6,
                  thumbColor: Color(0xFFF01140),
                  activeTrackColor: Colors.white,
                  inactiveTrackColor: Color(0xff666666),
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 7),
                  overlayShape: SliderComponentShape.noOverlay,
                ),
                child: Slider(
                  value: JKSetting.instance.volume,
                  min: 0,
                  max: 62,
                  onChanged: (value) {
                    JKSetting.instance.setVolume(value.toInt());
                    this.setState(() {});
                  },
                ),
              ),
            ),
          ),
          Container(
            width: 50,
            child: TextButton(
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Colors.transparent),
              ),
              child: Image.asset(
                JKImage.icon_voice_big,
                fit: BoxFit.fill,
              ),
              onPressed: null,
            ),
          ),
        ],
      ),
    );
  }

  // ['SUB', 'EON', 'TA', 'AF']
  bool isStateChecked(String state) {
    if (state == S.current.SUB) {
      return JKSetting.instance.isSub;
    }
    switch (state) {
      case "EON":
        return JKSetting.instance.isEon;
      case "TA":
        return JKSetting.instance.isTa;
      case "AF":
        return JKSetting.instance.isAf;
    }
    return true;
  }

  @override
  void dispose() {
    JKSetting.instance.mode = 0;
    super.dispose();
  }
}
