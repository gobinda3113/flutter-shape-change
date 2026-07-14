import 'package:flutter/material.dart';

class SliderRow extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final String unit;
  final int? decimals;
  final ValueChanged<double> onChange;
  final double? step;

  const SliderRow({
    super.key,
    required this.label,
    required this.value,
    this.min = 0,
    this.max = 100,
    this.unit = '',
    this.decimals,
    this.step,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF555555))),
              Text('${value.toStringAsFixed(decimals ?? 0)}$unit',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 6),
          SliderTheme(
            data: theme.sliderTheme.copyWith(
              activeTrackColor: AppTheme.accent,
              thumbColor: theme.brightness == Brightness.dark ? const Color(0xFFF5F5F5) : const Color(0xFF1A1A1A),
            ),
            child: Slider(
              value: value.clamp(min, max),
              min: min,
              max: max,
              divisions: step != null ? ((max - min) / step!).round() : null,
              onChanged: onChange,
            ),
          ),
        ],
      ),
    );
  }
}

class AppTheme {
  static const Color accent = Color(0xFFFA5D29);
}
