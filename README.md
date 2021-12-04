#TBIB Loading Transition button

A Customizable transition button for Flutter

## Getting Started

To use this package, add `tbib_loading_transition_button_and_social` as a dependency in your `pubspec.yaml` file.

```yaml
dependencies:
 ...
 tbib_loading_transition_button_and_social: ^0.0.1
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

```dart
LoadingSignButton(
  buttonType: ButtonType.google,
  onPressed: () {
   print('click');
  })
```


ButtonSize
```dart
SignInButton(
  buttonType: ButtonType.google,
  buttonSize: ButtonSize.large, // small(default), medium, large
  onPressed: () {
   print('click');
  })
```

ImagePosition
```dart
SignInButton(
  imagePosition: ImagePosition.left, // left or right
  buttonType: ButtonType.google,
  onPressed: () {
   print('click');
  })
```

Customized Button
```dart
LoadingSignButton(
 buttonType: ButtonType.pinterest,
 imagePosition: ImagePosition.right,
 //[buttonSize] You can also use this in combination with [width]. Increases the font and icon size of the button.
 buttonSize: ButtonSize.large,
 btnTextColor: Colors.grey,
 btnColor: Colors.white,
 //[width] Use if you change the text value.
 btnText: 'Pinterest',
 onPressed: () {
  print('click');
 })
```


Disabled Button

```dart
SignInButton(
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