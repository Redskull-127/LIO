import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_acrcloud/flutter_acrcloud.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:video_player/video_player.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // ignore: avoid_print
  print('A bg message just showed up :  ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  var auth = FirebaseMessaging.instance.getToken();
  // ignore: avoid_print
  print(auth);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ACRCloudResponseMusicItem? music;
  late VideoPlayerController _controller;

  @override
  initState() {
    super.initState();
    _controller = VideoPlayerController.asset("assets/video/dots.mp4")
      ..initialize().then((_) {
        _controller.play();
        _controller.setLooping(true);
        setState(() {});
      });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher',
              ),
            ));
      }
      String meer = "yo";
      if (notification!.title == "testing") {
        // ignore: avoid_print
        print(meer);
        print(notification.body);
        // flutterLocalNotificationsPlugin.show(
        //     0,
        //     'New Update!!!',
        //     notification.body,
        //     NotificationDetails(
        //       android: AndroidNotificationDetails(
        //         channel.id,
        //         channel.name,
        //         color: Colors.blue,
        //         playSound: true,
        //         icon: '@mipmap/ic_launcher',
        //       ),
        //     ),
        //     payload: 'Update(Simple)');
      }
    });

    ACRCloud.setUp(const ACRCloudConfig(
        "a5bea24bdcf9f49d3b78fa2bcb7513c9",
        "nhyNN5PkRyrimoCpqzi7uqdx7xuOHlWREmtZlTXU",
        "identify-eu-west-1.acrcloud.com"));
  }

  @override
  Widget build(BuildContext context) {
    const colorizeColors = [
      Colors.purple,
      Colors.blue,
      Colors.yellow,
      Colors.red,
    ];

    var colorizeTextStyle = GoogleFonts.openSans(fontSize: 60);
    return MaterialApp(
        home: SafeArea(
            child: Scaffold(
                backgroundColor: Colors.black,
                body: Stack(children: <Widget>[
                  SizedBox.expand(
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: SizedBox(
                        width: _controller.value.size.width,
                        height: _controller.value.size.height,
                        child: VideoPlayer(_controller),
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 135, top: 125),
                          child: SizedBox(
                            width: 250.0,
                            child: AnimatedTextKit(
                              animatedTexts: [
                                ColorizeAnimatedText(
                                  'LIO',
                                  textStyle: colorizeTextStyle,
                                  colors: colorizeColors,
                                ),
                              ],
                              isRepeatingAnimation: true,
                              repeatForever: true,
                              onTap: () {
                                // ignore: avoid_print
                                print("Tap Event");
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 125),
                          child: Text(
                            "Press Icon To Start...",
                            style: GoogleFonts.openSans(
                                color: Colors.amber, fontSize: 20),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 80),
                          child: AvatarGlow(
                            glowColor: Colors.amber,
                            endRadius: 60.0,
                            child: Builder(
                              builder: (context) => GestureDetector(
                                // ignore: avoid_print
                                onTap: () async {
                                  setState(() {
                                    music = null;
                                  });
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text("Listing ...",
                                        style: GoogleFonts.openSans(
                                            color: Colors.amber)),
                                    backgroundColor: Colors.black,
                                  ));

                                  final session = ACRCloud.startSession();

                                  final result = await session.result;

                                  if (result == null) {
                                    // Cancelled.
                                    return;
                                  } else if (result.metadata == null) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text("No Result ...",
                                          style: GoogleFonts.openSans(
                                              color: Colors.amber)),
                                      backgroundColor: Colors.black,
                                    ));
                                    return;
                                  }

                                  setState(() {
                                    music = result.metadata!.music.first;
                                  });
                                  // SecondRoute(mom: music!.title);
                                  if (music != null) {
                                    Vibrate.vibrate();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SecondRoute(
                                            mom: music!.title,
                                            momn: music!.album.name,
                                            momf: music!.artists.first.name,
                                          ),
                                        ));
                                  }
                                },
                                child: Material(
                                  // Replace this child with your own
                                  elevation: 10.0,
                                  shape: const CircleBorder(),

                                  child: CircleAvatar(
                                    backgroundColor: Colors.black,
                                    child: Image.asset(
                                      'assets/images/alien.png',
                                      height: 90,
                                    ),
                                    radius: 30.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]))));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

class SecondRoute extends StatelessWidget {
  final String? mom;
  final String? momn;
  final String? momf;
  const SecondRoute({Key? key, this.mom, this.momn, this.momf})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const colorizeColors = [
      Colors.purple,
      Colors.blue,
      Colors.yellow,
      Colors.red,
    ];

    var colorizeTextStyle = GoogleFonts.openSans(fontSize: 40);
    var colorizeTextStyle2 = GoogleFonts.openSans(fontSize: 30);
    return MaterialApp(
        home: Scaffold(
            backgroundColor: Colors.black,
            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 200),
                    child: AnimatedTextKit(
                      animatedTexts: [
                        ColorizeAnimatedText(
                          'FOUND IT!',
                          textStyle: colorizeTextStyle,
                          colors: colorizeColors,
                        ),
                      ],
                      isRepeatingAnimation: true,
                      repeatForever: true,
                      onTap: () {
                        // ignore: avoid_print
                        print(mom);
                      },
                    ),
                  ),

                  // ignore: avoid_print

                  if (mom != null) ...[
                    Padding(
                      padding: const EdgeInsets.only(top: 125),
                      child: AnimatedTextKit(
                        animatedTexts: [
                          ColorizeAnimatedText(
                            '$mom\n',
                            textStyle: colorizeTextStyle2,
                            colors: colorizeColors,
                          ),
                        ],
                        isRepeatingAnimation: true,
                        repeatForever: true,
                        onTap: () {},
                      ),
                    ),
                    Text('\nAlbum: $momn',
                        style: GoogleFonts.openSans(
                            color: Colors.amber, fontSize: 18)),
                    Text('By: $momf\n',
                        style: GoogleFonts.openSans(
                            color: Colors.amber, fontSize: 18)),
                  ],
                ]))));
  }
}
