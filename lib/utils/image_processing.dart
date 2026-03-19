import 'dart:typed_data';
import 'package:image/image.dart' as img;

class ImageProcessing {
  static img.Image contrastStretching(img.Image image) {
    int minVal = 255;
    int maxVal = 0;

    for (var pixel in image) {
      int gray = img.getLuminance(pixel).toInt();
      if (gray < minVal) minVal = gray;
      if (gray > maxVal) maxVal = gray;
    }

    if (maxVal > minVal) {
      for (int y = 0; y < image.height; y++) {
        for (int x = 0; x < image.width; x++) {
          var pixel = image.getPixel(x, y);
          int r = pixel.r.toInt();
          int g = pixel.g.toInt();
          int b = pixel.b.toInt();

          int newR = (((r - minVal) * 255) ~/ (maxVal - minVal)).clamp(0, 255);
          int newG = (((g - minVal) * 255) ~/ (maxVal - minVal)).clamp(0, 255);
          int newB = (((b - minVal) * 255) ~/ (maxVal - minVal)).clamp(0, 255);

          image.setPixel(x, y, img.ColorRgb8(newR, newG, newB));
        }
      }
    }
    return image;
  }

  static Float32List imageToFloat32List(img.Image image, {bool normalize = true}) {
    var convertedBytes = Float32List(image.width * image.height * 3);
    int pixelIndex = 0;
    double div = normalize ? 255.0 : 1.0;
    
    for (var pixel in image) {
      convertedBytes[pixelIndex++] = pixel.r / div;
      convertedBytes[pixelIndex++] = pixel.g / div;
      convertedBytes[pixelIndex++] = pixel.b / div;
    }
    return convertedBytes;
  }
}

// TOP-LEVEL FUNCTIONS UNTUK COMPUTE (Mencegah UI Freeze)

img.Image? decodeImageInIsolate(Uint8List bytes) {
  return img.decodeImage(bytes);
}

Map<String, dynamic> processNumberingFullInIsolate(Map<String, dynamic> params) {
  final img.Image image = params['image'];
  final int targetSize = 640;

  // 1. Contrast
  final processed = ImageProcessing.contrastStretching(image);
  
  // 2. Letterbox
  int w = processed.width;
  int h = processed.height;
  double scale = (targetSize / (w > h ? w : h));
  int newW = (w * scale).round();
  int newH = (h * scale).round();

  img.Image resized = img.copyResize(processed, width: newW, height: newH, interpolation: img.Interpolation.linear);
  img.Image canvas = img.Image(width: targetSize, height: targetSize);
  canvas.clear(img.ColorRgb8(114, 114, 114));

  int padLeft = (targetSize - newW) ~/ 2;
  int padTop = (targetSize - newH) ~/ 2;
  img.compositeImage(canvas, resized, dstX: padLeft, dstY: padTop);

  // 3. Konversi Float32
  final floatData = ImageProcessing.imageToFloat32List(canvas, normalize: true);

  return {
    'floatData': floatData,
    'scale': scale,
    'padLeft': padLeft,
    'padTop': padTop,
  };
}

Map<String, dynamic> processCariesFullInIsolate(Map<String, dynamic> params) {
  final img.Image image = params['image'];
  
  // 1. Contrast
  final processed = ImageProcessing.contrastStretching(image);
  
  // 2. Static Crop
  int h = processed.height;
  int w = processed.width;
  int xMin = (0.14 * w).toInt();
  int xMax = (0.90 * w).toInt();
  int yMin = (0.16 * h).toInt();
  int yMax = (0.98 * h).toInt();
  final cropped = img.copyCrop(processed, x: xMin, y: yMin, width: xMax - xMin, height: yMax - yMin);
  
  // 3. Tiles + Float Conversion
  int th = cropped.height ~/ 2;
  int tw = cropped.width ~/ 3;
  List<Float32List> tilesData = [];
  List<Map<String, int>> tilesMetadata = [];

  for (int r = 0; r < 2; r++) {
    for (int c = 0; c < 3; c++) {
      int yStart = r * th;
      int xStart = c * tw;
      img.Image tile = img.copyCrop(cropped, x: xStart, y: yStart, width: tw, height: th);
      img.Image resizedTile = img.copyResize(tile, width: 640, height: 640);
      tilesData.add(ImageProcessing.imageToFloat32List(resizedTile, normalize: true));
      tilesMetadata.add({'tw': tw, 'th': th, 'xStart': xStart, 'yStart': yStart});
    }
  }

  return {
    'tilesData': tilesData,
    'tilesMetadata': tilesMetadata,
    'xMin': xMin,
    'yMin': yMin,
  };
}
