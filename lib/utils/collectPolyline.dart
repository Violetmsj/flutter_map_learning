import 'package:flutter_map_directions/flutter_map_directions.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_learning/Model/path_model.dart';

class PolylineCollector {
  /// 将高德地图路径规划数据转换为LatLng列表
  static List<LatLng> collectPathPoints(PathModel pathModel) {
    List<LatLng> allPointsLatLng = [];

    if (pathModel.route?.paths == null) return allPointsLatLng;

    // 只处理第一条路径
    if (pathModel.route?.paths?[0].steps == null) return allPointsLatLng;

    for (var step in pathModel.route!.paths![0].steps!) {
      // 分割得到所有坐标点
      var points = step.polyline!.split(';');
      for (var point in points) {
        var coords = point.split(',');
        // 注意：高德地图返回的经纬度顺序是 longitude,latitude
        // 而 LatLng 构造函数的参数顺序是 latitude, longitude
        allPointsLatLng.add(LatLng(
          double.parse(coords[1]), // 纬度
          double.parse(coords[0]), // 经度
        ));
      }
    }

    return allPointsLatLng;
  }
}
