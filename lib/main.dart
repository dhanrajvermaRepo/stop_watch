import 'dart:math';

import 'package:flutter/material.dart';


void main()  {
  runApp(const MaterialApp(
    home: MyClock(),
  ));
}

class MyClock extends StatefulWidget {
  const MyClock({Key? key}) : super(key: key);

  @override
  _MyClockState createState() => _MyClockState();
}

class _MyClockState extends State<MyClock> with SingleTickerProviderStateMixin{
  late final AnimationController _animationController;
  @override
  initState(){
    super.initState();
    _animationController = AnimationController(vsync: this,duration: const Duration(minutes: 1 ));
    _animationController.forward();
    _animationController.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:Center(
            child: Stack(
              alignment:Alignment.center,
              children: [
                ...List.generate(30,(index)=>Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationZ(index*(2*pi/30)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(width: 10,height:2,color:Colors.black),
                      SizedBox(width:120),
                    ],
                  ),
                )),
                AnimatedBuilder(
                  animation:_animationController,
                  builder: (BuildContext context, Widget? child){
                    return Transform(
                      transform: Matrix4.rotationZ(_animationController.value*2*pi),
                      alignment: Alignment.center,
                      child: child!,
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(width:5),
                      Container(height: 10,width: 10,decoration:BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle
                      )),
                      SizedBox(width:100),
                    ],
                  ),
                ),
              ],
            )
        )
    );
  }
}

