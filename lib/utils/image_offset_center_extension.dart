import 'dart:ui';

extension Clamp on Offset {
  Offset clamp(int imageHeight, int imageWidth, double canvasHeight, double canvasWidth) {
    double dx = this.dx;
    if (dx + imageWidth > canvasWidth) {
      dx = dx - imageWidth;
    }
    double dy = this.dy;
    if (-dy < imageHeight) {
      dy = -imageHeight.toDouble();
    } else if (-dy > canvasHeight) {
      dy = -canvasHeight;
    }
    return Offset(dx, dy);
  }

  Offset toCenter(int imageHeight, int imageWidth) {
    return Offset(this.dx - (imageWidth / 2), this.dy - (imageHeight / 2));
  }

  Offset toBottomCenter(int imageHeight, int imageWidth) {
    return Offset(this.dx - (imageWidth / 2), this.dy - imageHeight);
  }

  Offset toTopCenter(int imageHeight, int imageWidth) {
    return Offset(this.dx - (imageWidth / 2), this.dy);
  }
}
