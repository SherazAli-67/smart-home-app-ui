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
import 'package:smart_home_app/core/models/device_model.dart';
import 'package:smart_home_app/core/models/room_model.dart';
import 'package:smart_home_app/presentation/widgets/circular_icon_button.dart';
import 'package:smart_home_app/presentation/widgets/device_toggle.dart';
import 'package:smart_home_app/presentation/widgets/pressable_scale.dart';
import 'package:smart_home_app/presentation/widgets/pulse_ring.dart';
import 'package:smart_home_app/presentation/widgets/staggered_fade_slide.dart';
import 'package:smart_home_app/providers/home_provider.dart';
import 'package:smart_home_app/routing/router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const acHeroTag = 'ac-unit';

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
                height: 155,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: .topCenter,
                    end: .bottomCenter,
                    colors: [
                      AppColors.topGlow.withValues(alpha: 0.35),
                      AppColors.white.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: .fromLTRB(NumberConstant.horizontalPadding, 8, NumberConstant.horizontalPadding, 24),
                child: Column(
                  spacing: 20,
                  children: [
                    StaggeredFadeSlide(child: _buildHeader()),
                    StaggeredFadeSlide(
                      delay: NumberConstant.animStaggerStep,
                      child: _buildRoomCarousel(context),
                    ),
                    StaggeredFadeSlide(
                      delay: NumberConstant.animStaggerStep * 2,
                      child: _buildDevicesSection(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            spacing: 0,
            crossAxisAlignment: .start,
            children: [
              Text(StringConst.greeting, style: AppTextStyles.greeting),
              Text(StringConst.welcomeBack, style: AppTextStyles.greetingSubtitle),
            ],
          ),
        ),
        CircularIconButton(icon: AssetRes.icNotification, showBadge: true),
      ],
    );
  }

  Widget _buildRoomCarousel(BuildContext context) {
    final pageController = context.read<HomeProvider>().roomPageController;
    return SizedBox(
      height: NumberConstant.roomCardHeight,
      child: PageView.builder(
        controller: pageController,
        itemCount: AppData.rooms.length,
        itemBuilder: (context, index) {
          return AnimatedBuilder(
            animation: pageController,
            builder: (context, child) {
              final page = pageController.hasClients
                  ? (pageController.page ?? pageController.initialPage.toDouble())
                  : pageController.initialPage.toDouble();
              final distance = (page - index).abs().clamp(0.0, 1.0);
              final scale = NumberConstant.roomCarouselFocusedScale -
                  (NumberConstant.roomCarouselFocusedScale - NumberConstant.roomCarouselNeighborScale) *
                      distance;
              return Transform.scale(scale: scale, child: child);
            },
            child: Padding(
              padding: .symmetric(horizontal: 8),
              child: _buildRoomCard(context, AppData.rooms[index]),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRoomCard(BuildContext context, RoomModel room) {
    final isLivingRoom = room.name == StringConst.livingRoom;
    final image = Image.asset(room.image, fit: .cover);

    return GestureDetector(
      onTap: () {
        if (isLivingRoom) context.push(NamedRoutes.airCondition.routeName);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: .circular(NumberConstant.roomCardRadius),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowPrimary.withValues(alpha: 0.15),
              blurRadius: 41,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: .circular(NumberConstant.roomCardRadius),
          child: Stack(
            fit: .expand,
            children: [
              if (isLivingRoom) Hero(tag: acHeroTag, child: image) else image,
              Positioned(
                left: 11,
                right: 11,
                bottom: 15,
                child: Container(
                  padding: .fromLTRB(18, 16, 18, 16),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: .circular(NumberConstant.roomInfoCardRadius),
                    border: .all(color: AppColors.primary),
                    boxShadow: [
                      BoxShadow(color: AppColors.shadowPrimary, blurRadius: 32, offset: Offset(4, 12)),
                    ],
                  ),
                  child: Column(
                    spacing: 12,
                    crossAxisAlignment: .start,
                    children: [
                      Column(
                        spacing: 4,
                        crossAxisAlignment: .start,
                        children: [
                          Text(room.name, style: AppTextStyles.roomCardTitle),
                          Text(
                            '${room.deviceCount} ${StringConst.devicesConnected}',
                            style: AppTextStyles.roomCardSubtitle,
                          ),
                        ],
                      ),
                      Divider(height: 1, thickness: 1, color: AppColors.white.withValues(alpha: 0.25)),
                      Row(
                        spacing: 8,
                        children: [
                          Expanded(
                            child: _buildRoomStat(
                              icon: AssetRes.icTemperature,
                              label: StringConst.temperature,
                              value: '${room.temperature.toInt()}°C',
                            ),
                          ),
                          Expanded(
                            child: _buildRoomStat(
                              icon: AssetRes.icHumidity,
                              label: StringConst.humidity,
                              value: '${room.humidity.toInt()}%',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoomStat({required String icon, required String label, required String value}) {
    return Row(
      spacing: 8,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.white,
            shape: .circle,
            boxShadow: [BoxShadow(color: AppColors.white.withValues(alpha: 0.1), blurRadius: 9, offset: Offset(0, 4))],
          ),
          child: SvgPicture.asset(icon),
        ),
        Expanded(
          child: Column(
            spacing: 2,
            crossAxisAlignment: .start,
            children: [
              Text(label, style: AppTextStyles.roomStatLabel, maxLines: 1),
              Text(value, style: AppTextStyles.roomStatValue),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDevicesSection(BuildContext context) {
    final provider = context.watch<HomeProvider>();
    final gridDevices = provider.gridDevices;
    final wideDevices = provider.wideDevices;
    return Column(
      spacing: NumberConstant.deviceSectionGap,
      children: [
        Row(
          children: [
            Expanded(child: Text(StringConst.allDevices, style: AppTextStyles.sectionTitle)),
            PressableScale(
              onTap: () => context.push(NamedRoutes.bedroomAr.routeName),
              child: DecoratedBox(
                decoration: BoxDecoration(color: AppColors.primarySoft, borderRadius: .circular(10)),
                child: Padding(
                  padding: .symmetric(horizontal: 8, vertical: 6),
                  child: Text(StringConst.add, style: AppTextStyles.addButton),
                ),
              ),
            ),
          ],
        ),
        Row(
          spacing: NumberConstant.deviceGridGap,
          crossAxisAlignment: .start,
          children: [
            for (final device in gridDevices) Expanded(child: _buildGridDeviceCard(context, device)),
          ],
        ),
        for (final device in wideDevices) _buildWideDeviceCard(context, device),
      ],
    );
  }

  Widget _buildGridDeviceCard(BuildContext context, DeviceModel device) {
    return AnimatedContainer(
      duration: NumberConstant.animFast,
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: device.isOn ? AppColors.primarySoft : AppColors.cardBackground,
        borderRadius: .circular(NumberConstant.deviceCardRadius),
      ),
      child: Padding(
        padding: .all(NumberConstant.deviceCardPadding),
        child: Column(
          spacing: 17,
          crossAxisAlignment: .start,
          children: [
            Row(
              children: [
                _buildDeviceIcon(device.image, device.isOn),
                const Spacer(),
                DeviceToggle(
                  value: device.isOn,
                  onChanged: (_) => context.read<HomeProvider>().toggleDeviceByName(device.name),
                ),
              ],
            ),
            Column(
              spacing: 6,
              crossAxisAlignment: .start,
              children: [
                Text(device.name, style: AppTextStyles.deviceName),
                _buildDeviceBadge(device),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWideDeviceCard(BuildContext context, DeviceModel device) {
    return AnimatedContainer(
      duration: NumberConstant.animFast,
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: device.isOn ? AppColors.primarySoft : AppColors.cardBackground,
        borderRadius: .circular(NumberConstant.deviceCardRadius),
      ),
      child: Padding(
        padding: .all(NumberConstant.deviceCardPadding),
        child: Row(
          spacing: 17,
          children: [
            _buildDeviceIcon(device.image, device.isOn),
            Expanded(
              child: Column(
                spacing: 6,
                crossAxisAlignment: .start,
                children: [
                  Text(device.name, style: AppTextStyles.deviceName),
                  _buildDeviceBadge(device),
                ],
              ),
            ),
            DeviceToggle(
              value: device.isOn,
              onChanged: (_) => context.read<HomeProvider>().toggleDeviceByName(device.name),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceIcon(String image, bool isOn) {
    return AnimatedOpacity(
      duration: NumberConstant.animFast,
      curve: Curves.easeOutCubic,
      opacity: isOn ? 1 : 0.55,
      child: DecoratedBox(
        decoration: BoxDecoration(color: AppColors.white, shape: .circle),
        child: Padding(
          padding: .all(12),
          child: Image.asset(image, width: 32, height: 32, fit: .contain),
        ),
      ),
    );
  }

  Widget _buildDeviceBadge(DeviceModel device) {
    return DecoratedBox(
      decoration: BoxDecoration(color: AppColors.white, borderRadius: .circular(30)),
      child: Padding(
        padding: .symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: .min,
          spacing: 6,
          children: [
            PulseRing(
              enabled: device.isOn,
              minScale: 0.85,
              maxScale: 1.15,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Color(device.badgeColorValue), shape: .circle),
                child: const SizedBox(width: 6, height: 6),
              ),
            ),
            Text('${device.deviceCount} ${StringConst.devices}', style: AppTextStyles.deviceCount),
          ],
        ),
      ),
    );
  }
}
