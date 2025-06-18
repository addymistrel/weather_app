import "dart:ui";

import "package:flutter/material.dart";
import "package:weather/additional_info_item.dart";
import "package:weather/api_service.dart";
import "package:weather/hourly_forecast_item.dart";
import "package:intl/intl.dart";

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  bool isLoading = false;

  IconData getWeatherIcon(String weather) {
    switch (weather.toLowerCase()) {
      case "clouds":
      case "rain":
        return Icons.cloud;
      default:
        return Icons.sunny;
    }
  }

  String formatTime(String dateTimeString) {
    final dateTime = DateTime.parse(dateTimeString);
    return DateFormat.jm().format(dateTime);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Weather App",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder(
        future: ApiService().getForecast(location: "Bhubaneswar"),
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(child: Text(asyncSnapshot.error.toString())),
            );
          }

          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator.adaptive());
          } else {
            final weatherData = asyncSnapshot.data?.data?['list'][0];
            final currentTemperature = weatherData['main']['temp'];
            final currentSky = weatherData["weather"][0]["main"];
            final currentHumidity = weatherData["main"]["humidity"];
            final currentWindSpeed = weatherData["wind"]["speed"];
            final currentPressure = weatherData["main"]["pressure"];
            final hourlyForecastData = asyncSnapshot.data?.data?["list"];
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  Text(
                                    "$currentTemperature K",
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                  Icon(getWeatherIcon(currentSky), size: 64),
                                  SizedBox(height: 15),
                                  Text(
                                    "${currentSky.substring(0, 1).toUpperCase()}${currentSky.substring(1).toLowerCase()}",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "Hourly Forecast",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 20,
                      itemBuilder: (context, index) {
                        final time = formatTime(
                          hourlyForecastData[index + 1]['dt_txt'],
                        );
                        final temp =
                            hourlyForecastData[index + 1]["main"]["temp"]
                                .toDouble();
                        final sky =
                            hourlyForecastData[index + 1]["weather"][0]["main"];

                        return HourlyForecastItem(
                          time: time,
                          temperature: temp,
                          icon: getWeatherIcon(sky),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "Additional Information",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AdditionalInfoItem(
                        title: "Humidity",
                        icon: Icons.water_drop,
                        value: currentHumidity.toString(),
                      ),
                      AdditionalInfoItem(
                        title: "Wind Speed",
                        icon: Icons.air,
                        value: currentWindSpeed.toString(),
                      ),
                      AdditionalInfoItem(
                        title: "Pressure",
                        icon: Icons.beach_access,
                        value: currentPressure.toString(),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
