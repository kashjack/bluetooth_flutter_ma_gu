/*
 * @Descripttion:
 * @version:
 * @Author: kashjack
 * @Date: 2021-01-04 18:40:19
 * @LastEditors: kashjack kashjack@163.com
 * @LastEditTime: 2022-08-29 14:41:17
 */

import 'package:flutter/material.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/helper/config/config.dart';
import 'package:flutter_app/helper/config/size.dart';
import 'package:flutter_app/route/BasePage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher_string.dart';

class GPSPage extends BaseWidget {
  BaseWidgetState<BaseWidget> getState() => _GPSPageState();
}

class _GPSPageState extends BaseWidgetState<GPSPage> {
  bool showGoogle = false;
  bool showYandex = false;
  bool showWaze = false;
  bool showGis = false;

  Map<String, String> mapUrl = {};

  Widget buildVerticalLayout() {
    return Column(
      children: [
        this.initTopView(S.current.GPS),
        SizedBox(height: 40),
        this.initHeadMessage(150 * this.px, 40 * this.px),
        SizedBox(height: 40),
        if (Platform.isIOS) this.initMapBtn('Apple Maps'),
        if (this.showGoogle) this.initMapBtn('Google Maps'),
        if (this.showYandex) this.initMapBtn('Yandex Maps'),
        if (this.showWaze) this.initMapBtn('Waze'),
        if (this.showGis) this.initMapBtn('2 Gis'),
        this.initCancelBtn(),
      ],
    );
  }

  Widget buildHorizontalLayout() {
    return Container(
      // color: Colors.red,
      child: Column(
        children: [
          this.initTopView(S.current.GPS),
          Expanded(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                this.initHeadMessage(0.0, 0.0),
                Expanded(
                  child: ListView(
                    children: [
                      if (Platform.isIOS) this.initMapBtn('Apple Maps'),
                      if (Platform.isIOS) this.initMapBtn('Apple Maps'),
                      if (Platform.isIOS) this.initMapBtn('Apple Maps'),
                      if (Platform.isIOS) this.initMapBtn('Apple Maps'),
                      if (Platform.isIOS) this.initMapBtn('Apple Maps'),
                      if (this.showGoogle) this.initMapBtn('Google Maps'),
                      if (this.showYandex) this.initMapBtn('Yandex Maps'),
                      if (this.showWaze) this.initMapBtn('Waze'),
                      if (this.showGis) this.initMapBtn('2 Gis'),
                      this.initCancelBtn(),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  initData() async {
    this.mapUrl = {
      'Apple Maps': 'maps://',
      'Google Maps': Platform.isIOS ? 'comgooglemapsurl://' : 'geo:0,0',
      'Yandex Maps': 'yandexmaps://',
      'Waze': Platform.isIOS ? 'waze://' : 'Waze',
      '2 Gis': 'dgis://'
    };
    canLaunchUrlString(this.mapUrl['Google Maps']!).then((value) => {
          this.setState(() {
            this.showGoogle = value;
          })
        });

    canLaunchUrlString('yandexmaps://').then((value) => {
          this.setState(() {
            this.showYandex = value;
          })
        });

    canLaunchUrlString(this.mapUrl['Waze']!).then((value) => {
          this.setState(() {
            this.showWaze = value;
          })
        });

    canLaunchUrlString('dgis://').then((value) => {
          this.setState(() {
            this.showGis = value;
          })
        });
  }

  Widget initHeadMessage(top, bottom) {
    return Container(
      margin: EdgeInsets.all(20),
      child: Text(
        S.current.openMap_msg,
        style: TextStyle(
          fontFamily: 'Mont',
          color: Colors.white,
          fontSize: 17,
        ),
      ),
    );
  }

  Widget initMapBtn(String text) {
    return InkWell(
      onTap: () {
        this.jumpApp(this.mapUrl[text]!, text);
      },
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          margin: EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            border: Border.all(
              color: JKColor.ff767676,
              width: 1.5,
            ),
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Mont',
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }

  Widget initCancelBtn() {
    return InkWell(
      onTap: () {
        this.back();
      },
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          margin: EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            border: Border.all(
              color: JKColor.main,
              width: 1.5,
            ),
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: Text(
            S.current.CANCEL,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Mont',
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> jumpApp(String app, String msg) async {
    if (await canLaunchUrlString(app)) {
      await launchUrlString(app);
    } else {
      Fluttertoast.showToast(msg: 'Could not launch $app');
    }
  }
}
