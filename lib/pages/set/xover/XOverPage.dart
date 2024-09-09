/*
 * @Author: your name
 * @Date: 2021-05-18 14:30:41
 * @LastEditTime: 2022-12-09 19:11:25
 * @LastEditors: kashjack kashjack@163.com
 * @Description: In User Settings Edit
 * @FilePath: /CarBlueTooth/lib/pages/setting/xover/XOverPage.dart
 */

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/helper/FlutterBlue/JKBluetooth.dart';
import 'package:flutter_app/helper/FlutterBlue/JKSetting.dart';
import 'package:flutter_app/helper/config/config.dart';
import 'package:flutter_app/helper/config/size.dart';
import 'package:flutter_app/pages/set/xover/XOverModel.dart';
import 'package:flutter_app/pages/set/xover/widget/LineChartView.dart';
import 'package:flutter_app/route/BasePage.dart';
import 'package:fluttertoast/fluttertoast.dart';

class XOverPage extends BaseWidget {
  BaseWidgetState<BaseWidget> getState() => _XOverPageState();
}

class _XOverPageState extends BaseWidgetState<XOverPage> {
  List<JKPoint> dataList = [JKPoint(0, 0)];

  List<String> list21 = [
    '1KHz',
    '1.6KHz',
    '2.5KHz',
    '4KHz',
    '5KHz',
    '6.3KHz',
    '8KHz',
    '10KHz',
    '12.5KHz',
    '16KHz',
  ];

  List<String> list22 = [
    S.current.FRQ_THROUGH,
    '30Hz',
    '40Hz',
    '50Hz',
    '60Hz',
    '70Hz',
    '80Hz',
    '90Hz',
    '100Hz',
    '120Hz',
    '150Hz',
    '180Hz',
    '220Hz',
    '250Hz',
    '315Hz',
    '400Hz',
    '500Hz',
  ];

  List<String> list23 = [
    S.current.FRQ_THROUGH,
    '30Hz',
    '40Hz',
    '50Hz',
    '60Hz',
    '70Hz',
    '80Hz',
    '90Hz',
    '100Hz',
    '120Hz',
    '150Hz',
    '180Hz',
    '220Hz',
    '250Hz',
    '315Hz',
    '400Hz',
    '500Hz',
  ];

  List<String> list24 = [
    S.current.FRQ_THROUGH,
    '30Hz',
    '40Hz',
    '50Hz',
    '60Hz',
    '70Hz',
    '80Hz',
    '90Hz',
    '100Hz',
    '120Hz',
    '150Hz',
    '180Hz',
    '220Hz',
    '250Hz',
  ];

  List<String> list31 = [
    '100Hz',
    '120Hz',
    '150Hz',
    '180Hz',
    '220Hz',
    '250Hz',
    '315Hz',
    '400Hz',
    '500Hz',
    '630Hz',
    '800Hz',
    '1KHz',
    '1.6KHz',
    '2.5KHz',
    '4KHz',
    '5KHz',
    '6.3KHz',
    '8KHz',
    '10KHz',
    '12.5KHz',
    S.current.FRQ_THROUGH,
  ];

  List<String> list321 = [
    S.current.FRQ_THROUGH,
    '30Hz',
    '40Hz',
    '50Hz',
    '60Hz',
    '70Hz',
    '80Hz',
    '90Hz',
    '100Hz',
    '120Hz',
    '150Hz',
    '180Hz',
    '220Hz',
    '250Hz',
    '315Hz',
    '400Hz',
    '500Hz',
  ];

  List<String> list322 = [
    '250Hz',
    '315Hz',
    '400Hz',
    '500Hz',
    '630Hz',
    '800Hz',
    '1KHz',
    '1.6KHz',
    '2.5KHz',
    '4KHz',
    '5KHz',
    '6.3KHz',
    '8KHz',
    '10KHz',
    '12.5KHz',
    S.current.FRQ_THROUGH,
  ];

