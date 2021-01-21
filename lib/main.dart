import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_mask/model/store.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final stores = List<Store>();
  var isLoading = true;

  Future fetch() async {
    isLoading = true;
    var url =
        'https://gist.githubusercontent.com/junsuk5/bb7485d5f70974deee920b8f0cd1e2f0/raw/063f64d9b343120c2cb01a6555cf9b38761b1d94/sample.json?lat=37.266389&lng=126.999333&m=5000';
    var response = await http.get(url);

    final jsonResult = jsonDecode(response.body);
    // print(jsonResult['stores']);
    final jsonStores = jsonResult['stores'];
    setState(() {
      stores.clear();
      jsonStores.forEach((e) {
        stores.add(Store.fromJson(e));
      });
    });

    // print('Response status: ${response.statusCode}');
    // print('Response body: ${response.body}');//${(utf8.decode(response.bodyBytes))}');
    isLoading = false;
  }

  @override
  void initState() {
    super.initState();
    fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('마스크 재고 있는 곳 : ${stores.where((e) =>
          e.remainStat == 'plenty' ||
              e.remainStat == 'some' ||
              e.remainStat == 'few').length}곳'),
          actions: [IconButton(icon: Icon(Icons.refresh), onPressed: fetch)],
        ),
        body: isLoading
            ? loadingWidget()
            : ListView(
                children: stores
                    .where((e) =>
                        e.remainStat == 'plenty' ||
                        e.remainStat == 'some' ||
                        e.remainStat == 'few')
                    .map((e) {
                  return ListTile(
                    title: Text(e.name),
                    subtitle: Text(e.addr),
                    trailing: _buildRemainStatWidget(e),
                  );
                }).toList(),
              ));
  }

  Widget _buildRemainStatWidget(Store store) {
    var remainStat = '매진';
    var description = '판매중지';
    var color = Colors.black;

    switch (store.remainStat) {
      case 'plenty':
        remainStat = '충분';
        description = '100개 이상';
        color = Colors.green;
        break;
      case 'some':
        remainStat = '보통';
        description = '30~100개';
        color = Colors.yellow;
        break;
      case 'few':
        remainStat = '부족';
        description = '2~30개';
        color = Colors.red;
        break;
      case 'empty':
        remainStat = '소진임박';
        description = '1개 이하';
        color = Colors.grey;
        break;
    }
    return Column(
      children: [
        Text(
          remainStat,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
        Text(
          description,
          style: TextStyle(color: color),
        ),
      ],
    );
  }

  Widget loadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('정보를 가져오는 중'),
          CircularProgressIndicator(),
        ],
      ),
    );
  }
}
