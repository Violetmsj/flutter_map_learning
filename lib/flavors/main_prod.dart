import 'package:flutter/material.dart';
import 'package:flutter_map_learning/flavors/flavor_config.dart';
import 'package:flutter_map_learning/flavors/main_common.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlavorConfig.create(
    appName: 'app-prod',
    apiUrl: 'http:www.prod.com',
    flavor: Flavor.prod,
  );
  await mainCommon();
}
