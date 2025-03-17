import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';

class MarkerClusteringPage extends StatelessWidget {
  MarkerClusteringPage({super.key});
  List<Marker> markers = [
    Marker(
        point: LatLng(38.689659112194434, 115.6547666511192),
        width: 80,
        height: 80,
        child: GestureDetector(
          child: FlutterLogo(),
        )),
    Marker(
        point: LatLng(38.66811304415809, 116.24120214743059),
        width: 80,
        height: 80,
        child: GestureDetector(
          child: FlutterLogo(),
        )),
    Marker(
        point: LatLng(38.37625020796615, 115.89706843274737),
        width: 80,
        height: 80,
        child: GestureDetector(
          child: FlutterLogo(),
        )),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("点位聚合页"),
        backgroundColor: Colors.blue,
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(39, 116), // Center the map over London
          initialZoom: 9.2,
          minZoom: 3,
          maxZoom: 18,
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
          MarkerClusterLayerWidget(
            options: MarkerClusterLayerOptions(
                maxClusterRadius: 45,
                size: const Size(40, 40),
                alignment: Alignment.center,
                padding: const EdgeInsets.all(50),
                maxZoom: 15,
                markers: markers,
                builder: (context, markers) {
                  return Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.blue),
                    child: Center(
                      child: Text(
                        markers.length.toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                },
                showPolygon: false),
          )
        ],
      ),
    );
  }
}
