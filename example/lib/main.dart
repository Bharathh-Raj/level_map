import 'dart:io';

import 'package:flutter/material.dart';
import 'package:level_map/level_map.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LevelMapPage(),
    );
  }
}

class LevelMapPage extends StatefulWidget {
  @override
  _LevelMapPageState createState() => _LevelMapPageState();
}

class _LevelMapPageState extends State<LevelMapPage> {
  String path = '';

  @override
  void initState() {
    String imagePath = '';
    ScreenshotController screenshotController = ScreenshotController();
    screenshotController
        .captureFromWidget(Icon(Icons.ac_unit))
        .then((image) async {
      final directory = await getApplicationDocumentsDirectory();
      imagePath = '${directory.path}/image.png';
      final filePath = await File(imagePath).create();
      await filePath.writeAsBytes(image);
    }).whenComplete(() {
      setState(() {
        path = imagePath;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    File? file;
    if (path.isNotEmpty) {
      file = File(path);
    }
    return SafeArea(
      child: Scaffold(
        body: Visibility(
          visible: path.isNotEmpty,
          child: LevelMap(
            backgroundColor: Colors.limeAccent,
            levelMapParams: LevelMapParams(
              levelCount: 4,
              currentLevel: 2.5,
              pathColor: Colors.black,
              currentLevelImage: ImageParams(
                bytes: file!.readAsBytesSync(),
                size: Size(40, 47),
              ),
              lockedLevelImage: ImageParams(
                bytes: file.readAsBytesSync(),
                size: Size(40, 42),
              ),
              completedLevelImage: ImageParams(
                bytes: file.readAsBytesSync(),
                size: Size(40, 42),
              ),
              startLevelImage: ImageParams(
                bytes: file.readAsBytesSync(),
                size: Size(60, 60),
              ),
              pathEndImage: ImageParams(
                bytes: file.readAsBytesSync(),
                size: Size(60, 60),
              ),
              bgImagesToBePaintedRandomly: [
                ImageParams(
                    path: "assets/images/Energy equivalency.png",
                    size: Size(80, 80),
                    repeatCountPerLevel: 0.5),
                ImageParams(
                    path: "assets/images/Astronomy.png",
                    size: Size(80, 80),
                    repeatCountPerLevel: 0.25),
                ImageParams(
                    path: "assets/images/Atom.png",
                    size: Size(80, 80),
                    repeatCountPerLevel: 0.25),
                ImageParams(
                    path: "assets/images/Certificate.png",
                    size: Size(80, 80),
                    repeatCountPerLevel: 0.25),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          child: Icon(
            Icons.bolt,
            color: Colors.white,
          ),
          onPressed: () {
            setState(() {
              //Just to visually see the change of path's curve.
            });
          },
        ),
      ),
    );
  }
}
