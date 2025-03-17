import 'package:flutter_map_learning/pages/camera_page.dart';
import 'package:flutter_map_learning/pages/draw_polyline_page.dart';
import 'package:flutter_map_learning/pages/img_picker_page.dart';
import 'package:flutter_map_learning/pages/marker_clustering_page.dart';
import 'package:flutter_map_learning/pages/polygon_clip_page.dart';
import 'package:get/get.dart';

import 'app_binding.dart';
import 'pages/home_page.dart';
import 'pages/map_page.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: '/',
      page: () => HomePage(),
      binding: AppBinding(),
    ),
    GetPage(
      name: '/camera',
      page: () => CameraPage(),
      binding: AppBinding(),
    ),
    GetPage(
      name: '/imgPicker',
      page: () => ImgPickerPage(),
      binding: AppBinding(),
    ),
    GetPage(
      name: '/map',
      page: () => MapPage(),
      binding: AppBinding(),
    ),
    GetPage(
      name: '/markerclustering',
      page: () => MarkerClusteringPage(),
      binding: AppBinding(),
    ),
    GetPage(
      name: '/drawpolyline',
      page: () => DrawPolylinePage(),
      binding: AppBinding(),
    ),
    GetPage(
      name: '/polygonclip',
      page: () => PolygonClipPage(),
      binding: AppBinding(),
    ),
  ];
}
