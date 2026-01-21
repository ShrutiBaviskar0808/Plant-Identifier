import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:shimmer/shimmer.dart';

class PremiumEffectsService {
  // Particle Rain Effect
  static Widget createRainEffect({required Widget child}) {
    return Stack(
      children: [
        child,
        ...List.generate(50, (index) => 
          Positioned(
            left: (index * 20.0) % 400,
            top: -10,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: -50, end: 800),
              duration: Duration(seconds: 2),
              builder: (context, position, child) {
                return Transform.translate(
                  offset: Offset(0, position),
                  child: Container(
                    width: 2,
                    height: 20,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.withValues(alpha: 0.7), Colors.transparent],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  // Glassmorphism Card
  static Widget createGlassCard({
    required Widget child,
    double blur = 20,
    double opacity = 0.2,
  }) {
    return GlassmorphicContainer(
      width: double.infinity,
      height: double.infinity,
      borderRadius: 20,
      blur: blur,
      alignment: Alignment.bottomCenter,
      border: 2,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withValues(alpha: 0.1),
          Colors.white.withValues(alpha: 0.05),
        ],
      ),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withValues(alpha: 0.5),
          Colors.white.withValues(alpha: 0.2),
        ],
      ),
      child: child,
    );
  }

  // Shimmer Loading Effect
  static Widget createShimmerEffect({
    required Widget child,
    Color? baseColor,
    Color? highlightColor,
  }) {
    return Shimmer.fromColors(
      baseColor: baseColor ?? Colors.grey[300]!,
      highlightColor: highlightColor ?? Colors.grey[100]!,
      child: child,
    );
  }

  // Floating Animation
  static Widget createFloatingEffect({
    required Widget child,
    Duration duration = const Duration(seconds: 3),
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: -10),
      duration: duration,
      builder: (context, offset, _) {
        return Transform.translate(
          offset: Offset(0, offset),
          child: Transform.scale(
            scale: 1.0 + (offset.abs() / 100),
            child: child,
          ),
        );
      },
    );
  }

  // Pulse Effect
  static Widget createPulseEffect({
    required Widget child,
    Duration duration = const Duration(milliseconds: 1500),
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 1.0, end: 1.1),
      duration: duration,
      builder: (context, scale, _) {
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
    );
  }

  // Morphing Transition
  static Widget createMorphTransition({
    required Widget from,
    required Widget to,
    required bool showFirst,
    Duration duration = const Duration(milliseconds: 800),
  }) {
    return AnimatedSwitcher(
      duration: duration,
      transitionBuilder: (child, animation) {
        return ScaleTransition(
          scale: animation,
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      child: showFirst ? from : to,
    );
  }

  // Cinematic Page Transition
  static PageRouteBuilder<T> createCinematicRoute<T>({
    required Widget page,
    Duration duration = const Duration(milliseconds: 1200),
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    );
  }

  // Health Aura Effect
  static Widget createHealthAura({
    required Widget child,
    required double healthScore,
  }) {
    final color = healthScore > 0.7 
        ? Colors.green 
        : healthScore > 0.4 
            ? Colors.orange 
            : Colors.red;

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: child,
    );
  }

  // Scanning Animation
  static Widget createScanningEffect({
    required Widget child,
    required AnimationController controller,
  }) {
    return Stack(
      children: [
        child,
        AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            return Positioned(
              top: controller.value * 300,
              left: 0,
              right: 0,
              child: Container(
                height: 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.green.withValues(alpha: 0.8),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}