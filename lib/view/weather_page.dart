import 'dart:developer';

import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:weathercast/constants/constants.dart';
import 'package:weathercast/logic/models/weather_model.dart';
import 'package:weathercast/logic/services/call_to_api.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  Future<WeatherModel> getData(bool isCurrentCity, String cityName) async {
    return await CallToApi().callWeatherAPi(isCurrentCity, cityName);
  }

  TextEditingController textController = TextEditingController(text: "Sanggau");
  Future<WeatherModel>? _myData;
  @override
  void initState() {
    super.initState();
    _searchCityWeather("Pontianak");
  }

  // void initState() {
  //   setState(() {
  //     _myData = getData(true, "");
  //   });

  //   super.initState();
  // }

  Future<void> _searchCityWeather(String cityName) async {
    if (cityName.isEmpty) {
      log("No city entered");
      return;
    }

    try {
      final WeatherModel weatherData = await getData(false, cityName);
      setState(() {
        _myData = Future.value(
            weatherData); // Menyimpan data cuaca berdasarkan kota yang diinputkan pengguna
      });
    } catch (e) {
      log("Failed to load weather data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: FutureBuilder<WeatherModel>(
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // if data has errors
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  '${snapshot.error.toString()} occurred',
                  style: const TextStyle(fontSize: 18),
                ),
              );

              // if data has no errors
            } else if (snapshot.hasData) {
              // Extracting data from snapshot object
              final data = snapshot.data as WeatherModel;
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment(0.8, 1),
                    colors: <Color>[
                      Color.fromARGB(255, 65, 89, 224),
                      Color.fromARGB(255, 83, 92, 215),
                      Color.fromARGB(255, 86, 88, 177),
                      Color(0xfff39060),
                      Color(0xffffb56b),
                    ],
                    tileMode: TileMode.mirror,
                  ),
                ),
                width: double.infinity,
                height: double.infinity,
                child: SafeArea(
                  child: Column(
                    children: [
                      AnimSearchBar(
                        rtl: true,
                        width: 400,
                        color: const Color(0xffffb56b),
                        textController: textController,
                        suffixIcon: const Icon(
                          Icons.search,
                          color: Colors.black,
                          size: 26,
                        ),
                        onSuffixTap: () async {
                          textController.text == ""
                              ? log("No city entered")
                              : setState(() {
                                  _myData = getData(false, textController.text);
                                });

                          FocusScope.of(context).unfocus();
                          textController.clear();
                        },
                        style: f14RblackLetterSpacing2,
                      ),
                      Text(
                        ("Weather - Forecast"),
                        style: ukurantext,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Colors.white,
                                ),
                                Text(
                                  data.city,
                                  style: f24Rwhitebold,
                                ),
                              ],
                            ),
                            height25,
                            Text(
                              data.desc,
                              style: f16PW,
                            ),
                            height25,
                            Text(
                              'Min Temp: ${data.tempMin}°C',
                              style: f36Rwhitebold,
                            ),
                            Text(
                              'Max Temp: ${data.tempMax}°C',
                              style: f36Rwhitebold,
                            ),
                            Text(
                              "Wind Speed: ${data.windSpeed} m/s",
                              style: ukurantext,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Center(
              child: Text("State ${snapshot.connectionState}"),
            );
          }
          return const Center(
            child: Text("Server timed out!"),
          );
        },
        future: _myData!,
      ),
    );
  }
}
