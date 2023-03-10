import 'package:flutter/foundation.dart';

class ModelsModel {
  final String id;
  final int created;
  final String root;

  ModelsModel({required this.id, required this.root, required this.created});
  factory ModelsModel.fromJson(Map<String, dynamic> json) =>
      ModelsModel(id: json["id"], created: json["created"], root: json["root"]);

  static List<ModelsModel> modelsSnapshot(List modelsSnapshot) {
    return modelsSnapshot.map((data) => ModelsModel.fromJson(data)).toList();
  }
}
