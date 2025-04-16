enum Flavor {
  dev,
  prod,
}

class FlavorConfig {
  /// App 名字
  final String appName;

  /// Api 地址
  final String apiUrl;

  /// 当前环境
  final Flavor flavor;

  static FlavorConfig shared = FlavorConfig.create();

  factory FlavorConfig.create({
    String appName = "",
    String apiUrl = "",
    Flavor flavor = Flavor.dev,
  }) {
    return shared =
        FlavorConfig(appName: appName, apiUrl: apiUrl, flavor: flavor);
  }

  FlavorConfig(
      {required this.appName, required this.apiUrl, this.flavor = Flavor.dev});
}
