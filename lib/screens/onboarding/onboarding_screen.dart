import 'package:flutter/material.dart';
import 'dart:math';
import '../../constants/colors.dart';
import '../../constants/strings.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _rotationAnimation;

  final List<Map<String, dynamic>> onboardingData = [
    {
      'title': 'Create Income',
      'subtitle': 'Turn recycling into dignified work opportunities',
      'icon': Icons.work_outline,
      'color': AppsColors.accent,
      'stat': '+R5,000\nEarned by collectors',
      'gradient': [
        Colors.orange.shade100,
        Colors.orange.shade300,
      ],
    },
    {
      'title': 'Safe & Trusted',
      'subtitle': 'Verified collectors, scheduled pickups, secure payments',
      'icon': Icons.verified_user_outlined,
      'color': AppsColors.primary,
      'stat': '100%\nVerified collectors',
      'gradient': [
        Colors.green.shade100,
        Colors.green.shade300,
      ],
    },
    {
      'title': 'Community Impact',
      'subtitle': 'Cleaner neighbourhoods, stronger communities',
      'icon': Icons.people_outlined,
      'color': AppsColors.charcoal,
      'stat': '50+\nCommunities served',
      'gradient': [
        Colors.blue.shade100,
        Colors.blue.shade300,
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _rotationAnimation = Tween<double>(begin: -0.05, end: 0.05).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppsColors.background,
      body: Stack(
        children: [
          // Animated background particles
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return CustomPaint(
                  painter: _ParticlePainter(_animationController.value),
                );
              },
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Brand Header with glow effect
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: Row(
                    children: [
                      AnimatedBuilder(
                        animation: _scaleAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _scaleAnimation.value,
                            child: Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppsColors.primary,
                                    AppsColors.primaryLight,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppsColors.primary.withOpacity(0.3),
                                    blurRadius: 15,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Text(
                                  'R',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppsStrings.appName,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppsColors.charcoal,
                              fontFamily: 'Inter',
                              letterSpacing: -0.5,
                            ),
                          ),
                          Text(
                            AppsStrings.tagline,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppsColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      // Skip button
                      if (_currentPage < onboardingData.length - 1)
                        TextButton(
                          onPressed: _navigateToHome,
                          style: TextButton.styleFrom(
                            foregroundColor: AppsColors.textSecondary,
                          ),
                          child: const Text('Skip'),
                        ),
                    ],
                  ),
                ),

                // Progress indicator with dots
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      onboardingData.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: _currentPage == index ? 30 : 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? AppsColors.primary
                              : AppsColors.border,
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: _currentPage == index
                              ? [
                                  BoxShadow(
                                    color: AppsColors.primary.withOpacity(0.3),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  ),
                                ]
                              : null,
                        ),
                      ),
                    ),
                  ),
                ),

                // Animated Page View
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: onboardingData.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      final data = onboardingData[index];
                      final gradientColors =
                          (data['gradient'] as List<Color>).cast<Color>();

                      return AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(
                              0,
                              sin(_animationController.value * 2 * pi) * 5,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Animated gradient circle with icon
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      // Outer glow
                                      Container(
                                        width: 180,
                                        height: 180,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: RadialGradient(
                                            colors: [
                                              gradientColors.last
                                                  .withOpacity(0.2),
                                              Colors.transparent,
                                            ],
                                          ),
                                        ),
                                      ),
                                      // Animated circle
                                      Container(
                                        width: 150,
                                        height: 150,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: LinearGradient(
                                            colors: gradientColors,
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: gradientColors.first
                                                  .withOpacity(0.4),
                                              blurRadius: 20,
                                              spreadRadius: 5,
                                            ),
                                          ],
                                        ),
                                        child: Transform.rotate(
                                          angle: _rotationAnimation.value,
                                          child: Icon(
                                            data['icon'],
                                            size: 64,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 40),

                                  // Animated stat text with gradient
                                  ShaderMask(
                                    shaderCallback: (bounds) {
                                      return LinearGradient(
                                        colors: gradientColors,
                                      ).createShader(bounds);
                                    },
                                    child: Text(
                                      data['stat'],
                                      style: const TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        height: 1.2,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const SizedBox(height: 30),

                                  // Title with animation
                                  AnimatedOpacity(
                                    duration: const Duration(milliseconds: 500),
                                    opacity: _fadeAnimation.value,
                                    child: Text(
                                      data['title'],
                                      style: const TextStyle(
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold,
                                        color: AppsColors.charcoal,
                                        fontFamily: 'Inter',
                                        letterSpacing: -1,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  // Subtitle with animated color
                                  AnimatedDefaultTextStyle(
                                    duration: const Duration(milliseconds: 300),
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Color.lerp(
                                        AppsColors.textSecondary,
                                        gradientColors.first,
                                        _animationController.value * 0.3,
                                      ),
                                      height: 1.5,
                                      fontFamily: 'Inter',
                                    ),
                                    child: Text(
                                      data['subtitle'],
                                      textAlign: TextAlign.center,
                                    ),
                                  ),

                                  // Animated decorative elements
                                  const SizedBox(height: 40),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(
                                      3,
                                      (index) => AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        width: 10,
                                        height: 10,
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color.lerp(
                                            gradientColors.first
                                                .withOpacity(0.3),
                                            gradientColors.first,
                                            (_animationController.value +
                                                    index * 0.3) %
                                                1,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

                // Bottom section with mission statement
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withOpacity(0.9),
                        Colors.white.withOpacity(0.95),
                      ],
                    ),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(32),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 30,
                        spreadRadius: 0,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Mission statement with animated border
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppsColors.primary.withOpacity(0.05),
                              AppsColors.accent.withOpacity(0.05),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppsColors.primary.withOpacity(0.2),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            AnimatedBuilder(
                              animation: _animationController,
                              builder: (context, child) {
                                return Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [
                                        AppsColors.primary,
                                        AppsColors.primaryLight,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppsColors.primary
                                            .withOpacity(0.3),
                                        blurRadius: 10 *
                                            _animationController.value,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.recycling,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Our Mission',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppsColors.primary,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    AppsStrings.mission,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: AppsColors.textPrimary,
                                      fontWeight: FontWeight.w500,
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Animated action button
                      AnimatedBuilder(
                        animation: _scaleAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _currentPage == onboardingData.length - 1
                                ? _scaleAnimation.value
                                : 1.0,
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _navigateToHome,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppsColors.primary,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 20,
                                  ),
                                  elevation: 8,
                                  shadowColor: AppsColors.primary
                                      .withOpacity(0.4),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      _currentPage ==
                                              onboardingData.length - 1
                                          ? AppsStrings.getStarted
                                          : AppsStrings.next,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                    if (_currentPage ==
                                        onboardingData.length - 1)
                                      const SizedBox(width: 10),
                                    if (_currentPage ==
                                        onboardingData.length - 1)
                                      AnimatedBuilder(
                                        animation: _animationController,
                                        builder: (context, child) {
                                          return Transform.rotate(
                                            angle: _animationController.value *
                                                2 *
                                                pi,
                                            child: const Icon(
                                              Icons.arrow_forward_rounded,
                                              size: 24,
                                            ),
                                          );
                                        },
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToHome() {
    if (_currentPage == onboardingData.length - 1) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    }
  }
}

// Custom painter for background particles
class _ParticlePainter extends CustomPainter {
  final double time;

  _ParticlePainter(this.time);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppsColors.primary.withOpacity(0.03)
      ..style = PaintingStyle.fill;

    // Draw floating particles
    for (int i = 0; i < 20; i++) {
      final x = size.width *
          (0.2 + 0.6 * sin(time * 2 * pi + i * 0.5) + i * 0.05);
      final y = size.height *
          (0.1 + 0.8 * cos(time * 2 * pi + i * 0.3) + i * 0.03);

      final radius = 2 + 3 * sin(time * 2 * pi + i * 0.2);

      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}