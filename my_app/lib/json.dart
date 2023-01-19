// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);
import 'dart:developer';
import 'dart:convert';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

// Welcome welcomeFromJson(String jsonString) {
//   final jsonData = json.decode(jsonString);
//   return Welcome.fromJson(jsonData);
// }

// String welcomeToJson(Welcome data) => json.encode(data!.toJson());

class Welcome {
    Welcome({
        required this.fact,
    });

    Fact? fact;

    factory Welcome.fromJson(Map<String, dynamic> json) {
      print("In json");
      // print(Fact.fromJson(json["fact"]).fragment);
      return Welcome(
        fact: Fact.fromJson(json["fact"]),
      );
    }

    // Map<String, dynamic> toJson() => {
    //     "fact": fact!.toJson(),
    // };
}

// Math & Trivia
class Fact {
    Fact({
        this.fragment,
        this.number,
        this.statement,
        this.type,
    });

    String? fragment;
    String? number;
    String? statement;
    String? type;

    factory Fact.fromJson(Map<String, dynamic> json) {
      if (json["type"] == "math" || json["type"] == "trivia"){
        return Fact(
          fragment: json["fragment"],
          number: json["number"].toString(),
          statement: json["statement"],
          type: json["type"],
        );
      } else if (json["type"] == "year"){
        return Fact(
          fragment: json["fragment"],
          number: json["year"].toString(),
          statement: json["statement"],
          type: '${json["type"]}s',
        );
      } else {
        return Fact(
          fragment: json["fragment"],
          number: '${json["month"]}/${json["day"]}',
          statement: json["statement"],
          type: '${json["type"]}s',
        );
      }
    }

    Map<String, dynamic> toJson() => {
        "fragment": fragment,
        "number": number,
        "statement": statement,
        "type": type,
    };
}
