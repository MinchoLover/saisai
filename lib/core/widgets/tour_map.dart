import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

import '../map/naver_map_config.dart';
import '../theme/app_theme.dart';
import 'mock_map.dart';

class TourMap extends StatelessWidget {
  const TourMap({
    super.key,
    this.startLabel = '서울역',
    this.destinationLabel = '광화문',
    this.showRoute = true,
    this.showCandidates = false,
  });

  final String startLabel;
  final String destinationLabel;
  final bool showRoute;
  final bool showCandidates;

  @override
  Widget build(BuildContext context) {
    if (!NaverMapConfig.isConfigured) {
      return MockMap(
        startLabel: startLabel,
        destinationLabel: destinationLabel,
        showRoute: showRoute,
        showCandidates: showCandidates,
      );
    }
    return _NaverTourMap(
      startLabel: startLabel,
      destinationLabel: destinationLabel,
      showRoute: showRoute,
      showCandidates: showCandidates,
    );
  }
}

class _NaverTourMap extends StatelessWidget {
  const _NaverTourMap({
    required this.startLabel,
    required this.destinationLabel,
    required this.showRoute,
    required this.showCandidates,
  });

  static const _start = NLatLng(37.5547, 126.9707);
  static const _destination = NLatLng(37.5716, 126.9769);
  static const _route = [
    _start,
    NLatLng(37.5566, 126.9723),
    NLatLng(37.5631, 126.9745),
    _destination,
  ];

  final String startLabel;
  final String destinationLabel;
  final bool showRoute;
  final bool showCandidates;

  @override
  Widget build(BuildContext context) => NaverMap(
        options: const NaverMapViewOptions(
          initialCameraPosition: NCameraPosition(
            target: NLatLng(37.5632, 126.9742),
            zoom: 14.2,
          ),
          contentPadding: EdgeInsets.only(bottom: 180),
          rotationGesturesEnable: false,
        ),
        onMapReady: _addOverlays,
      );

  Future<void> _addOverlays(NaverMapController controller) async {
    await controller.addOverlay(
      NMarker(
        id: 'start',
        position: _start,
        caption: NOverlayCaption(text: startLabel),
      ),
    );
    await controller.addOverlay(
      NMarker(
        id: 'destination',
        position: _destination,
        caption: NOverlayCaption(text: destinationLabel),
      ),
    );
    if (showRoute) {
      await controller.addOverlay(
        NPathOverlay(
          id: 'saisai_route',
          coords: _route,
          width: 6,
          color: AppTheme.primary,
          outlineWidth: 2,
          outlineColor: Colors.white,
        ),
      );
    }
    if (showCandidates) {
      const candidates = [
        ('seoullo', '서울로7017', NLatLng(37.5566, 126.9723)),
        ('deoksugung', '덕수궁', NLatLng(37.5658, 126.9751)),
        ('namdaemun', '남대문시장', NLatLng(37.5592, 126.9776)),
      ];
      for (final candidate in candidates) {
        await controller.addOverlay(
          NMarker(
            id: candidate.$1,
            position: candidate.$3,
            caption: NOverlayCaption(text: candidate.$2),
          ),
        );
      }
    }
  }
}