  List<String> list33 = [
    '30Hz',
    '40Hz',
    '50Hz',
    '60Hz',
    '70Hz',
    '80Hz',
    '90Hz',
    '100Hz',
    '120Hz',
    '150Hz',
    '180Hz',
    '220Hz',
    '250Hz',
    S.current.FRQ_THROUGH,
  ];

  List<String> slopeList = ['-6DB', '-12DB', '-18DB', '-24DB'];
  List<String> gainList = [
    '-8DB',
    '-7DB',
    '-6DB',
    '-5DB',
    '-4DB',
    '-3DB',
    '-2DB',
    '-1DB',
    '0DB',
  ];
  List<String> phaseList = [S.current.NORMAL, S.current.REVERSE];
  int slope = 0;
  int hSlope = 0;

  initData() {
    JKBluetooth.instance.stateCallback = (value) {
      if (value == 'xover') {
        this._changeData();
      }
    };
    JKSetting.instance.getXOverInfo();
    this._changeData();
  }

  Widget buildVerticalLayout() {
    return Container(
      child: Column(
        children: [
          this.initTopView(S.current.XOver),
          Container(
            // color: Colors.red,
            child: Text(
              this._getTitle(),
              style: TextStyle(
                // fontSize: 11,
                fontFamily: 'mont',
                color: Colors.white,
              ),
            ),
          ),
          this._initChartsView(),
          Expanded(
            child: Column(
              children: this._buildListView(),
            ),
          ),
          Container(
            child: this._initResetView(),
            margin: EdgeInsets.only(bottom: max(10, JKSize.instance.bottom)),
          )
        ],
      ),
    );
  }

