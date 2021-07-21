import 'dart:ui' as ui;

import 'package:level_map/model/image_details.dart';

class BGImage {
  final ImageDetails imageDetails;
  final List<ui.Offset> offsetsToBePainted;

  BGImage({required this.imageDetails, required this.offsetsToBePainted});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BGImage &&
          runtimeType == other.runtimeType &&
          imageDetails == other.imageDetails &&
          offsetsToBePainted == other.offsetsToBePainted;

  @override
  int get hashCode => imageDetails.hashCode ^ offsetsToBePainted.hashCode;
}
