import 'package:flutter/material.dart';
import 'transaction_type_page.dart';

class IdleScreenPage extends StatefulWidget {
  const IdleScreenPage({super.key});

  @override
  State<IdleScreenPage> createState() => _IdleScreenPageState();
}

class _IdleScreenPageState extends State<IdleScreenPage> {
  int _currentIndex = 0;
  final List<String> _ads = [
    'assets/ads/ad1.png',
    'assets/ads/ad2.png',
    'assets/ads/ad3.png',
  ];

  @override
  void initState() {
    super.initState();
    // Start automatic slideshow
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 5));
      if (!mounted) return false;
      setState(() {
        _currentIndex = (_currentIndex + 1) % _ads.length;
      });
      return true;
    });
  }

  void _goToTransactionTypePage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const TransactionTypePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double scale = (size.shortestSide / 400).clamp(0.75, 1.3);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _goToTransactionTypePage,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Expanded(
              flex: 5,
              child: AnimatedSwitcher(
                duration: const Duration(seconds: 1),
                child: Image.asset(
                  _ads[_currentIndex],
                  key: ValueKey<String>(_ads[_currentIndex]),
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.black,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 16 * scale),
                child: Text(
                  'Click anywhere to start',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22 * scale,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
