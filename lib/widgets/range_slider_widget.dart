import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/widgets/app_text_widget.dart';
import 'package:flutter/material.dart';

class RangeSliderWidget extends StatefulWidget {
  final double min;
  final double max;
  final double start;
  final double end;
  final ValueChanged<RangeValues> onChanged;

  const RangeSliderWidget({
    super.key,
    required this.min,
    required this.max,
    required this.start,
    required this.end,
    required this.onChanged,
  });

  @override
  State<RangeSliderWidget> createState() => _RangeSliderWidgetState();
}

class _RangeSliderWidgetState extends State<RangeSliderWidget> {
  late RangeValues _values;

  @override
  void initState() {
    super.initState();
    _values = RangeValues(widget.start, widget.end);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.10,
              child: AppText.title2(
                _values.start.toInt().toString(),
                customStyle: TextStyle(color: theme.primaryColor),
                textAlign: TextAlign.end,
                maxLines: 1,
              ),
            ),
            SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.65,
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: theme.primaryColor,
                  inactiveTrackColor: Colors.grey.shade300,
                  thumbColor: theme.primaryColor,
                  overlayColor: theme.primaryColor.withOpacity(0.2),
                  valueIndicatorColor: theme.primaryColor,
                  rangeThumbShape: const RoundRangeSliderThumbShape(enabledThumbRadius: 7.0),
                  trackHeight: 4.0,
                ),
                child: RangeSlider(
                  values: _values,
                  min: widget.min,
                  max: widget.max,
                  onChanged: (newValues) {
                    setState(() {
                      _values = newValues;
                    });
                    widget.onChanged(newValues);
                  },
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.10,
              child: AppText.title2(
                _values.end.toInt().toString(),
                customStyle: TextStyle(color: theme.primaryColor),
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
      ],
    );
  }
}