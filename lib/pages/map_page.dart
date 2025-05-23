import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_learning/Data/polygon_data.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MapPage> {
  List<LatLng> tappedPoints = [];
  List<Polygon> staticPolygons = PolygonData.staticPolygons(1);
  final textController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var markers = [
      Marker(
        point: LatLng(39, 116),
        width: 80,
        height: 80,
        child: GestureDetector(
          onTap: () {
            // 在这里处理点击事件
            showDialog(
              context: context,
              builder: (BuildContext context) {
                print(context);
                return AlertDialog(
                  title: Text('标记点信息'),
                  content: Text('位置：北纬39度，东经116度'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('关闭'),
                    ),
                  ],
                );
              },
            );
          },
          child: FlutterLogo(),
        ),
      )
    ];
    markers = [
      ...markers,
      ...tappedPoints.map((point) {
        return Marker(
          point: point,
          width: 80,
          height: 80,
          child: GestureDetector(
            onTap: () {
              // 在这里处理点击事件
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  print(context);
                  return AlertDialog(
                    title: Text('标记点信息'),
                    content:
                        Text('位置：北纬${point.latitude}度，东经${point.longitude}度'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('关闭'),
                      ),
                    ],
                  );
                },
              );
            },
            child: FlutterLogo(),
          ),
        );
      })
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text("地图页"),
        backgroundColor: Colors.blue,
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter:
              LatLng(44.343009, 86.011265), // Center the map over London
          // initialZoom: 17,
          initialZoom: 17,
          minZoom: 3,
          maxZoom: 20,
          onTap: (tapPosition, point) {
            print('经纬度: ${point.latitude}, ${point.longitude}');
            // 这里可以处理地图点击事件
            // point 是点击位置的经纬度
            // tapPosition 是屏幕坐标
            setState(() {
              tappedPoints.add(point);
            });
          },
          // interactionOptions: InteractionOptions(
          //   // enableScrollWheel: true,
          //   enableMultiFingerGestureRace: true,
          //   flags: InteractiveFlag.all,
          // ),
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
          const Scalebar(
            textStyle: TextStyle(color: Colors.black, fontSize: 14),
            padding: EdgeInsets.only(right: 10, left: 10, bottom: 40),
            alignment: Alignment.bottomLeft,
            length: ScalebarLength.s,
          ),
          MarkerLayer(
            markers: markers,
          ),
          PolygonLayer(
            polygons: staticPolygons,
          ),
          Column(
            children: [
              TextField(
                controller: textController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    print(textController.text);
                    late int res;

                    res = int.parse(textController.text);

                    setState(() {
                      staticPolygons = PolygonData.staticPolygons(res);
                    });
                  },
                  child: Text("set"))
            ],
          )
        ],
      ),
    );
  }
}
