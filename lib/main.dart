import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized;
  AwesomeNotifications().initialize(null, [NotificationChannel(channelKey: "testing_channel", channelName: "Testing Channel", channelDescription: "Testing Channel Description")], debug: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) { return MaterialApp(home: const MyHomePage(), navigatorKey: navigatorKey,); }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String statusString = "";
  bool isLoading = false;

  _MyHomePageState(): super() {
    Future.delayed(const Duration(milliseconds: 100), () {
      notificationExample(isStarting: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Current state is:'),
            Text(statusString),
      ])),
      
      floatingActionButton: FloatingActionButton(
        onPressed: isLoading ? null : () => notificationExample(),
        child: Icon(Icons.circle, color: isLoading ? Colors.grey : Colors.black),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void Test() {
    AwesomeNotifications().requestPermissionToSendNotifications().then((value) {
      showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) => AlertDialog(
        title: const Text("Value is"),
        actions: [TextButton(
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(), // dismisses only the dialog and returns nothing
            child: Text(value.toString())
          )]));
    }); 
  }

  void notificationExample({bool isStarting = false}) async{
    setState(() { statusString = "Loading..."; isLoading = true; });

    //Show a popup to indicate that it reached the AwesomeNotifications permission request
    //Uncomment to use as a debugging method when debugger is disconnected
    /*await showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) => AlertDialog(
        title: const Text("Before"),
        actions: [TextButton(
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(), // dismisses only the dialog and returns nothing
            child: const Text('OK')
          )]));*/

    //Checking if the permission is allowed, if not then ensure that app isn't just starting, then requestPermission.
    if (!await AwesomeNotifications().isNotificationAllowed() && (isStarting || !await AwesomeNotifications().requestPermissionToSendNotifications().then((value) { print('\x1B[31mReturned!\x1B[0m'); return value;}))) {
        //If permission denied set status to denied.
        setState(() { statusString = "Permission Denied, Click the bell to enable Notifications"; isLoading = false; });
        return; //Important Return
    }

    //Show a popup to indicate that it has passed the AwesomeNotifications permission request
    //Uncomment to use as a debugging method when debugger is disconnected
    /*await showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) => AlertDialog(
        title: const Text("After"),
        actions: [TextButton(
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(), // dismisses only the dialog and returns nothing
            child: const Text('OK')
          )]));*/
    
    setState(() { statusString = "Notification Loaded Successfully!"; isLoading = false; });


    //Show notification
    Random random = Random();
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: random.nextInt(1000) + 1,
        channelKey: "alerts", //testing_channel
        title: "Test Notification",
        body: "This is a test description."
        )
      );
  }
}