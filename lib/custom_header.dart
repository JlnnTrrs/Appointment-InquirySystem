import 'package:flutter/material.dart';
import 'dart:ui';

class CustomHeader extends StatelessWidget {
  const CustomHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isWide = constraints.maxWidth > 600;
      final textScale = constraints.maxWidth / 400;

      return Container(
        color: const Color(0xFFBE0002),
        padding: const EdgeInsets.only(top: 5, bottom: 5),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                  right: isWide ? 120 : 100,
                  left: isWide ? 24 : 16,
                  top: isWide ? 4 : 8,
                  bottom: isWide ? 4 : 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.55),
                      offset: const Offset(0, 12),
                      blurRadius: 20,
                      spreadRadius: -4,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'MIS OFFICE KIOSK',
                        style: TextStyle(
                          fontSize: 20 * textScale.clamp(1, 1.4),
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFFBE0002),
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'APPOINTMENT AND INQUIRY SYSTEM',
                        style: TextStyle(
                          fontSize: 14 * textScale.clamp(1, 1.3),
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFFBE0002),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      child: ImageFiltered(
                        imageFilter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                        child: ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.30),
                            BlendMode.srcATop,
                          ),
                          child: Image.asset(
                            'assets/logos/mis_logo.png',
                            height: isWide ? 60 : 60,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: isWide ? 60 : 60,
                      child: Image.asset(
                        'assets/logos/mis_logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}