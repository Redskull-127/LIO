import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

void mainfound() => runApp(BackgroundVideo());

class BackgroundVideo extends StatefulWidget {
  const BackgroundVideo({Key? key}) : super(key: key);

  @override
  _BackgroundVideoState createState() => _BackgroundVideoState();
}

class _BackgroundVideoState extends State<BackgroundVideo> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset("assets/video/dots.mp4")
      ..initialize().then((_) {
        _controller.play();
        _controller.setLooping(true);
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: const Color(0xffb55e28),
        colorScheme: ColorScheme.fromSwatch()
            .copyWith(secondary: const Color(0xffffd544)),
      ),
      home: SafeArea(
        child: Scaffold(
          body: Stack(
            children: <Widget>[
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
              const LoginWidget()
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

class LoginWidget extends StatelessWidget {
  final String? mom;
  final String? momn;
  final String? momf;
  const LoginWidget({
    Key? key,
    this.mom,
    this.momn,
    this.momf,
  }) : super(key: key);
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
                        print("Tap Event");
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
