import 'package:flutter/material.dart';

class ColorRow extends StatelessWidget {
  final String label;
  final Color value;
  final ValueChanged<Color> onChange;

  const ColorRow({
    super.key,
    required this.label,
    required this.value,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF555555))),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () async {
              final color = await showDialog<Color>(
                context: context,
                builder: (ctx) => SimpleColorPicker(initial: value),
              );
              if (color != null) onChange(color);
            },
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: value,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Theme.of(context).dividerColor),
              ),
            ),
          ),
          const Spacer(),
          Text(
            '#${value.toARGB32().toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}',
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF555555)),
          ),
        ],
      ),
    );
  }
}

class SimpleColorPicker extends StatefulWidget {
  final Color initial;
  const SimpleColorPicker({super.key, required this.initial});

  @override
  State<SimpleColorPicker> createState() => _SimpleColorPickerState();
}

class _SimpleColorPickerState extends State<SimpleColorPicker> {
  late double _hue;
  late double _sat;
  late double _val;

  @override
  void initState() {
    super.initState();
    final hsv = HSVColor.fromColor(widget.initial);
    _hue = hsv.hue;
    _sat = hsv.saturation;
    _val = hsv.value;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Pick Color'),
      content: SizedBox(
        width: 260,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [
                    HSVColor.fromAHSV(1, _hue, 0, 1).toColor(),
                    HSVColor.fromAHSV(1, _hue, 1, 1).toColor(),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Slider(value: _hue, min: 0, max: 360, onChanged: (v) => setState(() => _hue = v)),
            const SizedBox(height: 8),
            Text('Color: #${HSVColor.fromAHSV(1, _hue, _sat, _val).toColor().toARGB32().toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}',
                style: const TextStyle(fontSize: 11)),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        FilledButton(
          onPressed: () => Navigator.pop(context, HSVColor.fromAHSV(1, _hue, _sat, _val).toColor()),
          child: const Text('Select'),
        ),
      ],
    );
  }
}
