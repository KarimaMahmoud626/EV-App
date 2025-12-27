import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:ev_app/features/auth/data/models/user_model.dart';
import 'package:ev_app/features/battery_monitoring/presentation/pages/home/home_view.dart';
import 'package:flutter/material.dart';

class CustomNavigationBar extends StatefulWidget {
  const CustomNavigationBar({super.key, required this.user});
  final UserModel user;

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  late final PageController _pageController;
  late final NotchBottomBarController _notchController;

  List<Widget> _buildScreens() {
    return [const Scaffold(), HomeView(user: widget.user), const Scaffold()];
  }

  List<BottomBarItem> _navBarItems(ColorScheme colors) {
    return [
      BottomBarItem(
        inActiveItem: Icon(Icons.location_on, color: colors.onSurface),
        activeItem: Icon(Icons.location_on, color: colors.primary, size: 32),
        itemLabel: 'Stations',
      ),
      BottomBarItem(
        inActiveItem: Icon(Icons.energy_savings_leaf, color: colors.onSurface),
        activeItem: Icon(
          Icons.energy_savings_leaf,
          color: colors.primary,
          size: 32,
        ),
        itemLabel: 'Status',
      ),
      BottomBarItem(
        inActiveItem: Icon(Icons.history, color: colors.onSurface),
        activeItem: Icon(Icons.history, color: colors.primary, size: 32),
        itemLabel: 'History',
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 1);
    _notchController = NotchBottomBarController(index: 1);
  }

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _buildScreens(),
      ),
      bottomNavigationBar: AnimatedNotchBottomBar(
        notchBottomBarController: _notchController,
        bottomBarItems: _navBarItems(colors),
        onTap: (index) {
          _pageController.jumpToPage(index);
        },
        bottomBarHeight: 70,
        kIconSize: 28,
        kBottomRadius: 20,
        showLabel: true,
        color: colors.surface,
        notchColor: colors.surface,
        showShadow: true,
        shadowElevation: 3,
        showBottomRadius: true,
        showTopRadius: true,
      ),
    );
  }
}
