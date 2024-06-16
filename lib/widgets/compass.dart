import 'package:flutter/cupertino.dart';
import 'dart:math' as math;

class Compass extends StatefulWidget {
  const Compass({Key? key, required this.point}) : super(key: key);
  final int point;

  @override
  State<Compass> createState() => _CompassState();
}

class _CompassState extends State<Compass> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(5),
        child: Transform.rotate(
          angle: widget.point * math.pi / 180 - math.pi / 2,
          child: Image.asset('assets/compass.png'),
        ));
  }
}
