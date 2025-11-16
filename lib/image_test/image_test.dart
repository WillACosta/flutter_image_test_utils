import 'dart:async';
import 'dart:io';

import 'package:mocktail/mocktail.dart';

import '../mocks/mocks.dart';
import 'fake_image.dart';

/// Provides a mock HTTP client that responds with a fake image for all requests.
/// Wrap your test body with this function, for example:
///
/// ```dart
/// testWidgets('should do something', (tester) async {
///   provideMockedNetworkImages(
///     () async {
///       await tester.pumpWidget(
///         MaterialApp(
///           home: MyWidget(),
///         ),
///       );
///       ...
///     },
///   );
/// });
/// ```
///
/// See the README for more information.
T provideMockedNetworkImages<T>(
  T Function() callback, {
  /// Provide custom image bytes for the HTTP responses
  List<int> imageBytes = fakeImageBytes,
}) {
  return HttpOverrides.runZoned(
    callback,
    createHttpClient: (ctx) => _createMockImageHttpClient(
      ctx,
      imageBytes,
    ),
  );
}

class FakeHttpHeaders extends Fake implements HttpHeaders {}

/// Returns a mock HTTP client that responds with an image to all requests.
MockHttpClient _createMockImageHttpClient(
  SecurityContext? securityContext,
  List<int> imageBytes,
) {
  final MockHttpClient client = MockHttpClient();
  final MockHttpClientRequest request = MockHttpClientRequest();
  final MockHttpClientResponse response = MockHttpClientResponse();
  final MockHttpHeaders headers = MockHttpHeaders();

  registerFallbackValue(Uri.parse(""));
  registerFallbackValue("");

  when(() => client.getUrl(any())).thenAnswer(
    (_) => Future<HttpClientRequest>.value(request),
  );

  when(() => request.headers).thenReturn(headers);
  when(() => request.close()).thenAnswer(
    (_) => Future<HttpClientResponse>.value(response),
  );

  when(() => response.contentLength).thenReturn(imageBytes.length);
  when(() => response.statusCode).thenReturn(HttpStatus.ok);
  when(() => response.headers).thenReturn(FakeHttpHeaders());
  when(() => response.compressionState).thenReturn(
    HttpClientResponseCompressionState.notCompressed,
  );

  when(
    () => response.listen(
      any(),
      onDone: any(named: 'onDone'),
      onError: any(named: 'onError'),
      cancelOnError: any(named: 'cancelOnError'),
    ),
  ).thenAnswer(
    (invocation) {
      final void Function(List<int>) onData = invocation.positionalArguments[0];
      final void Function() onDone = invocation.namedArguments[#onDone];
      final void Function(Object, [StackTrace]) onError =
          invocation.namedArguments[#onError];
      final bool cancelOnError = invocation.namedArguments[#cancelOnError];

      return Stream<List<int>>.fromIterable([imageBytes]).listen(
        onData,
        onDone: onDone,
        onError: onError,
        cancelOnError: cancelOnError,
      );
    },
  );

  return client;
}
