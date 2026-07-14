import 'dart:async';
import 'package:flutter/material.dart';

class ToastService extends ChangeNotifier {
  static final ToastService instance = ToastService._();
  ToastService._();

  String? _message;
  Color? _bgColor;
  Timer? _timer;

  String? get message => _message;
  Color? get bgColor => _bgColor;

  void show(String text, {Color bg = const Color(0xFF1A1A1A), Duration duration = const Duration(milliseconds: 2800)}) {
    _timer?.cancel();
    _message = text;
    _bgColor = bg;
    notifyListeners();
    _timer = Timer(duration, () {
      _message = null;
      notifyListeners();
    });
  }

  void success(String text) => show(text, bg: const Color(0xFF10B981));
  void info(String text) => show(text, bg: const Color(0xFF3B82F6));
  void danger(String text) => show(text, bg: const Color(0xFFEF4444));
}

class ToastOverlay extends StatelessWidget {
  const ToastOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ToastService.instance,
      builder: (context, _) {
        final msg = ToastService.instance.message;
        if (msg == null) return const SizedBox.shrink();
        return Positioned(
          top: MediaQuery.of(context).padding.top + 60,
          left: 20,
          right: 20,
          child: AnimatedOpacity(
            opacity: 1,
            duration: const Duration(milliseconds: 240),
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(10),
              color: ToastService.instance.bgColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                child: Text(
                  msg,
                  style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
