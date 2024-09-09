/*
 * @Author: your name
 * @Date: 2021-07-05 16:14:31
 * @LastEditTime: 2022-08-29 15:42:26
 * @LastEditors: kashjack kashjack@163.com
 * @Description: 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 * @FilePath: /CarBlueTooth/lib/pages/set/widget/FabaWidget.dart
 */
import 'package:flutter/material.dart';
import 'package:flutter_app/helper/config/size.dart';

typedef _Callback = void Function(int id);

class RadioBtnWrap extends StatefulWidget {
  const RadioBtnWrap(
      {Key? key,
      required this.data,
      this.currentId = 0,
      this.onlyButtonIds,
      this.checkUpdate})
      : super(key: key);

  final Map<int, String> data;
  final int currentId;
  final List<int>? onlyButtonIds;
  final _Callback? checkUpdate; //更新选择

  @override
  _RadioBtnWrapState createState() => _RadioBtnWrapState();
}

class _RadioBtnWrapState extends State<RadioBtnWrap> {
  int? _currentId;
  List<int>? _onlyButtonIds;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _currentId = widget.currentId;
    _onlyButtonIds = widget.onlyButtonIds;
    if (_onlyButtonIds == null) {
      _onlyButtonIds = [];
    }
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 20,
        runSpacing: 10,
        children: widget.data
            .map((id, text) => MapEntry(
                id,
                Container(
                  width: JKSize.instance.px * 90,
                  height: 35,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _currentId = id;
                        if (widget.checkUpdate != null) {
                          widget.checkUpdate!(_currentId!);
                        }
                      });
                    },
                    child: Text(
                      text,
                      style: TextStyle(
                        fontFamily: 'Mont',
                      ),
                    ),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.transparent),
                        shadowColor:
                            MaterialStateProperty.all(Colors.transparent),
                        side: MaterialStateProperty.all(BorderSide(
                            color: ((!_onlyButtonIds!.contains(id)) &&
                                    (_currentId == id))
                                ? Color(0xFFF01140)
                                : Color(0xFF767676)))),
                  ),
                )))
            .values
            .toList(),
      ),
    );
  }
}
