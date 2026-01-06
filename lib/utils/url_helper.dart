const String BACKEND_URL =
    'https://reflective-clifton-phylacterical.ngrok-free.dev';

String buildFullUrl(String url) {
  if (url.startsWith('http://localhost')) {
    return url.replaceFirst('http://localhost', BACKEND_URL);
  }

  if (url.startsWith('/storage')) {
    return '$BACKEND_URL$url';
  }

  return url;
}
