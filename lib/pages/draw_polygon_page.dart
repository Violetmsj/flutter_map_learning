import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../utils/geo_calculation_utils.dart';

class DrawPolygonPage extends StatefulWidget {
  const DrawPolygonPage({super.key});

  @override
  State<DrawPolygonPage> createState() => _DrawPolygonPageState();
}

class _DrawPolygonPageState extends State<DrawPolygonPage> {
  // 存储所有已完成的多边形
  List<List<LatLng>> completedPolygons = [];
  // 当前正在绘制的多边形的点
  List<LatLng> currentPoints = [];
  //地图控制器
  final mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('绘制多边形'),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              setState(() {
                //  清除当前画的点位
                currentPoints.clear();
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.done),
            onPressed: () {
              setState(() {
                completedPolygons.add([...currentPoints]);
                currentPoints.clear();
              });
            },
          ),
        ],
      ),
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          initialCenter: LatLng(39, 116),
          initialZoom: 9.2,
          minZoom: 3,
          maxZoom: 18,
          onTap: (tapPosition, point) {
            final screenPoint = mapController.camera.latLngToScreenPoint(point);
            // 如果没有点位，直接添加新点
            if (currentPoints.isEmpty) {
              setState(() {
                currentPoints.add(point);
              });
              return;
            }
            final firstScreenPoint =
                mapController.camera.latLngToScreenPoint(currentPoints.first);
            setState(() {
              /**TODO
               * 这里使用的是经纬度坐标来计算点击的位置是否足够接近，
               * 如果地图放的很小，误差会很大，需要改成使用屏幕坐标计算
               *  */
              if (currentPoints.length >= 3 &&
                  (screenPoint.x - firstScreenPoint.x).abs() < 10 &&
                  (screenPoint.y - firstScreenPoint.y).abs() < 10) {
                // 如果点击位置接近第一个点，则闭合多边形
                completedPolygons.add(List.from(currentPoints));
                currentPoints.clear();
              } else {
                currentPoints.add(point);
              }
            });
          },
        ),
        children: [
          TileLayer(
            urlTemplate:
                'http://t4.tianditu.gov.cn/img_w/wmts?SERVICE=WMTS&REQUEST=GetTile&VERSION=1.0.0&LAYER=img&STYLE=default&TILEMATRIXSET=w&FORMAT=tiles&TILEMATRIX={z}&TILEROW={y}&TILECOL={x}&tk=2e4da3804eb62318a09cd95a01f8b17d',
            userAgentPackageName: 'com.example.flutter_map_learning',
          ),
          // 绘制已完成的多边形
          PolygonLayer(
            polygons: [
              for (var points in completedPolygons)
                Polygon(
                  points: points,
                  color: Colors.blue.withOpacity(0.3),
                  borderStrokeWidth: 2,
                  borderColor: Colors.blue,
                ),
            ],
          ),
          // 绘制当前正在绘制的多边形
          PolylineLayer(
            polylines: [
              if (currentPoints.isNotEmpty)
                Polyline(
                  points: currentPoints,
                  color: Colors.red,
                  strokeWidth: 2,
                ),
              // 绘制虚线（当有3个及以上点时）
              if (currentPoints.length >= 3)
                Polyline(
                  points: [
                    currentPoints.last,
                    currentPoints.first,
                  ],
                  color: Colors.red,
                  strokeWidth: 2,
                  pattern: StrokePattern.dashed(segments: [10, 5]),
                ),
            ],
          ),
          MarkerLayer(
            markers: currentPoints
                .map((point) => Marker(
                      point: point,
                      width: 20,
                      height: 20,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ))
                .toList(),
          ),
          // 显示面积标签
          MarkerLayer(
            markers: [
              for (var points in completedPolygons)
                Marker(
                  point: GeoCalculationUtils.calculateCentroid(points),
                  width: 100,
                  height: 30,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.blue),
                    ),
                    child: Text(
                      '${GeoCalculationUtils.calculatePolygonArea(points.toMapsToolkitList()).toStringAsFixed(2)} 亩',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),
          MarkerLayer(
            markers: [
              if (currentPoints.length >= 3)
                Marker(
                  point: GeoCalculationUtils.calculateCentroid(currentPoints),
                  width: 100,
                  height: 30,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.blue),
                    ),
                    child: Text(
                      '${GeoCalculationUtils.calculatePolygonArea(currentPoints.toMapsToolkitList()).toStringAsFixed(2)} 亩',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
            ],
          )
        ],
      ),
    );
  }
}
