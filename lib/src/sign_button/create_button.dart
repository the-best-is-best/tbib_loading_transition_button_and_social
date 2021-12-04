import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as v;

import 'constants.dart';

// ignore: must_be_immutable
class LoadingSignButton extends StatefulWidget {
  //required
  /// [buttonType] sets the style and icons of the button.
  final ButtonType buttonType;

  /// Background color of the button for the default / steady state.  If not set
  /// this will default to the accent color of the current [Theme].
  Color? color;

  final Color? progressIndicatorColor;

  //not required, Gets value according to buttonType.
  /// [btnDisabledColor] Set the background color of the disabled button.
  Color? btnDisabledColor;

  //not required, Gets value according to buttonType.
  /// [btnTextColor] set the button's text color.
  Color? btnTextColor;

  //not required, Gets value according to buttonType.
  /// [btnDisabledTextColor] set the disabled button's text color.
  Color? btnDisabledTextColor;

  /// Controller to be able to notify when the button can
  /// move to the next page o should animate to an
  /// errored state
  final LoadingSignButtonController controller;

  // new
  ///  widget success for error state
  final Widget? successWidget;

  // new
  /// Duration for the  success button animation.
  final Duration durationSuccess;

  /// Duration for the button animation.
  final Duration duration;

  /// Duration for the page trnasition
  final Duration transitionDuration;

  /// Background color for error state
  /// if null, it will use [color] by default
  final Color? errorColor;

  /// Use this callback to listen for interactions
  /// with the loading button
  final VoidCallback? onSubmit;

  //not required, default left
  /// [imagePosition] set the position of the icon.(left or right)
  ImagePosition? imagePosition;
  //not required, Gets value according to buttonSize.
  /// [padding] set the button's padding value.
  double? padding;

  /// [_image] value cannot be assigned.Gets value according to [buttonType].
  Widget? _image;

  //not required, Gets value according to buttonSize.
  /// You can change the value of [width] when the text size becomes too small.
  double? width;

  final double height;

  /// [_fontSize] value cannot be assigned.Gets value according to [buttonSize].
  double? _fontSize;

  /// [_imageSize] value cannot be assigned.Gets value according to [buttonSize].
  double? _imageSize;
  //not required, default small
  /// [buttonSize] set the size of the button. (small medium large)
  final ButtonSize buttonSize;

  //not required, Gets value according to buttonType.
  /// [btnText] set the button's text.
  String? btnText;

  /// [mini] It automatically takes value according to the selected constructor.
  bool mini;

  /// A button that respresents a loading and errored stated
  /// if given a [LoadingSignButtonController], this widget can use the [moveToScreen]
  /// to animate a transition to a new page
  LoadingSignButton({
    Key? key,
    required this.buttonType,
    this.color,
    this.progressIndicatorColor,
    this.duration = const Duration(milliseconds: 300),
    this.transitionDuration = const Duration(milliseconds: 400),
    this.onSubmit,
    this.imagePosition = ImagePosition.left,
    this.buttonSize = ButtonSize.small,
    this.padding,
    this.btnText,
    this.width,
    this.height = 30,
    required this.controller,
    this.errorColor = Colors.red,

    //new
    this.successWidget,
    this.durationSuccess = const Duration(milliseconds: 400),
  })  : assert(duration.inMilliseconds > 0),
        mini = false,
        super(key: key);

  LoadingSignButton.mini({
    Key? key,
    required this.buttonType,
    this.color,
    this.progressIndicatorColor,
    this.duration = const Duration(milliseconds: 300),
    this.transitionDuration = const Duration(milliseconds: 400),
    this.onSubmit,
    this.buttonSize = ButtonSize.small,
    this.padding,
    this.width,
    this.height = 30,
    required this.controller,
    this.errorColor = Colors.red,

    //new
    this.successWidget,
    this.durationSuccess = const Duration(milliseconds: 400),
  })  : assert(duration.inMilliseconds > 0),
        mini = true,
        super(key: key);
  @override
  _LoadginButtonState createState() => _LoadginButtonState();
}

