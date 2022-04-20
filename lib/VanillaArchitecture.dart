import 'package:flutter/material.dart';
import 'package:labs_flutter/ModelPosts.dart';

/// https://jsonplaceholder.typicode.com/posts - API link

/// VANILLA ARCHITECTURE
/// MODEL => STATEFUL WIDGET => STATE
/// 1) Stateful widget HomePageVanilla has state - _posts;
/// 2) State manages by setState() in function _initPosts();
/// 3) Method _viewBuild manage UI components, depending on _posts;

class HomePageVanilla extends StatefulWidget{
  HomePageVanilla({Key? key}) : super(key: key);

  final repository = PostsRepository();

  @override
  State<StatefulWidget> createState() => _HomePageVanillaState();
}

class _HomePageVanillaState extends State<HomePageVanilla>{
  late PostsResult _posts;
  
  void _initPosts() {
    widget.repository.getModelVanilla()
        .then((result) => setState(() => _posts = PostsResultSuccess(result)))
        .catchError((error) => setState(() => _posts = PostsResultError(error)));
    setState(() => _posts = PostsResultLoading());
  }

  @override
  void initState() {
    super.initState();
    _initPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Architecture Vanilla'),
        actions: [ IconButton(onPressed: () => _initPosts(), icon: const Icon(Icons.refresh),) ],
      ),
      body: SafeArea(
        child: _viewBuild(),
      ),
    );
  }

  // VIEW LOGIC

  Widget _viewBuild() => _posts is PostsResultLoading ? _buildProgress()
        : _posts is PostsResultError ? _buildError((_posts as PostsResultError).error)
        : _buildContent((_posts as PostsResultSuccess).posts);

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
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
