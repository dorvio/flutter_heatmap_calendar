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
    (i) => (startDate == DateUtil.startDayOfMonth(startDate) &&
            endDate.day - startDate.day != 7 &&
            i < (startDate.weekday % 7)) ||
        (endDate == DateUtil.endDayOfMonth(endDate) &&
            endDate.day - startDate.day != 7 &&
            i > (endDate.weekday % 7))
        ? datasets?.containsKey(DateTime(startDate.year, startDate.month,
            startDate.day - startDate.weekday % 7 + i)) ??
            false
            ? HeatMapContainer(
                date: DateTime(startDate.year, startDate.month,
                    startDate.day - startDate.weekday % 7 + i),
                backgroundColor: defaultColor,
                size: size,
                fontSize: fontSize,
                textColor: textColor,
                borderRadius: borderRadius,
                margin: margin,
                onClick: onClick,
                selectedColor: datasets?.keys
                    .contains(DateTime(startDate.year, startDate.month,
                        startDate.day - startDate.weekday % 7 + i)) ??
                    false,
                // If colorMode is ColorMode.opacity,
                ? (colorMode == ColorMode.opacity &&
                        datasets?[DateTime(startDate.year, startDate.month,
                            startDate.day + i - (startDate.weekday % 7))] !=
                            null)
                    ? colorsets?.values.first
                        .withOpacity((datasets?[
                            DateTime(startDate.year, startDate.month,
                                startDate.day + i - (startDate.weekday % 7))] ??
                            1) /
                        (maxValue ?? 1))
                    : DatasetsUtil.getColor(colorsets,
                        datasets?[DateTime(startDate.year, startDate.month,
                            startDate.day + i - (startDate.weekday % 7))])
                : null,
              )
        : (i == 0 || i == 6)
            ? Container(
                width: size ?? 42,
                height: size ?? 42,
                margin: margin ?? const EdgeInsets.all(2),
              )
            : HeatMapContainer(
                date: DateTime(startDate.year, startDate.month,
                    startDate.day - startDate.weekday % 7 + i),
                backgroundColor: defaultColor,
                size: size,
                fontSize: fontSize,
                textColor: textColor,
                borderRadius: borderRadius,
                margin: margin,
                onClick: onClick,
                selectedColor: datasets?.containsKey(DateTime(startDate.year, startDate.month,
                    startDate.day - startDate.weekday % 7 + i)) ??
                    false,
                // If colorMode is ColorMode.opacity,
                : (colorMode == ColorMode.opacity &&
                        datasets?[DateTime(startDate.year, startDate.month,
                            startDate.day + i - (startDate.weekday % 7))] !=
                            null)
                    ? colorsets?.values.first
                        .withOpacity((datasets?[
                            DateTime(startDate.year, startDate.month,
                                startDate.day + i - (startDate.weekday % 7))] ??
                            1) /
                        (maxValue ?? 1))
                    : DatasetsUtil.getColor(colorsets,
                        datasets?[DateTime(startDate.year, startDate.month,
                            startDate.day + i - (startDate.weekday % 7))])
                        : null,
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