  Widget buildHorizontalLayout() {
    return Stack(children: [
      Column(
        children: [
          this.initTopView(S.current.XOver),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              this._initChartsView(),
              Container(
                child: Column(
                  children: [
                    Text(
                      this._getTitle(),
                      style: TextStyle(
                        color: Colors.white,
                        // fontSize: 11,
                        fontFamily: 'Mont',
                      ),
                    ),
                    Container(
                      child: Column(
                        children: this._buildListView(),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
      Container(
        alignment: Alignment.bottomCenter,
        child: this._initResetView(),
      ),
    ]);
  }

  String _getTitle() {
    if (JKSetting.instance.aisle == 1) {
      return S.current.Tweeter;
    } else if (JKSetting.instance.aisle == 2) {
      return JKSetting.instance.is2WAY
          ? (S.current.FRONT + ' ' + S.current.HPF)
          : S.current.MID_RANGE;
    } else if (JKSetting.instance.aisle == 3) {
      return JKSetting.instance.is2WAY
          ? (S.current.REAR + ' ' + S.current.HPF)
          : S.current.WOOFER;
    } else {
      return S.current.SUBWOOFER_LPF;
    }
  }

  List<Widget> _buildListView() {
    List<Widget> list = [];
    if (JKSetting.instance.aisle == 1) {
      list = JKSetting.instance.is2WAY
          ? [
              SizedBox(height: 5),
              this._buildFrqView(S.current.FRQ, 21),
              SizedBox(height: 5),
              this._buildGainView(S.current.GAIN_LEFT),
              SizedBox(height: 5),
              this._buildGainView(S.current.GAIN_RIGHT),
            ]
          : [
              SizedBox(height: 5),
              this._buildFrqView(S.current.HPF_FRQ, 31),
              SizedBox(height: 5),
              this._buildSlopeView(S.current.HPF_SLOPE, 31),
              SizedBox(height: 5),
              this._buildGainView(S.current.GAIN),
              SizedBox(height: 5),
              this._buildPhaseView(S.current.PHASE),
            ];
    } else if (JKSetting.instance.aisle == 2) {
      list = JKSetting.instance.is2WAY
          ? [
              SizedBox(height: 5),
              this._buildFrqView(S.current.F_HPF_FRQ, 22),
              SizedBox(height: 5),
              this._buildGainView(S.current.GAIN),
              SizedBox(height: 5),
              this._buildSlopeView(S.current.SLOPE, 22),
            ]
          : [
              this._buildFrqView(S.current.F__HPF_FRQ, 321),
              this._buildSlopeView(S.current.F__HPF_SLOPE, 321),
              this._buildFrqView(S.current.F__LPF_FRQ, 322),
              this._buildSlopeView(S.current.F__LPF_SLOPE, 322),
              this._buildGainView(S.current.GAIN),
              this._buildPhaseView(S.current.PHASE),
            ];
    } else if (JKSetting.instance.aisle == 3) {
      list = JKSetting.instance.is2WAY
          ? [
              SizedBox(height: 5),
              this._buildFrqView(S.current.R_HPF_FRQ, 23),
              SizedBox(height: 5),
              this._buildGainView(S.current.GAIN),
              SizedBox(height: 5),
              this._buildSlopeView(S.current.SLOPE, 23),
            ]
          : [
              SizedBox(height: 5),
              this._buildFrqView(S.current.LPF_FRQ, 33),
              SizedBox(height: 5),
              this._buildSlopeView(S.current.LPF_SLOPE, 33),
              SizedBox(height: 5),
              this._buildGainView(S.current.GAIN),
              SizedBox(height: 5),
              this._buildPhaseView(S.current.PHASE),
            ];
    } else if (JKSetting.instance.aisle == 4) {
      list = [
        this._buildFrqView(S.current.SW_LPF_FRQ, 24),
        this._buildGainView(S.current.GAIN),
        this._buildSlopeView(S.current.SLOPE, 24),
        this._buildPhaseView(S.current.SW_LPF_PHASE),
      ];
    }
    return list;
  }

  Widget _initChartsView() {
    // Fluttertoast.showToast(msg: "${this.width}");
    return Container(
      child: LineChart(
        px(365),
        px(250),
        xyColor: Color(0xFF767676),
        bgColor: Colors.transparent,
        xOffset: 10,
        showBaseline: true,
        maxYValue: 36,
        paddingLeft: 45,
        yCount: 6,
        dataList: this.dataList,
        slope: this.slope,
        hSlope: this.hSlope,
        polygonalLineColor: Color(0xFFF01140),
      ),
    );
  }

  Widget _initResetView() {
    return ElevatedButton(
      onPressed: () {
        if (JKSetting.instance.aisle == 1) {
          JKSetting.instance.reset(0x14);
        } else if (JKSetting.instance.aisle == 2) {
          JKSetting.instance.reset(0x24);
        } else if (JKSetting.instance.aisle == 3) {
          JKSetting.instance.reset(0x34);
        } else if (JKSetting.instance.aisle == 4) {
          JKSetting.instance.reset(0x44);
        }
      },
      child: Text(
        S.current.Reset,
        style: TextStyle(
          fontSize: 12,
          fontFamily: 'Mont',
          color: Colors.white,
        ),
      ),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          shadowColor: MaterialStateProperty.all(Colors.transparent),
          side: MaterialStateProperty.all(
              BorderSide(width: 1, color: Color(0xFFFFFFFF))),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.47)))),
    );
  }

  Widget _buildFrqView(String title, int type) {
    String text = '';
    if (type == 21) {
      text = this.list21[JKSetting.instance.frq21];
    } else if (type == 22) {
      text = this.list22[JKSetting.instance.frq22];
    } else if (type == 23) {
      text = this.list23[JKSetting.instance.frq23];
    } else if (type == 24) {
      text = this.list24[JKSetting.instance.frq24];
    } else if (type == 31) {
      text = this.list31[JKSetting.instance.frq31];
    } else if (type == 321) {
      text = this.list321[JKSetting.instance.frq321];
    } else if (type == 322) {
      text = this.list322[JKSetting.instance.frq322];
    } else if (type == 33) {
      text = this.list33[JKSetting.instance.frq33];
    }
    return Container(
      height: px(40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: JKSize.instance.isPortrait
                ? JKSize.instance.px * 120
                : JKSize.instance.px * 100,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontFamily: 'mont',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.remove),
            color: Colors.red,
            onPressed: () {
              if (type == 21) {
                if (JKSetting.instance.frq21 == 0) {
                  return;
                } else {
                  JKSetting.instance.frq21 -= 1;
                }
              } else if (type == 22) {
                if (JKSetting.instance.frq22 == 0) {
                  return;
                } else {
                  JKSetting.instance.frq22 -= 1;
                }
              } else if (type == 23) {
                if (JKSetting.instance.frq23 == 0) {
                  return;
                } else {
                  JKSetting.instance.frq23 -= 1;
                }
              } else if (type == 24) {
                if (JKSetting.instance.frq24 == 0) {
                  return;
                } else {
                  JKSetting.instance.frq24 -= 1;
                }
              } else if (type == 31) {
                if (JKSetting.instance.frq31 == 0) {
                  return;
                } else {
                  JKSetting.instance.frq31 -= 1;
                }
              } else if (type == 321) {
                if (JKSetting.instance.frq321 == 0) {
                  return;
                } else {
                  JKSetting.instance.frq321 -= 1;
                }
              } else if (type == 322) {
                if (JKSetting.instance.frq322 == 0 ||
                    (JKSetting.instance.frq321 - JKSetting.instance.frq322 >
                        12)) {
                  return;
                } else {
                  JKSetting.instance.frq322 -= 1;
                }
              } else if (type == 33) {
                if (JKSetting.instance.frq33 == 0) {
                  return;
                } else {
                  JKSetting.instance.frq33 -= 1;
                }
              }
              JKSetting.instance.setXOverInfo();
              this._changeData();
            },
          ),
          Container(
            alignment: Alignment.center,
            height: 15,
            width: 90,
            color: Color(0xFF767676),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 11,
                fontFamily: 'mont',
                color: Colors.white,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.add),
            color: Colors.red,
            onPressed: () {
              if (type == 21) {
                if (JKSetting.instance.frq21 == (this.list21.length - 1)) {
                  return;
                } else {
                  JKSetting.instance.frq21 += 1;
                }
              } else if (type == 22) {
                if (JKSetting.instance.frq22 == (this.list22.length - 1)) {
                  return;
                } else {
                  JKSetting.instance.frq22 += 1;
                }
              } else if (type == 23) {
                if (JKSetting.instance.frq23 == (this.list23.length - 1)) {
                  return;
                } else {
                  JKSetting.instance.frq23 += 1;
                }
              } else if (type == 24) {
                if (JKSetting.instance.frq24 == (this.list24.length - 1)) {
                  return;
                } else {
                  JKSetting.instance.frq24 += 1;
                }
              } else if (type == 31) {
                if (JKSetting.instance.frq31 == (this.list31.length - 1)) {
                  return;
                } else {
                  JKSetting.instance.frq31 += 1;
                }
              } else if (type == 321) {
                if (JKSetting.instance.frq321 == (this.list321.length - 1) ||
                    (JKSetting.instance.frq321 - JKSetting.instance.frq322 >
                        12)) {
                  return;
                } else {
                  JKSetting.instance.frq321 += 1;
                }
              } else if (type == 322) {
                if (JKSetting.instance.frq322 == (this.list322.length - 1)) {
                  return;
                } else {
                  JKSetting.instance.frq322 += 1;
                }
              } else if (type == 33) {
                if (JKSetting.instance.frq33 == (this.list33.length - 1)) {
                  return;
                } else {
                  JKSetting.instance.frq33 += 1;
                }
              }
              JKSetting.instance.setXOverInfo();
              this._changeData();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGainView(String title) {
    return Container(
      height: px(40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: JKSize.instance.isPortrait ? px(120) : px(100),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontFamily: 'Mont',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.remove),
            color: Colors.red,
            onPressed: () {
              if (title == (S.current.GAIN_RIGHT)) {
                if (JKSetting.instance.gainRight == 0) {
                  return;
                } else {
                  JKSetting.instance.gainRight -= 1;
                }
              } else {
                if (JKSetting.instance.gain == 0) {
                  return;
                } else {
                  JKSetting.instance.gain -= 1;
                }
              }
              JKSetting.instance.setXOverInfo();
              this._changeData();
            },
          ),
          Container(
            alignment: Alignment.center,
            height: 15,
            width: 90,
            color: Color(0xFF767676),
            child: Text(
              this.gainList[title == (S.current.GAIN_RIGHT)
                  ? JKSetting.instance.gainRight
                  : JKSetting.instance.gain],
              style: TextStyle(
                fontSize: 11,
                fontFamily: 'mont',
                color: Colors.white,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.add),
            color: Colors.red,
            onPressed: () {
              if (title == (S.current.GAIN_RIGHT)) {
                if (JKSetting.instance.gainRight == 8) {
                  return;
                } else {
                  JKSetting.instance.gainRight += 1;
                }
              } else {
                if (JKSetting.instance.gain == 8) {
                  return;
                } else {
                  JKSetting.instance.gain += 1;
                }
              }
              JKSetting.instance.setXOverInfo();
              this._changeData();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSlopeView(String title, int type) {
    String text;
    if (type == 321) {
      text = this.slopeList[JKSetting.instance.hSlope];
    } else {
      text = this.slopeList[JKSetting.instance.slope];
    }
    return Container(
      height: px(40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: JKSize.instance.isPortrait ? px(120) : px(100),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontFamily: 'mont',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.remove),
            color: Colors.red,
            onPressed: () {
              if (type == 321) {
                if (JKSetting.instance.hSlope == 0) {
                  return;
                } else {
                  JKSetting.instance.hSlope -= 1;
                }
              } else {
                if (JKSetting.instance.slope == 0) {
                  return;
                } else {
                  JKSetting.instance.slope -= 1;
                }
              }
              JKSetting.instance.setXOverInfo();
              this._changeData();
            },
          ),
          Container(
            alignment: Alignment.center,
            height: 15,
            width: 90,
            color: Color(0xFF767676),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 11,
                fontFamily: 'mont',
                color: Colors.white,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.add),
            color: Colors.red,
            onPressed: () {
              if (type == 321) {
                if (JKSetting.instance.hSlope == 3) {
                  return;
                } else {
                  JKSetting.instance.hSlope += 1;
                }
              } else {
                if (JKSetting.instance.slope == 3) {
                  return;
                } else {
                  JKSetting.instance.slope += 1;
                }
              }
              JKSetting.instance.setXOverInfo();
              this._changeData();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPhaseView(String title) {
    return Container(
      height: px(40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: JKSize.instance.isPortrait
                ? JKSize.instance.px * 120
                : JKSize.instance.px * 100,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontFamily: 'mont',
                color: Colors.white,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.remove),
            color: Colors.red,
            onPressed: () {
              if (JKSetting.instance.phase == 0) {
                return;
              } else {
                JKSetting.instance.phase -= 1;
              }
              JKSetting.instance.setXOverInfo();
              this._changeData();
            },
          ),
          Container(
            alignment: Alignment.center,
            height: 15,
            width: 90,
            color: Color(0xFF767676),
            child: Text(
              this.phaseList[JKSetting.instance.phase],
              style: TextStyle(
                fontSize: 11,
                color: Colors.white,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.add),
            color: Colors.red,
            onPressed: () {
              if (JKSetting.instance.phase == 1) {
                return;
              } else {
                JKSetting.instance.phase += 1;
              }
              JKSetting.instance.setXOverInfo();
              this._changeData();
            },
          ),
        ],
      ),
    );
  }

  void _changeData() {
    this.setState(() {});
    if (JKSetting.instance.aisle == 1) {
      if (JKSetting.instance.is2WAY) {
        List xList = [
          18.0,
          18.6,
          19.5,
          21.0,
          22.0,
          23.3,
          25.0,
          27.0,
          27.25,
          27.6,
        ];
        double x1 = 0;
        double y1 = 0;
        double x2 = xList[JKSetting.instance.frq21];
        double y2 = 0;
        double x3 = xList[JKSetting.instance.frq21];
        double y3 = JKSetting.instance.gain.toDouble() - 8;
        double x4 = 28.0;
        double y4 = JKSetting.instance.gain.toDouble() - 8;

        double x5 = xList[JKSetting.instance.frq21];
        double y5 = JKSetting.instance.gainRight.toDouble() - 8;
        double x6 = 28.0;
        double y6 = JKSetting.instance.gainRight.toDouble() - 8;
        if (JKSetting.instance.frq21 > 7) {
          this.dataList = [
            JKPoint(x1, y1),
            JKPoint(x2, y2),
            JKPoint(x3, y3),
            JKPoint(0, 0),
            JKPoint(x5, y5),
          ];
        } else {
          this.dataList = [
            JKPoint(x1, y1),
            JKPoint(x2, y2),
            JKPoint(x3, y3),
            JKPoint(x4, y4),
            JKPoint(x5, y5),
            JKPoint(x6, y6),
          ];
        }
      } else {
        List x2List = [
          9.0,
          9.2,
          9.5,
          9.8,
          10.2,
          10.5,
          11.15,
          12.0,
          13.0,
          14.3,
          16.0,
          18.0,
          18.6,
          19.5,
          21.0,
          22.0,
          23.3,
          25.0,
          27.0,
          27.25,
          0.0,
        ];
        double x1 = x2List[JKSetting.instance.frq31];
        double y1 = -24 + (JKSetting.instance.gain.toDouble() - 8);
        double x2 = x2List[JKSetting.instance.frq31];
        double y2 = JKSetting.instance.gain.toDouble() - 8;
        double x3 = 28;
        double y3 = JKSetting.instance.gain.toDouble() - 8;
        this.dataList = [
          JKPoint(x1, y1),
          JKPoint(x2, y2),
          JKPoint(x3, y3),
        ];
        this.slope = JKSetting.instance.slope;
      }
    } else if (JKSetting.instance.aisle == 2) {
      if (JKSetting.instance.is2WAY) {
        List x2List = [
          0.0,
          2.0,
          3.0,
          4.0,
          5.0,
          6.0,
          7.0,
          8.0,
          9.0,
          9.2,
          9.5,
          9.8,
          10.2,
          10.5,
          11.15,
          12.0,
          13.0,
        ];
        double x1 = x2List[JKSetting.instance.frq22];
        double y1 = -24 + (JKSetting.instance.gain.toDouble() - 8);
        double x2 = x2List[JKSetting.instance.frq22];
        double y2 = JKSetting.instance.gain.toDouble() - 8;
        double x3 = 28;
        double y3 = JKSetting.instance.gain.toDouble() - 8;
        this.dataList = [
          JKPoint(x1, y1),
          JKPoint(x2, y2),
          JKPoint(x3, y3),
        ];
        this.slope = JKSetting.instance.slope;
      } else {
        List x2List = [
          0.0,
          2.0,
          3.0,
          4.0,
          5.0,
          6.0,
          7.0,
          8.0,
          9.0,
          9.2,
          9.5,
          9.8,
          10.2,
          10.5,
          11.15,
          12.0,
          13.0,
        ];
        List x3List = [
          10.5,
          11.15,
          12.0,
          13.0,
          14.3,
          16.0,
          18.0,
          18.6,
          19.5,
          21.0,
          22.0,
          23.3,
          25.0,
          27.0,
          27.25,
          28.0,
        ];
        double x1 = x2List[JKSetting.instance.frq321];
        double y1 = -24 + (JKSetting.instance.gain.toDouble() - 8);
        double x2 = x2List[JKSetting.instance.frq321];
        double y2 = JKSetting.instance.gain.toDouble() - 8;
        double x3 = x3List[JKSetting.instance.frq322];
        double y3 = JKSetting.instance.gain.toDouble() - 8;
        double x4 = x3List[JKSetting.instance.frq322];
        double y4 = -24 + (JKSetting.instance.gain.toDouble() - 8);
        if (JKSetting.instance.frq322 == this.list322.length - 1) {
          y4 = JKSetting.instance.gain.toDouble() - 8;
        }
        this.dataList = [
          JKPoint(x1, y1),
          JKPoint(x2, y2),
          JKPoint(x3, y3),
          JKPoint(x4, y4),
        ];
        this.hSlope = JKSetting.instance.hSlope;
        this.slope = JKSetting.instance.slope;
      }

      // this.dataList = {x1 + 0.01: 6.01, x1: 2, x2: 2, x2 + 0.01: 6};
    } else if (JKSetting.instance.aisle == 3) {
      if (JKSetting.instance.is2WAY) {
        List x2List = [
          0.0,
          2.0,
          3.0,
          4.0,
          5.0,
          6.0,
          7.0,
          8.0,
          9.0,
          9.2,
          9.5,
          9.8,
          10.2,
          10.5,
          11.15,
          12.0,
          13.0,
        ];
        double x1 = x2List[JKSetting.instance.frq23];
        double y1 = -24 + (JKSetting.instance.gain.toDouble() - 8);
        double x2 = x2List[JKSetting.instance.frq23];
        double y2 = JKSetting.instance.gain.toDouble() - 8;
        double x3 = 28.0;
        double y3 = JKSetting.instance.gain.toDouble() - 8;
        this.dataList = [
          JKPoint(x1, y1),
          JKPoint(x2, y2),
          JKPoint(x3, y3),
        ];
        this.slope = JKSetting.instance.slope;
      } else {
        List x2List = [
          2.0,
          3.0,
          4.0,
          5.0,
          6.0,
          7.0,
          8.0,
          9.0,
          9.2,
          9.5,
          9.8,
          10.2,
          10.5,
          11.15,
          12.0,
          13.0,
        ];
        double x1 = 0;
        double y1 = JKSetting.instance.gain.toDouble() - 8;
        double x2 = x2List[JKSetting.instance.frq33];
        double y2 = JKSetting.instance.gain.toDouble() - 8;
        double x3 = x2List[JKSetting.instance.frq33];
        double y3 = -24 + (JKSetting.instance.gain.toDouble() - 8);
        if (JKSetting.instance.frq33 == this.list33.length - 1) {
          x3 = 28.0;
          y3 = JKSetting.instance.gain.toDouble() - 8;
        }
        this.dataList = [
          JKPoint(x1, y1),
          JKPoint(x2, y2),
          JKPoint(x3, y3),
        ];
        this.slope = JKSetting.instance.slope;
      }

      // this.dataList = {0: 2, x: 2, x + 0.01: 6};
    } else if (JKSetting.instance.aisle == 4) {
      List x2List = [
        0.0,
        2.0,
        3.0,
        4.0,
        5.0,
        6.0,
        7.0,
        8.0,
        9.0,
        9.2,
        9.5,
        9.8,
        10.2,
        10.5,
        11.15,
        12.0,
        13.0,
      ];
      double x1 = 0;
      double y1 = JKSetting.instance.gain.toDouble() - 8;
      double x2 = x2List[JKSetting.instance.frq24];
      double y2 = JKSetting.instance.gain.toDouble() - 8;
      double x3 = x2List[JKSetting.instance.frq24];
      double y3 = -24 + (JKSetting.instance.gain.toDouble() - 8);
      if (JKSetting.instance.frq24 == 0) {
        x2 = 28.0;
        y3 = JKSetting.instance.gain.toDouble() - 8;
      }
      this.dataList = [
        JKPoint(x1, y1),
        JKPoint(x2, y2),
        JKPoint(x3, y3),
      ];
      this.slope = JKSetting.instance.slope;
    }
    this.setState(() {});
  }
}
