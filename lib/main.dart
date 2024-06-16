import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:helios/widgets/loading.dart';
import 'package:helios/widgets/welcome.dart';
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:helios/home.dart';
import 'package:helios/shared/constants.dart';
import 'package:helios/widgets/compass.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late SharedPreferences prefs;
  bool loading = true;
  late bool firstTime;

  DateTime dateTime = DateTime.now();
  late int day;
  late int month;
  late int year;

  int monthDays = 31;

  CompassEvent? data;
  int point = 0;

  Future getDegrees() async {
    data = await FlutterCompass.events!.first;
    setState(() {
      point = double.parse((data!.heading).toString()).round() + 30;
    });
  }

  Future getData(String latitude, String longitude) async {
    http.Response response = await http.get(Uri.parse(
        'https://api.sunrisesunset.io/json?lat=$latitude&lng=$longitude&date=$year-$month-$day'));
    var result = jsonDecode(response.body);

    return result;
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Future<Position>? _determinePosition;

  Future _dtbSetup() async {
    final getPrefs = await SharedPreferences.getInstance();
    setState(() => prefs = getPrefs);
    //await prefs.setBool('firstTime', true);
    firstTime = prefs.getBool('firstTime') ?? true;
    loading = false;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dtbSetup();
    _determinePosition = determinePosition();
    day = dateTime.day;
    month = dateTime.month;
    year = dateTime.year;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    getDegrees();

    switch (month) {
      case 1:
        setState(() {
          monthDays = 31;
        });
        break;
      case 2:
        setState(() {
          monthDays = 28;
        });
        break;
      case 3:
        setState(() {
          monthDays = 31;
        });
        break;
      case 4:
        setState(() {
          monthDays = 30;
        });
        break;
      case 5:
        setState(() {
          monthDays = 31;
        });
        break;
      case 6:
        setState(() {
          monthDays = 30;
        });
        break;
      case 7:
        setState(() {
          monthDays = 31;
        });
        break;
      case 8:
        setState(() {
          monthDays = 31;
        });
        break;
      case 9:
        setState(() {
          monthDays = 30;
        });
        break;
      case 10:
        setState(() {
          monthDays = 31;
        });
        break;
      case 11:
        setState(() {
          monthDays = 30;
        });
        break;
      case 12:
        setState(() {
          monthDays = 31;
        });
        break;
    }
    return loading
        ? const Loading()
        : CupertinoApp(
            home: CupertinoPageScaffold(
            backgroundColor: Colors.black,
            child: AnnotatedRegion(
              value: SystemUiOverlayStyle.light,
              child: SafeArea(
                bottom: false,
                child: StreamBuilder<CompassEvent>(
                    stream: FlutterCompass.events,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error reading heading: ${snapshot.error}',
                            style: textStyle);
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Image.asset(
                          'assets/loading.jpg',
                          fit: BoxFit.cover,
                          height: double.infinity,
                          width: double.infinity,
                          alignment: Alignment.center,
                        );
                      }
                      return FutureBuilder(
                          future: _determinePosition,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return FutureBuilder(
                                  future: getData(
                                      snapshot.data!.latitude.toString(),
                                      snapshot.data!.longitude.toString()),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      Map<String, dynamic> rawData =
                                          snapshot.data as Map<String, dynamic>;
                                      Map<String, dynamic> data =
                                          rawData['results']
                                              as Map<String, dynamic>;

                                      return Padding(
                                        padding: const EdgeInsets.only(top: 0),
                                        child: Stack(
                                          children: [
                                            Image.asset(
                                              'assets/main.jpg',
                                              fit: BoxFit.cover,
                                              height: double.infinity,
                                              width: double.infinity,
                                              alignment: Alignment.center,
                                            ),
                                            Column(
                                              children: [
                                                GlowText(
                                                  'Date',
                                                  style: textStyle.copyWith(
                                                      fontSize: 15),
                                                ),
                                                const SizedBox(height: 10),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(7),
                                                  color: Colors.white
                                                      .withOpacity(0.3),
                                                  child: CarouselSlider(
                                                    options: CarouselOptions(
                                                        onPageChanged:
                                                            (index, reason) {
                                                          setState(() {
                                                            day = index + 1;
                                                          });
                                                        },
                                                        height: 40,
                                                        viewportFraction: 0.148,
                                                        initialPage: day - 1),
                                                    items: List.generate(
                                                        monthDays,
                                                        (i) => i + 1).map((i) {
                                                      return Builder(
                                                        builder: (BuildContext
                                                            context) {
                                                          return Container(
                                                              width: 40,
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .white
                                                                      .withOpacity(
                                                                          0.3),
                                                                  borderRadius:
                                                                      const BorderRadius
                                                                          .all(
                                                                          Radius.circular(
                                                                              10))),
                                                              child: Center(
                                                                child: GlowText(
                                                                    i
                                                                        .toString(),
                                                                    style: textStyle.copyWith(
                                                                        fontSize:
                                                                            20)),
                                                              ));
                                                        },
                                                      );
                                                    }).toList(),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 10, 0, 20),
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(7),
                                                    color: Colors.white
                                                        .withOpacity(0.3),
                                                    child: CarouselSlider(
                                                      options: CarouselOptions(
                                                          onPageChanged:
                                                              (index, reason) {
                                                            setState(() {
                                                              month = index + 1;
                                                            });
                                                          },
                                                          height: 40,
                                                          viewportFraction:
                                                              0.148,
                                                          initialPage:
                                                              month - 1),
                                                      items: List.generate(
                                                              12, (i) => i + 1)
                                                          .map((i) {
                                                        return Builder(
                                                          builder: (BuildContext
                                                              context) {
                                                            return Container(
                                                                width: 40,
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .white
                                                                        .withOpacity(
                                                                            0.4),
                                                                    borderRadius:
                                                                        const BorderRadius
                                                                            .all(
                                                                            Radius.circular(10))),
                                                                child: Center(
                                                                  child: GlowText(
                                                                      i
                                                                          .toString(),
                                                                      style: textStyle.copyWith(
                                                                          fontSize:
                                                                              20)),
                                                                ));
                                                          },
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ),
                                                ),
                                                Home(data: data, prefs: prefs),
                                              ],
                                            ),
                                            IgnorePointer(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 28),
                                                child: Container(
                                                  height: 118,
                                                  decoration:
                                                      const BoxDecoration(
                                                          gradient:
                                                              LinearGradient(
                                                    begin: Alignment.centerLeft,
                                                    end: Alignment.centerRight,
                                                    colors: [
                                                      Colors.black,
                                                      Colors.transparent,
                                                      Colors.black,
                                                    ],
                                                  )),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                                bottom: -105,
                                                right: width / 2 - 100,
                                                child: Compass(point: point)),
                                            Visibility(
                                                visible: firstTime,
                                                child: Center(
                                                    child: GestureDetector(
                                                        onTap: () async {
                                                          await prefs.setBool(
                                                              'firstTime',
                                                              false);
                                                          setState(() =>
                                                              firstTime =
                                                                  !firstTime);
                                                        },
                                                        child:
                                                            const Welcome())))
                                          ],
                                        ),
                                      );
                                    } else {
                                      return const Loading();
                                    }
                                  });
                            } else {
                              return const Loading();
                            }
                          });
                    }),
              ),
            ),
          ));
  }
}
