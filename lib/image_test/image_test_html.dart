import 'fake_image.dart';

/// Provides a mock HTTP client that responds with a fake image for all requests.
///
/// On the web, this function does nothing but execute the callback.
T provideMockedNetworkImages<T>(
  T Function() callback, {
  /// This parameter is ignored on the web.
  List<int> imageBytes = fakeImageBytes,
}) {
  return callback();
}
