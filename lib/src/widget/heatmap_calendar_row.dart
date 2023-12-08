import 'package:flutter/material.dart';
import '../util/datasets_util.dart';
import './heatmap_container.dart';
import '../data/heatmap_color_mode.dart';
import '../util/date_util.dart';
import '../util/widget_util.dart';

class HeatMapCalendarRow extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;
  final double? size;
  final double? fontSize;
  final List<Widget> dayContainers;
  final Color? defaultColor;
  final Color? textColor;
  final Map<int, Color>? colorsets;
  final double? borderRadius;
  final bool? flexible;
  final EdgeInsets? margin;
  final Map<DateTime, int>? datasets;
  final ColorMode colorMode;
  final int? maxValue;
  final Function(DateTime)? onClick;

  HeatMapCalendarRow({
    Key? key,
    required this.startDate,
    required this.endDate,
    required this.colorMode,
    this.size,
    this.fontSize,
    this.defaultColor,
    this.colorsets,
    this.textColor,
    this.borderRadius,
    this.flexible,
    this.margin,
    this.datasets,
    this.maxValue,
    this.onClick,
  }) : dayContainers = List<Widget>.generate(
          7,
          (i) {
            final currentDay = startDate.day - (startDate.weekday - 1) + i;
            final currentDateTime = DateTime(
              startDate.year,
              startDate.month,
              currentDay,
            );

            return (currentDay < startDate.day ||
                    currentDay > endDate.day ||
                    (startDate == DateUtil.startDayOfMonth(startDate) &&
                        endDate.day - startDate.day != 7 &&
                        i < (startDate.weekday - 1)) ||
                    (endDate == DateUtil.endDayOfMonth(endDate) &&
                        endDate.day - startDate.day != 7 &&
                        i >= (endDate.weekday % 7)))
                ? Container(
                    width: size ?? 42,
                    height: size ?? 42,
                    margin: margin ?? const EdgeInsets.all(2),
                  )
                : HeatMapContainer(
                    date: currentDateTime,
                    backgroundColor: defaultColor,
                    size: size,
                    fontSize: fontSize,
                    textColor: textColor,
                    borderRadius: borderRadius,
                    margin: margin,
                    onClick: onClick,
                    selectedColor: datasets?.containsKey(currentDateTime) ?? false,
                    // If colorMode is ColorMode.opacity,
                    (colorMode == ColorMode.opacity &&
                            datasets?[DateTime(
                                    startDate.year,
                                    startDate.month,
                                    startDate.day + i - (startDate.weekday - 1))] !=
                                null)
                        ? colorsets?.values.first.withOpacity(
                            (datasets![
                                    DateTime(startDate.year, startDate.month, startDate.day + i - (startDate.weekday - 1))] ??
                                1) /
                                (maxValue ?? 1),
                          )
                        : DatasetsUtil.getColor(
                            colorsets,
                            datasets?[DateTime(
                                startDate.year,
                                startDate.month,
                                startDate.day + i - (startDate.weekday - 1))],
                          ),
                  );
          },
        ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (Widget container in dayContainers)
          WidgetUtil.flexibleContainer(flexible ?? false, true, container),
      ],
    );
  }
}
