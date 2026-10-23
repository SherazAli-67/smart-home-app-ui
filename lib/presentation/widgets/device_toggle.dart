import 'package:flutter/material.dart';
import 'package:smart_home_app/constants/number_constant.dart';
import 'package:smart_home_app/core/app_colors.dart';

class DeviceToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;

  const DeviceToggle({super.key, required this.value, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onChanged == null ? null : () => onChanged!(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: NumberConstant.toggleWidth,
        height: NumberConstant.toggleHeight,
        padding: .symmetric(horizontal: 2.5),
        alignment: value ? .centerRight : .centerLeft,
        decoration: BoxDecoration(
          gradient: value ? AppColors.primaryGradient : null,
          color: value ? null : AppColors.toggleOff,
          borderRadius: .circular(30),
          boxShadow: value ? [BoxShadow(color: AppColors.shadowPrimary.withValues(alpha: 0.15), blurRadius: 20, offset: Offset(0, 4))] : null,
        ),
        child: const DecoratedBox(
          decoration: BoxDecoration(color: AppColors.white, shape: .circle),
          child: SizedBox(width: 16, height: 16),
        ),
      ),
    );
  }
}
