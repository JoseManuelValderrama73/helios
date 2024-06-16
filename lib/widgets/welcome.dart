import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:helios/shared/constants.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  final double _borderRadius = 30;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(_borderRadius),
      child: SizedBox(
          width: 300,
          height: 588,
          child: Stack(children: [
            // blur fx
            BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container()),

            //gradient fx
            Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                    borderRadius: BorderRadius.circular(_borderRadius),
                    gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.amber.withOpacity(0.5),
                          Colors.amber.withOpacity(0.3),
                          Colors.orange.withOpacity(0.1),
                          Colors.white.withOpacity(0.1),
                          Colors.white.withOpacity(0.1),
                          Colors.white.withOpacity(0.1),
                        ])),
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Welcome to',
                          textAlign: TextAlign.left,
                          style: textStyle.copyWith(
                              fontWeight: FontWeight.normal)),
                      const SizedBox(height: 2),
                      GlowText('Helios',
                          glowColor: Colors.amber,
                          textAlign: TextAlign.left,
                          style: textStyle.copyWith(fontSize: 40)),
                      const SizedBox(height: 12),
                      Text(
                          'Helios is an utility app that will help you plan your photo and video shoots to get the best results possible by telling you important solar data, such as when the golden hour is. It includes a compass that tells you the direction of sunrise (East) and sunset (West).',
                          textAlign: TextAlign.left,
                          style: textStyle.copyWith(
                              fontWeight: FontWeight.normal, fontSize: 18)),
                      const SizedBox(height: 3),
                      Text(
                          'You can change the date in the top caroussels and switch the icons to text, just tap on any of them.',
                          textAlign: TextAlign.left,
                          style: textStyle.copyWith(
                              fontWeight: FontWeight.normal, fontSize: 18)),
                      const SizedBox(height: 3),
                      Text(
                          'It all comes in a beautiful minimalistic app design that will make you enjoy more your planning process.',
                          textAlign: TextAlign.left,
                          style: textStyle.copyWith(
                              fontWeight: FontWeight.normal, fontSize: 18)),
                      const SizedBox(height: 10),
                      Text('Developed by Jose Manuel Valderrama Sánchez',
                          textAlign: TextAlign.left,
                          style: textStyle.copyWith(
                              fontWeight: FontWeight.normal, fontSize: 14)),
                    ],
                  ),
                ))
          ])),
    );
  }
}
