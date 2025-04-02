import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_directions/flutter_map_directions.dart';
import 'package:flutter_map_learning/Model/path_model.dart';
import 'package:flutter_map_learning/utils/collectPolyline.dart';
import 'package:latlong2/latlong.dart';

class MarkerPathPage extends StatefulWidget {
  const MarkerPathPage({super.key});

  @override
  State<MarkerPathPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MarkerPathPage> {
  List<LatLng> tappedPoints = [];
  List<LatLng> pathPolyline = [];
  void onTap() async {
    //科创大厦
    var startPoint = '86.011265,44.343009';
    //西公园
    var endPoint = '86.0216195,44.297074';

    var dio = Dio();
    //获取高德路径规划数据
    var resJson = await dio
        .get("https://restapi.amap.com/v5/direction/driving", queryParameters: {
      "key": "c1ea93bf8ac403bb540cb1b8eda53305",
      "origin": startPoint,
      "destination": endPoint,
      "show_fields": "polyline"
    });
    var res = PathModel.fromJson(resJson.data);
    setState(() {
      pathPolyline = PolylineCollector.collectPathPoints(res);
    });
    print(pathPolyline);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("地图页"),
        backgroundColor: Colors.blue,
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter:
              LatLng(44.343009, 86.011265), // Center the map over London
          initialZoom: 17,
          minZoom: 3,
          maxZoom: 20,
        ),
        children: [
          TileLayer(
            // Bring your own tiles
            urlTemplate:
                'http://t4.tianditu.gov.cn/img_w/wmts?SERVICE=WMTS&REQUEST=GetTile&VERSION=1.0.0&LAYER=img&STYLE=default&TILEMATRIXSET=w&FORMAT=tiles&TILEMATRIX={z}&TILEROW={y}&TILECOL={x}&tk=2e4da3804eb62318a09cd95a01f8b17d', // For demonstration only
            userAgentPackageName:
                'com.example.flutter_map_learning', // Add your app identifier
            // And many more recommended properties!
          ),
          PolylineLayer(
            polylines: [Polyline(points: pathPolyline, color: Colors.blue)],
          ),
          ElevatedButton(onPressed: onTap, child: Text("导航"))
        ],
      ),
    );
  }
}
