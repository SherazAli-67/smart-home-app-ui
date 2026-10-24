import 'package:flutter/material.dart';
import 'package:smart_home_app/constants/number_constant.dart';

class PulseRing extends StatefulWidget {
  final Widget child;
  final bool enabled;
  final Duration duration;
  final double minScale;
  final double maxScale;
  final double minOpacity;
  final double maxOpacity;

  const PulseRing({
    super.key,
    required this.child,
    this.enabled = true,
    this.duration = NumberConstant.animPulse,
    this.minScale = 0.92,
    this.maxScale = 1.08,
    this.minOpacity = 0.55,
    this.maxOpacity = 1,
  });

  @override
  State<PulseRing> createState() => _PulseRingState();
}

class _PulseRingState extends State<PulseRing> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _scale = Tween<double>(begin: widget.minScale, end: widget.maxScale).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _opacity = Tween<double>(begin: widget.minOpacity, end: widget.maxOpacity).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _syncAnimation();
  }

  @override
  void didUpdateWidget(covariant PulseRing oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.enabled != widget.enabled) _syncAnimation();
  }

  void _syncAnimation() {
    if (widget.enabled) {
      _controller.repeat(reverse: true);
    } else {
      _controller
        ..stop()
        ..value = 1;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacity.value,
          child: Transform.scale(scale: _scale.value, child: child),
        );
      },
      child: widget.child,
    );
  }
}
