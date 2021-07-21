import 'package:flutter/material.dart';
import 'package:level_map/model/image_details.dart';
import 'package:level_map/model/level_map_params.dart';
import 'package:level_map/utils/image_offset_extension.dart';

import '../model/bg_image.dart';
import '../model/images_to_paint.dart';

class LevelMapPainter extends CustomPainter {
  final LevelMapParams params;
  final ImagesToPaint? imagesToPaint;
  final Paint _pathPaint;
  final Paint _shadowPaint;

  LevelMapPainter({required this.params, this.imagesToPaint})
      : _pathPaint = Paint()
          ..strokeWidth = params.strokeWidth
          ..color = params.pathColor
          ..strokeCap = StrokeCap.round,
        _shadowPaint = Paint()
          ..strokeWidth = params.strokeWidth
          ..color = params.pathColor.withOpacity(0.2)
          ..strokeCap = StrokeCap.round;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(0, size.height);

    if (imagesToPaint != null) {
      _drawBGImages(canvas);
      _drawStartLevelImage(canvas, size.width);
      _drawPathEndImage(canvas, size.width, size.height);
    }

    final double _centerWidth = size.width / 2;
    double _p2_dx_VariationFactor =
        params.firstCurveReferencePointOffsetFactor!.dx;
    double _p2_dy_VariationFactor =
        params.firstCurveReferencePointOffsetFactor!.dy;
    for (int currentLevel = 0;
        currentLevel < params.levelCount;
        currentLevel++) {
      final Offset p1 =
          Offset(_centerWidth, -(currentLevel * params.levelHeight));
      final Offset p2 = getP2OffsetBasedOnCurveSide(currentLevel,
          _p2_dx_VariationFactor, _p2_dy_VariationFactor, _centerWidth);
      final Offset p3 = Offset(_centerWidth,
          -((currentLevel * params.levelHeight) + params.levelHeight));

      _drawBezierCurve(canvas, p1, p2, p3, currentLevel + 1);

      if (params.enableVariationBetweenCurves) {
        _p2_dx_VariationFactor = _p2_dx_VariationFactor +
            params.curveReferenceOffsetVariationForEachLevel[currentLevel].dx;
        _p2_dy_VariationFactor = _p2_dy_VariationFactor +
            params.curveReferenceOffsetVariationForEachLevel[currentLevel].dy;
      }
    }

    canvas.restore();
  }

  void _drawBGImages(Canvas canvas) {
    final List<BGImage>? _bgImages = imagesToPaint!.bgImages;
    if (_bgImages != null) {
      _bgImages.forEach((bgImage) {
        bgImage.offsetsToBePainted.forEach((offset) {
          _paintImage(canvas, bgImage.imageDetails, offset);
        });
      });
    }
  }

  void _drawStartLevelImage(Canvas canvas, double canvasWidth) {
    if (imagesToPaint!.startLevelImage != null) {
      final ImageDetails _startLevelImage = imagesToPaint!.startLevelImage!;
      final Offset _offset =
          Offset(canvasWidth / 2, 0).toBottomCenter(_startLevelImage.size);
      _paintImage(canvas, _startLevelImage, _offset);
    }
  }

  void _drawPathEndImage(
      Canvas canvas, double canvasWidth, double canvasHeight) {
    if (imagesToPaint!.pathEndImage != null) {
      final ImageDetails _pathEndImage = imagesToPaint!.pathEndImage!;
      final Offset _offset = Offset(canvasWidth / 2, -canvasHeight)
          .toTopCenter(_pathEndImage.size.width);
      _paintImage(canvas, _pathEndImage, _offset);
    }
  }

  Offset getP2OffsetBasedOnCurveSide(
      int currentLevel,
      double p2_dx_VariationFactor,
      double p2_dy_VariationFactor,
      double centerWidth) {
    final double clamped_dxFactor = p2_dx_VariationFactor.clamp(
        params.minReferencePositionOffsetFactor.dx,
        params.maxReferencePositionOffsetFactor.dx);
    final double clamped_dyFactor = p2_dy_VariationFactor.clamp(
        params.minReferencePositionOffsetFactor.dy,
        params.maxReferencePositionOffsetFactor.dy);
    final double p2_dx = currentLevel.isEven
        ? centerWidth * (1 - clamped_dxFactor)
        : centerWidth + (centerWidth * clamped_dxFactor);
    final double p2_dy = -((currentLevel * params.levelHeight) +
        (params.levelHeight *
            (currentLevel.isEven ? clamped_dyFactor : 1 - clamped_dyFactor)));
    return Offset(p2_dx, p2_dy);
  }

  void _drawBezierCurve(
      Canvas canvas, Offset p1, Offset p2, Offset p3, int currentLevel) {
    final double _dashFactor = params.dashLengthFactor;
    //TODO: Customise the empty dash length with this multiplication factor 2.
    for (double t = _dashFactor; t <= 1; t += _dashFactor * 2) {
      Offset offset1 = Offset(
          _compute(t, p1.dx, p2.dx, p3.dx), _compute(t, p1.dy, p2.dy, p3.dy));
      Offset offset2 = Offset(_compute(t + _dashFactor, p1.dx, p2.dx, p3.dx),
          _compute(t + _dashFactor, p1.dy, p2.dy, p3.dy));
      canvas.drawLine(offset1, offset2, _pathPaint);
      if (params.showPathShadow) {
        canvas.drawLine(
            Offset(offset1.dx + params.shadowDistanceFromPathOffset.dx,
                offset1.dy + params.shadowDistanceFromPathOffset.dy),
            Offset(offset2.dx + params.shadowDistanceFromPathOffset.dx,
                offset2.dy + params.shadowDistanceFromPathOffset.dy),
            _shadowPaint);
      }
    }
    if (imagesToPaint != null) {
      final Offset _offsetToPaintImage = Offset(
          _compute(0.5, p1.dx, p2.dx, p3.dx),
          _compute(0.5, p1.dy, p2.dy, p3.dy));
      ImageDetails imageDetails = imagesToPaint!.lockedLevelImage;
      if (params.currentLevel > currentLevel) {
        imageDetails = imagesToPaint!.completedLevelImage;
      } else if (params.currentLevel == currentLevel) {
        imageDetails = imagesToPaint!.currentLevelImage;
      } else {
        imageDetails = imagesToPaint!.lockedLevelImage;
      }
      _paintImage(canvas, imageDetails,
          _offsetToPaintImage.toCenter(imageDetails.size));
    }
  }

  void _paintImage(Canvas canvas, ImageDetails imageDetails, Offset offset) {
    paintImage(
        canvas: canvas,
        rect: Rect.fromLTWH(offset.dx, offset.dy, imageDetails.size.width,
            imageDetails.size.height),
        image: imageDetails.imageInfo.image);
  }

  double _compute(double t, double p1, double p2, double p3) {
    ///To learn about these parameters, visit https://en.wikipedia.org/wiki/B%C3%A9zier_curve
    return (((1 - t) * (1 - t) * p1) + (2 * (1 - t) * t * p2) + (t * t) * p3);
  }

  @override
  bool shouldRepaint(covariant LevelMapPainter oldDelegate) =>
      oldDelegate.imagesToPaint != imagesToPaint;
}
