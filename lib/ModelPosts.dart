import 'dart:convert';

import 'package:http/http.dart' as http;

class ModelPosts {
  int userId;
  int id;
  String title;
  String body;

  ModelPosts({
    required this.userId,
    required this.id,
    required this.title,
    required this.body
  });

  factory ModelPosts.fromJson(Map<String, dynamic> json) {
    return ModelPosts(
      id: json['id'],
      userId: json['userId'],
      body: json['body'],
      title: json['title'],
    );
  }
}

class PostsRepository {
  Future<List<ModelPosts>> getModelVanilla() async {
    final response = await Future.delayed(const Duration(seconds: 1), () => http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts')));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<ModelPosts> result = body.map((dynamic item) => ModelPosts.fromJson(item),).toList();
      return result;
    } else {
      throw "Unable to get data";
    }
  }
}

abstract class PostsResult { }

class PostsResultSuccess extends PostsResult {
  final List<ModelPosts> posts;
  PostsResultSuccess(this.posts);
}

class PostsResultError extends PostsResult {
  final String error;
  PostsResultError(this.error);
}

class PostsResultLoading extends PostsResult {
  PostsResultLoading();
}