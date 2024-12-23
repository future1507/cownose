// To parse this JSON data, do
//
//     final nosetest = nosetestFromJson(jsonString);

import 'dart:convert';

List<Nosetest> nosetestFromJson(String str) => List<Nosetest>.from(json.decode(str).map((x) => Nosetest.fromJson(x)));

String nosetestToJson(List<Nosetest> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Nosetest {
  int id;
  String name;
  String? desc;
  String? img;

  Nosetest({
    required this.id,
    required this.name,
    required this.desc,
    required this.img,
  });

  factory Nosetest.fromJson(Map<String, dynamic> json) => Nosetest(
    id: json["id"],
    name: json["name"],
    desc: json["desc"],
    img: json["img"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "desc": desc,
    "img": img,
  };
}
