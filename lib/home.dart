import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:core';

import 'package:flutter_glow/flutter_glow.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'shared/constants.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.data, required this.prefs});
  final Map<String, dynamic> data;
  final SharedPreferences prefs;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late String? goldenHour;
  late String? sunrise;
  late String? sunset;
  late String? firstLight;
  late String? lastLight;
  late String? timeZone;
  late String? dawn;
  late String? dusk;
  late String? solarNoon;
  late String? dayLength;

  late bool text;

  @override
  Widget build(BuildContext context) {
    text = widget.prefs.getBool('text') ?? false;

    goldenHour = DateFormat('HH:mm')
        .format(DateFormat('h:mm:ss a').parse(widget.data['golden_hour']));
    sunrise = DateFormat('HH:mm')
        .format(DateFormat('h:mm:ss a').parse(widget.data['sunrise']));
    sunset = DateFormat('HH:mm')
        .format(DateFormat('h:mm:ss a').parse(widget.data['sunset']));
    firstLight = DateFormat('HH:mm')
        .format(DateFormat('h:mm:ss a').parse(widget.data['first_light']));
    lastLight = DateFormat('HH:mm')
        .format(DateFormat('h:mm:ss a').parse(widget.data['last_light']));
    dawn = DateFormat('HH:mm')
        .format(DateFormat('h:mm:ss a').parse(widget.data['dawn']));
    dusk = DateFormat('HH:mm')
        .format(DateFormat('h:mm:ss a').parse(widget.data['dusk']));
    solarNoon = DateFormat('HH:mm')
        .format(DateFormat('h:mm:ss a').parse(widget.data['solar_noon']));
    dayLength = widget.data['day_length'].toString();
    timeZone = widget.data['timezone'].toString();

    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Timezone: $timeZone  ·  ',
                        style: textStyle.copyWith(fontSize: 10)),
                    Text('Powered by SunriseSunset.io',
                        style: textStyle.copyWith(fontSize: 10)),
                  ],
                ),
              )),
          Flexible(
            flex: 5,
            child: Center(
              child: GestureDetector(
                onTap: () async {
                  await widget.prefs.setBool('text', !text);
                  //setState(() {});
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                              child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: text
                                    ? const Text('First Light',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15))
                                    : const Icon(CupertinoIcons.light_max,
                                        color: Colors.white),
                              ),
                              GlowText(
                                  firstLight == null
                                      ? 'No data'
                                      : firstLight.toString(),
                                  style: textStyle),
                            ],
                          )),
                          Expanded(
                              child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: text
                                    ? const Text('Dawn',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15))
                                    : const Icon(CupertinoIcons.sun_haze,
                                        color: Colors.white),
                              ),
                              GlowText(
                                  dawn == null ? 'No data' : dawn.toString(),
                                  style: textStyle),
                            ],
                          )),
                          Expanded(
                              child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: text
                                    ? const Text('Sunrise',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15))
                                    : const Icon(CupertinoIcons.sunrise,
                                        color: Colors.white),
                              ),
                              GlowText(
                                  sunrise == null
                                      ? 'No data'
                                      : sunrise.toString(),
                                  style: textStyle),
                            ],
                          )),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                              child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: text
                                    ? const Text('Sunset',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15))
                                    : const Icon(CupertinoIcons.sunset,
                                        color: Colors.white),
                              ),
                              GlowText(
                                  sunset == null
                                      ? 'No data'
                                      : sunset.toString(),
                                  style: textStyle),
                            ],
                          )),
                          Expanded(
                              child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: text
                                    ? const Text('Dusk',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15))
                                    : const Icon(CupertinoIcons.sun_dust,
                                        color: Colors.white),
                              ),
                              GlowText(
                                  dusk == null ? 'No data' : dusk.toString(),
                                  style: textStyle),
                            ],
                          )),
                          Expanded(
                              child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: text
                                    ? const Text('Last Light',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15))
                                    : const Icon(CupertinoIcons.light_min,
                                        color: Colors.white),
                              ),
                              GlowText(
                                  lastLight == null
                                      ? 'No data'
                                      : lastLight.toString(),
                                  style: textStyle),
                            ],
                          )),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Flexible(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Golden Hour',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                GlowText(
                  goldenHour.toString(),
                  style: textStyle.copyWith(fontSize: 40),
                  glowColor: Colors.amber,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
