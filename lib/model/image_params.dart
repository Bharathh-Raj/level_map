import 'dart:ui';

import '../enum/image_side_enum.dart';

class ImageParams {
  final String path;
  final Size size;

  /// It determines how close the image could get to the center of the page.
  /// Should be between 0 and 1.
  /// 0 means it wont be visible,
  /// 0.5 means it could reach from 0 to 0.25*width on the left side and from 0.75 to 1*width on the right side of the path,
  /// 1 means, image could reach the center of the page.
  /// Default is 0.6
  final double imagePositionFactor;

  /// It determines how often this image could repeat in the same level.
  /// 1 means it appear once per level.
  /// 2 means it appear twice per level.
  /// 0.5 means it appear once every two levels.
  final double repeatCountPerLevel;

  /// If an image need to be panted only on left or right, set this parameter.
  final Side side;

  ImageParams({
    required this.path,
    required this.size,
    this.imagePositionFactor = 0.4,
    this.repeatCountPerLevel = 1,
    this.side = Side.BOTH,
  })  : assert(imagePositionFactor >= 0 && imagePositionFactor <= 1,
            "Image Position factor should be between 0 and 1"),
        assert(repeatCountPerLevel >= 0,
            "repeatPerLevel parameter should be positive");
}
