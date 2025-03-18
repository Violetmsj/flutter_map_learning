import 'package:latlong2/latlong.dart' as latlong2;
import "package:maps_toolkit/maps_toolkit.dart" as maps_toolkit;
import 'package:polybool/polybool.dart' as polybool;

// latlong2与maps_toolkit的LatLng类的互相转换
extension LatLong2Extension on latlong2.LatLng {
  maps_toolkit.LatLng toMapsToolkit() {
    return maps_toolkit.LatLng(latitude, longitude);
  }
}

extension MapsToolkitLatLngExtension on maps_toolkit.LatLng {
  latlong2.LatLng toLatLng2() {
    return latlong2.LatLng(latitude, longitude);
  }
}

extension latlong2LatLngListConverter on List<latlong2.LatLng> {
  List<maps_toolkit.LatLng> toMapsToolkitList() {
    return map((e) => e.toMapsToolkit()).toList();
  }
}

extension MapsToolkitLatLngListConverter on List<maps_toolkit.LatLng> {
  List<latlong2.LatLng> toLatLng2List() {
    return map((e) => e.toLatLng2()).toList();
  }
}

class GeoCalculationUtils {
  // 计算多边形面积
  static double calculatePolygonArea(List<maps_toolkit.LatLng> points) {
    var area = maps_toolkit.SphericalUtil.computeArea(points).toDouble();
    area = area * 0.0015; //平方米转换为亩
    return area;
  }

// 切割多边形
  static List<List<maps_toolkit.LatLng>> splitPolygonByPolyline(
      List<maps_toolkit.LatLng> polygon, List<maps_toolkit.LatLng> polyline) {
    // 1. 首先使用 maps_toolkit 计算切割线的缓冲区宽度
    // 这里使用原多边形周长的 0.1% 作为缓冲区宽度
    double bufferWidth =
        maps_toolkit.SphericalUtil.computeLength(polygon) * 0.001;

    // 2. 创建切割线的缓冲区多边形
    List<polybool.Coordinate> cuttingPolygonPoints = [];

    // 2. 为每个线段创建独立的缓冲区多边形
    List<polybool.Polygon> bufferPolygons = [];

    for (int i = 0; i < polyline.length - 1; i++) {
      List<polybool.Coordinate> segmentBuffer = [];
      maps_toolkit.LatLng start = polyline[i];
      maps_toolkit.LatLng end = polyline[i + 1];

      double heading =
          maps_toolkit.SphericalUtil.computeHeading(start, end).toDouble();

      // 创建矩形缓冲区的四个角点
      maps_toolkit.LatLng p1 = maps_toolkit.SphericalUtil.computeOffset(
          start, bufferWidth, heading - 90);
      maps_toolkit.LatLng p2 = maps_toolkit.SphericalUtil.computeOffset(
          start, bufferWidth, heading + 90);
      maps_toolkit.LatLng p3 = maps_toolkit.SphericalUtil.computeOffset(
          end, bufferWidth, heading + 90);
      maps_toolkit.LatLng p4 = maps_toolkit.SphericalUtil.computeOffset(
          end, bufferWidth, heading - 90);

      // 按顺序添加点形成闭合多边形
      segmentBuffer.add(polybool.Coordinate(p1.latitude, p1.longitude));
      segmentBuffer.add(polybool.Coordinate(p2.latitude, p2.longitude));
      segmentBuffer.add(polybool.Coordinate(p3.latitude, p3.longitude));
      segmentBuffer.add(polybool.Coordinate(p4.latitude, p4.longitude));
      segmentBuffer
          .add(polybool.Coordinate(p1.latitude, p1.longitude)); // 闭合多边形

      // 将这段缓冲区添加到列表
      bufferPolygons.add(polybool.Polygon(regions: [segmentBuffer]));
    }

    // 合并所有缓冲区
    polybool.Polygon cuttingPoly = bufferPolygons.reduce((a, b) => a.union(b));

    // 3. 创建 PolyBool 的多边形对象
    polybool.Polygon originalPoly = polybool.Polygon(regions: [
      polygon.map((p) => polybool.Coordinate(p.latitude, p.longitude)).toList()
    ]);

    // 4. 执行布尔运算得到切割结果
    polybool.Polygon difference = originalPoly.difference(cuttingPoly);

    // 5. 将结果转换回 maps_toolkit.LatLng 列表
    List<List<maps_toolkit.LatLng>> result = difference.regions.map((region) {
      return region
          .map((coord) => maps_toolkit.LatLng(coord.x, coord.y))
          .toList();
    }).toList();

    return result;
  }
}
