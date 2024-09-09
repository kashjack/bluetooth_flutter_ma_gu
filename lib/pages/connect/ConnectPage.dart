/*
 * @Author: your name
 * @Date: 2021-06-01 17:41:47
 * @LastEditTime: 2022-11-03 22:53:00
 * @LastEditors: kashjack kashjack@163.com
 * @Description: In User Settings Edit
 * @FilePath: /CarBlueTooth/lib/pages/connect/ConnectPage.dart
 */

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/helper/FlutterBlue/JKBluetooth.dart';
import 'package:flutter_app/helper/config/config.dart';
import 'package:flutter_app/helper/config/image.dart';
import 'package:flutter_app/route/BasePage.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ConnectPage extends BaseWidget {
  BaseWidgetState<BaseWidget> getState() => _ConnectPageState();
}

class _ConnectPageState extends BaseWidgetState<ConnectPage> {
  List<String> sectionListTitle = [
    S.current.Paired_Device,
    S.current.Devices_Found
  ];
  List<ScanResult> scanResultList = [];
  EasyRefreshController _controller = EasyRefreshController();
  StreamSubscription<List<ScanResult>>? scanSubscription;

  void initData() {
    JKBluetooth.instance.initBle();
    JKBluetooth.startScan();
    scanSubscription = JKBluetooth.instance.scaning().listen((results) {
      // 扫描结果 可扫描到的所有蓝牙设备
      for (ScanResult result in results) {
        // Fluttertoast.showToast(msg: result.device.name);
        if (result.device.name.length > 0 &&
            result.device.id.toString() != result.device.name &&
            !this.scanResultList.contains(result) &&
            JKBluetooth.instance.device != result.device) {
          scanResultList.add(result);
        }
      }
      this.setState(() {});
    });
  }

  buildVerticalLayout() {
    return this._buildBodyLayout();
  }

  buildHorizontalLayout() {
    return this._buildBodyLayout();
  }

  Widget _buildBodyLayout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        this.initTitleView(),
        this.initContentView(),
      ],
    );
  }

  Widget initTitleView() {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              this.back();
            },
            child: Container(
              width: 105,
              alignment: Alignment.centerLeft,
              child: Image.asset(
                JKImage.icon_back,
                height: 25,
                width: 25,
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          Text(
            S.current.Device,
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontFamily: 'Mont',
            ),
          ),
          InkWell(
            onTap: () {
              if (JKBluetooth.isConnect()) {
                Fluttertoast.showToast(msg: S.current.Connect);
              } else {
                Fluttertoast.showToast(msg: S.current.DisConnected);
              }
            },
            child: Container(
              width: 105,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Offstage(
                    offstage: !JKBluetooth.isConnect(),
                    child: Image.asset(
                      JKImage.icon_true,
                      height: 15,
                      width: 20,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  Text(
                    S.current.Connect,
                    style: TextStyle(
                      fontFamily: 'Mont',
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget initContentView() {
    int itemCount =
        this.scanResultList.length + (JKBluetooth.isConnect() ? 3 : 2);
    return Expanded(
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: EasyRefresh(
          enableControlFinishRefresh: false,
          controller: _controller,
          onRefresh: () async {
            JKBluetooth.startScan();
            this.setState(() {
              scanResultList = [];
            });
            _controller.finishRefresh(success: true);
            _controller.finishLoad(success: true, noMore: false);
          },
          header: ClassicalHeader(
            refreshText: S.current.pull_to_scan,
            refreshReadyText: S.current.release_to_scan,
            refreshingText: S.current.scaning + '...',
            refreshedText: S.current.scaning + '...',
            textColor: Colors.white,
            showInfo: false,
          ),
          child: ListView.separated(
            itemCount: itemCount,
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(
              height: 1,
              color: Colors.grey,
            ),
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return this.initGroupView(this.sectionListTitle.first);
              }
              if (JKBluetooth.isConnect()) {
                // 连上蓝牙
                if (index == 1) {
                  return this.initRowView(JKBluetooth.instance.device!);
                } else if (index == 2) {
                  return this.initGroupView(this.sectionListTitle.last);
                }
                return this.initRowView(this.scanResultList[index - 3].device);
              } else {
                // 未连蓝牙
                if (index == 1) {
                  return this.initGroupView(this.sectionListTitle.last);
                }
                return this.initRowView(this.scanResultList[index - 2].device);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget initGroupView(String title) {
    return Container(
      height: 50,
      margin: EdgeInsets.only(left: 15),
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          fontFamily: 'Mont',
          color: Colors.white60,
          fontSize: 20,
        ),
      ),
    );
  }

  Widget initRowView(BluetoothDevice device) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.only(top: 15, bottom: 15, left: 30, right: 20),
        child: Text(
          device.name,
          style: TextStyle(
            fontFamily: 'Mont',
            color: Colors.white,
          ),
        ),
      ),
      onTap: () {
        bool isConnectDevice = (JKBluetooth.instance.device == device);
        if (isConnectDevice) {
          EasyLoading.show(status: S.current.DisConnected + '...');
          JKBluetooth.disConnect().then((value) {
            JKBluetooth.instance.device = null;
            EasyLoading.dismiss();
            Fluttertoast.showToast(msg: S.current.DisConnected);
            JKBluetooth.startScan();
          });
        } else {
          this.connect(device);
        }
      },
    );
  }

  void connect(BluetoothDevice device) {
    EasyLoading.show(status: S.current.Connect + '...');
    JKBluetooth.instance.connectDevice(device).then((value) {
      EasyLoading.dismiss();
      Fluttertoast.showToast(msg: S.current.Connected);
      this.setState(() {});
      List<BluetoothService> services = value;
      services.forEach((service) {
        printLog("所有服务值 --- $service");
        if (service.uuid.toString().toUpperCase().substring(4, 8) == "FFF0") {
          service.characteristics.forEach((characteristic) {
            // characteristic.uuid;
            String upString =
                characteristic.uuid.toString().toUpperCase().substring(4, 8);
            // printLog("所有特征值 --- $characteristic");
            if (upString == "FFF2") {
              JKBluetooth.instance.wCharacteristic = characteristic;
            } else if (upString == "FFF1") {
              JKBluetooth.setNoticeCharacteristic(characteristic);
            }
          });
        }
      });
    });
  }

  dataCallbackBle() async {
    await JKBluetooth.instance.rCharacteristic!.setNotifyValue(true);
    JKBluetooth.instance.rCharacteristic!.value.listen((value) {
      // do something with new value
      // print("我是蓝牙返回数据 - $value");
      if (value == null) {
        printLog("我是蓝牙返回数据 - 空！！");
        return;
      }
      List data = [];
      for (var i = 0; i < value.length; i++) {
        String dataStr = value[i].toRadixString(16);
        if (dataStr.length < 2) {
          dataStr = "0" + dataStr;
        }
        String dataEndStr = "0x" + dataStr;
        data.add(dataEndStr);
      }
      printLog("我是蓝牙返回数据 - $data");
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (scanSubscription != null) {
      scanSubscription!.cancel();
    }
    JKBluetooth.stopScan();
  }
}
