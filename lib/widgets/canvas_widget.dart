import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../utils/editor_state.dart';
import '../utils/path_builder.dart';
import '../shapes/shape_library.dart';

class MaskedImageCanvas extends StatelessWidget {
  final ImageItem? item;
  final double zoom;

  const MaskedImageCanvas({super.key, this.item, this.zoom = 1});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _MaskedImagePainter(item: item),
          size: const Size(1000, 1000),
        ),
      ),
    );
  }
}

class _MaskedImagePainter extends CustomPainter {
  final ImageItem? item;

  _MaskedImagePainter({required this.item});

  @override
  void paint(Canvas canvas, Size size) {
    if (item == null) return;

    final w = size.width;
    final h = size.height;

    if (item!.bg.type == 'solid') {
      canvas.drawRect(Rect.fromLTWH(0, 0, w, h), Paint()..color = item!.bg.color);
    } else if (item!.bg.type == 'gradient') {
      final rad = item!.bg.angle * math.pi / 180;
      final diag = math.sqrt(w * w + h * h) / 2;
      final cx = w / 2, cy = h / 2;
      final x1 = cx - math.cos(rad) * diag;
      final y1 = cy - math.sin(rad) * diag;
      final x2 = cx + math.cos(rad) * diag;
      final y2 = cy + math.sin(rad) * diag;
      final gradient = ui.Gradient.linear(Offset(x1, y1), Offset(x2, y2), [item!.bg.color, item!.bg.color2]);
      canvas.drawRect(Rect.fromLTWH(0, 0, w, h), Paint()..shader = gradient);
    }

    if (item!.image == null) return;

    Path? maskPath;
    try {
      final shape = getShapeById(item!.shapeId);
      maskPath = pathFromSvgString(shape?.path ?? 'M50,2 A48,48 0 1,1 49.99,2 Z', w);
    } catch (_) {
      return;
    }

    final img = item!.image!;
    final baseScale = math.min(w / img.width, h / img.height);
    final userScale = item!.adjust.scale / 100;
    final finalScale = baseScale * userScale;
    final drawW = img.width * finalScale;
    final drawH = img.height * finalScale;

    final cx = w / 2 + (item!.adjust.offsetX / 100) * (w / 2);
    final cy = h / 2 + (item!.adjust.offsetY / 100) * (h / 2);

    if (item!.effects.shadow) {
      canvas.save();
      final shadowPaint = Paint()
        ..color = item!.effects.shadowColor.withAlpha((item!.effects.shadowColor.a * 255).round())
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, item!.effects.shadowBlur);
      canvas.translate(item!.effects.shadowOffsetX, item!.effects.shadowOffsetY);
      canvas.drawPath(maskPath, shadowPaint);
      canvas.restore();
    }

    if (item!.effects.glow) {
      canvas.save();
      final glowPaint = Paint()
        ..color = item!.effects.glowColor.withAlpha((item!.effects.glowColor.a * 255).round())
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, item!.effects.glowSize);
      canvas.drawPath(maskPath, glowPaint);
      canvas.restore();
    }

    canvas.save();
    canvas.clipPath(maskPath);

    canvas.save();
    canvas.translate(cx, cy);
    canvas.rotate(item!.adjust.rotation * math.pi / 180);

    canvas.drawImageRect(
      img,
      Rect.fromLTWH(0, 0, img.width.toDouble(), img.height.toDouble()),
      Rect.fromCenter(center: Offset.zero, width: drawW, height: drawH),
      Paint()..filterQuality = FilterQuality.high,
    );

    canvas.restore();

    if (item!.adjust.filter == 'cool' || item!.adjust.filter == 'warm') {
      final overlayColor = item!.adjust.filter == 'cool'
          ? const Color(0xFF4A90E2).withAlpha(71)
          : const Color(0xFFFF7A3D).withAlpha(71);
      canvas.drawRect(Rect.fromLTWH(0, 0, w, h), Paint()..color = overlayColor);
    }

    canvas.restore();

    if (item!.effects.border) {
      canvas.drawPath(
        maskPath,
        Paint()
          ..color = item!.effects.borderColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = item!.effects.borderSize
          ..strokeJoin = StrokeJoin.round,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _MaskedImagePainter old) => old.item != item;
}
