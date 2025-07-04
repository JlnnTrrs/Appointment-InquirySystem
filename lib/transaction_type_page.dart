import 'package:flutter/material.dart';
import 'inquiry_type_page.dart';
import 'employee_list_page.dart';
import 'speaker.dart'; // 👈 For TTS

class TransactionTypePage extends StatefulWidget {
  const TransactionTypePage({super.key});

  @override
  State<TransactionTypePage> createState() => _TransactionTypePageState();
}

class _TransactionTypePageState extends State<TransactionTypePage> {
  @override
  void initState() {
    super.initState();
    // 👇 Speak welcome message when the page loads
    speakText("Welcome, please choose the transaction you want.");
  }

  void handleTransactionType(BuildContext context, String type) {
    speakText('You selected $type');

    if (type == 'Inquiry') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const InquiryTypePage()),
      );
    } else if (type == 'Appointment') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const EmployeeListPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isWide = screenSize.width > 700;

    final List<Map<String, dynamic>> options = [
      {'label': 'Inquiry', 'type': 'Inquiry', 'icon': Icons.help_outline},
      {'label': 'Appointment', 'type': 'Appointment', 'icon': Icons.calendar_today},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFDE1923),
      appBar: AppBar(
        backgroundColor: const Color(0xFFDE1923),
        elevation: 0,
        toolbarHeight: 60,
        title: const Text(
          'Choose Transaction Type',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              children: [
                const Text(
                  'What do you need?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 40),
                Wrap(
                  spacing: 40,
                  runSpacing: 30,
                  alignment: WrapAlignment.center,
                  children: options.map((option) {
                    return GestureDetector(
                      onTap: () => handleTransactionType(context, option['type']),
                      child: Container(
                        width: isWide ? 320 : 280,
                        height: isWide ? 160 : 140,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(option['icon'], size: isWide ? 36 : 32, color: Colors.black),
                              const SizedBox(width: 16),
                              Text(
                                option['label'],
                                style: TextStyle(
                                  fontSize: isWide ? 26 : 22,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
