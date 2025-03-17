import 'package:flutter/material.dart';
import 'dart:math';

// 生成随机颜色
Color getRandomColor({
  double minSaturation = 0.5, // 最小饱和度
  double maxSaturation = 1.0, // 最大饱和度
  double minBrightness = 0.6, // 最小亮度
  double maxBrightness = 0.9, // 最大亮度
  double opacity = 1.0, // 不透明度
}) {
  final random = Random();

  // HSV颜色空间可以更好地控制颜色的饱和度和亮度
  return HSVColor.fromAHSV(
    opacity,
    random.nextDouble() * 360, // 随机色相 (0-360)
    minSaturation +
        random.nextDouble() * (maxSaturation - minSaturation), // 随机饱和度
    minBrightness +
        random.nextDouble() * (maxBrightness - minBrightness), // 随机亮度
  ).toColor();
}
