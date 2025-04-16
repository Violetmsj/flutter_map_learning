import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class PolygonData {
  static final List<Polygon> polygons = List.generate(1000, (index) {
    // 中心点坐标
    const centerLat = 44.343009;
    const centerLng = 86.011265;

    // 在中心点周围0.1度范围内随机生成顶点
    final random = Random();
    final vertexCount = random.nextInt(4) + 3; // 3-6个顶点

    final points = List.generate(vertexCount, (i) {
      final lat = centerLat + (random.nextDouble() - 0.5) * 0.1;
      final lng = centerLng + (random.nextDouble() - 0.5) * 0.1;
      return LatLng(lat, lng);
    });

    // 生成随机颜色
    final color = Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      0.4, // 透明度固定为0.4
    );

    final borderColor = Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1.0, // 边框不透明
    );

    return Polygon(
      points: points,
      color: color,
      borderColor: borderColor,
      borderStrokeWidth: 2,
    );
  });

  // 固定的多边形列表
  static List<Polygon> staticPolygons(int num) {
    return List.generate(num, (index) {
      List<LatLng> points = [
        LatLng(44.34258543770059, 86.010157155875),
        LatLng(44.34118227634131, 86.0099160244863),
        LatLng(44.341006932334004, 86.01197182194613),
        LatLng(44.342380767491775, 86.01217617673682)
      ];

      // 使用固定的颜色
      final hue = (index * 37) % 360; // 使用黄金角度来生成不同的色相
      final color = HSVColor.fromAHSV(0.4, hue.toDouble(), 0.7, 0.9).toColor();
      final borderColor =
          HSVColor.fromAHSV(1.0, hue.toDouble(), 0.8, 0.7).toColor();

      return Polygon(
        points: points,
        color: color,
        borderColor: borderColor,
        borderStrokeWidth: 2,
      );
    });
  }
}
