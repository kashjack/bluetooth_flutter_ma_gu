/*
 * @Author: kashjack kashjack@163.com
 * @Date: 2022-08-24 17:55:51
 * @LastEditors: kashjack kashjack@163.com
 * @LastEditTime: 2022-08-29 14:33:13
 * @FilePath: /CarBlueTooth/lib/bean/RadioBean.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
class RadioSliderConfig {
  double lineHeight = 0;
  double cursorWidth = 0; //指针宽度
  double cursorHeight = 0; //指针高度
  double graduateWidth = 0; //刻度宽度
  double graduateHeight = 0; //刻度高度
  int min = 0; //最小值
  int max = 0; //最大值
  int graduateCount = 0; //刻度数量

  RadioSliderConfig(
      {required this.lineHeight,
      required this.cursorWidth,
      required this.cursorHeight,
      required this.graduateWidth,
      required this.graduateHeight,
      required this.min,
      required this.max,
      required this.graduateCount});
}
