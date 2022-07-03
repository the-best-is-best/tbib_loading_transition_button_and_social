#TBIB Loading Transition button

A Customizable transition button for Flutter

## Getting Started

To use this package, add `tbib_loading_transition_button_and_social` as a dependency in your `pubspec.yaml` file.

```yaml
dependencies:
 ...
 tbib_loading_transition_button_and_social: ^1.0.0
```

## How to use

In your project add the following import:

```dart
import  'package:tbib_loading_transition_button_and_social/tbib_loading_transition_button_and_social.dart';
```

In order to use this widget you have to use a `LoadingButtonController` to handler the different states.

```dart
final _controller = LoadingButtonController();
```

This widget starts a loading animation once it's tapped or by using the controller. You can the launcher to
init an error animation or stop the loading animation.

```dart
LoadingButton(
    color: Colors.blue,
    onSubmit: () => print('onSubmit'),
    controller: _controller,
    errorColor: Colors.red,
    transitionDuration: Duration(seconds: 1),
    child: Text(
    'Hit me!',
    style: Theme.of(context)
        .textTheme
        .bodyText1!
        .copyWith(color: Colors.white),
    ),
),
```

To support the transition to a different page to have to call the `moveToScreen` method

```dart
_controller.moveToScreen(
    context: context,
    page: SearchPage(),
    stopAnimation: true,
    navigationCallback: (route) =>
        Navigator.of(context).push(route),
),
```

// available widget success

```dart
LoadingButton(
    // v1.0.1
    borderSize:8
    boarderSide: BoarderSide.none, // Default
    color: Colors.blue,
    onSubmit: () => print('onSubmit'),
    controller: _controller,
    errorColor: Colors.red,
    progressIndicatorColor: Colors.grey,
    durationSuccess: const Duration(seconds: 1),
    duration: const Duration(milliseconds: 500),
    successWidget: FaIcon(FontAwesomeIcons.checkCircle),
    transitionDuration: Duration(seconds: 1),
    child: Text(
    'Hit me!',
    style: Theme.of(context)
        .textTheme
        .bodyText1!
        .copyWith(color: Colors.white),
    ),
),
```


## Login Button


Now in your Dart code, you can use:


## Usage Example

It very simple!

In order to use this widget you have to use a `LoadingSignButtonController` to handler the different states.

```dart
final _controller = LoadingSignButtonController();
```

```dart
LoadingSignButton(
  controller: _controller,
  buttonType: ButtonType.google,

  onPressed: () {
   print('click');
  })
```


* ButtonSize Removed in v 1.0.0
```dart
LoadingSignButton(
  controller: _controller,
  buttonType: ButtonType.google,
  buttonSize: ButtonSize.large, // small(default), medium, large
  onPressed: () {
   print('click');
  })
```

* use it in v 1.0.0
```dart
LoadingSignButton(
  controller: _controller,
  buttonType: ButtonType.google,
  width: 100,
  height:50,
  fontSize: 20,
  imageSize: 16,
  onPressed: () {
   print('click');
  })
```

* ImagePosition
```dart
LoadingSignButton(
  controller: _controller,
  imagePosition: ImagePosition.left, // left or right
  buttonType: ButtonType.google,
  onPressed: () {
   print('click');
  })
```

* Customized Button
```dart
LoadingSignButton(
controller: _controller,
 buttonType: ButtonType.pinterest,
 imagePosition: ImagePosition.right,
 //[buttonSize] You can also use this in combination with [width]. Increases the font and icon size of the button.
 buttonSize: ButtonSize.large,
 btnTextColor: Colors.grey,
 btnColor: Colors.white,
 //[width] Use it to change width button.
  //[height] Use it to change height button.

 btnText: 'Pinterest',
 onPressed: () {
  print('click');
 })
```


* Disabled Button

```dart
LoadingSignButton(
 controller: _controller,
 buttonType: ButtonType.facebook,
 onPressed: null,
),
```



### Mini Button
```dart
LoadingSignButton.mini(
 buttonType: ButtonType.github,
 onPressed: () {},
),
```

# TBIB Loading Transition button

![AnimatedButton](https://raw.githubusercontent.com/the-best-is-best/tbib_loading_transition_button_and_social/master/src/example1.gif)