class _LoadginButtonState extends State<LoadingSignButton>
    with TickerProviderStateMixin, RouteAware {
  late AnimationController _controller;
  bool get _enabled => widget.onSubmit != null;

  bool get _disabled => !_enabled;

  /// if null, it will use the accent color by default
  bool _isLoading = false;
  bool _isError = false;
  bool _isReversed = false;
  double _parentHeight = 0;

  //new
  bool _isSuccess = false;
  late Duration _durationSuccess;

  // Transition
  final GlobalKey _buttonKey = GlobalKey();

  final RouteObserver<PageRoute<dynamic>> routeObserver =
      RouteObserver<PageRoute>();

  @override
  void initState() {
    widget.controller._state = this;

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..addListener(() => setState(() {}));

    super.initState();
  }

  @override
  didPopNext() {
    setState(() => _isLoading = false);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _durationSuccess = widget.durationSuccess;

    _setButtonSize();
    _createStyle(context);
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute<dynamic>);

    Animation startColor = ColorTween(
      begin: widget.color,
      end: widget.errorColor ?? widget.color,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.2),
      ),
    );

    startColor.addListener(() {
      widget.color = startColor.value;
    });

    Animation endColor = ColorTween(
      begin: widget.errorColor ?? widget.color,
      end: widget.color,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.8, 1.0),
      ),
    );

    endColor.addListener(() {
      widget.color = endColor.value;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    routeObserver.unsubscribe(this);

    super.dispose();
  }

  // Shake animation
  v.Vector3 _getTranslation() {
    var progress = _controller.value;
    var offset = sin(progress * pi * 5);

    offset *= 12;
    return v.Vector3(offset, 0.0, 0.0);
  }

  void _setButtonSize() {
    if (widget.buttonSize == ButtonSize.small) {
      widget.padding ??= !widget.mini ? 5.0 : 6.0;
      widget.width ??= 200;
      widget._fontSize = 15.0;
      widget._imageSize = !widget.mini ? 24.0 : 30.0;
    } else if (widget.buttonSize == ButtonSize.medium) {
      widget.padding ??= !widget.mini ? 5.5 : 6.5;
      widget.width ??= 220;
      widget._fontSize = 17.0;
      widget._imageSize = !widget.mini ? 28.0 : 34.0;
    } else {
      widget.padding ??= !widget.mini ? 6.0 : 7.0;
      widget.width ??= 250;
      widget._fontSize = 19.0;
      widget._imageSize = !widget.mini ? 32.0 : 38.0;
    }
  }

  void _createStyle(BuildContext context) {
    widget.btnDisabledColor ??=
        Theme.of(context).disabledColor.withOpacity(0.12);
    widget.btnDisabledTextColor ??=
        Theme.of(context).disabledColor.withOpacity(0.38);

    widget._image = Image.asset(
      'images/${describeEnum(widget.buttonType)}.png',
      package: 'tbib_loading_transition_button_and_social',
      width: widget._imageSize,
      height: widget._imageSize,
    );

    if (_disabled) {
      widget._image = ColorFiltered(
        colorFilter: const ColorFilter.matrix(<double>[
          0.2126,
          0.7152,
          0.0722,
          0,
          0,
          0.2126,
          0.7152,
          0.0722,
          0,
          0,
          0.2126,
          0.7152,
          0.0722,
          0,
          0,
          0,
          0,
          0,
          1,
          0,
        ]),
        child: widget._image,
      );
    }

    switch (widget.buttonType) {
      case ButtonType.facebook:
        widget.btnText ??= 'Sign in with Facebook';
        widget.btnTextColor ??= Colors.white;
        widget.color ??= const Color(0xFF1877F2);
        break;

      case ButtonType.facebookDark:
        widget.btnText ??= 'Sign in with Facebook';
        widget.btnTextColor ??= Colors.white;
        widget.color ??= Colors.black;
        break;

      case ButtonType.github:
        widget.btnText ??= 'Sign in with Github';
        widget.btnTextColor ??= Colors.black87;
        widget.color ??= Colors.white;
        break;

      case ButtonType.githubDark:
        widget.btnText ??= "Sign in with Github";
        widget.btnTextColor ??= Colors.white70;
        widget.color ??= const Color(0xff212121);
        break;

      case ButtonType.pinterest:
        widget.btnText ??= 'Sign in with Pinterest';
        widget.btnTextColor ??= Colors.white;
        widget.color ??= Colors.redAccent;
        break;

      case ButtonType.apple:
        widget.btnText ??= 'Sign in with Apple';
        widget.btnTextColor ??= Colors.black;
        widget.color ??= const Color(0xfff7f7f7);
        break;

      case ButtonType.appleDark:
        widget.btnText ??= 'Sign in with Apple';
        widget.btnTextColor ??= Colors.white;
        widget.color ??= Colors.black;
        break;

      case ButtonType.twitter:
        widget.btnText ??= 'Sign in with Twitter';
        widget.btnTextColor ??= Colors.white;
        widget.color ??= const Color(0xFF1DA1F2);
        break;

      case ButtonType.linkedin:
        widget.btnText ??= 'Sign in with LinkedIn';
        widget.btnTextColor ??= Colors.white;
        widget.color ??= const Color(0xFF3282B8);
        break;

      case ButtonType.google:
        widget.btnText ??= 'Sign in with Google';
        widget.btnTextColor ??= Colors.black;
        widget.color ??= const Color(0xfff7f7f7);
        break;

      case ButtonType.googleDark:
        widget.btnText ??= 'Sign in with Google';
        widget.btnTextColor ??= Colors.white;
        widget.color ??= const Color(0xFF4285F4);
        break;

      case ButtonType.youtube:
        widget.btnText ??= 'Sign in with Youtube';
        widget.btnTextColor ??= Colors.black;
        widget.color ??= Colors.white;
        break;

      case ButtonType.microsoft:
        widget.btnText ??= 'Sign in with Microsoft';
        widget.btnTextColor ??= Colors.white;
        widget.color ??= const Color(0xFF2F2F2F);
        break;

      case ButtonType.tumblr:
        widget.btnText ??= 'Sign in with Tumblr';
        widget.btnTextColor ??= Colors.white;
        widget.color ??= const Color(0xFF0F4C75);
        break;

      case ButtonType.mail:
        widget.btnText ??= 'Sign in with Mail';
        widget.btnTextColor ??= Colors.white;
        widget.color ??= const Color(0xFF20639B);
        break;

      case ButtonType.reddit:
        widget.btnText ??= 'Sign in with Reddit';
        widget.btnTextColor ??= Colors.white;
        widget.color ??= const Color(0xFFC85417);
        break;

      case ButtonType.yahoo:
        widget.btnText ??= 'Sign in with Yahoo';
        widget.btnTextColor ??= Colors.white;
        widget.color ??= const Color(0xFF7C5295);
        break;

      case ButtonType.amazon:
        widget.btnText ??= 'Sign in with Amazon';
        widget.btnTextColor ??= Colors.black87;
        widget.color ??= Colors.white;
        break;

      case ButtonType.quora:
        widget.btnText ??= 'Sign in with Quora';
        widget.btnTextColor ??= Colors.black87;
        widget.color ??= Colors.white;
        break;

      case ButtonType.instagram:
        widget.btnText ??= 'Sign in with Instagram';
        widget.btnTextColor ??= Colors.black87;
        widget.color ??= Colors.white;
        break;
    }
  }

  Widget _getChildWidget(BuildContext context) {
    return !widget.mini
        ? AnimatedSwitcher(
            switchOutCurve: Curves.easeInOutCubic,
            duration: widget.duration,
            child: _isLoading && !_isSuccess
                ? CircularProgressIndicator(
                    strokeWidth: 2.0,
                    backgroundColor: widget.progressIndicatorColor,
                    valueColor: const AlwaysStoppedAnimation(Colors.white),
                  )
                : _isLoading && _isSuccess
                    ? widget.successWidget ??
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment:
                              widget.imagePosition == ImagePosition.left
                                  ? MainAxisAlignment.start
                                  : MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(widget.padding ?? 0),
                                child:
                                    widget.imagePosition == ImagePosition.left
                                        ? widget._image
                                        : _text(),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(widget.padding ?? 0),
                                child:
                                    widget.imagePosition == ImagePosition.left
                                        ? _text()
                                        : widget._image,
                              ),
                            ),
                          ],
                        )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment:
                            widget.imagePosition == ImagePosition.left
                                ? MainAxisAlignment.start
                                : MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(widget.padding ?? 0),
                              child: widget.imagePosition == ImagePosition.left
                                  ? widget._image
                                  : _text(),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: EdgeInsets.all(widget.padding ?? 0),
                              child: widget.imagePosition == ImagePosition.left
                                  ? _text()
                                  : widget._image,
                            ),
                          ),
                        ],
                      ),
          )
        : AnimatedSwitcher(
            switchOutCurve: Curves.easeInOutCubic,
            duration: widget.duration,
            child: _isLoading && !_isSuccess
                ? const CircularProgressIndicator(
                    strokeWidth: 2.0,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  )
                : _isLoading && _isSuccess
                    ? widget.successWidget ??
                        SizedBox(
                          child: widget._image,
                        )
                    : SizedBox(
                        child: widget._image,
                      ),
          );
  }

  Widget _text() {
    return Text(
      widget.btnText!,
      style: TextStyle(
        fontSize: widget._fontSize,
        color: _enabled ? widget.btnTextColor : widget.btnDisabledTextColor,
      ),
    );
  }

  double _getBeginWidth(BoxConstraints constraints) {
    if (_isReversed) {
      return _parentHeight;
    }
    return constraints.maxWidth;
  }

  double _getEndWidth(BoxConstraints constraints) {
    if (_isLoading) {
      return _parentHeight;
    }
    return constraints.maxWidth;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        _parentHeight = constraints.maxHeight;
        return Center(
          child: TweenAnimationBuilder(
            curve: Curves.fastOutSlowIn,
            duration: widget.duration,
            tween: Tween<double>(
                begin: _getBeginWidth(constraints),
                end: _getEndWidth(constraints)),
            child: Transform(
              transform: Matrix4.translation(_getTranslation()),
              child: RawMaterialButton(
                key: _buttonKey,
                onPressed: () => (_isLoading || widget.onSubmit == null)
                    ? null
                    : _submitAndAnimate(),
                fillColor: widget.color,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(constraints.maxHeight / 2),
                ),
                child: _getChildWidget(context),
              ),
            ),
            builder: (BuildContext context, double size, Widget? child) {
              return SizedBox(
                height: constraints.maxHeight,
                width: size,
                child: child,
              );
            },
            onEnd: () {
              if (_isError) {
                _controller.reset();
                _controller.forward();
                _isError = false;
              }
              if (_isSuccess) {
                _isSuccess = false;
              }
            },
          ),
        );
      }),
    );
  }

  /// Calls [onSubmit] callback and inits the animation
  void _submitAndAnimate() {
    widget.onSubmit?.call();
    _iniAnimation();
  }

  void _stopAnimation() {
    setState(() {
      _isReversed = true;
      _isLoading = false;
    });
  }

  void _iniAnimation() {
    setState(() {
      _isReversed = false;
      _isError = false;
      _isLoading = true;
      _isSuccess = false;
    });
  }

  void _success() {
    setState(() {
      _isSuccess = true;
    });
  }

  Widget _buildTransition(
    BuildContext context,
    Widget page,
    Animation<double> animation,
    Size buttonSize,
    Offset fabOffset,
  ) {
    if (animation.value == 1) return page;

    final rect = Rect.fromCenter(
        center: fabOffset, width: buttonSize.width, height: buttonSize.height);
    final finalRect = rect.inflate(MediaQuery.of(context).size.longestSide);

    final radiusTween = BorderRadiusTween(
      begin: BorderRadius.circular(buttonSize.height / 2),
      end: BorderRadius.circular(finalRect.size.height / 2),
    );

    final sizeTween = SizeTween(
      begin: buttonSize,
      end: finalRect.size,
    );

    final offsetTween = Tween<Offset>(
        begin: fabOffset,
        end: Offset(MediaQuery.of(context).size.width - finalRect.right,
            MediaQuery.of(context).size.height - finalRect.bottom));

    final easeInAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.linear,
    );

    final radius = radiusTween.evaluate(easeInAnimation);
    final offset = offsetTween.evaluate(animation);
    final size = sizeTween.evaluate(easeInAnimation);

    Widget positionedClippedChild(Widget child) => Positioned(
          width: size!.width,
          height: size.height,
          left: offset.dx,
          top: offset.dy,
          child: ClipRRect(
            borderRadius: radius,
            child: child,
          ),
        );

    return Stack(
      children: [
        positionedClippedChild(Container(color: widget.color)),
      ],
    );
  }

  _moveToNextPage({
    required BuildContext context,
    required Widget page,
    bool stopAnimation = false,
    required NavigationSignCallback callback,
  }) {
    final RenderBox buttonRenderBox =
        _buttonKey.currentContext!.findRenderObject() as RenderBox;
    final buttonSize = buttonRenderBox.size;
    final buttonOffset = buttonRenderBox.localToGlobal(Offset.zero);

    final pageBuilder = PageRouteBuilder(
      transitionDuration: widget.transitionDuration,
      pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) =>
          page,
      transitionsBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation, Widget child) =>
          _buildTransition(context, child, animation, buttonSize, buttonOffset),
    );

    callback(pageBuilder);

    if (stopAnimation) _stopAnimation();
  }
}

