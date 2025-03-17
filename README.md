# Flutter Map Learning

这是一个用于学习和探索Flutter地图相关功能的示例项目。本项目主要基于flutter_map库，集成了多个地理信息处理库，实现了地图显示、标记点聚合、多边形绘制和编辑等功能。

## 功能特性

- 基础地图显示和控制
- 标记点（Marker）添加和聚合
- 多边形（Polygon）绘制和编辑
- 折线（Polyline）绘制和编辑
- 多边形裁剪操作
- 相机和图片选择功能
- 经纬度坐标转换工具

## 项目结构

```
lib/
├── main.dart                    # 应用程序入口
├── app_binding.dart             # GetX依赖注入配置
├── app_pages.dart               # 路由配置
├── get_controller/             
│   ├── get_camera_controller.dart # 相机控制器
│   └── loading_controller.dart    # 加载状态控制器
├── pages/
│   ├── home_page.dart            # 首页
│   ├── map_page.dart             # 地图页面
│   ├── marker_clustering_page.dart # 标记点聚合页面
│   ├── draw_polygon_page.dart     # 多边形绘制页面
│   ├── draw_polyline_page.dart    # 折线绘制页面
│   ├── polygon_clip_page.dart     # 多边形裁剪页面
│   ├── polyline_edit.dart         # 折线编辑页面
│   ├── camera_page.dart           # 相机页面
│   └── img_picker_page.dart       # 图片选择页面
└── utils/
    ├── util_clip_polygon.dart     # 多边形裁剪工具
    └── util_latlng_converter.dart # 经纬度转换工具
```

## 使用的主要第三方库

- **flutter_map**: ^7.0.2 - 基础地图显示和控制
- **latlong2**: ^0.9.0 - 经纬度坐标处理
- **flutter_map_marker_cluster**: ^1.4.0 - 标记点聚合功能
- **flutter_map_line_editor**: ^7.0.0 - 折线编辑工具
- **flutter_map_dragmarker**: ^7.0.0 - 可拖动标记点
- **turf**: ^0.0.10 - 地理空间分析工具
- **polybool**: ^0.2.0 - 多边形布尔运算
- **geodesy**: ^0.10.2 - 大地测量计算
- **get**: ^4.7.2 - 状态管理和路由
- **camera**: ^0.11.1 - 相机功能
- **image_picker**: ^1.1.2 - 图片选择功能

## 运行要求

- Flutter SDK: ^3.6.1
- Dart SDK: ^3.6.1

## 权限说明

本应用需要以下权限：

- 网络访问权限（用于加载地图）
- 相机权限（用于拍照功能）
- 存储权限（用于保存图片）

## 开始使用

1. 确保已安装Flutter开发环境
2. 克隆项目到本地
3. 运行以下命令安装依赖：
   ```bash
   flutter pub get
   ```
4. 运行项目：
   ```bash
   flutter run
   ```

## 注意事项

- 首次运行时请确保网络连接正常，以便加载地图数据
- 部分功能可能需要定位权限，请在使用时授予相应权限