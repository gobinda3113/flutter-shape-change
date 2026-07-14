import 'package:flutter/material.dart';

class ToggleRow extends StatelessWidget {
  final String label;
  final bool checked;
  final ValueChanged<bool> onChange;

  const ToggleRow({
    super.key,
    required this.label,
    required this.checked,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
          Switch(
            value: checked,
            onChanged: onChange,
          ),
        ],
      ),
    );
  }
}
