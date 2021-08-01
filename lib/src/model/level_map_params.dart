import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'image_params.dart';

class LevelMapParams {
  static final _random = math.Random();
  final int levelCount;

  /// Determines the current level of the user.
  /// If the user is in between levels, use decimal.
  late final double currentLevel;

  /// Determines the stroke width of the path lines.
  /// Default is 3.
  final double pathStrokeWidth;
  final Color pathColor;

  /// Default is 200.
  final double levelHeight;

  /// Used to adjust the length of the dash.
  /// Should be between 0 and 0.5.
  /// Default is 0.025.
  final double dashLengthFactor;

  /// If set to false, there won't be any variation between curves, all curves are identical.
  /// Default is true.
  final bool enableVariationBetweenCurves;

  /// Determines max offset variation between curves.
  /// Affects only if [enableVariationBetweenCurves] flag is set to true.
  /// Note: Having huge [maxVariationFactor]  causes hard edges. Ideal value is between 0 and 1 (may vary based on the [levelHeight]).
  /// Default is 0.2.
  final double maxVariationFactor;

  /// Determines the position of the reference point of the first curve.
  /// This affects all the successive reference points.
  /// Offset factor should be between 0 and 1.
  /// Default is random.
  late Offset? firstCurveReferencePointOffsetFactor;

  /// List of reference point offset of each level.
  /// Affects only if [enableVariationBetweenCurves] flag is set to true
  /// Helps to position the reference point for each curve.
  /// Default is random.
  final List<Offset> curveReferenceOffsetVariationForEachLevel;

  final bool showPathShadow;

  /// Determines how far the shadows should cast.
  /// Affects only if showPathShadow flag is set to true
  /// dx of the offset determines horizontal distance from the path,
  /// dy of the offset determines vertical distance from the path.
  /// +ve dx casts shadow to right and -ve dx casts shadow to the left,
  /// +ve dy casts shadow to the bottom and -ve dy casts shadow to the top.
  /// Default is Offset(-2, 12).
  final Offset shadowDistanceFromPathOffset;

  /// Min Amplitude factor of the curve.
  /// Affects how far the reference point at least be from mid point.
  /// Offset factor should be between 0 and 1.
  /// Default is Offset(0.4, 0.3), which means dx of Reference point should at least (0.4 * (width/2))
  /// and dy of the Reference point should at least (0.3 * (width/2))
  /// width/2 since the curve starts in center
  final Offset minReferencePositionOffsetFactor;

  /// Max Amplitude factor of the curve.
  /// Affects how far the reference point at most be from mid point.
  /// Offset factor should be between 0 and 1.
  /// Default is Offset(1, 0.7), which means dx of Reference point should at most (1 * (width/2))
  /// and dy of the Reference point should at most (0.7 * (width/2))
  /// width/2 since the curve starts in center
  final Offset maxReferencePositionOffsetFactor;

  final List<ImageParams>? bgImagesToBePaintedRandomly;

  /// It is the image positioned in the bottom center of the level map to indicate the start position.
  final ImageParams? startLevelImage;

  /// It is the image positioned on top of the completed levels of the level map to indicate the level is completed.
  final ImageParams completedLevelImage;

  /// It is the image positioned on top of the current level of the level map to indicate the current position of the user.
  final ImageParams currentLevelImage;

  /// It is the image positioned on top of the upcoming levels of the level map to indicate those levels are yet to unlock.
  final ImageParams lockedLevelImage;

  /// It is the image positioned in the top center of the level map to indicate the end of the level map.
  final ImageParams? pathEndImage;

  ///Note: If you see any hard edge, decrease the [maxVariationFactor],else disable the [enableVariationBetweenCurves] parameter, Default is 0.2.
  /// If you need the curves to be fixed in every build, set the [enableVariationBetweenCurves] to false and set the [firstCurveReferencePointOffsetFactor], Default is random.
  LevelMapParams({
    required this.levelCount,
    required double currentLevel,
    this.pathColor = Colors.black,
    this.levelHeight = 200,
    this.pathStrokeWidth = 3,
    this.dashLengthFactor = 0.025,
    this.enableVariationBetweenCurves = true,
    this.maxVariationFactor = 0.2,
    this.showPathShadow = true,
    this.shadowDistanceFromPathOffset = const Offset(-2, 12),
    this.minReferencePositionOffsetFactor = const Offset(0.4, 0.3),
    this.maxReferencePositionOffsetFactor = const Offset(1, 0.7),
    this.firstCurveReferencePointOffsetFactor,
    this.bgImagesToBePaintedRandomly,
    this.startLevelImage,
    required this.completedLevelImage,
    required this.currentLevelImage,
    required this.lockedLevelImage,
    this.pathEndImage,
  })  : assert(currentLevel <= levelCount,
            "Current level should be less than total level count"),
        assert(currentLevel >= 1, "Current level should at least be 1"),
        assert(dashLengthFactor >= 0 && dashLengthFactor <= 0.5,
            "Dash length factor should be between 0 and 0.5"),
        assert(100 % (dashLengthFactor * 100) == 0,
            "Dash length factor should be a factor of 1"),
        assert(
            minReferencePositionOffsetFactor.dx <= 1 &&
                minReferencePositionOffsetFactor.dx >= 0 &&
                minReferencePositionOffsetFactor.dy <= 1 &&
                minReferencePositionOffsetFactor.dy >= 0,
            "dx and dy of minEndReferenceOffsetVariationFactor should be between 0 and 1"),
        assert(
            maxReferencePositionOffsetFactor.dx <= 1 &&
                maxReferencePositionOffsetFactor.dx >= 0 &&
                maxReferencePositionOffsetFactor.dy <= 1 &&
                maxReferencePositionOffsetFactor.dy >= 0,
            "dx and dy of maxEndReferenceOffsetVariationFactor should be between 0 and 1"),
        this.curveReferenceOffsetVariationForEachLevel = List.generate(
            levelCount,
            (index) => Offset(
                (_random.nextBool()
                        ? _random.nextDouble()
                        : -_random.nextDouble()) *
                    maxVariationFactor,
                (_random.nextBool()
                        ? _random.nextDouble()
                        : -_random.nextDouble()) *
                    maxVariationFactor),
            growable: false) {
    this.currentLevel = currentLevel.clamp(1, levelCount).toDouble();
    this.firstCurveReferencePointOffsetFactor =
        firstCurveReferencePointOffsetFactor ??
            Offset(_random.nextDouble(), _random.nextDouble());
  }
}
