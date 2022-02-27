import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:labs_flutter/Vanilla/ModelVanilla.dart';

/// https://jsonplaceholder.typicode.com/posts - API link

class HomePageVanilla extends StatefulWidget{
  const HomePageVanilla({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HomePageVanillaState();
  }

}

class HomePageVanillaState extends State<HomePageVanilla>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('My Flutter Labs'),
        actions: [ IconButton(onPressed: () => setState(() {}), icon: const Icon(Icons.refresh),) ],
      ),
      body: FutureBuilder(
        future: Future.delayed(const Duration(seconds: 2), () => getModelVanilla()),
        builder: (BuildContext context, AsyncSnapshot<List<ModelVanilla>> snapshot) =>
          snapshot.hasData ? _messagesList(snapshot.data!)
            : snapshot.hasError ? _error(snapshot.error)
              : _progress(),
      ),
    );
  }

  Widget _progress() {
    return Center(
      child: CircularProgressIndicator(
        color: ThemeData.light().primaryColor,
      ),
    );
  }

  Widget _error(dynamic error) {
    return Center(
      child: Text(
        'Error: $error',
      ),
    );
  }

  Widget _messagesList(List<ModelVanilla> response) {
    return ListView.builder(
      itemCount: response.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
          elevation: 2.0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  response[index].title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  textDirection: TextDirection.ltr,
                ),
                Text(
                  response[index].body,
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