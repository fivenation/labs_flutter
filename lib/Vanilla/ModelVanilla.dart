import 'dart:convert';

import 'package:http/http.dart' as http;

class ModelVanilla {
  int userId;
  int id;
  String title;
  String body;

  ModelVanilla({
    required this.userId,
    required this.id,
    required this.title,
    required this.body
  });

  factory ModelVanilla.fromJson(Map<String, dynamic> json) {
    return ModelVanilla(
      id: json['id'],
      userId: json['userId'],
      body: json['body'],
      title: json['title'],
    );
  }
}

Future<List<ModelVanilla>> getModelVanilla() async {
  final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
  if (response.statusCode == 200) {
    List<dynamic> body = jsonDecode(response.body);
    List<ModelVanilla> result = body.map((dynamic item) => ModelVanilla.fromJson(item),).toList();
    return result;
  } else {
    throw "Unable to get data";
  }
}