import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

const double _kMarkerSize = 10;
const double _kMarkerThickness = 1;
const double _kDotSize = 10;

void main() {
  runApp(const MaterialApp(
    home: MyClock(),
  ));
}

class MyClock extends StatefulWidget {
  final double diameter;
  const MyClock({Key? key, this.diameter = 300}) : super(key: key);

  @override
  _MyClockState createState() => _MyClockState();
}

class _MyClockState extends State<MyClock> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  final ValueNotifier<int> _switch = ValueNotifier<int>(0);
  final ValueNotifier<int> _pausePlay = ValueNotifier<int>(0);
  // final ValueNotifier<int> _seconds = ValueNotifier<int>(0);
  // final Stopwatch _timer = Stopwatch();
  @override
  initState() {
    super.initState();
    // _seconds.value+=1;
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
  }

  @override
  dispose() {
    super.dispose();
  }

  double get _outerCircleDiameter => widget.diameter - _kMarkerSize;
  double get _innerCircleDiameter => widget.diameter - 4 * _kDotSize;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Row(
          children: [
            AnimatedBuilder(
                animation: _animationController,
                builder: (_, __) {
                  return ElevatedButton(
                      onPressed: () {
                        if (_switch.value == 1) {
                          _animationController.reset();
                          _switch.value = 0;
                          _pausePlay.value = 0;
                        } else {
                          _animationController.repeat();
                          _switch.value = 1;
                          _pausePlay.value = 1;
                        }
                      },
                      child: ValueListenableBuilder<int>(
                          valueListenable: _switch,
                          builder: (BuildContext context, int value, _) {
                            return Text(value == 0 ? "Start" : "Stop");
                          }));
                }),
            ValueListenableBuilder<int>(
                valueListenable: _switch,
                builder: (_, int value, __) {
                  return ValueListenableBuilder<int>(
                      valueListenable: _pausePlay,
                      builder: (_, int pausePlay, __) {
                        return ElevatedButton(
                            onPressed: value == 1
                                ? () {
                                    if (_pausePlay.value == 1) {
                                      _animationController.stop(
                                          canceled: false);
                                      _pausePlay.value = 0;
                                    } else {
                                      _animationController.repeat();
                                      _pausePlay.value = 1;
                                    }
                                  }
                                : null,
                            child: Text(pausePlay == 1 ? 'Pause' : 'Play'));
                      });
                })
          ],
        ),
        SizedBox(
          height: widget.diameter,
          width: widget.diameter,
          child: Stack(
            alignment: Alignment.center,
            children: [
              ...List.generate(
                  250,
                  (index) => Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationZ(index * (2 * pi / 250)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                                width: _kMarkerSize,
                                height: _kMarkerThickness,
                                color: Colors.black),
                            SizedBox(width: _outerCircleDiameter),
                          ],
                        ),
                      )),
              AnimatedBuilder(
                animation: _animationController,
                builder: (BuildContext context, Widget? child) {
                  return Transform(
                    transform:
                        Matrix4.rotationZ(_animationController.value * 2 * pi),
                    alignment: Alignment.center,
                    child: child!,
                  );
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                        height: _kDotSize,
                        width: _kDotSize,
                        decoration: const BoxDecoration(
                            color: Colors.blue, shape: BoxShape.circle)),
                    SizedBox(height: _innerCircleDiameter),
                  ],
                ),
              ),
              // ValueListenableBuilder<int>(valueListenable: _seconds, builder: (_,seconds,__){
              //   return Text('$seconds');
              // })
            ],
          ),
        ),
      ],
    ));
  }
}
