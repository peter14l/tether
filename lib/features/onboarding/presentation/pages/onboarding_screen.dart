import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../core/theme/linen_ember_theme.dart';
import 'splash_page.dart';
import 'welcome_page.dart';
import 'what_is_tether_page.dart';
import 'circles_feature_page.dart';
import 'wellness_feature_page.dart';
import 'couples_feature_page.dart';
import 'family_feature_page.dart';
import 'privacy_promise_page.dart';
import 'get_started_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController _pageController;
  int _currentPage = 0;
  bool _showBottomBar = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(_handlePageScroll);
  }

  void _handlePageScroll() {
    final page = _pageController.page?.round() ?? 0;
    if (page != _currentPage) {
      setState(() {
        _currentPage = page;
        // Hide bottom bar on Splash (0) and Get Started (8)
        _showBottomBar = _currentPage > 0 && _currentPage < 8;
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
    );
  }

  void _skip() {
    _pageController.animateToPage(
      8,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LinenEmberTheme.backgroundPrimary,
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            physics: const ClampingScrollPhysics(),
            children: [
              SplashPage(onComplete: _nextPage),
              const WelcomePage(),
              const WhatIsTetherPage(),
              const CirclesFeaturePage(),
              const WellnessFeaturePage(),
              const CouplesFeaturePage(),
              const FamilyFeaturePage(),
              const PrivacyPromisePage(),
              const GetStartedPage(),
            ],
          ),
          
          // Skip button
          if (_currentPage > 0 && _currentPage < 8)
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              right: 24,
              child: GestureDetector(
                onTap: _skip,
                child: Text(
                  'Skip',
                  style: LinenEmberTheme.body(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: LinenEmberTheme.textSecondary,
                  ),
                ),
              ).animate().fadeIn(duration: 400.ms),
            ),
        ],
      ),
      bottomNavigationBar: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        child: _showBottomBar
            ? _buildBottomBar()
            : const SizedBox(width: double.infinity, height: 0),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      height: 80 + MediaQuery.of(context).padding.bottom,
      padding: EdgeInsets.fromLTRB(
        32,
        0,
        32,
        MediaQuery.of(context).padding.bottom,
      ),
      decoration: const BoxDecoration(
        color: LinenEmberTheme.backgroundPrimary,
        border: Border(
          top: BorderSide(color: LinenEmberTheme.borderSubtle, width: 1),
        ),
      ),
      child: Row(
        children: [
          // Progress Indicator
          SmoothPageIndicator(
            controller: _pageController,
            count: 9,
            effect: const ExpandingDotsEffect(
              dotWidth: 8,
              dotHeight: 8,
              expansionFactor: 3,
              spacing: 8,
              dotColor: Color(0x33F5EDE0),
              activeDotColor: LinenEmberTheme.accentSunsetOrange,
            ),
          ),
          const Spacer(),
          // Continue Button
          GestureDetector(
            onTap: _nextPage,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(LinenEmberTheme.radiusFull),
                gradient: const LinearGradient(
                  colors: [
                    LinenEmberTheme.accentSunsetOrange,
                    LinenEmberTheme.accentGoldenAmber,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                boxShadow: const [LinenEmberTheme.shadowGlow],
              ),
              child: Text(
                'Continue',
                style: LinenEmberTheme.body(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: LinenEmberTheme.backgroundPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate().slideY(begin: 1, end: 0, duration: 400.ms, curve: Curves.easeOutCubic);
  }
}
