import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as maps_toolkit;
import '../utils/util_clip_polygon.dart';
import "../utils/util_latlng_converter.dart";
import '../utils/util_random_color.dart';

typedef HitValue = ({String polygonKey, String testValue});

class PolygonClipPage extends StatefulWidget {
  const PolygonClipPage({super.key});

  @override
  State<PolygonClipPage> createState() => _PolygonClipPageState();
}

class _PolygonClipPageState extends State<PolygonClipPage> {
  List<LatLng> clipLinepPints = []; //存储分割线的点
  var startSelect = false;
  var startClip = false;
  final LayerHitNotifier<HitValue> _hitNotifier = ValueNotifier(null);
  // List<HitValue>? _prevHitValues; // 保存上一次点击的polygon
  List<Polygon<HitValue>>? _clickGons = [];
  List<Polygon> _testGons = [];
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
  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: LatLng(39, 116),
        initialZoom: 9.2,
        minZoom: 3,
        maxZoom: 18,
        onTap: (tapPosition, point) {
          print("enter map tap");
          if (startSelect && _clickGons!.isNotEmpty) {
            setState(() {
              clipLinepPints.add(point);
            });
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
                        setState(() {
                          startSelect ? _clickGons = [] : '';
                          startSelect = !startSelect;
                        });
                      },
                      child: startSelect ? Text('选择中') : Text('开始选择'),
                    ),
                    SizedBox(width: 20),
                    // FloatingActionButton(
                    //   onPressed: () {},
                    //   child: !startClip ? Text('开始分割') : Text('结束分割'),
                    // )
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          startClip = !startClip;
                          if (startClip &&
                              _clickGons!.isNotEmpty &&
                              clipLinepPints.isNotEmpty) {
                            print("is ready to clip");
                            // 调用切割工具
                            List<LatLng> polygonPointstest =
                                _clickGons![0].points;
                            print(polygonPointstest);

                            if (_clickGons != null && _clickGons!.isNotEmpty) {
                              // final clippedPolygons =
                              //     PolygonClipUtils.clipPolygon(
                              //   _clickGons![0],
                              //   clipLinepPints,
                              // );
                              // if (clippedPolygons != null) {
                              //   _testGons = clippedPolygons.toList();
                              //   clipLinepPints.clear();
                              //   setState(() {});
                              // }
                              var readyPolygon =
                                  _clickGons![0].points.toMapsToolkitList();
                              var readyClipLine =
                                  clipLinepPints.toMapsToolkitList();
                              // maps_toolkit.LatLng
                              var clipResult = splitPolygonByPolyline(
                                  readyPolygon, readyClipLine);
                              _testGons = clipResult.indexed.map((
                                e,
                              ) {
                                var points = e.$2.toLatLng2List();
                                return Polygon(
                                  points: points,
                                  // borderColor:
                                  //     e.$1 == 0 ? Colors.pink : Colors.green,
                                  color: getRandomColor(),
                                  borderStrokeWidth: 4,
                                );
                              }).toList();
                              setState(() {});
                              print(clipResult);
                            }
                          }
                        });
                      },
                      child: Text('点击分割'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: startSelect && _clickGons!.isEmpty
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
        PolylineLayer<Object>(
          polylines: clipLinepPints.length >= 2
              ? [
                  Polyline<Object>(
                    points: clipLinepPints,
                    color: Colors.red,
                    strokeWidth: 3.0,
                  ),
                ]
              : [],
        ),
        MarkerLayer(
          markers: clipLinepPints
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
        PolygonLayer(
          polygons: _testGons,
        )
      ],
    );
  }
}
