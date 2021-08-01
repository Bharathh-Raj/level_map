import 'dart:ui';

extension ImageOffsetExtension on Offset {
  Offset clamp(Size imageSize, Size canvasSize) {
    double dx = this.dx;
    if (dx + imageSize.width > canvasSize.width) {
      dx = dx - imageSize.width;
    }
    double dy = this.dy;
    if (-dy < imageSize.height) {
      dy = -imageSize.height.toDouble();
    } else if (-dy > canvasSize.height) {
      dy = -canvasSize.height;
    }
    return Offset(dx, dy);
  }

  Offset toCenter(Size imageSize) {
    return Offset(
        this.dx - (imageSize.width / 2), this.dy - (imageSize.height / 2));
  }

  Offset toBottomCenter(Size imageSize) {
    return Offset(this.dx - (imageSize.width / 2), this.dy - imageSize.height);
  }

  Offset toTopCenter(double imageWidth) {
    return Offset(this.dx - (imageWidth / 2), this.dy);
  }
}
