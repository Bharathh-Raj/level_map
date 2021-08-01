import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:level_map/src/enum/image_side_enum.dart';
import 'package:level_map/src/model/bg_image.dart';
import 'package:level_map/src/model/image_details.dart';
import 'package:level_map/src/model/image_params.dart';
import 'package:level_map/src/model/images_to_paint.dart';
import 'package:level_map/src/model/level_map_params.dart';

import 'image_offset_extension.dart';

final math.Random _random = math.Random();

Future<ImagesToPaint?> loadImagesToPaint(LevelMapParams levelMapParams,
    int levelCount, double levelHeight, double screenWidth) async {
  final ImageDetails completedLevelImageDetails = ImageDetails(
      imageInfo: await _getUiImage(levelMapParams.completedLevelImage),
      size: levelMapParams.completedLevelImage.size);
  final ImageDetails currentLevelImageDetails = ImageDetails(
      imageInfo: await _getUiImage(levelMapParams.currentLevelImage),
      size: levelMapParams.currentLevelImage.size);
  final ImageDetails lockedLevelImageDetails = ImageDetails(
      imageInfo: await _getUiImage(levelMapParams.lockedLevelImage),
      size: levelMapParams.lockedLevelImage.size);
  final ImageDetails? startLevelImageDetails =
      levelMapParams.startLevelImage != null
          ? ImageDetails(
              imageInfo: await _getUiImage(levelMapParams.startLevelImage!),
              size: levelMapParams.startLevelImage!.size)
          : null;
  final ImageDetails? pathEndImageDetails = levelMapParams.pathEndImage != null
      ? ImageDetails(
          imageInfo: await _getUiImage(levelMapParams.pathEndImage!),
          size: levelMapParams.pathEndImage!.size)
      : null;
  final List<BGImage>? bgImageDetailsList =
      levelMapParams.bgImagesToBePaintedRandomly != null
          ? await _getBGImages(levelMapParams.bgImagesToBePaintedRandomly!,
              levelCount, levelHeight, screenWidth)
          : null;
  return ImagesToPaint(
    bgImages: bgImageDetailsList,
    startLevelImage: startLevelImageDetails,
    completedLevelImage: completedLevelImageDetails,
    currentLevelImage: currentLevelImageDetails,
    lockedLevelImage: lockedLevelImageDetails,
    pathEndImage: pathEndImageDetails,
  );
}

Future<List<BGImage>?> _getBGImages(List<ImageParams> bgImagesParams,
    int levelCount, double levelHeight, double screenWidth) async {
  if (bgImagesParams.isNotEmpty) {
    final List<BGImage> _bgImagesToPaint = [];
    await Future.forEach<ImageParams>(bgImagesParams, (bgImageParam) async {
      final ImageInfo? imageInfo = await _getUiImage(bgImageParam);
      if (imageInfo == null || bgImageParam.repeatCountPerLevel == 0) {
        return;
      }
      final List<ui.Offset> offsetList =
          _getImageOffsets(bgImageParam, levelCount, levelHeight, screenWidth);
      _bgImagesToPaint.add(BGImage(
          imageDetails:
              ImageDetails(imageInfo: imageInfo, size: bgImageParam.size),
          offsetsToBePainted: offsetList));
    });
    return _bgImagesToPaint;
  }
}

List<ui.Offset> _getImageOffsets(ImageParams imageParams, int levelCount,
    double levelHeight, double screenWidth) {
  final List<ui.Offset> offsetList = [];
  final int imageRepeatCount =
      (levelCount * imageParams.repeatCountPerLevel).ceil();
  final double heightBasedOnRepeatCount =
      (1 / imageParams.repeatCountPerLevel) * levelHeight;

  for (int i = 1; i <= imageRepeatCount; i++) {
    double dx = 0;
    double _widthPerSide = screenWidth / 2;
    if (imageParams.side == Side.RIGHT ||
        (imageParams.side == Side.BOTH && _random.nextBool())) {
      dx = imageParams.imagePositionFactor *
          _widthPerSide *
          _random.nextDouble();
      dx = screenWidth - dx;
    } else {
      dx = imageParams.imagePositionFactor *
          _widthPerSide *
          _random.nextDouble();
    }
    final double dy = -(((i - 1) * heightBasedOnRepeatCount) +
        (heightBasedOnRepeatCount * _random.nextDouble()));
    offsetList.add(ui.Offset(dx, dy).clamp(
      imageParams.size,
      Size(screenWidth, levelCount * levelHeight),
    ));
  }
  return offsetList;
}

Future<ImageInfo> _getUiImage(ImageParams imageParams) async {
  Completer<ImageInfo> completer = Completer();
  //TODO: Add network image functionality also.
  final AssetImage image = new AssetImage(imageParams.path);
  image
      .resolve(ImageConfiguration())
      .addListener(ImageStreamListener((ImageInfo info, bool _) {
    completer.complete(info);
  }));
  ImageInfo imageInfo = await completer.future;
  return imageInfo;
}
