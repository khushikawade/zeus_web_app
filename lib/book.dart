import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

class AutocompleteClass extends StatefulWidget {
  const AutocompleteClass({Key? key}) : super(key: key);

  @override
  State<AutocompleteClass> createState() => _AutocompleteClassState();
}

class _AutocompleteClassState extends State<AutocompleteClass> {

  AutoCompleteTextField? searchTextField;
  GlobalKey<AutoCompleteTextFieldState<User>> key = new GlobalKey();
  static List<User> users = <User>[];
  bool loading = true;

  void getUsers() async {
    try {
      final response =
      await http.get(Uri.parse("https://jsonplaceholder.typicode.com/users"));
      if (response.statusCode == 200) {
        users = loadUsers(response.body);
        print('Users: ${users.length}');
        setState(() {
          loading = false;
        });
      } else {
        print("Error getting users.");
      }
    } catch (e) {
      print("Error getting users.");
    }
  }

  static List<User> loadUsers(String jsonString) {
    final parsed = json.decode(jsonString).cast<Map<String, dynamic>>();
    return parsed.map<User>((json) => User.fromJson(json)).toList();
  }

  @override
  void initState() {
    getUsers();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          loading
              ? CircularProgressIndicator()
              : searchTextField = AutoCompleteTextField<User>(
            key: key,
            clearOnSubmit: false,
            suggestions: users,
            style: TextStyle(color: Colors.black, fontSize: 16.0),
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 20.0),
              hintText: "Search Name",
              hintStyle: TextStyle(color: Colors.black),
            ),
            itemFilter: (item, query) {
              return item.name
                  !.toLowerCase()
                  .startsWith(query.toLowerCase());
            },
            itemSorter: (a, b) {
              return a.name!.compareTo(b.name!);
            },
            itemSubmitted: (item) {
              setState(() {
                searchTextField!.textField!.controller!.text = item.name!;
              });
            },
            itemBuilder: (context, item) {
              // ui for the autocompelete row
              return row(item);
            },
          ),
        ],
      ),
    );
  }
}

Widget row(User user) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Text(
        user.name!,
        style: TextStyle(fontSize: 16.0),
      ),
      SizedBox(
        width: 10.0,
      ),
      Text(
        user.email!,
      ),
    ],
  );
}

class User {
  int? id;
  String? name;
  String? email;

  User({this.id, this.name, this.email});

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return User(
      id: parsedJson["id"],
      name: parsedJson["name"] as String,
      email: parsedJson["email"] as String,
    );
  }
}
