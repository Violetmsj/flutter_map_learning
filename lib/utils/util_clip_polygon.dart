import 'package:polybool/polybool.dart';
// import 'package:latlong2/latlong.dart';
import 'package:maps_toolkit/maps_toolkit.dart';

List<List<LatLng>> splitPolygonByPolyline(
    List<LatLng> polygon, List<LatLng> polyline) {
  // 1. 首先使用 maps_toolkit 计算切割线的缓冲区宽度
  // 这里使用原多边形周长的 0.1% 作为缓冲区宽度
  double bufferWidth = SphericalUtil.computeLength(polygon) * 0.001;

  // 2. 创建切割线的缓冲区多边形
  List<Coordinate> cuttingPolygonPoints = [];

  // 2. 为每个线段创建独立的缓冲区多边形
  List<Polygon> bufferPolygons = [];

  for (int i = 0; i < polyline.length - 1; i++) {
    List<Coordinate> segmentBuffer = [];
    LatLng start = polyline[i];
    LatLng end = polyline[i + 1];

    double heading = SphericalUtil.computeHeading(start, end).toDouble();

    // 创建矩形缓冲区的四个角点
    LatLng p1 = SphericalUtil.computeOffset(start, bufferWidth, heading - 90);
    LatLng p2 = SphericalUtil.computeOffset(start, bufferWidth, heading + 90);
    LatLng p3 = SphericalUtil.computeOffset(end, bufferWidth, heading + 90);
    LatLng p4 = SphericalUtil.computeOffset(end, bufferWidth, heading - 90);

    // 按顺序添加点形成闭合多边形
    segmentBuffer.add(Coordinate(p1.latitude, p1.longitude));
    segmentBuffer.add(Coordinate(p2.latitude, p2.longitude));
    segmentBuffer.add(Coordinate(p3.latitude, p3.longitude));
    segmentBuffer.add(Coordinate(p4.latitude, p4.longitude));
    segmentBuffer.add(Coordinate(p1.latitude, p1.longitude)); // 闭合多边形

    // 将这段缓冲区添加到列表
    bufferPolygons.add(Polygon(regions: [segmentBuffer]));
  }

  // 合并所有缓冲区
  Polygon cuttingPoly = bufferPolygons.reduce((a, b) => a.union(b));

  // 3. 创建 PolyBool 的多边形对象
  Polygon originalPoly = Polygon(regions: [
    polygon.map((p) => Coordinate(p.latitude, p.longitude)).toList()
  ]);

  // 4. 执行布尔运算得到切割结果
  Polygon difference = originalPoly.difference(cuttingPoly);

  // 5. 将结果转换回 LatLng 列表
  List<List<LatLng>> result = difference.regions.map((region) {
    return region.map((coord) => LatLng(coord.x, coord.y)).toList();
  }).toList();

  return result;
}

// 使用示例：
void main() {
  // 原多边形
  List<LatLng> polygon = [
    LatLng(0, 0),
    LatLng(0, 1),
    LatLng(1, 1),
    LatLng(1, 0),
    LatLng(0, 0), // 闭合多边形
  ];

  // 切割线
  List<LatLng> polyline = [
    LatLng(-0.5, 0.5),
    LatLng(1.5, 0.5),
  ];

  // 执行切割
  List<List<LatLng>> splitResult = splitPolygonByPolyline(polygon, polyline);

  // splitResult 中包含切割后的两个多边形
  print('切割后的多边形数量: ${splitResult.length}');
  for (var poly in splitResult) {
    print('多边形顶点: $poly');
  }
}
