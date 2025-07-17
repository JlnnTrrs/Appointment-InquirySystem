import 'dart:async';
import 'package:flutter/material.dart';
import 'inquiry_type_page.dart';
import 'employee_list_page.dart';
import 'speaker.dart';
import 'custom_header.dart';
import 'idle_screen_page.dart';

class OptionItem {
  final String label;
  final String type;
  final IconData icon;

  OptionItem({required this.label, required this.type, required this.icon});
}

class TransactionTypePage extends StatefulWidget {
  const TransactionTypePage({super.key});

  @override
  State<TransactionTypePage> createState() => _TransactionTypePageState();
}

class _TransactionTypePageState extends State<TransactionTypePage> {
  Timer? _inactivityTimer;

  @override
  void initState() {
    super.initState();
    speakText("Welcome, please choose the transaction you want.");
    _startInactivityTimer();
  }

  @override
  void dispose() {
    _inactivityTimer?.cancel();
    super.dispose();
  }

  void _startInactivityTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(const Duration(seconds: 30), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const IdleScreenPage()),
      );
    });
  }

  void _resetInactivityTimer() {
    _startInactivityTimer();
  }

  void handleTransactionType(BuildContext context, String type) async {
    _inactivityTimer?.cancel();
    await speakText('You selected $type');
    await Future.delayed(const Duration(milliseconds: 1300));

    if (type == 'Inquiry') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const InquiryTypePage()));
    } else if (type == 'Appointment') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const EmployeeListPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final options = [
      OptionItem(label: 'Inquiry', type: 'Inquiry', icon: Icons.help_outline),
      OptionItem(label: 'Appointment', type: 'Appointment', icon: Icons.calendar_today),
    ];

    final size = MediaQuery.of(context).size;
    final double width = size.width;
    final double height = size.height;
    final double scale = ((width + height) / 2) / 800;
    final crossAxisCount = width < 600 ? 1 : 2;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _resetInactivityTimer,
      onPanDown: (_) => _resetInactivityTimer(),
      child: Scaffold(
        backgroundColor: const Color(0xFFBE0002),
        body: SafeArea(
          child: Column(
            children: [
              const CustomHeader(),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      physics: constraints.maxHeight < 500
                          ? const BouncingScrollPhysics()
                          : const NeverScrollableScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: constraints.maxHeight),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 18 * scale),
                                child: Text(
                                  'WHAT WOULD YOU LIKE TO DO?',
                                  style: TextStyle(
                                    fontSize: (30 * scale).clamp(20, 36),
                                    fontWeight: FontWeight.w900,
                                    fontFamily: 'Montserrat',
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(height: 25 * scale),
                              ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 800),
                                child: GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: options.length,
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: crossAxisCount,
                                    crossAxisSpacing: 30 * scale,
                                    mainAxisSpacing: 30 * scale,
                                    mainAxisExtent: (height * 0.33).clamp(120, 200),
                                  ),
                                  itemBuilder: (context, index) {
                                    final option = options[index];
                                    return GestureDetector(
                                      onTap: () => handleTransactionType(context, option.type),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(20 * scale),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.55),
                                              blurRadius: 12 * scale,
                                              offset: Offset(0, 3 * scale),
                                            ),
                                          ],
                                        ),
                                        padding: EdgeInsets.symmetric(horizontal: 16 * scale),
                                        child: Center(
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                option.icon,
                                                size: (35 * scale).clamp(20, 40),
                                                color: Colors.black,
                                              ),
                                              SizedBox(width: 16 * scale),
                                              Text(
                                                option.label,
                                                style: TextStyle(
                                                  fontFamily: 'OpenSans',
                                                  fontSize: (25 * scale).clamp(14, 24),
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 15),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '© 2025 University of Mindanao. All Rights Reserved.',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: (12 * scale).clamp(10, 14),
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
