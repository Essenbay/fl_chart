import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart_app/presentation/resources/app_colors.dart';
import 'package:flutter/material.dart';

class MeasureModel {
  final DateTime dateTime;
  final double value;

  MeasureModel({required this.dateTime, required this.value});
}

class LinearChartWidget extends StatefulWidget {
  const LinearChartWidget(
      {super.key,
      required this.data,
      required this.measures,
      this.horizontalTarget});
  final List<MeasureModel> data;
  final String measures;
  final double? horizontalTarget;

  @override
  State<LinearChartWidget> createState() => _LinearChartWidgetState();
}

class _LinearChartWidgetState extends State<LinearChartWidget> {
  late double chartMinY;
  late double chartMaxY;
  late double chartMaxX;
  late double chartMinX;

  @override
  void initState() {
    initMaxMin();
    super.initState();
  }

  Future<void> initMaxMin() async {
    int? minX = widget.data.firstOrNull?.dateTime.day;
    double? minY = widget.data.firstOrNull?.value;
    int maxX = 0;
    double maxY = 0;

    if (minX == null && minY == null) {
      chartMaxX = 9;
      chartMinX = 1;
      chartMinX = 40;
      chartMaxY = 80;
    } else if (minX != null && minY != null) {
      for (var element in widget.data) {
        if (minY! > element.value) {
          minY = element.value;
        }
        if (minX! > element.dateTime.day) {
          minX = element.dateTime.day;
        }
        if (maxY < element.value) {
          maxY = element.value;
        }
        if (maxX < element.dateTime.day) {
          maxX = element.dateTime.day;
        }
      }

      chartMinY = minY! - (minY % 10);
      chartMinX = minX!.toDouble();

      if (maxX - chartMinX < 8) {
        chartMaxX = 7 + chartMinX;
        chartMinX -= 1;
      } else {
        chartMaxX = maxX.toDouble();
      }
      if (maxY - chartMinY < 40) {
        chartMaxY = 20 + chartMinY;
        chartMinY -= 20;
      } else {
        chartMaxY = maxY;
      }
    }
  }

  late final purposeLine = LineChartBarData(
      spots: [
        FlSpot(
          chartMinX,
          widget.horizontalTarget!.toDouble(),
        ),
        FlSpot(
          chartMaxX,
          widget.horizontalTarget!.toDouble(),
        ),
      ],
      showingIndicators: [chartMinX.toInt(), chartMaxX.toInt()],
      dotData: FlDotData(show: false),
      barWidth: 1,
      show: false,
      color: AppColors.primary,
      dashArray: [5]);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: LineChart(
        LineChartData(
            lineBarsData: [
              LineChartBarData(
                spots: chartSpots,
                isCurved: false,
                preventCurveOverShooting: true,
                barWidth: 2,
                color: AppColors.primary,
                belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.blue200,
                        AppColors.blue200.withOpacity(0)
                      ],
                    )),
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (p0, p1, p2, p3) => FlDotCirclePainter(
                    color: AppColors.white,
                    strokeColor: AppColors.primary,
                    strokeWidth: 2,
                  ),
                ),
              ),
              if (widget.horizontalTarget != null) purposeLine,
            ],
            maxY: chartMaxY,
            minY: chartMinY,
            maxX: chartMaxX,
            gridData: FlGridData(
              show: true,
              verticalInterval: 1,
              drawHorizontalLine: false,
              getDrawingVerticalLine: (value) => FlLine(
                color: AppColors.grey200,
                strokeWidth: .5,
              ),
            ),
            showingTooltipIndicators: [
              // if (widget.horizontalTarget != null)
              //   ShowingTooltipIndicators([
              //     LineBarSpot(
              //       LineChartBarData(),
              //       2,
              //       purposeLine.spots.first,
              //     )
              //   ]),
            ],
            extraLinesData: ExtraLinesData(
              horizontalLines: [
                if (widget.horizontalTarget != null)
                  HorizontalLine(
                      y: widget.horizontalTarget!,
                      color: AppColors.primary,
                      strokeWidth: 1,
                      dashArray: [5],
                      label: HorizontalLineLabel(
                        show: true,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 3),
                        alignment: Alignment.centerLeft,
                        backgroundColor: AppColors.primary,
                        style: const TextStyle(color: AppColors.white),
                        borderRadius: const Radius.circular(12),
                        margin: const EdgeInsets.only(left: 3),
                        labelResolver: (p0) =>
                            '${widget.horizontalTarget!.toStringAsFixed(0)} kg',
                      ))
              ],
            ),
            lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: AppColors.blue600,
              tooltipRoundedRadius: 15,
              tooltipPadding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              getTooltipItems: (touchedSpots) => touchedSpots
                  .map(
                    (e) => LineTooltipItem(
                      '${e.y.toStringAsFixed(0)} kg',
                      const TextStyle(
                        color: AppColors.white,
                        fontSize: 12,
                      ),
                    ),
                  )
                  .toList(),
            )),
            titlesData: FlTitlesData(
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles:
                  AxisTitles(sideTitles: SideTitles(showTitles: false)),
              leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                      showTitles: true,
                      interval: 10,
                      getTitlesWidget: getTitlesWidget,
                      reservedSize: 35)),
              bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: getTitlesWidget,
                      reservedSize: 30)),
            ),
            borderData: FlBorderData(show: false)),
      ),
    );
  }

  List<FlSpot> get chartSpots => widget.data
      .map((e) => FlSpot(e.dateTime.day.toDouble(), e.value))
      .toList();

  Widget getTitlesWidget(double value, TitleMeta meta) => Align(
        alignment: meta.axisSide == AxisSide.bottom
            ? Alignment.bottomCenter
            : Alignment.centerLeft,
        child: Text(
          value.toStringAsFixed(0),
          style: const TextStyle(color: AppColors.grey600),
        ),
      );
}
