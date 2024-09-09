import 'package:flutter/material.dart';
import 'package:flutter_app/pages/set/widget/CustomSlide.dart';

class EQSlideItem {
  GlobalKey<EQSliderState>? key;
  int id = 0;
  String leftText = '';
  String rightText = '';
  double min = 0;
  double max = 0;

  EQSlideItem({
    this.key,
    required this.id,
    required this.leftText,
    required this.rightText,
    required this.min,
    required this.max,
  });
}
