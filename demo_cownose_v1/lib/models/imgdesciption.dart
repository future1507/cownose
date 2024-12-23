// To parse this JSON data, do
//
//     final imagesDesciption = imagesDesciptionFromJson(jsonString);

import 'dart:convert';

ImagesDesciption imagesDesciptionFromJson(String str) => ImagesDesciption.fromJson(json.decode(str));

String imagesDesciptionToJson(ImagesDesciption data) => json.encode(data.toJson());

class ImagesDesciption {
  String img1Kp;
  String img2Kp;
  String result;

  ImagesDesciption({
    required this.img1Kp,
    required this.img2Kp,
    required this.result,
  });

  factory ImagesDesciption.fromJson(Map<String, dynamic> json) => ImagesDesciption(
    img1Kp: json["img1kp"],
    img2Kp: json["img2kp"],
    result: json["result"],
  );

  Map<String, dynamic> toJson() => {
    "img1kp": img1Kp,
    "img2kp": img2Kp,
    "result": result,
  };
}
