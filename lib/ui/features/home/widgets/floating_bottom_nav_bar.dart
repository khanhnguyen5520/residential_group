import 'package:flutter/material.dart';

class _FloatingNavItem {
  const _FloatingNavItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    this.badgeCount = 0,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final int badgeCount;
}

/// Thanh điều hướng nổi dạng viên thuốc với hiệu ứng trượt nền sang tab được chọn.
class FloatingBottomNavBar extends StatelessWidget {
  const FloatingBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.unreadNotificationCount,
    required this.onDestinationSelected,
  });

  final int selectedIndex;
  final int unreadNotificationCount;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final barColor = isDark ? const Color(0xFF1E2B30) : Colors.white;
    final activePillColor = isDark
        ? theme.colorScheme.primary.withValues(alpha: 0.28)
        : const Color(0xFFFCE08B);
    final activeForeground = isDark ? Colors.white : const Color(0xFF1A1C1E);
    final inactiveForeground = isDark
        ? Colors.white.withValues(alpha: 0.72)
        : const Color(0xFF3E4442);

    final items = <_FloatingNavItem>[
      const _FloatingNavItem(
        label: 'Tổng quan',
        icon: Icons.dashboard_outlined,
        selectedIcon: Icons.dashboard_rounded,
      ),
      _FloatingNavItem(
        label: 'Thông báo',
        icon: Icons.notifications_outlined,
        selectedIcon: Icons.notifications_rounded,
        badgeCount: unreadNotificationCount,
      ),
      const _FloatingNavItem(
        label: 'Cài đặt',
        icon: Icons.settings_outlined,
        selectedIcon: Icons.settings_rounded,
      ),
      const _FloatingNavItem(
        label: 'Profile',
        icon: Icons.person_outline,
        selectedIcon: Icons.person_rounded,
      ),
    ];

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: Container(
          key: const ValueKey('floating_bottom_nav'),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: barColor,
            borderRadius: BorderRadius.circular(36),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.black.withValues(alpha: 0.05),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.36 : 0.10),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final itemWidth = constraints.maxWidth / items.length;
              return Stack(
                children: [
                  AnimatedPositioned(
                    key: const ValueKey('floating_nav_indicator'),
                    duration: const Duration(milliseconds: 280),
                    curve: Curves.easeOutCubic,
                    left: selectedIndex * itemWidth,
                    top: 0,
                    bottom: 0,
                    width: itemWidth,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: activePillColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  Row(
                    children: List<Widget>.generate(items.length, (index) {
                      final item = items[index];
                      final isSelected = index == selectedIndex;
                      final fgColor = isSelected
                          ? activeForeground
                          : inactiveForeground;
                      final iconWidget = Icon(
                        isSelected ? item.selectedIcon : item.icon,
                        size: 22,
                        color: fgColor,
                      );

                      return Expanded(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(30),
                            onTap: () => onDestinationSelected(index),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 4,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  item.badgeCount > 0
                                      ? Badge.count(
                                          count: item.badgeCount,
                                          child: iconWidget,
                                        )
                                      : iconWidget,
                                  const SizedBox(height: 3),
                                  AnimatedDefaultTextStyle(
                                    duration: const Duration(milliseconds: 200),
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: isSelected
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                      color: fgColor,
                                    ),
                                    child: Text(
                                      item.label,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
