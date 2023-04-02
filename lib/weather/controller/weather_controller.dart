import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:weather_getx/constants/app_colors.dart';
import 'package:weather_getx/constants/appi.dart';
import 'package:weather_getx/weather/models/weather_model.dart';

class WeatherCtl extends GetxController {
  Rx<Weather?> weather = Rxn();

  final dio = Dio();

  @override
  void onInit() {
    super.onInit();
    weatherName();
  }

  Future<void> weatherLoction() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.always &&
          permission == LocationPermission.whileInUse) {
        Position position = await Geolocator.getCurrentPosition();

        final response = await dio.get(
          ApiConst.latLongaddres(
              lat: position.latitude, long: position.longitude),
        );

        if (response.statusCode == 200) {
          weather.value = Weather(
            id: response.data['current']['weather'][0]['id'],
            main: response.data['current']['weather'][0]['main'],
            description: response.data['current']['weather'][0]['description'],
            icon: response.data['current']['weather'][0]['icon'],
            city: response.data['timezone'],
            temp: response.data['current']['temp'],
          );
        }
      }
    } else {
      Position position = await Geolocator.getCurrentPosition();
      final dio = Dio();
      final response = await dio.get(
        ApiConst.latLongaddres(
            lat: position.latitude, long: position.longitude),
      );

      if (response.statusCode == 200) {
        weather.value = Weather(
          id: response.data['current']['weather'][0]['id'],
          main: response.data['current']['weather'][0]['main'],
          description: response.data['current']['weather'][0]['description'],
          icon: response.data['current']['weather'][0]['icon'],
          city: response.data['timezone'],
          temp: response.data['current']['temp'],
        );
      }
    }
    // isloading = false.obs;
  }

  Future<void> weatherName([String? name]) async {
    final response = await dio.get(ApiConst.address(name ?? 'bishkek'));

    if (response.statusCode == 200) {
      weather.value = Weather(
        id: response.data['weather'][0]['id'],
        main: response.data['weather'][0]['main'],
        description: response.data['weather'][0]['description'],
        icon: response.data['weather'][0]['icon'],
        city: response.data['name'],
        temp: response.data['main']['temp'],
        country: response.data['sys']['country'],
      );
    }
  }

  List<String> cities = [
    'bishkek',
    'osh',
    'jalal-abad',
    'karakol',
    'batken',
    'naryn',
    'talas',
    'tokmok',
  ];

  void showBottom(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.fromLTRB(15, 20, 15, 7),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 18, 180, 230),
            border: Border.all(color: AppColors.white),
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20.0),
              topLeft: Radius.circular(20.0),
            ),
          ),
          child: ListView.builder(
            itemCount: cities.length,
            itemBuilder: (context, index) {
              final city = cities[index];
              return Card(
                child: ListTile(
                  onTap: () {
                    weatherName(city);
                    Navigator.pop(context);
                  },
                  title: Text(city),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
