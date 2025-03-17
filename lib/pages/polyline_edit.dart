import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_dragmarker/flutter_map_dragmarker.dart';
import 'package:flutter_map_line_editor/flutter_map_line_editor.dart';
import 'package:latlong2/latlong.dart';

typedef HitValue = ({String polygonKey, String testValue});

class PolylineEdit extends StatefulWidget {
  const PolylineEdit({super.key});

  @override
  State<PolylineEdit> createState() => _PolylineEditState();
}

class _PolylineEditState extends State<PolylineEdit> {
  // 随机颜色

  List<LatLng> clipLinepPints = []; //存储分割线的点
  var startSelect = false;
  var startClip = false;
  final LayerHitNotifier<HitValue> _hitNotifier = ValueNotifier(null);
  // List<HitValue>? _prevHitValues; // 保存上一次点击的polygon
  List<Polygon<HitValue>>? _clickGons = [];
  List<Polygon> _testGons = [];
  late PolyEditor polyEditor;
  final polyPoints = <LatLng>[];
  @override
  void initState() {
    polyEditor = PolyEditor(
      addClosePathMarker: false,
      points: polyPoints,
      pointIcon: const Icon(Icons.crop_square, size: 23),
      // intermediateIcon: const Icon(Icons.lens, size: 15, color: Colors.grey),
      callbackRefresh: (LatLng? _) {
        //debugPrint("polyedit setstate");
        setState(() {});
      },
    );

    super.initState();
  }

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
    final polyLines = <Polyline>[];
    final testPolyline = Polyline(color: Colors.deepOrange, points: polyPoints);
    polyLines.add(testPolyline);
    return FlutterMap(
      options: MapOptions(
        initialCenter: LatLng(39, 116),
        initialZoom: 9.2,
        minZoom: 3,
        maxZoom: 18,
        onTap: (_, ll) {
          polyEditor.add(testPolyline.points, ll);
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
            ),
            FloatingActionButton(
                child: const Icon(Icons.replay),
                onPressed: () {
                  setState(() {
                    testPolyline.points.clear();
                  });
                }),
          ],
        ),
        GestureDetector(
          onTap: () {
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
          },
          child: PolygonLayer(
            hitNotifier: _hitNotifier,
            polygons: [..._polygonsRaw, ...?_clickGons],
          ),
        ),
        PolylineLayer(polylines: polyLines),
        DragMarkers(markers: polyEditor.edit()),
      ],
    );
  }
}
