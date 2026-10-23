import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_home_app/constants/number_constant.dart';
import 'package:smart_home_app/core/app_colors.dart';

class CircularIconButton extends StatelessWidget {
  final String icon;
  final VoidCallback? onTap;
  final bool showBadge;
  final Color backgroundColor;
  final ColorFilter? colorFilter;
  final EdgeInsetsGeometry padding;

  const CircularIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.showBadge = false,
    this.backgroundColor = AppColors.white,
    this.colorFilter,
    this.padding = const EdgeInsets.all(NumberConstant.circularButtonPadding),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: .none,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: .circle,
              boxShadow: [BoxShadow(color: AppColors.shadowLight, blurRadius: 30, offset: Offset(0, 15))],
            ),
            child: Padding(padding: padding, child: SvgPicture.asset(icon, colorFilter: colorFilter)),
          ),
          if (showBadge)
            Positioned(
              top: 3,
              right: 0,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: .circle,
                  boxShadow: [BoxShadow(color: AppColors.shadowPrimary, blurRadius: 6, offset: Offset(0, 4))],
                ),
                child: SizedBox(width: NumberConstant.notificationDotSize, height: NumberConstant.notificationDotSize),
              ),
            ),
        ],
      ),
    );
  }
}
