import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:math' as math;

import 'package:flutter/material.dart';

class Device {
  static double devicePixelRatio = WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;
  static ui.Size size = WidgetsBinding.instance.platformDispatcher.views.first.physicalSize;
  static double width = size.width;
  static double height = size.height;
  static double screenWidth = width / devicePixelRatio;
  static double screenHeight = height / devicePixelRatio;
  static ui.Size screenSize = ui.Size(screenWidth, screenHeight);
  final bool? isTablet, isPhone, isIos, isAndroid, isIphoneX;
  static bool hasNotch = WidgetsBinding.instance.platformDispatcher.views.first.viewPadding.bottom > 0;
  static Device? _device;
  static Function? onMetricsChange;

  Device({
    this.isTablet,
    this.isPhone,
    this.isIos,
    this.isAndroid,
    this.isIphoneX,
  });

  factory Device.get() {
    log("##################Device.get:");

    if (_device != null) return _device!;

    if (onMetricsChange == null) {
      onMetricsChange = WidgetsBinding.instance.platformDispatcher.onMetricsChanged;
      WidgetsBinding.instance.platformDispatcher.onMetricsChanged = () {
        _device = null;

        size = WidgetsBinding.instance.platformDispatcher.views.first.physicalSize;
        width = size.width;
        height = size.height;
        screenWidth = width / devicePixelRatio;
        screenHeight = height / devicePixelRatio;
        screenSize = ui.Size(screenWidth, screenHeight);

        onMetricsChange!();
      };
    }

    bool isTablet;
    bool isPhone;
    bool isIos = Platform.isIOS;
    bool isAndroid = Platform.isAndroid;
    bool isIphoneX = false;
    // bool hasNotch = false;

    if (devicePixelRatio < 2 && (width >= 1000 || height >= 1000)) {
      isTablet = true;
      isPhone = false;
      log("#########devicePixelRatio:tab1 $isTablet");
    } else if (devicePixelRatio == 2 && (width >= 1920 || height >= 1920)) {
      isTablet = true;
      isPhone = false;
      log("#########devicePixelRatio:tab2 $isTablet");
    } else {
      isTablet = false;
      isPhone = true;
      log("#########devicePixelRatio:tab-else $isTablet");
    }

    // Recalculate for Android Tablet using device inches
    if (isAndroid) {
      final adjustedWidth = _calWidth() / devicePixelRatio;
      final adjustedHeight = _calHeight() / devicePixelRatio;
      final diagonalSizeInches = (math
              .sqrt(math.pow(adjustedWidth, 2) + math.pow(adjustedHeight, 2))) /
          _ppi;

      log("#########Dialog size inches is $diagonalSizeInches");

      if (diagonalSizeInches >= 6.5) {
        isTablet = true;
        isPhone = false;
        log("#########diagonalSizeInches:tab $isTablet");
      } else {
        isTablet = false;
        isPhone = true;
        log("#########diagonalSizeInches:tab-else $isTablet");
      }
    }

    if (isIos &&
        isPhone &&
        (screenHeight == 812 ||
            screenWidth == 812 ||
            screenHeight == 896 ||
            screenWidth == 896 ||
            // iPhone 12 pro
            screenHeight == 844 ||
            screenWidth == 844 ||
            // Iphone 12 pro max
            screenHeight == 926 ||
            screenWidth == 926)) {
      isIphoneX = true;
      hasNotch = true;
    }

    if (_hasTopOrBottomPadding()) hasNotch = true;

    return _device = Device(
      isTablet: isTablet,
      isPhone: isPhone,
      isAndroid: isAndroid,
      isIos: isIos,
      isIphoneX: isIphoneX,
    );
  }

  static double _calWidth() {
    if (width > height) {
      return (width +
          (WidgetsBinding.instance.platformDispatcher.views.first.viewPadding.left + WidgetsBinding.instance.platformDispatcher.views.first.viewPadding.right) *
              width /
              height);
    }
    return (width + WidgetsBinding.instance.platformDispatcher.views.first.viewPadding.left + WidgetsBinding.instance.platformDispatcher.views.first.viewPadding.right);
  }

  static double _calHeight() {
    return (height +
        (WidgetsBinding.instance.platformDispatcher.views.first.viewPadding.top + WidgetsBinding.instance.platformDispatcher.views.first.viewPadding.bottom));
  }

  static int get _ppi => Platform.isAndroid
      ? 160
      : Platform.isIOS
          ? 150
          : 96;

  static bool _hasTopOrBottomPadding() {
    final padding = WidgetsBinding.instance.platformDispatcher.views.first.viewPadding;
    return padding.top > 0 || padding.bottom > 0;
  }
}
