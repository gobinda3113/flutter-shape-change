import 'dart:ui' as ui;
import 'dart:io';
import 'package:flutter/material.dart';

class BgConfig {
  String type; // transparent, solid, gradient
  Color color;
  Color color2;
  double angle;

  BgConfig({
    this.type = 'transparent',
    this.color = Colors.white,
    this.color2 = const Color(0xFFFA5D29),
    this.angle = 135,
  });

  BgConfig copyWith({String? type, Color? color, Color? color2, double? angle}) {
    return BgConfig(
      type: type ?? this.type,
      color: color ?? this.color,
      color2: color2 ?? this.color2,
      angle: angle ?? this.angle,
    );
  }
}

class EffectConfig {
  bool border;
  double borderSize;
  Color borderColor;
  bool shadow;
  double shadowBlur;
  Color shadowColor;
  double shadowOffsetX;
  double shadowOffsetY;
  bool glow;
  double glowSize;
  Color glowColor;

  EffectConfig({
    this.border = false,
    this.borderSize = 4,
    this.borderColor = Colors.white,
    this.shadow = false,
    this.shadowBlur = 20,
    this.shadowColor = Colors.black,
    this.shadowOffsetX = 0,
    this.shadowOffsetY = 8,
    this.glow = false,
    this.glowSize = 20,
    this.glowColor = const Color(0xFFFA5D29),
  });

  EffectConfig copyWith({
    bool? border,
    double? borderSize,
    Color? borderColor,
    bool? shadow,
    double? shadowBlur,
    Color? shadowColor,
    double? shadowOffsetX,
    double? shadowOffsetY,
    bool? glow,
    double? glowSize,
    Color? glowColor,
  }) {
    return EffectConfig(
      border: border ?? this.border,
      borderSize: borderSize ?? this.borderSize,
      borderColor: borderColor ?? this.borderColor,
      shadow: shadow ?? this.shadow,
      shadowBlur: shadowBlur ?? this.shadowBlur,
      shadowColor: shadowColor ?? this.shadowColor,
      shadowOffsetX: shadowOffsetX ?? this.shadowOffsetX,
      shadowOffsetY: shadowOffsetY ?? this.shadowOffsetY,
      glow: glow ?? this.glow,
      glowSize: glowSize ?? this.glowSize,
      glowColor: glowColor ?? this.glowColor,
    );
  }
}

class AdjustConfig {
  double scale;
  double rotation;
  double offsetX;
  double offsetY;
  double brightness;
  double contrast;
  double saturation;
  double blur;
  String filter;

  AdjustConfig({
    this.scale = 100,
    this.rotation = 0,
    this.offsetX = 0,
    this.offsetY = 0,
    this.brightness = 100,
    this.contrast = 100,
    this.saturation = 100,
    this.blur = 0,
    this.filter = 'none',
  });

  AdjustConfig copyWith({
    double? scale,
    double? rotation,
    double? offsetX,
    double? offsetY,
    double? brightness,
    double? contrast,
    double? saturation,
    double? blur,
    String? filter,
  }) {
    return AdjustConfig(
      scale: scale ?? this.scale,
      rotation: rotation ?? this.rotation,
      offsetX: offsetX ?? this.offsetX,
      offsetY: offsetY ?? this.offsetY,
      brightness: brightness ?? this.brightness,
      contrast: contrast ?? this.contrast,
      saturation: saturation ?? this.saturation,
      blur: blur ?? this.blur,
      filter: filter ?? this.filter,
    );
  }
}

class ImageItem {
  final String id;
  final String name;
  File? file;
  ui.Image? image;
  String shapeId;
  AdjustConfig adjust;
  EffectConfig effects;
  BgConfig bg;

  ImageItem({
    required this.id,
    required this.name,
    this.file,
    this.image,
    this.shapeId = 'circle',
    AdjustConfig? adjust,
    EffectConfig? effects,
    BgConfig? bg,
  })  : adjust = adjust ?? AdjustConfig(),
        effects = effects ?? EffectConfig(),
        bg = bg ?? BgConfig();
}

const int maxImages = 5;
