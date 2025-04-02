import 'dart:math' as math;
import 'package:latlong2/latlong.dart';

class CoordinateConverter {
  static const double PI = math.pi;
  static const double X_PI = PI * 3000.0 / 180.0;
  static const double EARTH_R = 6378245.0;
  static const double EE = 0.00669342162296594323;

  /// 高德坐标系(GCJ-02)转天地图坐标系(WGS-84)
  ///
  /// [point] LatLng对象，包含纬度和经度
  /// 返回格式：LatLng对象
  static LatLng gcj02ToWgs84(LatLng point) {
    if (outOfChina(point.latitude, point.longitude)) {
      return point;
    }

    var dLat = transformLat(point.longitude - 105.0, point.latitude - 35.0);
    var dLng = transformLng(point.longitude - 105.0, point.latitude - 35.0);
    var radLat = point.latitude / 180.0 * PI;
    var magic = math.sin(radLat);
    magic = 1 - EE * magic * magic;
    var sqrtMagic = math.sqrt(magic);
    dLat = (dLat * 180.0) / ((EARTH_R * (1 - EE)) / (magic * sqrtMagic) * PI);
    dLng = (dLng * 180.0) / (EARTH_R / sqrtMagic * math.cos(radLat) * PI);

    var mgLat = point.latitude + dLat;
    var mgLng = point.longitude + dLng;
    return LatLng(point.latitude * 2 - mgLat, point.longitude * 2 - mgLng);
  }

  /// 天地图坐标系(WGS-84)转高德坐标系(GCJ-02)
  ///
  /// [point] LatLng对象，包含纬度和经度
  /// 返回格式：LatLng对象
  static LatLng wgs84ToGcj02(LatLng point) {
    if (outOfChina(point.latitude, point.longitude)) {
      return point;
    }

    var dLat = transformLat(point.longitude - 105.0, point.latitude - 35.0);
    var dLng = transformLng(point.longitude - 105.0, point.latitude - 35.0);
    var radLat = point.latitude / 180.0 * PI;
    var magic = math.sin(radLat);
    magic = 1 - EE * magic * magic;
    var sqrtMagic = math.sqrt(magic);
    dLat = (dLat * 180.0) / ((EARTH_R * (1 - EE)) / (magic * sqrtMagic) * PI);
    dLng = (dLng * 180.0) / (EARTH_R / sqrtMagic * math.cos(radLat) * PI);

    return LatLng(point.latitude + dLat, point.longitude + dLng);
  }

  /// 判断坐标是否在中国境内
  static bool outOfChina(double lat, double lng) {
    if (lng < 72.004 || lng > 137.8347) {
      return true;
    }
    if (lat < 0.8293 || lat > 55.8271) {
      return true;
    }
    return false;
  }

  static double transformLat(double x, double y) {
    var ret = -100.0 +
        2.0 * x +
        3.0 * y +
        0.2 * y * y +
        0.1 * x * y +
        0.2 * math.sqrt(x.abs());
    ret += (20.0 * math.sin(6.0 * x * PI) + 20.0 * math.sin(2.0 * x * PI)) *
        2.0 /
        3.0;
    ret +=
        (20.0 * math.sin(y * PI) + 40.0 * math.sin(y / 3.0 * PI)) * 2.0 / 3.0;
    ret += (160.0 * math.sin(y / 12.0 * PI) + 320 * math.sin(y * PI / 30.0)) *
        2.0 /
        3.0;
    return ret;
  }

  static double transformLng(double x, double y) {
    var ret = 300.0 +
        x +
        2.0 * y +
        0.1 * x * x +
        0.1 * x * y +
        0.1 * math.sqrt(x.abs());
    ret += (20.0 * math.sin(6.0 * x * PI) + 20.0 * math.sin(2.0 * x * PI)) *
        2.0 /
        3.0;
    ret +=
        (20.0 * math.sin(x * PI) + 40.0 * math.sin(x / 3.0 * PI)) * 2.0 / 3.0;
    ret += (150.0 * math.sin(x / 12.0 * PI) + 300.0 * math.sin(x / 30.0 * PI)) *
        2.0 /
        3.0;
    return ret;
  }
}
