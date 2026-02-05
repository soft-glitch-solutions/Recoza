import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/constants/colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Widget> _onboardingPages = [
    const _OnboardingPage(
      imageAsset: 'assets/images/onboarding1.png',
      title: 'Welcome to Recoza!',
      description: 'The easy way to manage and schedule your recycling pickups.',
    ),
    const _OnboardingPage(
      imageAsset: 'assets/images/onboarding2.png',
      title: 'Log Your Recyclables',
      description: 'Quickly log what you want to recycle, and your collector will be notified.',
    ),
    const _OnboardingPage(
      imageAsset: 'assets/images/onboarding3.png',
      title: 'Earn as You Go',
      description: 'Become a collector and turn your community\'s recycling into a reliable income.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppsColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Skip Button
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () => context.go('/login'),
                child: const Text('Skip', style: TextStyle(color: AppsColors.primary)),
              ),
            ),
            // PageView for Onboarding Steps
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: _onboardingPages,
              ),
            ),
            // Page Indicator and Next Button
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: _onboardingPages.length,
                    effect: const ExpandingDotsEffect(
                      activeDotColor: AppsColors.primary,
                      dotColor: AppsColors.primaryLight,
                      dotHeight: 10,
                      dotWidth: 10,
                    ),
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      if (_currentPage < _onboardingPages.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      } else {
                        // After the last onboarding page, go to profile setup
                        context.push('/profile-setup');
                      }
                    },
                    backgroundColor: AppsColors.primary,
                    elevation: 2,
                    child: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// A helper widget for the onboarding pages
class _OnboardingPage extends StatelessWidget {
  final String imageAsset;
  final String title;
  final String description;

  const _OnboardingPage({
    required this.imageAsset,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(imageAsset, height: 250), // Using Image.asset now
          const SizedBox(height: 48),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppsColors.charcoal,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: AppsColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
