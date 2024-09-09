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
import 'package:flutter_app/helper/config/text_style.dart';
import 'package:flutter_app/notifier/changeNotifier.dart';
import 'package:flutter_app/route/BasePage.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:fluttertoast/fluttertoast.dart';

class ConnectPage extends BaseWidget {
  BaseWidgetState<BaseWidget> getState() => _ConnectPageState();
}

class _ConnectPageState extends BaseWidgetState<ConnectPage> {
  List<String> sectionListTitle = [S.current.Paired_Device, S.current.Devices_Found];

  RefreshController _controller = RefreshController(initialRefresh: true);
  List<ScanResult> _deviceList = [];
  StreamSubscription? _streamSubscription;

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  buildVerticalLayout() {
    return _buildBodyLayout();
  }

  buildHorizontalLayout() {
    return _buildBodyLayout();
  }

  Widget _buildBodyLayout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildTopView(),
        _buildContentView(),
      ],
    );
  }

  Widget _buildTopView() {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildBackView(),
          _buildTitleView(),
          buildConnectView(),
        ],
      ),
    );
  }

  Widget _buildBackView() {
    return Container(
      width: 100.w,
      child: InkWell(
        onTap: () {
          Get.back();
        },
        child: Container(
          alignment: Alignment.centerLeft,
          child: Image.asset(
            JKImage.icon_back,
            height: 25.w,
            width: 25.w,
            fit: BoxFit.fitHeight,
          ),
        ),
      ),
    );
  }

  Widget _buildTitleView() {
    return Container(
      alignment: Alignment.centerLeft,
      child: Text(
        S.current.Device,
        style: styleSize_17Height_24.copyWith(
          color: Colors.white,
          fontFamily: 'Mont',
        ),
      ),
    );
  }

  Widget _buildContentView() {
    return ChangeNotifierProvider.value(
      value: ConnectNotifier.instance,
      builder: (context, child) {
        bool isConnected = context.watch<ConnectNotifier>().isConnected;
        List<int> groupLength = [(isConnected ? 1 : 0), _deviceList.length];
        List<String> sectionListTitle = [S.current.Paired_Device, S.current.Devices_Found];
        return Expanded(
          child: SmartRefresher(
            controller: _controller,
            enablePullUp: false,
            onRefresh: () {
              _controller.refreshCompleted();
              _controller.loadComplete();
              _deviceList.clear();
              _streamSubscription = JKBluetooth.instance.startScan().listen((result) {
                if (!_deviceList.contains(result)) {
                  _deviceList.add(result);
                }
                if (mounted) {
                  setState(() {});
                }
              });
            },
            child: ListView.builder(
              itemCount: 2,
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 分组标题
                    _buildGroupView(sectionListTitle[index]),
                    // 分组中的行
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: groupLength[index],
                      itemBuilder: (BuildContext context, int rowIndex) {
                        if (index == 0) {
                          return _buildItemView(JKBluetooth.instance.connectedDevice!);
                        } else {
                          return _buildItemView(_deviceList[rowIndex].device);
                        }
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildGroupView(String title) {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 15),
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

  Widget _buildItemView(BluetoothDevice device) {
    return InkWell(
      onTap: () async {
        if (ConnectNotifier.instance.isConnected) {
          // 点击断开
          EasyLoading.show(status: S.current.DisConnected + '...');
          JKBluetooth.disConnect().then((value) {
            EasyLoading.dismiss();
            Fluttertoast.showToast(msg: S.current.DisConnected);
          });
          setState(() {});
        } else {
          // 点击连接
          EasyLoading.show(status: S.current.Connect + '...');
          await JKBluetooth.connectDevice(device).catchError(
            (e, stacktrace) {
              EasyLoading.dismiss();
              Fluttertoast.showToast(msg: 'S.current.Connection_Timed_Out');
              throw Exception("$e $stacktrace");
            },
          );
          EasyLoading.dismiss();
          Fluttertoast.showToast(msg: S.current.Connected);
        }
      },
      child: Container(
        padding: EdgeInsets.only(top: 15, bottom: 15, left: 30, right: 20),
        child: Text(
          device.platformName,
          style: TextStyle(
            fontFamily: 'Mont',
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
