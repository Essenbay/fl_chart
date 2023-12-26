import 'package:fl_chart_app/examle_chart.dart';
import 'package:fl_chart_app/presentation/resources/app_resources.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppTexts.appName,
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.pageBackground,
      ),
      home: Scaffold(
          backgroundColor: AppColors.white,
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: LinearChartWidget(
                data: [
                  MeasureModel(dateTime: DateTime.now(), value: 59),
                  MeasureModel(
                      dateTime: DateTime.now().add(const Duration(days: 1)),
                      value: 59),
                  MeasureModel(
                      dateTime: DateTime.now().add(const Duration(days: 2)),
                      value: 60),
                ],
                measures: 'kg',
                horizontalTarget: 50,
              ),
            ),
          )),
    );
  }
}
