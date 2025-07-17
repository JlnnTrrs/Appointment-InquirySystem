import 'package:flutter/material.dart';
import 'transaction_type_page.dart';

/// Confirmation Dialog
Future<bool?> showConfirmationDialog(
  BuildContext context,
  String highlightText,
  String type,
) async {
  final size = MediaQuery.of(context).size;
  final scale = ((size.width + size.height) / 2) / 700;

  final dialogWidth = (size.width * 0.80).clamp(320.0, 540.0).toDouble();
  final double titleSize = (25 * scale).clamp(18.0, 28.0).toDouble();
  final double prefixSize = (16 * scale).clamp(12.0, 18.0).toDouble();
  final double highlightSize = (18 * scale).clamp(12.0, 20.0).toDouble();
  final double buttonSize = (16 * scale).clamp(12.0, 18.0).toDouble();
  final double paddingH = (26 * scale.clamp(0.8, 1.3)).toDouble();
  final double paddingV = (30 * scale.clamp(0.8, 1.3)).toDouble();
  final double buttonPaddingH = (28 * scale.clamp(0.8, 1.2)).toDouble();
  final double buttonPaddingV = (12 * scale.clamp(0.8, 1.2)).toDouble();

  String prefixText = type == 'appointment'
      ? 'Are you sure you want to request an appointment with'
      : 'Are you sure you want to make an inquiry for';

  return showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (_) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      child: Container(
        width: dialogWidth,
        padding: EdgeInsets.symmetric(
          vertical: paddingV,
          horizontal: paddingH,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'CONFIRMATION',
              style: TextStyle(
                fontSize: titleSize,
                fontWeight: FontWeight.w900,
                fontFamily: 'Montserrat',
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              prefixText,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: prefixSize,
                fontFamily: 'Montserrat',
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                  fontSize: highlightSize,
                  fontFamily: 'Montserrat',
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: '"${highlightText.toUpperCase()}"',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const TextSpan(
                    text: '?',
                    style: TextStyle(fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Wrap(
              spacing: 20,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFBE0002), width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: buttonPaddingH,
                      vertical: buttonPaddingV,
                    ),
                  ),
                  child: Text(
                    'YES',
                    style: TextStyle(
                      fontSize: buttonSize,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Montserrat',
                      color: Color(0xFFBE0002),
                    ),
                  ),
                ),
                OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.black, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: buttonPaddingH,
                      vertical: buttonPaddingV,
                    ),
                  ),
                  child: Text(
                    'NO',
                    style: TextStyle(
                      fontSize: buttonSize,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Montserrat',
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Future<void> showSuccessScreen(BuildContext context) async {
  final overlay = Overlay.of(context);
  final size = MediaQuery.of(context).size;
  final scale = ((size.width + size.height) / 2) / 800;

  // Set larger font size for the header and smaller for the rest of the text
  final double headerFontSize = (48 * scale).clamp(40.0, 60.0).toDouble(); // Header font size
  final double bodyFontSize = (32 * scale).clamp(28.0, 40.0).toDouble(); // Body text font size
  final double paddingV = (20 * scale).clamp(16.0, 28.0).toDouble();

  final entry = OverlayEntry(
    builder: (context) => Stack(
      children: [
        // Background to block interaction and cover the whole screen
        ModalBarrier(
          dismissible: false,
          color: Colors.black.withOpacity(0.5),
        ),
        // Full-screen container with message
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: Container(
              color: const Color(0xFFBE0002),
              padding: EdgeInsets.symmetric(
                vertical: paddingV,
                horizontal: 16,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Header Text ("PLEASE WAIT")
                    Text(
                      'PLEASE WAIT',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: headerFontSize, // Larger font size for the header
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w900,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16), // Space between header and body text
                    // Body Text
                    Text(
                      'AN EMPLOYEE WILL ASSIST YOU SHORTLY.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: bodyFontSize, // Smaller font size for the body
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );

  overlay.insert(entry);
  await Future.delayed(const Duration(seconds: 10));
  entry.remove();

  Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (_) => const TransactionTypePage()),
  );
}
