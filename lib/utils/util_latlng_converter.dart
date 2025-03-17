/* 
maps_toolkit的LatLng类与latlong2的LatLng类互相转换的工具
 */
import 'package:latlong2/latlong.dart' as latlong2;
import 'package:maps_toolkit/maps_toolkit.dart' as maps_toolkit;

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
