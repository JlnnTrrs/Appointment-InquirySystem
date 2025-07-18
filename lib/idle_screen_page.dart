import 'dart:async';
import 'package:flutter/material.dart';
import 'transaction_type_page.dart';

class IdleScreenPage extends StatefulWidget {
  const IdleScreenPage({super.key});

  @override
  State<IdleScreenPage> createState() => _IdleScreenPageState();
}

class _IdleScreenPageState extends State<IdleScreenPage> {
  final List<String> _ads = [
    'assets/ads/CourseQual.jpg',
    'assets/ads/CRMS.jpg',
    'assets/ads/ePlan.png',
    'assets/ads/MIS.jpg',
    'assets/ads/OATH.jpg',
    'assets/ads/QualiTeach.png',
    'assets/ads/UM Perform.jpg',
  ];

  late PageController _pageController;
  int _currentIndex = 0;
  Timer? _autoSwipeTimer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _startAutoSwipe();
  }

  @override
  void dispose() {
    _autoSwipeTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoSwipe() {
    _autoSwipeTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_pageController.hasClients) {
        final nextIndex = (_currentIndex + 1) % _ads.length;
        _pageController.animateToPage(
          nextIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _goToTransactionTypePage() {
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const TransactionTypePage()),
    );
  }

  void _goToPage(int index) {
    if (!mounted) return;
    _currentIndex = (index + _ads.length) % _ads.length;
    if (_pageController.hasClients) {
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    }
  }

  String _getAdLabel(String adPath) {
    final fileName = adPath.split('/').last;
    return fileName.replaceAll(RegExp(r'\.(jpg|png)$'), '');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double scale = (size.shortestSide / 400).clamp(0.75, 1.3);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _goToTransactionTypePage,
      onPanUpdate: (details) {
        if (details.delta.dx > 0) {
          _goToPage(_currentIndex - 1);
        } else {
          _goToPage(_currentIndex + 1);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFBE0002),
        body: Column(
          children: [
            Expanded(
              flex: 5,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: _ads.length,
                    onPageChanged: (index) {
                      setState(() => _currentIndex = index);
                    },
                    itemBuilder: (context, index) {
                      return Image.asset(
                        _ads[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      );
                    },
                  ),
                  Positioned(
                    left: 8,
                    top: 0,
                    bottom: 0,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios,
                          color: Colors.white, size: 30 * scale),
                      onPressed: () {
                        _goToPage(_currentIndex - 1);
                      },
                    ),
                  ),
                  Positioned(
                    right: 8,
                    top: 0,
                    bottom: 0,
                    child: IconButton(
                      icon: Icon(Icons.arrow_forward_ios,
                          color: Colors.white, size: 30 * scale),
                      onPressed: () {
                        _goToPage(_currentIndex + 1);
                      },
                    ),
                  ),
                  // Label banner aligned with arrows
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.36, // Around vertical center of the ad
                    left: 0,
                    right: 0,
                    child: Container(
                      color: Colors.black.withOpacity(0.6),
                      padding: EdgeInsets.symmetric(vertical: 12 * scale),
                      child: Center(
                        child: Text(
                          _getAdLabel(_ads[_currentIndex]),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30 * scale,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_ads.length, (index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: index == _currentIndex ? 12 : 8,
                          height: index == _currentIndex ? 12 : 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: index == _currentIndex
                                ? Colors.white
                                : Colors.white.withOpacity(0.4),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 16 * scale),
                color: const Color(0xFFBE0002),
                child: Text(
                  'TAP ANYWHERE TO TRANSACT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 35 * scale,
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
