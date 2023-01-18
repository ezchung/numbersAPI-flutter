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

class Fact {
    Fact({
        this.fragment,
        this.number,
        this.statement,
        this.type,
    });

    String? fragment;
    int? number;
    String? statement;
    String? type;

    factory Fact.fromJson(Map<String, dynamic> json) => Fact(
        fragment: json["fragment"],
        number: json["number"],
        statement: json["statement"],
        type: json["type"],
    );

    Map<String, dynamic> toJson() => {
        "fragment": fragment,
        "number": number,
        "statement": statement,
        "type": type,
    };
}
