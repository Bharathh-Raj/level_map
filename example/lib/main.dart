import 'package:flutter/material.dart';
import 'package:level_map/level_map.dart';

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
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: LevelMap(
          backgroundColor: Colors.limeAccent,
          levelMapParams: LevelMapParams(
            levelCount: 4,
            currentLevel: 2.5,
            pathColor: Colors.black,
            currentLevelImage: ImageParams(
              path: "assets/images/current_black.png",
              size: Size(40, 47),
            ),
            lockedLevelImage: ImageParams(
              path: "assets/images/locked_black.png",
              size: Size(40, 42),
            ),
            completedLevelImage: ImageParams(
              path: "assets/images/completed_black.png",
              size: Size(40, 42),
            ),
            startLevelImage: ImageParams(
              path: "assets/images/Boy Study.png",
              size: Size(60, 60),
            ),
            pathEndImage: ImageParams(
              path: "assets/images/Boy Graduation.png",
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
