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
import 'package:smart_home_app/core/models/ar_hotspot_model.dart';
import 'package:smart_home_app/presentation/widgets/circular_icon_button.dart';
import 'package:smart_home_app/presentation/widgets/pressable_scale.dart';
import 'package:smart_home_app/presentation/widgets/pulse_ring.dart';
import 'package:smart_home_app/presentation/widgets/staggered_fade_slide.dart';
import 'package:smart_home_app/providers/bedroom_ar_provider.dart';
import 'package:smart_home_app/routing/router.dart';
import 'package:smart_home_app/screens/home_screen.dart';

class BedroomArScreen extends StatelessWidget {
  const BedroomArScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: .expand,
        children: [
          StaggeredFadeSlide(
            beginOffset: Offset.zero,
            child: Stack(
              fit: .expand,
              children: [
                Image.asset(
                  AssetRes.bedroomAr,
                  fit: .cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: .topLeft,
                      end: .bottomRight,
                      colors: [
                        AppColors.primary.withValues(alpha: 0.2),
                        AppColors.primaryLight.withValues(alpha: 0.2),
                      ],
                    ),
                  ),
                  child: const SizedBox.expand(),
                ),
              ],
            ),
          ),
          for (final hotspot in AppData.arHotspots)
            StaggeredFadeSlide(
              delay: NumberConstant.animStaggerStep,
              beginOffset: Offset.zero,
              child: _ArHotspot(hotspot: hotspot),
            ),
          SafeArea(
            child: Padding(
              padding: .fromLTRB(NumberConstant.horizontalPadding, 8, NumberConstant.horizontalPadding, 16),
              child: Column(
                children: [
                  StaggeredFadeSlide(child: _buildHeader(context)),
                  const Spacer(),
                  Stack(
                    children: [
                      StaggeredFadeSlide(
                        delay: NumberConstant.animStaggerStep * 2,
                        child: _buildBottomBar(context),
                      ),
                      Positioned(
                        right: 0,
                        child: PressableScale(
                          child: Container(
                            decoration: const BoxDecoration(shape: .circle, color: Colors.white),
                            padding: .all(13),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [AppColors.primary, AppColors.primaryLight],
                                  stops: const [0, 1],
                                ),
                                shape: .circle,
                              ),
                              padding: .all(15),
                              child: const Icon(Icons.add_rounded, color: Colors.white),
                            ),
                          ),
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
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Stack(
      alignment: .center,
      children: [
        Text(StringConst.bedroomAr, style: AppTextStyles.screenTitleWhite),
        Align(
          alignment: .centerLeft,
          child: CircularIconButton(
            icon: AssetRes.icBack,
            backgroundColor: AppColors.white.withValues(alpha: 0.4),
            onTap: () => context.pop(),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    final provider = context.watch<BedroomArProvider>();
    return Row(
      crossAxisAlignment: .end,
      children: [
        Expanded(child: _buildRoomSelector(provider)),

      ],
    );
  }

  Widget _buildRoomSelector(BedroomArProvider provider) {
    final rooms = AppData.arRooms;
    final selected = provider.selectedRoomIndex;
    final direction = provider.slideDirection.toDouble();

    return Row(
      mainAxisAlignment: .center,
      crossAxisAlignment: .end,
      children: [
        ClipRect(
          child: AnimatedSize(
            duration: NumberConstant.animNormal,
            curve: Curves.easeOutCubic,
            alignment: .centerRight,
            child: selected > 0
                ? Row(
                    mainAxisSize: .min,
                    crossAxisAlignment: .end,
                    spacing: 8,
                    children: [
                      _buildSideRoomChip(rooms[selected - 1], onTap: provider.selectPreviousRoom),
                      GestureDetector(
                        onTap: provider.selectPreviousRoom,
                        child: Padding(
                          padding: .only(bottom: 12),
                          child: Transform.flip(
                            flipX: true,
                            child: SvgPicture.asset(
                              AssetRes.icChevron,
                              colorFilter: .mode(AppColors.white, .srcIn),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ),
        if (selected > 0) const SizedBox(width: 8),
        AnimatedSwitcher(
          duration: NumberConstant.animNormal,
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeOutCubic,
          transitionBuilder: (child, animation) {
            final offsetAnimation = Tween<Offset>(
              begin: Offset(direction * 0.35, 0),
              end: Offset.zero,
            ).animate(animation);
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(position: offsetAnimation, child: child),
            );
          },
          child: KeyedSubtree(
            key: ValueKey(selected),
            child: _buildActiveRoomSelector(rooms[selected]),
          ),
        ),
        if (selected < rooms.length - 1) const SizedBox(width: 8),
        ClipRect(
          child: AnimatedSize(
            duration: NumberConstant.animNormal,
            curve: Curves.easeOutCubic,
            alignment: .centerLeft,
            child: selected < rooms.length - 1
                ? Row(
                    mainAxisSize: .min,
                    crossAxisAlignment: .end,
                    spacing: 8,
                    children: [
                      GestureDetector(
                        onTap: provider.selectNextRoom,
                        child: Padding(
                          padding: .only(bottom: 12),
                          child: SvgPicture.asset(
                            AssetRes.icChevron,
                            colorFilter: .mode(AppColors.white, .srcIn),
                          ),
                        ),
                      ),
                      _buildSideRoomChip(rooms[selected + 1], onTap: provider.selectNextRoom),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }

  Widget _buildActiveRoomSelector(String room) {
    return SizedBox(
      width: NumberConstant.arUnionWidth,
      height: NumberConstant.arUnionHeight,
      child: Stack(
        alignment: .center,
        children: [
          SvgPicture.asset(
            AssetRes.unionShape,
            width: NumberConstant.arUnionWidth,
            height: NumberConstant.arUnionHeight,
          ),
          Positioned(
            top: 13,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: .circle,
                border: .all(color: AppColors.white.withValues(alpha: 0.6), width: 1.5),
              ),
              child: Padding(
                padding: .all(13),
                child: SvgPicture.asset(AssetRes.icBed, colorFilter: .mode(AppColors.white, .srcIn)),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Text(room, style: AppTextStyles.arRoomLabel, textAlign: .center),
          ),
        ],
      ),
    );
  }

  Widget _buildSideRoomChip(String room, {required VoidCallback onTap}) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 96),
      child: PressableScale(
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(color: AppColors.overlayDark, borderRadius: .circular(60)),
          child: Padding(
            padding: .symmetric(horizontal: 16, vertical: 9),
            child: Text(room, style: AppTextStyles.arRoomLabel, overflow: .ellipsis, maxLines: 1),
          ),
        ),
      ),
    );
  }
}

class _ArHotspot extends StatelessWidget {
  final ArHotspotModel hotspot;

  const _ArHotspot({required this.hotspot});

  @override
  Widget build(BuildContext context) {
    final isAirCondition = hotspot.label == StringConst.airConditions;
    final inner = DecoratedBox(
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        shape: .circle,
        boxShadow: [BoxShadow(color: AppColors.shadowPrimary, blurRadius: 16, offset: Offset(0, 6))],
      ),
      child: Padding(
        padding: .all(11),
        child: SvgPicture.asset(hotspot.icon, colorFilter: .mode(AppColors.white, .srcIn)),
      ),
    );

    return Stack(
      children: [
        Positioned(
          top: hotspot.top,
          left: hotspot.left,
          child: PressableScale(
            onTap: isAirCondition
                ? () => context.push(NamedRoutes.airCondition.routeName)
                : null,
            child: SizedBox(
              width: NumberConstant.arHotspotOuterSize,
              height: NumberConstant.arHotspotOuterSize,
              child: Stack(
                alignment: .center,
                children: [
                  PulseRing(
                    minScale: 0.9,
                    maxScale: 1.1,
                    minOpacity: 0.45,
                    maxOpacity: 0.9,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.black.withValues(alpha: 0.2),
                        shape: .circle,
                      ),
                      child: const SizedBox(
                        width: NumberConstant.arHotspotOuterSize,
                        height: NumberConstant.arHotspotOuterSize,
                      ),
                    ),
                  ),
                  if (isAirCondition) Hero(tag: HomeScreen.acHeroTag, child: inner) else inner,
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: hotspot.labelTop,
          left: hotspot.labelLeft,
          child: Text(hotspot.label, style: AppTextStyles.arHotspotLabel),
        ),
        Positioned(
          top: hotspot.top + 20,
          left: hotspot.labelOnRight ? hotspot.left + 70 : hotspot.labelLeft + 40,
          child: SvgPicture.asset(AssetRes.icLeftArLine),
        ),
      ],
    );
  }
}
