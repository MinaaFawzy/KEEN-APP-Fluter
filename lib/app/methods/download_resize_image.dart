import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

Future<FileInfo?> _downloadAndResize(String url) async {
  final cacheManager = DefaultCacheManager();

  // Download or get from cache
  final fileInfo = await cacheManager.getFileFromCache(url) ??
      await cacheManager.downloadFile(url);

  if (fileInfo == null) return null;

  final originalBytes = await fileInfo.file.readAsBytes();
  final decoded = img.decodeImage(originalBytes);

  if (decoded == null) return fileInfo;

  // Resize the image
  final resized = img.copyResize(
    decoded,
    width: 400,
    height: 400,
  );

  final resizedBytes = Uint8List.fromList(img.encodeJpg(resized));

  // Put resized back into cache
  await cacheManager.putFile(
    url,
    resizedBytes,
    fileExtension: "jpg",
    eTag: DateTime.now().millisecondsSinceEpoch.toString(), // force update
  );

  return cacheManager.getFileFromCache(url);
}

String getResizedImageUrl(String originalUrl, int width, int height) {
  if (originalUrl.contains('.jpg')) {
    return originalUrl.replaceFirst('.jpg', '_${width}x$height.jpg');
  } else if (originalUrl.contains('.png')) {
    return originalUrl.replaceFirst('.png', '_${width}x$height.png');
  }
  return originalUrl; // fallback
}