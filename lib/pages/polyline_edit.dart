import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_dragmarker/flutter_map_dragmarker.dart';
import 'package:flutter_map_line_editor/flutter_map_line_editor.dart';
import 'package:latlong2/latlong.dart';

class PolylineEdit extends StatefulWidget {
  const PolylineEdit({super.key});

  @override
  State<PolylineEdit> createState() => _PolylineEditState();
}

class _PolylineEditState extends State<PolylineEdit> {
  // 折线编辑器，用于管理折线的编辑操作，包括添加、移动点等功能
  late PolyEditor polyEditor;

  // 存储折线的所有点位坐标的列表
  final clipLinepPoints = <LatLng>[];

  @override
  void initState() {
    polyEditor = PolyEditor(
      addClosePathMarker: false,
      points: clipLinepPoints,
      pointIcon: const Icon(Icons.crop_square, size: 23),
      intermediateIcon: const Icon(Icons.lens, size: 15, color: Colors.grey),
      callbackRefresh: (LatLng? _) {
        //debugPrint("polyedit setstate");
        setState(() {});
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // 存储地图上所有折线的列表
    final polyLines = <Polyline>[];
    // 创建一个测试用的折线对象，设置颜色为深橙色，使用clipLinepPoints作为点位数据
    final testPolyline =
        Polyline(color: Colors.deepOrange, points: clipLinepPoints);
    polyLines.add(testPolyline);

    return Scaffold(
      appBar: AppBar(title: const Text('Polyline example')),
      body: FlutterMap(
        options: MapOptions(
          onTap: (_, ll) {
            polyEditor.add(testPolyline.points, ll);
          },
          // For backwards compatibility with pre v5 don't use const
          // ignore: prefer_const_constructors
          initialCenter: LatLng(45.5231, -122.6765),
          initialZoom: 10,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          ),
          PolylineLayer(polylines: polyLines),
          DragMarkers(markers: polyEditor.edit()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.replay),
        onPressed: () {
          setState(() {
            testPolyline.points.clear();
          });
        },
      ),
    );
  }
}
