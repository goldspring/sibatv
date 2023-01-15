import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class TVWidget extends StatefulWidget {
  TVWidget(
      {Key? key,
      required this.child,
      this.focusChange,
      this.onclick,
      this.decoration,
      this.margin = const EdgeInsets.all(8),
      this.focusedTextStyle,
      this.defaultTextStyle,
      this.hasDecoration = true,
      this.requestFocus = false,
      required this.debugLabel,
      this.focusNode,
      this.order = null})
      : super(key: key);
  Widget child;
  onFocusChange? focusChange;
  onClick? onclick;
  bool requestFocus;
  BoxDecoration? decoration;
  TextStyle? focusedTextStyle;
  TextStyle? defaultTextStyle;
  bool hasDecoration;
  EdgeInsets margin;
  String debugLabel;
  FocusNode? focusNode;
  NumericFocusOrder? order;
  @override
  State<StatefulWidget> createState() {
    return TVWidgetState();
  }
}

typedef void onFocusChange(bool hasFocus);
typedef void onClick();

class TVWidgetState extends State<TVWidget> {
  late final FocusNode _focusNode;
  bool init = false;
  var defaultDecoration = BoxDecoration(
      border: Border.all(width: 3, color: Colors.deepOrange),
      borderRadius: const BorderRadius.all(
        Radius.circular(5),
      ));
  BoxDecoration? decoration;
  TextStyle? textStyle;
  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode(debugLabel: widget.debugLabel);
    textStyle = widget.defaultTextStyle;
    _focusNode.addListener(() {
      if (widget.focusChange != null) {
        widget.focusChange!(_focusNode.hasFocus);
      }
      if (_focusNode.hasFocus) {
        if (mounted) {
          setState(() {
            if (widget.hasDecoration) {
              decoration = widget.decoration ?? defaultDecoration;
            }
            textStyle = widget.focusedTextStyle ?? widget.defaultTextStyle;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            decoration = null;
            textStyle = widget.defaultTextStyle;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.requestFocus && !init) {
      FocusScope.of(context).requestFocus(_focusNode);
      init = true;
    }
    var chid = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          _focusNode.requestFocus();
          if (widget.onclick != null) {
            widget.onclick!();
          }
        },
        child: RawKeyboardListener(
            focusNode: _focusNode,
            onKey: (event) {
              if (event is RawKeyDownEvent &&
                  event.data is RawKeyEventDataAndroid) {
                RawKeyDownEvent rawKeyDownEvent = event;
                RawKeyEventDataAndroid rawKeyEventDataAndroid =
                    rawKeyDownEvent.data as RawKeyEventDataAndroid;
                switch (rawKeyEventDataAndroid.keyCode) {
                  /*
              case 19: //KEY_UP//
                //DefaultFocusTraversal.of(context)
                //.inDirection( //                    FocusScope.of(context).focusedChild, TraversalDirection.up);
                FocusScope.of(context).focusInDirection(TraversalDirection.up);
                //FocusManager.instance.primaryFocus?.focusInDirection(TraversalDirection.up);
            break;
              case 20: //KEY_DOWN
                FocusScope.of(context).focusInDirection(TraversalDirection.down);
                //FocusManager.instance.primaryFocus?.focusInDirection(TraversalDirection.down);
                break;
              case 21: //KEY_LEFT
                //                            FocusScope.of(context).requestFocus(focusNodeB0);
                FocusScope.of(context).focusInDirection(TraversalDirection.left);
                //FocusManager.instance.primaryFocus?.focusInDirection(TraversalDirection.left);
                // 手动指定下一个焦点
                //FocusScope.of(context).requestFocus(_focusNode);
                break;
              case 22: //KEY_RIGHT
                //FocusManager.instance.primaryFocus?.focusInDirection(TraversalDirection.right);
                //                       FocusScope.of(context).requestFocus(focusNodeB1);
                //FocusScope.of(context).focusInDirection(TraversalDirection.right); //                DefaultFocusTraversal.of(context)
                FocusScope.of(context).nextFocus();
                //                    .inDirection(_focusNode, TraversalDirection.right);
                //                if(_focusNode.nextFocus()){
                //                  FocusScope.of(context)
                //                      .focusInDirection(TraversalDirection.right);
                //                }
                break;

               */
                  case 23: //KEY_CENTER
                    //debugDumpFocusTree();
                    if (widget.onclick != null) {
                      widget.onclick!();
                    }
                    break;
                  case 66: //KEY_ENTER
                    if (widget.onclick != null) {
                      widget.onclick!();
                    }
                    break;
                  default:
                    break;
                }
              }
            },
            child: Container(
              margin: widget.margin,
              decoration: decoration,
              child: DefaultTextStyle.merge(
                  style: textStyle,
                  child: Center(
                    child: widget.child,
                  )),
            )));

    return widget.order != null
        ? FocusTraversalOrder(order: widget.order!, child: chid)
        : chid;
  }
}
