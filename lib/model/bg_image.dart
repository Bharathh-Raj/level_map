import 'dart:ui' as ui;

class BGImage {
  final ui.Image image;
  final List<ui.Offset> offsetsToBePainted;

  BGImage({required this.image, required this.offsetsToBePainted});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BGImage &&
          runtimeType == other.runtimeType &&
          image == other.image &&
          offsetsToBePainted == other.offsetsToBePainted;

  @override
  int get hashCode => image.hashCode ^ offsetsToBePainted.hashCode;
}
