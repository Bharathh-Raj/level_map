import 'package:flutter/material.dart';
import 'package:level_map/model/images_to_paint.dart';
import 'package:level_map/model/level_map_params.dart';
import 'package:level_map/paint/level_map_painter.dart';
import 'package:level_map/utils/load_ui_image_to_draw.dart';
import 'package:level_map/utils/scroll_behaviour.dart';

class LevelMap extends StatelessWidget {
  final LevelMapParams levelMapParams;
  final Color backgroundColor;

  /// If set to false, scroll starts from the bottom end (level 1).
  final bool scrollToCurrentLevel;
  const LevelMap({
    Key? key,
    required this.levelMapParams,
    this.backgroundColor = Colors.transparent,
    this.scrollToCurrentLevel = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => ScrollConfiguration(
        behavior: const MyBehavior(),
        child: SingleChildScrollView(
          controller: ScrollController(
              initialScrollOffset: (((scrollToCurrentLevel
                          ? (levelMapParams.levelCount -
                              levelMapParams.currentLevel +
                              2)
                          : levelMapParams.levelCount)) *
                      levelMapParams.levelHeight) -
                  constraints.maxHeight),
          // physics: FixedExtentScrollPhysics(),
          child: Container(
            color: backgroundColor,
            child: FutureBuilder<ImagesToPaint?>(
              future: loadImagesToPaint(
                levelMapParams,
                levelMapParams.levelCount,
                levelMapParams.levelHeight,
                constraints.maxWidth,
              ),
              builder: (context, snapshot) {
                return CustomPaint(
                  size: Size(constraints.maxWidth,
                      levelMapParams.levelCount * levelMapParams.levelHeight),
                  painter: LevelMapPainter(
                      params: levelMapParams, imagesToPaint: snapshot.data),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
