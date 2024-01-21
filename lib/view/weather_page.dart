import 'dart:developer';
import 'dart:ui';

import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:weathercast/constants/constants.dart';
import 'package:weathercast/logic/models/weather_model.dart';
import 'package:weathercast/logic/services/call_to_api.dart';
import 'package:weathercast/view/colors.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  Future<WeatherModel> getData(bool isCurrentCity, String cityName) async {
    return await CallToApi().callWeatherAPi(isCurrentCity, cityName);
  }

  TextEditingController textController = TextEditingController(text: "");
  Future<WeatherModel>? _myData;
  @override
  void initState() {
    setState(() {
      _myData = getData(true, "");
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: FutureBuilder(
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If error occured
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  '${snapshot.error.toString()} occurred',
                  style: TextStyle(fontSize: 18),
                ),
              );

              // if data has no errors
            } else if (snapshot.hasData) {
              // Extracting data from snapshot object
              final data = snapshot.data as WeatherModel;
              return Container(
                width: double.infinity,
                height: double.infinity,
                child: Stack(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Image.asset(
                        ColorBG.colorMap['clear sky']!,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          height: 300,
                        ),
                        Container(
                          alignment: AlignmentDirectional.center,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 5.0,
                              sigmaY: 5.0,
                            
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  data.city,
                                  style: f24Rwhitebold,
                                ),
                                height25,
                                Text(
                                  data.desc,
                                  style: f16PW,
                                ),
                                height25,
                                Text(
                                  "${data.temp}°C",
                                  style: f42Rwhitebold,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    AnimSearchBar(
                      rtl: true,
                      width: 400,
                      color: Color(0xffffb56b),
                      textController: textController,
                      suffixIcon: Icon(
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
                  ],
                ),
              );
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Center(
              child: Text("${snapshot.connectionState} occured"),
            );
          }
          return Center(
            child: Text("Server timed out!"),
          );
        },
        future: _myData!,
      ),
    );
  }
}
