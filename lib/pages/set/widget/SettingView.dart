/*
 * @Author: your name
 * @Date: 2021-05-16 00:08:48
 * @LastEditTime: 2022-11-17 11:59:48
 * @LastEditors: kashjack kashjack@163.com
 * @Description: In User Settings Edit
 * @FilePath: /CarBlueTooth/lib/pages/setting/alignment/settingView.dart
 */

import 'package:flutter/material.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/helper/config/config.dart';
import 'package:flutter_app/helper/config/image.dart';

// ignore: must_be_immutable
class SettingView extends StatefulWidget {
  int selIndex;
  Function(int index)? selectTypeCallBack;

  SettingView({required this.selIndex, this.selectTypeCallBack});

  @override
  State<StatefulWidget> createState() {
    return SettingState();
  }
}

class SettingState extends State<SettingView> {
  var imageArr = [
    JKImage.icon_setting_1,
    JKImage.icon_setting_2,
    JKImage.icon_setting_3,
    JKImage.icon_setting_4,
    JKImage.icon_setting_5,
  ];

  var titleArr = [
    S.current.EQ,
    S.current.FABA,
    S.current.AUDIO_SET,
    S.current.Alignment,
    S.current.Speaker,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      width: 190,
      height: 280,
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border.all(
                color: Color(0xFF9C9C9C),
                width: 5,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    this.initBtn(0),
                    this.initBtn(1),
                  ],
                ),
                this.initBtn(2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    this.initBtn(3),
                    this.initBtn(4),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget initBtn(int index) {
    return InkWell(
      onTap: () {
        if (widget.selectTypeCallBack != null) {
          widget.selectTypeCallBack!(index);
        }
      },
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          border: Border.all(
            color: widget.selIndex == index ? JKColor.main : JKColor.ff767676,
            width: 1.5,
          ),
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              this.imageArr[index],
              height: 50,
            ),
            Center(
              child: Text(
                this.titleArr[index],
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: widget.selIndex == index ? JKColor.main : Colors.white,
                  fontFamily: 'Mont',
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    // Container(
    //   height: 90,
    //   width: 90,
    //   child: TextButton(
    //     style: ButtonStyle(
    //       overlayColor: MaterialStateProperty.all(Colors.transparent),
    //       padding: MaterialStateProperty.all(EdgeInsets.all(3)),
    //     ),
    //     child: Image.asset(
    //       widget.selIndex == index ? this.selArr[index] : this.norArr[index],
    //       fit: BoxFit.fill,
    //     ),
    //     onPressed: () {
    //       if (widget.selectTypeCallBack != null) {
    //         widget.selectTypeCallBack(index);
    //       }
    //     },
    //   ),
    // );
  }
}
