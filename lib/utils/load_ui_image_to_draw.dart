import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:image/image.dart' as image;
import 'package:level_map/enum/image_side_enum.dart';
import 'package:level_map/model/bg_image.dart';
import 'package:level_map/model/image_params.dart';
import 'package:level_map/model/images_to_paint.dart';
import 'package:level_map/model/level_map_params.dart';

import 'image_offset_center_extension.dart';

final math.Random _random = math.Random();

Future<ImagesToPaint?> loadImagesToPaint(
    LevelMapParams levelMapParams, int levelCount, double levelHeight, double screenWidth) async {
  return ImagesToPaint(
    bgImages: await _getBGImages(levelMapParams, levelCount, levelHeight, screenWidth),
    startLevelImage: await _getUiImage(levelMapParams.startLevelImage),
    completedLevelImage: (await _getUiImage(levelMapParams.completedLevelImage))!,
    currentLevelImage: (await _getUiImage(levelMapParams.currentLevelImage))!,
    lockedLevelImage: (await _getUiImage(levelMapParams.lockedLevelImage))!,
    pathEndImage: await _getUiImage(levelMapParams.pathEndImage),
  );
}

Future<List<BGImage>?> _getBGImages(
    LevelMapParams levelMapParams, int levelCount, double levelHeight, double screenWidth) async {
  final List<ImageParams>? _bgImageParams = levelMapParams.pathOfBGImagesToBePaintedRandomly;
  if (_bgImageParams != null && _bgImageParams.isNotEmpty) {
    final List<BGImage> _bgImagesToPaint = [];
    await Future.forEach<ImageParams>(_bgImageParams, (element) async {
      final ui.Image? image = await _getUiImage(element);
      if (image == null || element.repeatCountPerLevel == 0) {
        return;
      }
      final List<ui.Offset> offsetList = _getImageOffsets(element, levelCount, levelHeight, screenWidth);
      _bgImagesToPaint.add(BGImage(image: image, offsetsToBePainted: offsetList));
    });
    return _bgImagesToPaint;
  }
}

List<ui.Offset> _getImageOffsets(ImageParams imageParams, int levelCount, double levelHeight, double screenWidth) {
  final List<ui.Offset> offsetList = [];
  final int imageRepeatCount = (levelCount * imageParams.repeatCountPerLevel).ceil();
  final double heightBasedOnRepeatCount = (1 / imageParams.repeatCountPerLevel) * levelHeight;

  for (int i = 1; i <= imageRepeatCount; i++) {
    double dx = 0;
    double _widthPerSide = screenWidth / 2;
    if (imageParams.side == Side.RIGHT || (imageParams.side == Side.BOTH && _random.nextBool())) {
      dx = imageParams.imagePositionFactor * _widthPerSide * _random.nextDouble();
      dx = screenWidth - dx;
    } else {
      dx = imageParams.imagePositionFactor * _widthPerSide * _random.nextDouble();
    }
    final double dy = -(((i - 1) * heightBasedOnRepeatCount) + (heightBasedOnRepeatCount * _random.nextDouble()));
    offsetList.add(ui.Offset(dx, dy).clamp(
      imageParams.height,
      imageParams.width,
      levelCount * levelHeight,
      screenWidth,
    ));
  }
  return offsetList;
}

Future<ui.Image?> _getUiImage(ImageParams? imageParams) async {
  if (imageParams == null) {
    return null;
  }
  final ByteData assetImageByteData = await rootBundle.load(imageParams.path);
  image.Image? baseSizeImage = image.decodeImage(assetImageByteData.buffer.asUint8List());
  if (baseSizeImage == null) {
    return null;
  }
  image.Image resizeImage = image.copyResize(baseSizeImage, height: imageParams.height, width: imageParams.width);
  ui.Codec codec = await ui.instantiateImageCodec(Uint8List.fromList(image.encodePng(resizeImage)));
  ui.FrameInfo frameInfo = await codec.getNextFrame();
  return frameInfo.image;
}
