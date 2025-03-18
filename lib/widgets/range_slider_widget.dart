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
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.green,
            inactiveTrackColor: Colors.grey.shade300,
            thumbColor: Colors.green,
            overlayColor: Colors.green.withOpacity(0.2),
            valueIndicatorColor: Colors.green,
            rangeThumbShape: const RoundRangeSliderThumbShape(enabledThumbRadius: 12.0),
            trackHeight: 6.0,
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.min.toInt().toString(),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54),
              ),
              Text(
                _values.start.toInt().toString(),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
              ),
              Text(
                _values.end.toInt().toString(),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
              ),
              Text(
                widget.max.toInt().toString(),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54),
              ),
            ],
          ),
        ),
      ],
    );
  }
}