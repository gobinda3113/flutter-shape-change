import 'dart:math';
import 'package:flutter/material.dart';

Path polygonPath(int sides, {double cx = 50, double cy = 50, double r = 48, double rotation = -pi / 2}) {
  final path = Path();
  for (int i = 0; i < sides; i++) {
    final a = rotation + (i / sides) * pi * 2;
    final x = cx + cos(a) * r;
    final y = cy + sin(a) * r;
    if (i == 0) {
      path.moveTo(x, y);
    } else {
      path.lineTo(x, y);
    }
  }
  path.close();
  return path;
}

Path starPath(int points, {double cx = 50, double cy = 50, double outerR = 48, double innerR = 22}) {
  final path = Path();
  final step = pi / points;
  for (int i = 0; i < points * 2; i++) {
    final r = i % 2 == 0 ? outerR : innerR;
    final a = -pi / 2 + i * step;
    final x = cx + cos(a) * r;
    final y = cy + sin(a) * r;
    if (i == 0) {
      path.moveTo(x, y);
    } else {
      path.lineTo(x, y);
    }
  }
  path.close();
  return path;
}

const heartPath = 'M50,85 C50,85 10,55 10,30 C10,15 22,8 32,8 C40,8 47,12 50,20 C53,12 60,8 68,8 C78,8 90,15 90,30 C90,55 50,85 50,85 Z';
const cloudPath = 'M25,72 C12,72 5,62 5,52 C5,42 13,34 23,34 C25,22 35,14 48,14 C60,14 70,22 73,34 C85,35 95,44 95,55 C95,65 87,72 75,72 Z';
const dropletPath = 'M50,5 C50,5 20,40 20,62 C20,80 33,92 50,92 C67,92 80,80 80,62 C80,40 50,5 50,5 Z';
const beanPath = 'M20,30 Q20,10 40,10 Q60,10 65,30 Q90,40 90,60 Q90,90 65,90 Q40,90 35,70 Q10,60 10,40 Q10,30 20,30 Z';
const speechPath = 'M10,15 Q10,5 20,5 L80,5 Q90,5 90,15 L90,60 Q90,70 80,70 L45,70 L30,85 L32,70 L20,70 Q10,70 10,60 Z';
const shieldPath = 'M50,5 L88,18 L88,52 Q88,80 50,95 Q12,80 12,52 L12,18 Z';
const arrowPath = 'M5,35 L60,35 L60,15 L95,50 L60,85 L60,65 L5,65 Z';
const plusPath = 'M35,5 L65,5 L65,35 L95,35 L95,65 L65,65 L65,95 L35,95 L35,65 L5,65 L5,35 L35,35 Z';
const squirclePath = 'M50,5 C77,5 95,23 95,50 C95,77 77,95 50,95 C23,95 5,77 5,50 C5,23 23,5 50,5 Z';
const pillPath = 'M25,15 L75,15 Q95,15 95,50 Q95,85 75,85 L25,85 Q5,85 5,50 Q5,15 25,15 Z';
const ringPath = 'M50,5 C75,5 95,25 95,50 C95,75 75,95 50,95 C25,95 5,75 5,50 C5,25 25,5 50,5 Z M50,25 C36,25 25,36 25,50 C25,64 36,75 50,75 C64,75 75,64 75,50 C75,36 64,25 50,25 Z';
const crossPath = 'M15,15 L25,5 L50,30 L75,5 L85,15 L60,40 L85,65 L75,75 L50,50 L25,75 L15,65 L40,40 Z';

Path svgDPathToFlutter(String d, {double scale = 1.0, double offsetX = 0, double offsetY = 0}) {
  final path = Path();
  double currentX = 0, currentY = 0;
  double startX = 0, startY = 0;
  int i = 0;

  while (i < d.length) {
    final ch = d[i];
    if (ch == ' ' || ch == ',' || ch == '\n' || ch == '\r' || ch == '\t') {
      i++;
      continue;
    }

    final cmd = ch;
    i++;

    switch (cmd) {
      case 'M':
      case 'L': {
        final nums = _parseNumbers(d, i);
        if (nums.length >= 2) {
          currentX = nums[0] * scale + offsetX;
          currentY = nums[1] * scale + offsetY;
          startX = currentX;
          startY = currentY;
          path.moveTo(currentX, currentY);
          i = nums[2].toInt();
        }
        break;
      }
      case 'C': {
        final nums = _parseNumbers(d, i);
        if (nums.length >= 6) {
          final x1 = nums[0] * scale + offsetX;
          final y1 = nums[1] * scale + offsetY;
          final x2 = nums[2] * scale + offsetX;
          final y2 = nums[3] * scale + offsetY;
          currentX = nums[4] * scale + offsetX;
          currentY = nums[5] * scale + offsetY;
          path.cubicTo(x1, y1, x2, y2, currentX, currentY);
          i = nums[6].toInt();
        }
        break;
      }
      case 'Q': {
        final nums = _parseNumbers(d, i);
        if (nums.length >= 4) {
          final x1 = nums[0] * scale + offsetX;
          final y1 = nums[1] * scale + offsetY;
          currentX = nums[2] * scale + offsetX;
          currentY = nums[3] * scale + offsetY;
          path.quadraticBezierTo(x1, y1, currentX, currentY);
          i = nums[4].toInt();
        }
        break;
      }
      case 'H': {
        final nums = _parseNumbers(d, i);
        if (nums.isNotEmpty) {
          currentX = nums[0] * scale + offsetX;
          path.lineTo(currentX, currentY);
          i = nums[1].toInt();
        }
        break;
      }
      case 'V': {
        final nums = _parseNumbers(d, i);
        if (nums.isNotEmpty) {
          currentY = nums[0] * scale + offsetY;
          path.lineTo(currentX, currentY);
          i = nums[1].toInt();
        }
        break;
      }
      case 'Z':
      case 'z':
        path.close();
        currentX = startX;
        currentY = startY;
        break;
    }
  }
  return path;
}

List<double> _parseNumbers(String d, int start) {
  final nums = <double>[];
  final buffer = StringBuffer();
  int i = start;

  while (i < d.length && nums.length < 8) {
    final ch = d[i];
    if (ch == ' ' || ch == ',' || ch == '\n' || ch == '\r' || ch == '\t') {
      if (buffer.isNotEmpty) {
        nums.add(double.tryParse(buffer.toString()) ?? 0);
        buffer.clear();
      }
      i++;
      continue;
    }
    if ((ch == '-' || ch == '+') && buffer.isNotEmpty) {
      nums.add(double.tryParse(buffer.toString()) ?? 0);
      buffer.clear();
      buffer.write(ch);
      i++;
      continue;
    }
    if (ch == 'A' || ch == 'a' || ch == 'M' || ch == 'L' || ch == 'C' || ch == 'Q' || ch == 'Z' || ch == 'z') {
      if (buffer.isNotEmpty) {
        nums.add(double.tryParse(buffer.toString()) ?? 0);
        buffer.clear();
      }
      break;
    }
    buffer.write(ch);
    i++;
  }
  if (buffer.isNotEmpty) {
    nums.add(double.tryParse(buffer.toString()) ?? 0);
  }
  nums.add(i.toDouble());
  return nums;
}

Path pathFromSvgString(String d, double size) {
  final scale = size / 100;
  return svgDPathToFlutter(d, scale: scale);
}
