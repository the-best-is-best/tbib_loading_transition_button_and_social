// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tbib_loading_transition_button_and_social/tbib_loading_transition_button_and_social.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sign in Button Demo',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: const MyHomePage(title: 'Loading Button Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String _buttonClick = "click sign in button";
  final _controllerSign = LoadingSignButtonController();
  final _controller = LoadingButtonController();
  bool signInAnimPage = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: !signInAnimPage
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    LoadingButton(
                      controller: _controller,
                      color: Colors.blue,
                      errorColor: Colors.red,
                      child: const Text("Test"),
                      durationSuccess: const Duration(seconds: 1),
                      duration: const Duration(milliseconds: 500),
                      successWidget: const FaIcon(FontAwesomeIcons.checkCircle),
                      onSubmit: () {
                        print('onSubmit');
                      },
                    ),
                    const SizedBox(height: 5.0),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () => _controller.startLoadingAnimation(),
                          child: const Text('Start'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () => _controller.stopLoadingAnimation(),
                          child: const Text('Stop'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () => _controller.onError(),
                          child: const Text('Error'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () => _controller.onSuccess(),
                          child: const Text('success'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5.0),
                    ElevatedButton(
                      onPressed: () => setState(() {
                        signInAnimPage = true;
                      }),
                      child: const Text('Sign Button'),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      _buttonClick,
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    const SizedBox(height: 5.0),
                    LoadingSignButton(
                      controller: _controllerSign,
                      buttonType: ButtonType.google,
                      progressIndicatorColor: Colors.grey,
                      durationSuccess: const Duration(seconds: 1),
                      duration: const Duration(milliseconds: 500),
                      successWidget: const FaIcon(FontAwesomeIcons.checkCircle),
                      onSubmit: () {
                        _controllerSign.startLoadingAnimation();
                        //  _buttonClick = "google";
                      },
                      fontSize: 20,
                      imageSize: 16,
                    ),
                    const SizedBox(height: 5.0),
                    LoadingSignButton.mini(
                      controller: _controllerSign,
                      buttonType: ButtonType.google,
                      progressIndicatorColor: Colors.grey,
                      durationSuccess: const Duration(seconds: 1),
                      duration: const Duration(milliseconds: 500),
                      successWidget: const FaIcon(FontAwesomeIcons.checkCircle),
                      onSubmit: () {},
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () =>
                              _controllerSign.startLoadingAnimation(),
                          child: const Text('Start'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () =>
                              _controllerSign.stopLoadingAnimation(),
                          child: const Text('Stop'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () => _controllerSign.onError(),
                          child: const Text('Error'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () => _controllerSign.onSuccess(),
                          child: const Text('success'),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    ElevatedButton(
                      onPressed: () => setState(() {
                        signInAnimPage = false;
                      }),
                      child: const Text('Normal Button'),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
