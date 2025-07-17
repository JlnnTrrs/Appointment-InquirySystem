import 'dart:async';
import 'package:flutter/material.dart';
import 'api_service.dart';
import 'speaker.dart';
import 'custom_header.dart';
import 'dialogs.dart';
import 'idle_screen_page.dart'; // ✅ Import IdleScreenPage

class InquiryTypePage extends StatefulWidget {
  const InquiryTypePage({super.key});

  @override
  State<InquiryTypePage> createState() => _InquiryTypePageState();
}

class _InquiryTypePageState extends State<InquiryTypePage> {
  final List<Map<String, dynamic>> options = [
    {'label': 'MIS / Employee Portal', 'icon': Icons.computer},
    {'label': 'CRMS / Academic Portal', 'icon': Icons.school},
    {'label': 'Student Academic Portal', 'icon': Icons.account_box},
    {'label': 'Others', 'icon': Icons.help_outline},
  ];

  Timer? _inactivityTimer; // ✅ Inactivity timer

  @override
  void initState() {
    super.initState();
    speakText("Please choose the type of inquiry you want to make.");
    _startInactivityTimer();
  }

  @override
  void dispose() {
    _inactivityTimer?.cancel();
    super.dispose();
  }

  void _startInactivityTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(const Duration(seconds: 45), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const IdleScreenPage()),
      );
    });
  }

  void _resetInactivityTimer() {
    _startInactivityTimer();
  }

  Future<void> submitInquiry(BuildContext context, String inquiryType) async {
    _inactivityTimer?.cancel();

    final String spokenText = inquiryType
        .replaceAllMapped(RegExp(r'\bMIS\b', caseSensitive: false), (match) => 'M I S')
        .replaceAllMapped(RegExp(r'\bCRMS\b', caseSensitive: false), (match) => 'C R M S');

    speakText("Are you sure you want to make an inquiry for $spokenText?");
    final bool? confirmed = await showConfirmationDialog(context, inquiryType, 'inquiry');

    if (confirmed != true) {
      _startInactivityTimer();
      return;
    }

    speakText("An inquiry for $spokenText has been requested. Please wait");

    try {
      await showSuccessScreen(context);
      await ApiService.submitInquiry(inquiryType: inquiryType);
    } catch (e) {
      Navigator.of(context).pop(); // close any open dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save inquiry: $e')),
      );
    }
  }

  Widget buildInquiryButton(BuildContext context, String label, IconData icon, double scale) {
    return GestureDetector(
      onTap: () {
        submitInquiry(context, label);
      },
      child: Container(
        constraints: const BoxConstraints(maxWidth: 420),
        padding: EdgeInsets.symmetric(horizontal: 16 * scale, vertical: 14 * scale),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16 * scale),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 6 * scale,
              offset: Offset(0, 4 * scale),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 22 * scale, color: Colors.black),
            SizedBox(width: 12 * scale),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 18 * scale,
                  fontFamily: 'OpenSans',
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final scale = ((width + height) / 2) / 800;
    final fontScale = scale.clamp(1.0, 1.5);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _resetInactivityTimer,
      onPanDown: (_) => _resetInactivityTimer(),
      child: Scaffold(
        backgroundColor: const Color(0xFFBE0002),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: [
                  const CustomHeader(),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.05,
                        vertical: 35 * fontScale,
                      ),
                      child: Column(
                        children: [
                          Text(
                            'PLEASE SELECT AN INQUIRY TYPE',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 28 * fontScale,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'Montserrat',
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Expanded(
                            child: Center(
                              child: options.length <= 4
                                  ? GridView.count(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 20 * fontScale,
                                      crossAxisSpacing: 20 * fontScale,
                                      childAspectRatio: 4.3,
                                      children: options
                                          .map((option) => buildInquiryButton(
                                                context,
                                                option['label'] as String,
                                                option['icon'] as IconData,
                                                fontScale,
                                              ))
                                          .toList(),
                                    )
                                  : LayoutBuilder(
                                      builder: (context, constraints) {
                                        int crossAxisCount = 2;
                                        double maxWidth = constraints.maxWidth;

                                        if (maxWidth >= 1200) {
                                          crossAxisCount = 5;
                                        } else if (maxWidth >= 900) {
                                          crossAxisCount = 4;
                                        } else if (maxWidth >= 600) {
                                          crossAxisCount = 3;
                                        }

                                        return GridView.builder(
                                          padding: const EdgeInsets.only(top: 8),
                                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: crossAxisCount,
                                            mainAxisSpacing: 30 * fontScale,
                                            crossAxisSpacing: 40 * fontScale,
                                            childAspectRatio: 3.2,
                                          ),
                                          itemCount: options.length,
                                          itemBuilder: (context, index) {
                                            final option = options[index];
                                            return buildInquiryButton(
                                              context,
                                              option['label'] as String,
                                              option['icon'] as IconData,
                                              fontScale,
                                            );
                                          },
                                        );
                                      },
                                    ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                _inactivityTimer?.cancel();
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.arrow_back,
                                  size: 15 * fontScale, color: Colors.black),
                              label: Text(
                                'Back',
                                style: TextStyle(
                                  fontSize: 15 * fontScale,
                                  color: Colors.black,
                                  fontFamily: 'OpenSans',
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                elevation: 6,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20 * fontScale,
                                  vertical: 12 * fontScale,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14 * fontScale),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 15 * scale),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '© 2025 University of Mindanao. All Rights Reserved.',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 11.5 * fontScale,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
