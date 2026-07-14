import 'package:flutter/material.dart';
import '../shapes/shape_library.dart';
import '../utils/path_builder.dart';

class ShapePickerWidget extends StatefulWidget {
  final String activeShapeId;
  final ValueChanged<String> onShapeSelected;

  const ShapePickerWidget({super.key, required this.activeShapeId, required this.onShapeSelected});

  @override
  State<ShapePickerWidget> createState() => _ShapePickerWidgetState();
}

class _ShapePickerWidgetState extends State<ShapePickerWidget> {
  String selectedCategory = 'Popular';

  @override
  Widget build(BuildContext context) {
    final filtered = allShapes.where((s) => s.category == selectedCategory).toList();
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 36,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: shapeCategories.map((cat) {
              final isActive = cat == selectedCategory;
              return Padding(
                padding: const EdgeInsets.only(right: 6),
                child: ChoiceChip(
                  label: Text(cat, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
                    color: isActive ? theme.colorScheme.onPrimary : null)),
                  selected: isActive,
                  onSelected: (_) => setState(() => selectedCategory = cat),
                  selectedColor: theme.colorScheme.primary,
                  backgroundColor: theme.cardTheme.color,
                  side: BorderSide(color: theme.dividerColor),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
            ),
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final shape = filtered[index];
              final isActive = widget.activeShapeId == shape.id;
              return GestureDetector(
                onTap: () => widget.onShapeSelected(shape.id),
                child: Container(
                  decoration: BoxDecoration(
                    color: isActive ? const Color(0xFFFA5D29) : theme.cardTheme.color,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isActive ? const Color(0xFFFA5D29) : theme.dividerColor,
                      width: isActive ? 2 : 1,
                    ),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: CustomPaint(
                    painter: ShapePreviewPainter(d: shape.path, color: isActive ? Colors.white : const Color(0xFFFA5D29)),
                    size: const Size.square(40),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class ShapePreviewPainter extends CustomPainter {
  final String d;
  final Color color;

  ShapePreviewPainter({required this.d, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..style = PaintingStyle.fill;
    final path = pathFromSvgString(d, size.width);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant ShapePreviewPainter old) => old.d != d || old.color != color;
}
