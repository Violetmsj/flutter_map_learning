import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as maps_toolkit;
import 'package:flutter_map_line_editor/flutter_map_line_editor.dart';
import 'package:flutter_map_dragmarker/flutter_map_dragmarker.dart';
import '../utils/util_clip_polygon.dart';
import "../utils/util_latlng_converter.dart";
import '../utils/util_random_color.dart';

typedef HitValue = ({String polygonKey, String testValue});

enum PolygonClipState {
  idle, // 初始状态
  selecting, // 选择多边形状态
  drawing, // 绘制分割线状态
  clipping, // 正在分割状态
}

class PolygonClipPage extends StatefulWidget {
  const PolygonClipPage({super.key});

  @override
  State<PolygonClipPage> createState() => _PolygonClipPageState();
}

class _PolygonClipPageState extends State<PolygonClipPage> {
  final clipLinepPoints = <LatLng>[]; //存储分割线的点

  // 替换原来的布尔变量
  PolygonClipState _polygonClipState = PolygonClipState.idle;

  // 添加状态管理方法
  void _handleStateChange(PolygonClipState newState) {
    setState(() {
      if (newState == PolygonClipState.idle) {
        _clickGons = [];
        clipLinepPoints.clear();
      }
      _polygonClipState = newState;
    });
  }

  // 折线编辑器，用于管理折线的编辑操作，包括添加、移动点等功能
  late PolyEditor polyEditor;

  final LayerHitNotifier<HitValue> _hitNotifier = ValueNotifier(null);
  // List<HitValue>? _prevHitValues; // 保存上一次点击的polygon
  List<Polygon<HitValue>>? _clickGons = []; //被选中的被切割的polygon
  List<Polygon> _resultGons = []; //对_clickGons切割完毕的产生的结果polygon
  final _polygonsRaw = <Polygon<HitValue>>[
    Polygon(
      points: const [
        LatLng(38.689659112194434, 115.6547666511192),
        LatLng(38.66811304415809, 116.24120214743067),
        LatLng(38.37625020796615, 115.89707923274737)
      ],
      borderColor: Colors.red,
      borderStrokeWidth: 4,
      hitValue: (polygonKey: "polygon1", testValue: "1"),
    ),
    Polygon(
      points: const [
        LatLng(39.3703838571772, 115.69119933022823),
        LatLng(39.3703838571772, 116.16754882301785),
        LatLng(39.11710963110816, 116.19943200538022),
        LatLng(39.102977520366785, 115.67297655663572),
      ],
      borderColor: Colors.red,
      borderStrokeWidth: 4,
      hitValue: (polygonKey: "polygon2", testValue: "2"),
    ),
  ];
  // 这是个Map映射，用于快速找到对应的polygon
  late final _polygons =
      Map.fromEntries(_polygonsRaw.map((e) => MapEntry(e.hitValue, e)));
  // 将分割逻辑抽取为单独的方法
  void _handleClipping() {
    if (clipLinepPoints.isEmpty) return;

    setState(() {
      var readyPolygon = _clickGons![0].points.toMapsToolkitList();
      var readyClipLine = clipLinepPoints.toMapsToolkitList();

      var clipResult = splitPolygonByPolyline(readyPolygon, readyClipLine);
      _resultGons = clipResult.indexed.map((e) {
        var points = e.$2.toLatLng2List();
        return Polygon(
          points: points,
          color: getRandomColor(),
          borderStrokeWidth: 4,
        );
      }).toList();

      // 重置状态
      // _handleStateChange(PolygonClipState.idle);
    });
  }

  @override
  void initState() {
    polyEditor = PolyEditor(
      addClosePathMarker: false,
      points: clipLinepPoints,
      pointIcon: const Icon(Icons.crop_square, size: 23),
      callbackRefresh: (LatLng? _) {
        setState(() {
          if (clipLinepPoints.length >= 2) {
            // 只有在有两个或更多点时才执行分割
            _handleClipping();
          }
        });
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // 存储地图上所有折线的列表
    final polyLines = <Polyline>[];
    // 创建一个测试用的折线对象，设置颜色为深橙色，使用polyPoints作为点位数据
    final testPolyline =
        Polyline(color: Colors.deepOrange, points: clipLinepPoints);
    polyLines.add(testPolyline);
    return FlutterMap(
      options: MapOptions(
        initialCenter: LatLng(39, 116),
        initialZoom: 9.2,
        minZoom: 3,
        maxZoom: 18,
        onTap: (tapPosition, point) {
          if (_polygonClipState == PolygonClipState.drawing) {
            // setState(() {
            //   clipLinepPoints.add(point);
            // });

            polyEditor.add(testPolyline.points, point);
          }
        },
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
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, bottom: 20, right: 20),
              child: Container(
                width: 300,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _handleStateChange(
                            _polygonClipState == PolygonClipState.idle
                                ? PolygonClipState.selecting
                                : PolygonClipState.idle);
                      },
                      child: Text(
                          _polygonClipState == PolygonClipState.selecting
                              ? '选择中'
                              : '开始选择'),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: _clickGons?.isEmpty ?? true
                          ? null
                          : () {
                              if (_polygonClipState ==
                                  PolygonClipState.drawing) {
                                // 执行分割操作
                                _handleClipping();
                              } else {
                                _handleStateChange(PolygonClipState.drawing);
                              }
                            },
                      child: Text(_polygonClipState == PolygonClipState.drawing
                          ? '完成分割'
                          : '开始分割'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: _polygonClipState == PolygonClipState.selecting
              ? () {
                  final hitValues = _hitNotifier.value?.hitValues.toList();
                  final clickPolygons = hitValues?.map((v) {
                    final original = _polygons[v]!; // 找到对应的polygon
                    return Polygon<HitValue>(
                      points: original.points,
                      color: Colors.amber.withOpacity(0.5),
                      // borderStrokeWidth: 15,
                      // borderColor: Colors.green,
                    );
                  }).toList();
                  setState(() {
                    _clickGons = clickPolygons;
                  });
                  print(_hitNotifier.value);
                }
              : null,
          child: PolygonLayer(
            hitNotifier: _hitNotifier,
            polygons: [..._polygonsRaw, ...?_clickGons],
          ),
        ),
        PolygonLayer(
          polygons: _resultGons,
        ),
        PolylineLayer(polylines: polyLines),
        DragMarkers(markers: polyEditor.edit()),
        // MarkerLayer(
        //   markers: clipLinepPoints
        //       .map((point) => Marker(
        //             point: point,
        //             width: 20,
        //             height: 20,
        //             child: Container(
        //               decoration: BoxDecoration(
        //                 color: Colors.red,
        //                 shape: BoxShape.circle,
        //                 border: Border.all(color: Colors.white, width: 2),
        //               ),
        //             ),
        //           ))
        //       .toList(),
        // ),
      ],
    );
  }
}
