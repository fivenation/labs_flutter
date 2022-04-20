import 'package:flutter/material.dart';
import 'package:labs_flutter/ModelPosts.dart';
import 'package:scoped_model/scoped_model.dart';

/// https://jsonplaceholder.typicode.com/posts - API link

/// SCOPED MODEL ARCHITECTURE
/// MODEL => SCOPED MODEL => VIEW
/// 1) UI is separated from business logic;
/// 2) Scoped Model manages UI;
/// 3) All business logic is contained in the Scoped Model;
/// 4) HomePage now - is a Stateless Widget;
/// 5) Scoped Model does State Management;

// POSTS MODEL (SCOPED MODEl)

class PostsModel extends Model {
  PostsModel(this._repository);

  final PostsRepository _repository;

  late PostsResult _posts;

  PostsResult get posts => _posts;

  void loadPosts() {
    _posts = PostsResultLoading();
    notifyListeners();
    _repository.getModelVanilla().then((result) {
      _posts = PostsResultSuccess(result);
      notifyListeners();
    }).catchError((error) {
      _posts = PostsResultError(error);
      notifyListeners();
    });
  }

  static PostsModel of(BuildContext context) =>
      ScopedModel.of<PostsModel>(context);
}

// PRESENTATION (VIEW)

class HomePageScopedModel extends StatelessWidget {
  HomePageScopedModel({Key? key}) : super(key: key);
  final _repository = PostsRepository();
  late final PostsModel _postsModel;

  @override
  Widget build(BuildContext context) {
    _postsModel = PostsModel(_repository);
    _postsModel.loadPosts();
    return ScopedModel(
      model: _postsModel,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          title: const Text('Architecture Scoped Model'),
          actions: [ IconButton( onPressed: () { _postsModel.loadPosts(); }, icon: const Icon(Icons.refresh), ) ],
        ),
        body: SafeArea(
          child: ScopedModelDescendant<PostsModel>(
              builder: (context, child, model) => _viewBuild(model)),
        ),
      ),
    );
  }

  Widget _viewBuild(PostsModel _postsModel) =>
      _postsModel._posts is PostsResultLoading
          ? _buildProgress()
          : _postsModel._posts is PostsResultError
          ? _buildError((_postsModel._posts as PostsResultError).error)
          : _buildContent((_postsModel._posts as PostsResultSuccess).posts);

  // UI COMPONENTS

  Widget _buildProgress() {
    return Center(
      child: CircularProgressIndicator(
        color: ThemeData.light().primaryColor,
      ),
    );
  }

  Widget _buildError(dynamic error) {
    return Center(
      child: Text(
        'Error: $error',
      ),
    );
  }

  Widget _buildContent(List<ModelPosts> response) {
    return ListView.builder(
      itemCount: response.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 2.0,
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  response[index].title,
                  style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  textDirection: TextDirection.ltr,
                ),
                Text(
                  response[index].body,
                  style: const TextStyle(fontSize: 18),
                  textDirection: TextDirection.ltr,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}