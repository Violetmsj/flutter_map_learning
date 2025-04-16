import 'package:flutter/material.dart';
import 'package:flutter_map_learning/flavors/flavor_config.dart';
import 'package:flutter_map_learning/pages/camera_page.dart';
import 'package:flutter_map_learning/pages/draw_polygon_page.dart';
import 'package:flutter_map_learning/pages/draw_polyline_page.dart';
import 'package:flutter_map_learning/pages/img_picker_page.dart';
import 'package:flutter_map_learning/pages/map_page.dart';
import 'package:flutter_map_learning/pages/marker_clustering_page.dart';
import 'package:flutter_map_learning/pages/marker_path_page.dart';
import 'package:flutter_map_learning/pages/polygon_clip_page.dart';
import 'package:flutter_map_learning/pages/polyline_edit.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  // final CameraDescription camera;
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("首页"), backgroundColor: Colors.amber),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Get.snackbar("当前环境", FlavorConfig.shared.appName);
              },
              child: Text("版本提示"),
            ),
            ElevatedButton(
              onPressed: () {
                Get.to(MapPage());
              },
              child: Text("进入地图页"),
            ),
            ElevatedButton(
              onPressed: () {
                Get.to(CameraPage(
                    // camera: camera,
                    ));
              },
              child: Text("进入拍照上传页"),
            ),
            ElevatedButton(
              onPressed: () {
                Get.to(MarkerClusteringPage());
              },
              child: Text("进入地图点位聚合页"),
            ),
            ElevatedButton(
              onPressed: () {
                Get.to(ImgPickerPage());
              },
              child: Text("进入image_picker页"),
            ),
            ElevatedButton(
              onPressed: () {
                Get.to(DrawPolylinePage());
              },
              child: Text("进入polyline绘制页"),
            ),
            ElevatedButton(
              onPressed: () {
                Get.to(DrawPolygonPage());
              },
              child: Text("进入polygon绘制页"),
            ),
            ElevatedButton(
              onPressed: () {
                Get.to(PolygonClipPage());
              },
              child: Text("进入polygon分割页"),
            ),
            ElevatedButton(
              onPressed: () {
                Get.to(PolylineEdit());
              },
              child: Text("polygon_picker"),
            ),
            ElevatedButton(
              onPressed: () {
                Get.to(MarkerPathPage());
              },
              child: Text("路径规划"),
            ),
          ],
        ),
      ),
    );
  }
}
