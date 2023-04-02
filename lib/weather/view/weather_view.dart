import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_getx/components/custom.dart';
import 'package:weather_getx/constants/app_colors.dart';
import 'package:weather_getx/constants/app_textStyle.dart';
import 'package:weather_getx/constants/appi.dart';
import 'package:weather_getx/weather/controller/weather_controller.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final ctl = Get.put(WeatherCtl());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0.0,
        title: const Text("WEATHER", style: AppTextStyle.appBartitle),
        centerTitle: true,
      ),
      body: ctl.weather.value == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              //  constraints: BoxConstraints.lerp(asc),
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/weather.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomButton(
                        icon: Icons.near_me,
                        onPressed: () async {
                          await ctl.weatherLoction();
                        },
                      ),
                      CustomButton(
                          icon: Icons.location_city,
                          onPressed: () {
                            ctl.showBottom(context);
                          }),
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(width: 14),
                      Obx(
                        () => Text(
                          "${(ctl.weather.value!.temp - 273.15).toInt()}°",
                          style: AppTextStyle.temp,
                        ),
                      ),

                      //  ctl.weather.value != null
                      Image.network(
                        ApiConst.getIcon(ctl.weather.value!.icon, 4),
                        height: 160,
                        fit: BoxFit.fitHeight,
                      ),
                    ],
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FittedBox(
                          child: Obx(() {
                            return Text(
                              ctl.weather.value!.description
                                  .replaceAll(' ', '\n'),

                              // "You'all need and".replaceAll(' ', '\n'),
                              style: AppTextStyle.centrtitle,
                              textAlign: TextAlign.right,
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: FittedBox(
                        child: Obx(() {
                          return Text(
                            ctl.weather.value!.city,
                            style: const TextStyle(
                                fontSize: 80, color: AppColors.white),
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
