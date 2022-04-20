import 'dart:async';
import 'package:flutter/material.dart';
import 'ModelPosts.dart';

/// https://jsonplaceholder.typicode.com/posts - API link

/// BLOC ARCHITECTURE
/// MODEL => BLOC => VIEW
/// 1) UI is separated from business logic;
/// 2) BLoC object manages UI;
/// 3) All business logic is contained in the BLoC object;
/// 4) HomePage now - is a Stateless Widget;
/// 5) Interface is controlled by Stream;
/// 6) Reactivity - there are no additional methods for controlling the state;
/// 7) BLoC object does State Management;

// BLoC CLASS

class PostsBloc {
  PostsBloc(this._repository);

  final PostsRepository _repository;

  final _controller = StreamController<PostsResult>();

  Stream<PostsResult> get posts => _controller.stream;

  void loadPosts() {
    _controller.sink.add(PostsResultLoading());
    _repository.getModelVanilla().then((result) {
      _controller.sink.add(PostsResultSuccess(result));
    }).catchError((error) {
      _controller.sink.add(PostsResultError(error));
    });
  }

  void dispose() {
    _controller.close();
  }
}

// PRESENTER (VIEW)

class HomePageBloc extends StatelessWidget {
  HomePageBloc({Key? key}) : super(key: key);
  final _repository = PostsRepository();
  late final PostsBloc _postsBloc;

  @override
  Widget build(BuildContext context) {
    _postsBloc = PostsBloc(_repository);
    _postsBloc.loadPosts();

    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          title: const Text('Architecture BLoC'),
          actions: [ IconButton( onPressed: () { _postsBloc.loadPosts(); }, icon: const Icon(Icons.refresh),) ],
        ),
        body: SafeArea(
          child: StreamBuilder<PostsResult>(
            stream: _postsBloc.posts,
            initialData: PostsResultLoading(),
            builder: (context, snapshot) => snapshot.data is PostsResultLoading
                  ? _buildProgress()
                  : snapshot.data is PostsResultError
                  ? _buildError((snapshot.data as PostsResultError).error)
                  : _buildContent((snapshot.data as PostsResultSuccess).posts),
          ),
        ),
      );
  }

}

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