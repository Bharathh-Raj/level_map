import 'dart:ui' as ui;

import 'package:level_map/model/bg_image.dart';

class ImagesToPaint {
  final List<BGImage>? bgImages;
  final ui.Image? startLevelImage;
  final ui.Image completedLevelImage;
  final ui.Image currentLevelImage;
  final ui.Image lockedLevelImage;
  final ui.Image? pathEndImage;

  ImagesToPaint({
    this.bgImages,
    this.startLevelImage,
    required this.completedLevelImage,
    required this.currentLevelImage,
    required this.lockedLevelImage,
    this.pathEndImage,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ImagesToPaint &&
          runtimeType == other.runtimeType &&
          bgImages == other.bgImages &&
          startLevelImage == other.startLevelImage &&
          currentLevelImage == other.currentLevelImage &&
          pathEndImage == other.pathEndImage &&
          lockedLevelImage == other.lockedLevelImage &&
          completedLevelImage == other.completedLevelImage;

  @override
  int get hashCode =>
      bgImages.hashCode ^
      startLevelImage.hashCode ^
      currentLevelImage.hashCode ^
      pathEndImage.hashCode ^
      lockedLevelImage.hashCode ^
      completedLevelImage.hashCode;
}
