import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:zeus/add_new_phase/model/resources_needed.dart';
import 'package:zeus/navigation/skills_model/skills_response_project.dart';
import 'package:zeus/utility/app_url.dart';

class SearchTextClass extends StatefulWidget {
  const SearchTextClass({Key? key}) : super(key: key);

  @override
  State<SearchTextClass> createState() => _SearchTextClassState();
}

class _SearchTextClassState extends State<SearchTextClass> {
  AutoCompleteTextField? searchTextField;
  GlobalKey<AutoCompleteTextFieldState<Datum>> key = new GlobalKey();
  static List<Datum> users = <Datum>[];
  bool loading = true;
  List _search = [];
  var currentElement;
  String dropdownvalue = 'Item 1';

  // List of items in our dropdown menu

  void getUsers() async {
    var response = await http.get(
      Uri.parse(AppUrl.tags_search),
      headers: {
        "Accept": "application/json",
        "Authorization":
            'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiZTE4M2M5ZGNiZGJjNTk3YjM5NzdiODI0OTNiN2QxMTRkYjU3ZTVhZTZhNTM3ZTY4Y2Q0MWI4ZDA4ZTAyZjA4MjU4Nzc0MzM4ZmU5ZWM4YWIiLCJpYXQiOjE2NjIwMzQ3OTEuODg0OTkyLCJuYmYiOjE2NjIwMzQ3OTEuODg0OTk2LCJleHAiOjE2OTM1NzA3OTEuNzczMTM3LCJzdWIiOiIxMSIsInNjb3BlcyI6W119.cJL-V0Bg4NJLIJhulUrMe9RCeYLP1VXars1mYrfaxDQim6yJpBhGsVN-ae2j2Eol2OtvJTBh2B3w5xJQOJyxzHDbmi848qkpwybbDnGX-7d3qDgjPhzrJmJ4jgjPngDUVMAO6g1CNaLSf3iILAjq-K5zVpfLVJDclkCjI9JBssWDPaV9XOtyZjgbyyGuA6a1ANKIX9fD0wryNkg4SgYrKTyqClyPjdFmBt0M6t92EoJv2O_SKR26uQgr490V0Hc1wScL2un1ZpDbjUC1px-8pAuXu7OLUnLomes2ppHFgBTZbxibjp5yZ_5_u6z_VtqkweRgC2XQpZSt8Z8g_YwaYZ-0-fSYQhZPfrhV_WG92fQs_AUB32EHplpmjvDqXqflLFzY9HlEcbQQbshnYjW982cNa4sQfeaPPL6FqTIsPiQnzOg3eOfHoD_j0CFNvS6v5FL3iNqscgpQt5bxptx1NuOyX_GJ88mTlJeLcAnzJw949Lz0HoZARbeNMyTj5fmdbRQB4t2Vh6wWbUW2ZBRxz1ivSm5B1s3ZOcSG00GvujLEYbKz2yCaAQCHt3OA0d6ePLlmloBp3jSfKSi5rppGKGEDCAFuLCtCwChOKsWv_u2hp8AeiiJasIZpfjJ1y0S50AxBvcbO6tXzjjSxGwRPwV0ieBaQ9MCU0PuITlTlu-s'
      },
    );
    if (response.statusCode == 200) {
      print("sucess");
      var user = userFromJson(response.body);

      users = user.data!;
      // print('Users: ${users.length}');
      setState(() {
        loading = false;
      });
    } else {
      print("Error getting users.");
      // print(response.body);
    }
  }

  var items = [
    'Item 1',
    //'Item 2',
  ];

  sers(String jsonString) {
    final parsed = json.decode(jsonString).cast<Map<String, dynamic>>();
    return parsed.map<User>((json) => User.fromJson(json)).toList();
  }

  @override
  void initState() {
    getUsers();
    super.initState();
  }

  @override
  // Printing all the values in List

  Widget build(BuildContext context) {
    for (var i = 1; i <= 365; i++) {
      items.add("$i");
    }
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton(
              // Initial Value
              value: dropdownvalue,

              // Down Arrow Icon
              icon: const Icon(Icons.keyboard_arrow_down),

              // Array list of items
              items: items.map((String items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text(items),
                );
              }).toList(),
              // After selecting the desired option,it will
              // change button value to selected value
              onChanged: (String? newValue) {
                setState(() {
                  dropdownvalue = newValue!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

Widget row(Datum user) {
  return Container(
    padding: EdgeInsets.all(11.0),
    decoration: BoxDecoration(
      color: Color(0xff0F172A),
    ),
    child: Row(
      children: <Widget>[
        Text(
          user!.title!,
          style: TextStyle(fontSize: 16.0, color: Colors.white),
        ),
        SizedBox(
          width: 9.0,
        ),
        /* Text(
          user!.email!,
        ),*/
      ],
    ),
  );
}

Widget rowProject(SkillsData user) {
  return Container(
    padding: EdgeInsets.all(11.0),
    decoration: BoxDecoration(
      color: Color(0xff0F172A),
    ),
    child: Row(
      children: <Widget>[
        Text(
          user.name.toString(),
          style: TextStyle(fontSize: 16.0, color: Colors.white),
        ),
        SizedBox(
          width: 9.0,
        ),
        /* Text(
          user!.email!,
        ),*/
      ],
    ),
  );
}

Widget rowResourceName(item) {
  return Container(
    padding: EdgeInsets.all(11.0),
    decoration: BoxDecoration(
      color: Color(0xff0F172A),
    ),
    child: Row(
      children: <Widget>[
        Text(
          item.name.toString(),
          style: TextStyle(fontSize: 16.0, color: Colors.white),
        ),
        SizedBox(
          width: 9.0,
        ),
        /* Text(
          user!.email!,
        ),*/
      ],
    ),
  );
}

Widget row1(Datum user) {
  return Container(
    padding: EdgeInsets.all(11.0),
    decoration: BoxDecoration(
      color: Color(0xff0F172A),
    ),
    child: Row(
      children: <Widget>[
        Text(
          user!.title!,
          style: TextStyle(fontSize: 16.0, color: Colors.white),
        ),
        SizedBox(
          width: 9.0,
        ),
        /* Text(
          user!.email!,
        ),*/
      ],
    ),
  );
}

// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  List<Datum>? data;

  factory User.fromJson(Map<String, dynamic> json) => User(
        status: json["status"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.id,
    this.resourceId,
    this.title,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? resourceId;
  String? title;

  DateTime? createdAt;
  DateTime? updatedAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        resourceId: json["resource_id"],
        title: json["title"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "resource_id": resourceId,
        "title": title,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}
