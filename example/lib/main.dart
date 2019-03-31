import 'package:flutter/material.dart';
import 'package:custom_bottom_tab_bar/custom_bottom_tab_bar.dart';
import 'package:custom_bottom_tab_bar/custom_bottom_tab_item.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int _currentIndex = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      bottomNavigationBar: CustomBottomTabBar(
        tabBarHeight: 60.0,
        backgroundColor: Color(0xFFf9f9f9),
        onTap: (index){
          setState(() {
            _currentIndex = index;
          });
        },
        currentIndex: _currentIndex,
        items: <CustomBottomTabItem>[
          CustomBottomTabItem(
            icon: Icon(Icons.home),
            badgeNum: '5',
            title: Text('home')
          ),
          CustomBottomTabItem(
            icon: Icon(Icons.video_call),
            title: Text('视频'),
            badgeNum: 'n',
          ),
          CustomBottomTabItem(
            icon: Icon(Icons.mail),
            title: Text('邮件')
          ),
          CustomBottomTabItem(
            icon: Icon(Icons.account_circle),
            title: Text('我的')
          ),
          CustomBottomTabItem(
            icon: Icon(Icons.account_circle),
            title: Text('我的')
          ),
        ],
      ),
    );
  }
}
