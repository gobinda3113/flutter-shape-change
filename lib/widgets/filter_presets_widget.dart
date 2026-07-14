import 'package:flutter/material.dart';

class FilterPreset {
  final String id;
  final String label;
  final Color swatch;

  const FilterPreset({required this.id, required this.label, required this.swatch});
}

const filterPresets = [
  FilterPreset(id: 'none', label: 'Original', swatch: Color(0xFF9CA3AF)),
  FilterPreset(id: 'grayscale', label: 'B&W', swatch: Color(0xFF374151)),
  FilterPreset(id: 'sepia', label: 'Sepia', swatch: Color(0xFF8B6F47)),
  FilterPreset(id: 'vintage', label: 'Vintage', swatch: Color(0xFFA0785A)),
  FilterPreset(id: 'cool', label: 'Cool', swatch: Color(0xFF1E40AF)),
  FilterPreset(id: 'warm', label: 'Warm', swatch: Color(0xFFC2410C)),
];

class FilterPresetsWidget extends StatelessWidget {
  final String active;
  final ValueChanged<String> onChange;

  const FilterPresetsWidget({super.key, required this.active, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: Text('FILTER PRESETS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.1, color: Color(0xFF555555))),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.8,
          ),
          itemCount: filterPresets.length,
          itemBuilder: (context, index) {
            final p = filterPresets[index];
            final isActive = active == p.id;
            return GestureDetector(
              onTap: () => onChange(p.id),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardTheme.color,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isActive ? const Color(0xFFFA5D29) : Theme.of(context).dividerColor,
                    width: isActive ? 2 : 1,
                  ),
                ),
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: p.swatch,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Theme.of(context).dividerColor),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(p.label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
