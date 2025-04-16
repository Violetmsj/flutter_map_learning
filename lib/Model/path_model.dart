
class PathModel {
  String? status;
  String? info;
  String? infocode;
  String? count;
  Route? route;

  PathModel({this.status, this.info, this.infocode, this.count, this.route});

  PathModel.fromJson(Map<String, dynamic> json) {
    if(json["status"] is String) {
      status = json["status"];
    }
    if(json["info"] is String) {
      info = json["info"];
    }
    if(json["infocode"] is String) {
      infocode = json["infocode"];
    }
    if(json["count"] is String) {
      count = json["count"];
    }
    if(json["route"] is Map) {
      route = json["route"] == null ? null : Route.fromJson(json["route"]);
    }
  }

  static List<PathModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(PathModel.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["status"] = status;
    _data["info"] = info;
    _data["infocode"] = infocode;
    _data["count"] = count;
    if(route != null) {
      _data["route"] = route?.toJson();
    }
    return _data;
  }
}

class Route {
  String? origin;
  String? destination;
  String? taxiCost;
  List<Paths>? paths;

  Route({this.origin, this.destination, this.taxiCost, this.paths});

  Route.fromJson(Map<String, dynamic> json) {
    if(json["origin"] is String) {
      origin = json["origin"];
    }
    if(json["destination"] is String) {
      destination = json["destination"];
    }
    if(json["taxi_cost"] is String) {
      taxiCost = json["taxi_cost"];
    }
    if(json["paths"] is List) {
      paths = json["paths"] == null ? null : (json["paths"] as List).map((e) => Paths.fromJson(e)).toList();
    }
  }

  static List<Route> fromList(List<Map<String, dynamic>> list) {
    return list.map(Route.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["origin"] = origin;
    _data["destination"] = destination;
    _data["taxi_cost"] = taxiCost;
    if(paths != null) {
      _data["paths"] = paths?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}

class Paths {
  String? distance;
  String? restriction;
  List<Steps>? steps;

  Paths({this.distance, this.restriction, this.steps});

  Paths.fromJson(Map<String, dynamic> json) {
    if(json["distance"] is String) {
      distance = json["distance"];
    }
    if(json["restriction"] is String) {
      restriction = json["restriction"];
    }
    if(json["steps"] is List) {
      steps = json["steps"] == null ? null : (json["steps"] as List).map((e) => Steps.fromJson(e)).toList();
    }
  }

  static List<Paths> fromList(List<Map<String, dynamic>> list) {
    return list.map(Paths.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["distance"] = distance;
    _data["restriction"] = restriction;
    if(steps != null) {
      _data["steps"] = steps?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}

class Steps {
  String? instruction;
  String? orientation;
  String? stepDistance;
  String? polyline;

  Steps({this.instruction, this.orientation, this.stepDistance, this.polyline});

  Steps.fromJson(Map<String, dynamic> json) {
    if(json["instruction"] is String) {
      instruction = json["instruction"];
    }
    if(json["orientation"] is String) {
      orientation = json["orientation"];
    }
    if(json["step_distance"] is String) {
      stepDistance = json["step_distance"];
    }
    if(json["polyline"] is String) {
      polyline = json["polyline"];
    }
  }

  static List<Steps> fromList(List<Map<String, dynamic>> list) {
    return list.map(Steps.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["instruction"] = instruction;
    _data["orientation"] = orientation;
    _data["step_distance"] = stepDistance;
    _data["polyline"] = polyline;
    return _data;
  }
}