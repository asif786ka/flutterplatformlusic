import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Declaration of method channel for communication between flutter code and
  // native code
  MethodChannel methodChannel = MethodChannel("music");

  // Variable used to setState of the Play/Stop button according to the running
  // status of the music service
  late bool isServiceRunning;

  @override
  void initState() {
    isServiceRunning = false;
    super.initState();
  }

  //Using method channel to invoke native code to play music
  void startService() async {
    bool data = await methodChannel.invokeMethod("startMusic");
    setState(() {
      isServiceRunning = data;
    });
  }

  //Using method channel to invoke native code to stop music
  void stopService() async {
    bool data = await methodChannel.invokeMethod("stopMusic");
    setState(() {
      isServiceRunning = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Music Player Example"),
      ),
      body: Container(
          child: Center(
              child: MaterialButton(
                child: Text(isServiceRunning?"Stop":"Play"),
                color: Colors.white,
                onPressed: isServiceRunning?stopService:startService,
              )
          )
      ),
    );
  }
}