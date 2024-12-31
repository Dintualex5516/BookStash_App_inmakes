import 'dart:convert';

import 'package:book_stash/auth/signup_screen.dart';
import 'package:book_stash/auth/ui/login_screen.dart';
import 'package:book_stash/firebase_options.dart';
import 'package:book_stash/pages/home.dart';
import 'package:book_stash/pages/message_screen.dart';
import 'package:book_stash/service/auth_service.dart';
import 'package:book_stash/service/notification_service.dart';
import 'package:book_stash/utils/toast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

final navigatorKey=GlobalKey<NavigatorState>();

Future _fireBackgroudMessage(RemoteMessage message)async{
  if(message.notification!=null)
  {
    print("A notification found in bckground");

  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await PushNotificationHelper.init();

  await PushNotificationHelper.localNotificationInitialization();

  FirebaseMessaging.onBackgroundMessage(_fireBackgroudMessage);
 
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message){

    if(message.notification!=null){
      print("background notification");
      navigatorKey.currentState!.pushNamed("/message",arguments: message);
    }
  });


FirebaseMessaging.onMessage.listen((RemoteMessage message){
  String payloadContent =jsonEncode(message.data);
  print(" message found in back");
  if(message.notification!=null){
    PushNotificationHelper.showLocalNotification(title: message.notification!.title!,
     body: message.notification!.body!, 
     payload: payloadContent);
  }

});

// TERMINATED STATE

final RemoteMessage? message=
await FirebaseMessaging.instance.getInitialMessage();
if(message!=null){
  print("from terminated state");
  Future.delayed(Duration(seconds: 3),(){
    navigatorKey.currentState!.pushNamed("/message",arguments: message);
  });
}
  




  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title:'flyttert',
      theme: ThemeData(

      ),

      navigatorKey: navigatorKey,

    // home: LoginScreen(),
    routes: {
      "/":(context)=>CheckUserBookStash(),
      "/login":(context)=>LoginScreen(),
      "/home":(context)=>Home(),
      "/signup":(context)=>SignupScreen(),

      "/message":(context)=>MessageScreen(),
    },

    );
  }
}

class CheckUserBookStash extends StatefulWidget {
  const CheckUserBookStash({super.key});

  @override
  State<CheckUserBookStash> createState() => _CheckUserBookStashState();
}

class _CheckUserBookStashState extends State<CheckUserBookStash> {
@override
  void initState() {
    AuthServiceHelper.isUserLoggedIn().then((value){
      if(value){
        Navigator.pushReplacementNamed(context, "/home");
      }else{
        Navigator.pushReplacementNamed(context, "/login");
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}