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
import 'package:smart_home_app/providers/bedroom_ar_provider.dart';
import 'package:smart_home_app/routing/router.dart';

class BedroomArScreen extends StatelessWidget {
  const BedroomArScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: .expand,
        children: [
          Image.asset(AssetRes.bedroomAr, fit: .cover, width: double.infinity, height: double.infinity),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(begin: .topLeft, end: .bottomRight, colors: [AppColors.primary.withValues(alpha: 0.2), AppColors.primaryLight.withValues(alpha: 0.2)]),
            ),
            child: const SizedBox.expand(),
          ),
          for (final hotspot in AppData.arHotspots) _buildHotspot(context, hotspot),
          SafeArea(
            child: Padding(
              padding: .fromLTRB(NumberConstant.horizontalPadding, 8, NumberConstant.horizontalPadding, 16),
              child: Column(
                children: [
                  _buildHeader(context),
                  const Spacer(),
                  _buildBottomBar(context),
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

  Widget _buildHotspot(BuildContext context, ArHotspotModel hotspot) {
    return Stack(
      children: [
        Positioned(
          top: hotspot.top,
          left: hotspot.left,
          child: GestureDetector(
            onTap: () {
              if (hotspot.label == StringConst.airConditions) context.push(NamedRoutes.airCondition.routeName);
            },
            child: SizedBox(
              width: NumberConstant.arHotspotOuterSize,
              height: NumberConstant.arHotspotOuterSize,
              child: Stack(
                alignment: .center,
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(color: AppColors.black.withValues(alpha: 0.2), shape: .circle),
                    child: const SizedBox(width: NumberConstant.arHotspotOuterSize, height: NumberConstant.arHotspotOuterSize),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      shape: .circle,
                      boxShadow: [BoxShadow(color: AppColors.shadowPrimary, blurRadius: 16, offset: Offset(0, 6))],
                    ),
                    child: Padding(
                      padding: .all(11),
                      child: SvgPicture.asset(hotspot.icon, colorFilter: .mode(AppColors.white, .srcIn)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
            top: hotspot.labelTop,
            left: hotspot.labelLeft,
            child: Text(hotspot.label, style: AppTextStyles.arHotspotLabel)),
        Positioned(
          top: hotspot.top + 20,
          left: hotspot.labelOnRight ? hotspot.left + 70 : hotspot.labelLeft + 40,
          child: SvgPicture.asset(AssetRes.icLeftArLine)
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
        GestureDetector(onTap: () {}, child: SvgPicture.asset(AssetRes.icPlus)),
      ],
    );
  }

  Widget _buildRoomSelector(BedroomArProvider provider) {
    final rooms = AppData.arRooms;
    final selected = provider.selectedRoomIndex;
    return Row(
      mainAxisAlignment: .center,
      spacing: 8,
      children: [
        if (selected > 0) ...[
          _buildSideRoomChip(rooms[selected - 1], onTap: provider.selectPreviousRoom),
          GestureDetector(
            onTap: provider.selectPreviousRoom,
            child: Transform.flip(flipX: true, child: SvgPicture.asset(AssetRes.icChevron, colorFilter: .mode(AppColors.white, .srcIn))),
          ),
        ],
        _buildActiveRoomSelector(rooms[selected]),
        if (selected < rooms.length - 1) ...[
          GestureDetector(
            onTap: provider.selectNextRoom,
            child: SvgPicture.asset(AssetRes.icChevron, colorFilter: .mode(AppColors.white, .srcIn)),
          ),
          _buildSideRoomChip(rooms[selected + 1], onTap: provider.selectNextRoom),
        ],
      ],
    );
  }

  Widget _buildActiveRoomSelector(String room) {
    return Column(
      spacing: 8,
      mainAxisSize: .min,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(shape: .circle, border: .all(color: AppColors.white.withValues(alpha: 0.5), width: 2)),
          child: Padding(
            padding: .all(12),
            child: DecoratedBox(
              decoration: BoxDecoration(color: AppColors.overlayDark, shape: .circle),
              child: Padding(
                padding: .all(10),
                child: SvgPicture.asset(AssetRes.icBed, colorFilter: .mode(AppColors.white, .srcIn)),
              ),
            ),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(color: AppColors.overlayDark, borderRadius: .circular(60)),
          child: Padding(padding: .symmetric(horizontal: 24, vertical: 9), child: Text(room, style: AppTextStyles.arRoomLabel)),
        ),
      ],
    );
  }

  Widget _buildSideRoomChip(String room, {required VoidCallback onTap}) {
    return Flexible(
      child: GestureDetector(
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

class _LeaderLinePainter extends CustomPainter {
  final bool toRight;

  _LeaderLinePainter({required this.toRight});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.white.withValues(alpha: 0.85)
      ..style = .stroke
      ..strokeWidth = 1.5
      ..strokeCap = .round;
    final path = Path();
    if (toRight) {
      path.moveTo(0, size.height * 0.6);
      path.quadraticBezierTo(size.width * 0.4, 0, size.width, size.height * 0.2);
    } else {
      path.moveTo(size.width, size.height * 0.2);
      path.quadraticBezierTo(size.width * 0.6, 0, 0, size.height * 0.6);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _LeaderLinePainter oldDelegate) => oldDelegate.toRight != toRight;
}
