import 'package:flutter/material.dart';
import 'package:flutter_map_learning/app_binding.dart';
import 'package:flutter_map_learning/app_pages.dart';
import 'package:flutter_map_learning/get_controller/get_camera_controller.dart';
import 'package:get/get.dart';

Future<void> mainCommon() async {
  final getCameraController = Get.put(GetCameraController());
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // final CameraDescription camera;
  const MyApp({
    super.key,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialBinding: AppBinding(),
      initialRoute: "/",
      getPages: AppPages.routes,
      // home: HomePage(),
    );
  }
}
