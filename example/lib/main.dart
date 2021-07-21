import 'package:flutter/material.dart';
import 'package:level_map/level_map.dart';
import 'package:level_map/model/image_params.dart';
import 'package:level_map/model/level_map_params.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: LevelMap(
          backgroundColor: Colors.limeAccent,
          levelMapParams: LevelMapParams(
            levelCount: 5,
            currentLevel: 2,
            levelHeight: 200,
            pathColor: Colors.black,
            strokeWidth: 3,
            dashLengthFactor: 0.025,
            firstCurveReferencePointOffsetFactor: Offset(0.5, 0.5),
            currentLevelImage: ImageParams(
              path: "assets/images/current_black.png",
              size: Size(40, 47),
            ),
            lockedLevelImage: ImageParams(
              path: "assets/images/locked_black.png",
              size: Size(51, 54),
            ),
            completedLevelImage: ImageParams(
              path: "assets/images/completed_black.png",
              size: Size(51, 54),
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
              ImageParams(path: "assets/images/Energy equivalency.png", size: Size(80, 80), repeatCountPerLevel: 0.5),
              ImageParams(path: "assets/images/Astronomy.png", size: Size(80, 80), repeatCountPerLevel: 0.25),
              ImageParams(path: "assets/images/Atom.png", size: Size(80, 80), repeatCountPerLevel: 0.25),
              // ImageParams(path: "assets/images/Boy Graduation.png", size: Size(80, 80), repeatCountPerLevel: 0.25),
              // ImageParams(path: "assets/images/Boy Study.png", size: Size(80, 80), repeatCountPerLevel: 0.25),
              ImageParams(path: "assets/images/Certificate.png", size: Size(80, 80), repeatCountPerLevel: 0.25),
              // ImageParams(path: "assets/images/Geology.png", size: Size(80, 80), repeatCountPerLevel: 0.15),
              // ImageParams(path: "assets/images/Graduation Cap.png", size: Size(80, 80), repeatCountPerLevel: 0.15),
              // ImageParams(path: "assets/images/Math.png", size: Size(80, 80), repeatCountPerLevel: 0.15),
              // ImageParams(path: "assets/images/Notes.png", size: Size(80, 80), repeatCountPerLevel: 0.15),
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
            setState(() {});
          },
        ),
      ),
    );
  }
}
