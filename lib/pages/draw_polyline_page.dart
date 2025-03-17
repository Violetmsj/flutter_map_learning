import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class DrawPolylinePage extends StatefulWidget {
  const DrawPolylinePage({super.key});

  @override
  State<DrawPolylinePage> createState() => _DrawPolylinePageState();
}

class _DrawPolylinePageState extends State<DrawPolylinePage> {
  List<LatLng> points = [];

  // 计算两点之间的距离（单位：公里）
  double calculateDistance(LatLng point1, LatLng point2) {
    const Distance distance = Distance();
    return distance.as(LengthUnit.Meter, point1, point2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('绘制折线'),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              setState(() {
                points.clear();
              });
            },
          ),
        ],
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(39.9075, 116.38805555555557),
          initialZoom: 9.2,
          minZoom: 3,
          maxZoom: 18,
          onTap: (tapPosition, point) {
            setState(() {
              points.add(point);
            });
          },
        ),
        children: [
          TileLayer(
            urlTemplate:
                'http://t4.tianditu.gov.cn/img_w/wmts?SERVICE=WMTS&REQUEST=GetTile&VERSION=1.0.0&LAYER=img&STYLE=default&TILEMATRIXSET=w&FORMAT=tiles&TILEMATRIX={z}&TILEROW={y}&TILECOL={x}&tk=2e4da3804eb62318a09cd95a01f8b17d',
            userAgentPackageName: 'com.example.flutter_map_learning',
          ),
          PolylineLayer<Object>(
            polylines: points.length >= 2
                ? [
                    Polyline<Object>(
                      points: points,
                      color: Colors.red,
                      strokeWidth: 3.0,
                    ),
                  ]
                : [],
          ),
          MarkerLayer(
            markers: points
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
          MarkerLayer(
            markers: points.length >= 2
                ? [
                    for (int i = 0; i < points.length - 1; i++)
                      Marker(
                        point: LatLng(
                          (points[i].latitude + points[i + 1].latitude) / 2,
                          (points[i].longitude + points[i + 1].longitude) / 2,
                        ),
                        width: 80,
                        height: 30,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.blue),
                          ),
                          child: Text(
                            '${calculateDistance(points[i], points[i + 1]).toStringAsFixed(5)}m',
                            style: const TextStyle(fontSize: 10),
                          ),
                        ),
                      ),
                  ]
                : [],
          ),
        ],
      ),
    );
  }
}
