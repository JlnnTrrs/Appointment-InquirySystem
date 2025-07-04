import 'package:flutter/material.dart';
import 'api_service.dart';
import 'speaker.dart';
import 'transaction_type_page.dart';

class InquiryTypePage extends StatefulWidget {
  const InquiryTypePage({super.key});

  @override
  State<InquiryTypePage> createState() => _InquiryTypePageState();
}

class _InquiryTypePageState extends State<InquiryTypePage> {
  @override
  void initState() {
    super.initState();
    speakText("Please choose an inquiry type");
  }

  Future<void> submitInquiry(BuildContext context, String inquiryType) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirm Inquiry'),
        content: Text('Are you sure you want to request an inquiry for "$inquiryType"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    // Speak with abbreviation fix (MIS → M I S)
    String spokenText = inquiryType.replaceAllMapped(
      RegExp(r'\bMIS\b', caseSensitive: false),
      (match) => 'M I S',
    );

    speakText("An inquiry for $spokenText has been requested. Please wait");

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        content: Row(
          children: const [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text("Submitting..."),
          ],
        ),
      ),
    );

    try {
      await ApiService.submitInquiry(inquiryType: inquiryType);
      Navigator.of(context).pop(); // Close loading dialog

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.hourglass_top, color: Colors.orange, size: 60),
              const SizedBox(height: 16),
              const Text(
                'Please wait. An employee will assist you shortly.',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        ),
      );

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const TransactionTypePage()),
        (route) => false,
      );
    } catch (e) {
      Navigator.of(context).pop(); // Close loading
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save inquiry: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scale = (size.shortestSide / 400).clamp(0.75, 1.4);

    final List<Map<String, dynamic>> options = [
      {'label': 'MIS / Employee Portal', 'icon': Icons.computer},
      {'label': 'CRMS / Academic Portal', 'icon': Icons.school},
      {'label': 'Student Academic Portal', 'icon': Icons.account_box},
      {'label': 'Others', 'icon': Icons.help_outline},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFDE1923),
      appBar: AppBar(
        backgroundColor: const Color(0xFFDE1923),
        elevation: 0,
        title: Text(
          'Select Inquiry Type',
          style: TextStyle(
            fontSize: 20 * scale,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        toolbarHeight: 60 * scale,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final int crossAxisCount = constraints.maxWidth > 600 ? 2 : 1;

          return Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24 * scale, vertical: 32 * scale),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 700),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Select your inquiry type:',
                      style: TextStyle(
                        fontSize: 24 * scale,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 32 * scale),
                    GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 24 * scale,
                      mainAxisSpacing: 24 * scale,
                      childAspectRatio: 2.8,
                      physics: const NeverScrollableScrollPhysics(),
                      children: options.map((option) {
                        return GestureDetector(
                          onTap: () => submitInquiry(context, option['label']),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16 * scale),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16 * scale),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  blurRadius: 20 * scale,
                                  spreadRadius: 4 * scale,
                                  offset: Offset(0, 10 * scale),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(option['icon'], color: Colors.black, size: 24 * scale),
                                  SizedBox(width: 10 * scale),
                                  Flexible(
                                    child: Text(
                                      option['label'],
                                      style: TextStyle(
                                        fontSize: 18 * scale,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 40 * scale),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.arrow_back, size: 20 * scale, color: Colors.black),
                        label: Text(
                          'Back',
                          style: TextStyle(fontSize: 16 * scale, color: Colors.black),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          elevation: 6,
                          padding: EdgeInsets.symmetric(
                            horizontal: 24 * scale,
                            vertical: 14 * scale,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16 * scale),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
