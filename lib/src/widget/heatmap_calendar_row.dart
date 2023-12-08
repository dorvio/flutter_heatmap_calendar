import 'package:flutter/material.dart';
import '../util/datasets_util.dart';
import './heatmap_container.dart';
import '../data/heatmap_color_mode.dart';
import '../util/date_util.dart';
import '../util/widget_util.dart';

class HeatMapCalendarRow extends StatelessWidget {
  /// The integer value of beginning date of the week.
  final DateTime startDate;

  /// The integer value of end date of the week
  final DateTime endDate;

  /// The double value of every [HeatMapContainer]'s width and height.
  final double? size;

  /// The double value of every [HeatMapContainer]'s fontSize.
  final double? fontSize;

  /// The List of row items.
  ///
  /// It includes every days of the week and
  /// if one week doesn't have 7 days, it will be filled with [SizedBox].
  final List<Widget> dayContainers;

  /// The default background color value of [HeatMapContainer]
  final Color? defaultColor;

  /// The text color value of [HeatMapContainer]
  final Color? textColor;

  /// The colorsets which give the color value for its thresholds key value.
  ///
  /// Be aware that first Color is the maximum value if [ColorMode] is [ColorMode.opacity].
  final Map<int, Color>? colorsets;

  /// The double value of [HeatMapContainer]'s borderRadius
  final double? borderRadius;

  /// Make block size flexible if value is true.
  final bool? flexible;

  /// The margin value for every block.
  final EdgeInsets? margin;

  /// The datasets which fill blocks based on its value.
  ///
  /// datasets keys have to greater or equal to [startDate] and
  /// smaller or equal to [endDate].
  final Map<DateTime, int>? datasets;

  /// ColorMode changes the color mode of blocks.
  ///
  /// [ColorMode.opacity] requires just one colorsets value and changes color
  /// dynamically based on hightest value of [datasets].
  /// [ColorMode.color] changes colors based on [colorsets] thresholdsc key value.
  final ColorMode colorMode;

  /// The integer value of the maximum value for the highest value of the month.
  final int? maxValue;

  /// Function that will be called when a block is clicked.
  ///
  /// Paratmeter gives clicked [DateTime] value.
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
  })  : dayContainers = List<Widget>.generate(
  7,
  (i) => (startDate == DateUtil.startDayOfMonth(startDate) &&
          endDate.day - startDate.day != 7 &&
          i <= (startDate.weekday % 7)) ||
      (endDate == DateUtil.endDayOfMonth(endDate) &&
          endDate.day - startDate.day != 7 &&
          i >= (endDate.weekday % 7 + 7 - 1))
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
          selectedColor: datasets?.keys.contains(DateTime(
              startDate.year, startDate.month,
              startDate.day - startDate.weekday % 7 + i)) ??
              false,
          colorMode == ColorMode.opacity
              ? colorsets?.values.first.withOpacity((datasets?[
                      DateTime(
                          startDate.year, startDate.month,
                          startDate.day + i - (startDate.weekday % 7))] ??
                  1) / (maxValue ?? 1))
              : DatasetsUtil.getColor(
                  colorsets,
                  datasets?[DateTime(startDate.year, startDate.month,
                      startDate.day + i - (startDate.weekday % 7))]),
                      : null,
                ),
        ),
);

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