typedef NavigationSignCallback = Function(PageRouteBuilder);

/// This controller defines a set of helper methods
/// that notifies the loading button about the state of the
/// animation
class LoadingSignButtonController {
  late _LoadginButtonState _state;

  /// Stops the loading animation and init the error state
  void onError() {
    _state._isError = true;
    _state._stopAnimation();
  }

  //new
  void onSuccess() async {
    _state._success();
    await Future.delayed(_state._durationSuccess);

    _state._stopAnimation();
  }

  /// Inits the loading state and fires [onSubmit] callback
  /// When the loading animation is running, the button will
  /// be disabled
  void startLoadingAnimation() {
    _state._iniAnimation();
  }

  /// Stops loading animations
  void stopLoadingAnimation() {
    _state._stopAnimation();
  }

  /// Inits the transition to the next page
  /// Please provide the next [page] that you want to present to the user.
  /// If you want to stop the button animation once the [page] is presented,
  /// you can set [stopAnimation] as true.
  /// Finally, provide a [navigationCallback] that will let you set the navigation
  /// behavior, this callback will return the new route.
  void moveToScreen({
    required BuildContext context,
    required Widget page,
    required stopAnimation,
    required NavigationSignCallback navigationCallback,
  }) {
    _state._moveToNextPage(
      context: context,
      page: page,
      stopAnimation: stopAnimation,
      callback: navigationCallback,
    );
  }
}
