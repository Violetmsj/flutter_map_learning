// import 'package:polybool/polybool.dart';
// // import 'package:latlong2/latlong.dart';
// import 'package:maps_toolkit/maps_toolkit.dart';

// List<List<LatLng>> splitPolygonByPolyline(
//     List<LatLng> polygon, List<LatLng> polyline) {
//   // 1. 首先使用 maps_toolkit 计算切割线的缓冲区宽度
//   // 这里使用原多边形周长的 0.1% 作为缓冲区宽度
//   double bufferWidth = SphericalUtil.computeLength(polygon) * 0.001;

//   // 2. 创建切割线的缓冲区多边形
//   List<Coordinate> cuttingPolygonPoints = [];

//   // 对切割线的每个线段创建缓冲区
//   for (int i = 0; i < polyline.length - 1; i++) {
//     LatLng start = polyline[i];
//     LatLng end = polyline[i + 1];

//     // 计算垂直于线段方向的向量
//     double heading = SphericalUtil.computeHeading(start, end).toDouble();

//     // 在线段两侧创建缓冲区点
//     LatLng p1 = SphericalUtil.computeOffset(start, bufferWidth, heading - 90);
//     LatLng p2 = SphericalUtil.computeOffset(start, bufferWidth, heading + 90);
//     LatLng p3 = SphericalUtil.computeOffset(end, bufferWidth, heading + 90);
//     LatLng p4 = SphericalUtil.computeOffset(end, bufferWidth, heading - 90);

//     if (i == 0) {
//       cuttingPolygonPoints.add(Coordinate(p1.latitude, p1.longitude));
//       cuttingPolygonPoints.add(Coordinate(p2.latitude, p2.longitude));
//     }

//     cuttingPolygonPoints.add(Coordinate(p3.latitude, p3.longitude));
//     cuttingPolygonPoints.add(Coordinate(p4.latitude, p4.longitude));
//   }

//   // 闭合切割线的缓冲区多边形
//   cuttingPolygonPoints.add(cuttingPolygonPoints.first);

//   // 3. 创建 PolyBool 的多边形对象
//   Polygon originalPoly = Polygon(regions: [
//     polygon.map((p) => Coordinate(p.latitude, p.longitude)).toList()
//   ]);

//   Polygon cuttingPoly = Polygon(regions: [cuttingPolygonPoints]);

//   // 4. 执行布尔运算得到切割结果
//   Polygon difference = originalPoly.difference(cuttingPoly);

//   // 5. 将结果转换回 LatLng 列表
//   List<List<LatLng>> result = difference.regions.map((region) {
//     return region.map((coord) => LatLng(coord.x, coord.y)).toList();
//   }).toList();

//   return result;
// }

// // 使用示例：
// void main() {
//   // 原多边形
//   List<LatLng> polygon = [
//     LatLng(0, 0),
//     LatLng(0, 1),
//     LatLng(1, 1),
//     LatLng(1, 0),
//     LatLng(0, 0), // 闭合多边形
//   ];

//   // 切割线
//   List<LatLng> polyline = [
//     LatLng(-0.5, 0.5),
//     LatLng(1.5, 0.5),
//   ];

//   // 执行切割
//   List<List<LatLng>> splitResult = splitPolygonByPolyline(polygon, polyline);

//   // splitResult 中包含切割后的两个多边形
//   print('切割后的多边形数量: ${splitResult.length}');
//   for (var poly in splitResult) {
//     print('多边形顶点: $poly');
//   }
// }
