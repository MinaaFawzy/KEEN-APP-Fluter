
String getResizedImageUrl(String originalUrl, int width, int height) {
  if (originalUrl.contains('.jpg')) {
    return originalUrl.replaceFirst('.jpg', '_${width}x$height.jpg');
  } else if (originalUrl.contains('.png')) {
    return originalUrl.replaceFirst('.png', '_${width}x$height.png');
  }
  return originalUrl; // fallback
}