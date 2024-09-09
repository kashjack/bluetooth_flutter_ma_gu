/*
 * @Author: kashjack
 * @Date: 2022-04-09 21:59:27
 * @LastEditTime: 2022-08-29 14:43:29
 * @LastEditors: kashjack kashjack@163.com
 * @Description: 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 * @FilePath: /CarBlueTooth/lib/pages/radio/widget/Swiper.dart
 */

import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_app/helper/config/image.dart';

// ignore: must_be_immutable
class Swiper extends StatefulWidget {
  List<String> images = [];
  double viewportFraction = 0;
  int initialPage = 0;
  final Function(int pageIndex)? onSwitchPageIndexCallBack;
  final Function(int pageIndex)? onTapCallBack;

  Swiper({
    required Key key,
    required this.images,
    this.initialPage = 0,
    this.viewportFraction = 0,
    this.onSwitchPageIndexCallBack,
    this.onTapCallBack,
  }) : super(key: key);

  @override
  SwiperState createState() => SwiperState();
}

class SwiperState extends State<Swiper> {
  double pageOffset = 0;
  PageController? _pageController;
  @override
  Widget build(BuildContext context) {
    return this.buildContentView();
  }

  void pageTo(int index) {
    _pageController!.jumpToPage(index);
  }

  Widget buildContentView() {
    _pageController = PageController(
      initialPage: widget.initialPage,
      viewportFraction: widget.viewportFraction,
    )..addListener(() {
        setState(() {
          pageOffset = _pageController!.page!;
        });
      });
    return PageView.builder(
      itemCount: widget.images.length,
      scrollDirection: Axis.horizontal,
      controller: _pageController,
      onPageChanged: (int index) {
        if (widget.onSwitchPageIndexCallBack != null) {
          widget.onSwitchPageIndexCallBack!(index);
        }
      },
      itemBuilder: (context, index) {
        double scale = max(widget.viewportFraction,
            (1 - (pageOffset - index).abs()) + widget.viewportFraction);
        int R =
            240 - ((240 - 42) * (1 + widget.viewportFraction - scale)).toInt();
        int G =
            17 - ((17 - 42) * (1 + widget.viewportFraction - scale)).toInt();
        int B =
            63 - ((63 - 42) * (1 + widget.viewportFraction - scale)).toInt();
        Color color = Color.fromRGBO(R, G, B, 1);
        double opacity = 1 + widget.viewportFraction - scale;
        if (index == 5) {
          return TextButton(
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.all(Colors.transparent),
            ),
            onPressed: () {
              if (widget.onTapCallBack != null) {
                widget.onTapCallBack!(index);
              }
            },
            child: scale < widget.viewportFraction + 0.2
                ? Center(
                    child: Container(
                      width: 150 * scale,
                      height: 150 * scale,
                      child: Image.asset(
                        JKImage.icon_rgb_dark,
                        fit: BoxFit.contain,
                      ),
                    ),
                  )
                : Stack(
                    children: [
                      Center(
                        child: Container(
                          width: 150 * scale,
                          height: 150 * scale,
                          child: Image.asset(
                            widget.images[index],
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                        child: Container(
                          color: Colors.black.withOpacity(opacity * 0.3),
                        ),
                      )
                    ],
                  ),
          );
        }
        return TextButton(
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.all(Colors.transparent),
          ),
          onPressed: () {
            if (widget.onTapCallBack != null) {
              widget.onTapCallBack!(index);
            }
          },
          child: Container(
            width: 150 * scale,
            height: 150 * scale,
            child: Image.asset(
              widget.images[index],
              color: color,
              fit: BoxFit.contain,
            ),
          ),
        );
      },
    );
  }
}
