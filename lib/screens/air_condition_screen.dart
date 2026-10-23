import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:smart_home_app/constants/number_constant.dart';
import 'package:smart_home_app/constants/string_const.dart';
import 'package:smart_home_app/core/app_colors.dart';
import 'package:smart_home_app/core/app_data.dart';
import 'package:smart_home_app/core/app_textstyles.dart';
import 'package:smart_home_app/core/asset_res.dart';
import 'package:smart_home_app/core/models/ac_mood_model.dart';
import 'package:smart_home_app/presentation/widgets/circular_icon_button.dart';
import 'package:smart_home_app/providers/air_condition_provider.dart';

class AirConditionScreen extends StatelessWidget {
  const AirConditionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          Positioned(
            top: -9,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: Container(
                height: 151,
                decoration: BoxDecoration(
                  gradient: LinearGradient(begin: .topCenter,
                      end: .bottomCenter,
                      colors: [
                        AppColors.topGlow.withValues(alpha: 0.35),
                        AppColors.white.withValues(alpha: 0)
                      ]),
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: .fromLTRB(NumberConstant.horizontalPadding, 8, NumberConstant.horizontalPadding, 24),
                child: Column(
                  children: [
                    _buildHeader(context),
                    const SizedBox(height: 24,),
                    _buildRoomTabs(context),
                    const SizedBox(height: 24,),
                    Image.asset(AssetRes.airConditionImg,fit: .cover,),
                    _buildControlsCard(context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final provider = context.watch<AirConditionProvider>();
    return Row(
      children: [
        CircularIconButton(icon: AssetRes.icBack, onTap: () => context.pop()),
        Expanded(child: Text(StringConst.airConditions, style: AppTextStyles.screenTitle, textAlign: .center)),
        CircularIconButton(
          icon: AssetRes.icPower,
          padding: .all(4),
          onTap: provider.togglePower,
          colorFilter: provider.isPowerOn ? null : .mode(AppColors.gray, .srcIn),
        ),
      ],
    );
  }

  Widget _buildRoomTabs(BuildContext context) {
    final provider = context.watch<AirConditionProvider>();
    return SingleChildScrollView(
      scrollDirection: .horizontal,
      child: Row(
        spacing: 8,
        children: [
          for (var i = 0; i < AppData.acRoomTabs.length; i++)
            GestureDetector(
              onTap: () => provider.selectRoom(i),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: i == provider.selectedRoomIndex ? AppColors.primaryGradient : null,
                  color: i == provider.selectedRoomIndex ? null : AppColors.white,
                  borderRadius: .circular(8),
                  border: i == provider.selectedRoomIndex ? null : Border.all(color: AppColors.borderColor),
                  boxShadow: i == provider.selectedRoomIndex ? [BoxShadow(color: AppColors.shadowPrimary.withValues(alpha: 0.15), blurRadius: 17, offset: Offset(0, 4))] : null,
                ),
                child: Padding(
                  padding: .symmetric(horizontal: i == provider.selectedRoomIndex ? 22 : 20, vertical: 7),
                  child: Text(AppData.acRoomTabs[i], style: i == provider.selectedRoomIndex ? AppTextStyles.chipSelected : AppTextStyles.chipUnselected),
                ),
              ),
            ),
        ],
      ),
    );
  }


  Widget _buildControlsCard(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: AppColors.cardBackground, borderRadius: .circular(NumberConstant.deviceCardRadius)),
      child: Padding(
        padding: .symmetric(horizontal: 15, vertical: 19),
        child: Column(
          spacing: 16,
          crossAxisAlignment: .start,
          children: [
            _buildMoodSection(context),
            Divider(height: 1, thickness: 1, color: AppColors.black.withValues(alpha: 0.08)),
            _buildTimerSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodSection(BuildContext context) {
    final provider = context.watch<AirConditionProvider>();
    return Column(
      spacing: 12,
      crossAxisAlignment: .start,
      children: [
        Text(StringConst.selectMood, style: AppTextStyles.controlSectionTitle),
        Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            for (var i = 0; i < AppData.acMoods.length; i++) _buildMoodItem(context, AppData.acMoods[i], i == provider.selectedMoodIndex, () => provider.selectMood(i)),
          ],
        ),
      ],
    );
  }

  Widget _buildMoodItem(BuildContext context, AcMoodModel mood, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        spacing: 7,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: isSelected ? AppColors.primaryGradient : null,
              color: isSelected ? null : AppColors.white,
              shape: .circle,
              boxShadow: isSelected ? [BoxShadow(color: AppColors.shadowPrimary.withValues(alpha: 0.2), blurRadius: 10, offset: Offset(0, 4))] : null,
            ),
            child: Padding(
              padding: .all(18),
              child: SvgPicture.asset(mood.icon, colorFilter: isSelected ? .mode(AppColors.white, .srcIn) : .mode(AppColors.gray, .srcIn)),
            ),
          ),
          Text(mood.label, style: isSelected ? AppTextStyles.moodLabelSelected : AppTextStyles.moodLabel),
        ],
      ),
    );
  }

  Widget _buildTimerSection(BuildContext context) {
    final provider = context.watch<AirConditionProvider>();
    return Column(
      spacing: 12,
      crossAxisAlignment: .start,
      children: [
        Text(StringConst.addTimer, style: AppTextStyles.controlSectionTitle),
        Column(
          spacing: 4,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final progress = ((provider.timerHours - NumberConstant.timerMin) / (NumberConstant.timerMax - NumberConstant.timerMin)).clamp(0.0, 1.0);
                final thumbX = progress * constraints.maxWidth;
                return SizedBox(
                  height: 62,
                  child: Stack(
                    clipBehavior: .none,
                    children: [
                      Positioned(
                        left: (thumbX - 24).clamp(0, constraints.maxWidth - 48),
                        top: 0,
                        child: DecoratedBox(
                          decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: .circular(8)),
                          child: Padding(
                            padding: .symmetric(horizontal: 10, vertical: 6),
                            child: Text('${provider.timerHours.toInt()} ${StringConst.hrs}', style: AppTextStyles.timerValue),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 47,
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 8,
                            activeTrackColor: AppColors.primary,
                            inactiveTrackColor: AppColors.primary.withValues(alpha: 0.1),
                            thumbColor: AppColors.white,
                            overlayShape: .noOverlay,
                            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12.5, elevation: 4),
                            trackShape: const RoundedRectSliderTrackShape(),
                          ),
                          child: Slider(
                            value: provider.timerHours,
                            min: NumberConstant.timerMin,
                            max: NumberConstant.timerMax,
                            onChanged: provider.setTimerHours,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Text('${NumberConstant.timerMin.toInt()}', style: AppTextStyles.timerScale),
                Text('${NumberConstant.timerMax.toInt()}', style: AppTextStyles.timerScale),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

