// To parse this JSON data, do
//
//     final matchingDesciption = matchingDesciptionFromJson(jsonString);

import 'dart:convert';

MatchingDesciption matchingDesciptionFromJson(String str) => MatchingDesciption.fromJson(json.decode(str));

String matchingDesciptionToJson(MatchingDesciption data) => json.encode(data.toJson());

class MatchingDesciption {
  int goodMatches;
  int matches;
  double score;

  MatchingDesciption({
    required this.goodMatches,
    required this.matches,
    required this.score,
  });

  factory MatchingDesciption.fromJson(Map<String, dynamic> json) => MatchingDesciption(
    goodMatches: json["goodMatches"],
    matches: json["matches"],
    score: json["score"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "goodMatches": goodMatches,
    "matches": matches,
    "score": score,
  };
}
