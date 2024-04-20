### @flutter_image_test_utils

This package provides a simple and easier way to test flutter widgets that are using
`Image.network` or `CachedNetworkImage`, by using a mock HTTP client with mocktail stubs
that responds with a fake image for every requests.

> ℹ️ This is an inspiration of: [image_test_utils](https://github.com/roughike/image_test_utils) that is discontinued and [mock_image_http](https://github.com/flutter/flutter/blob/master/dev/manual_tests/test/mock_image_http.dart) from Flutter team.

## Usage

Run this command on the root folder of your Flutter project:

```sh
flutter pub add flutter_image_test_utils
```

Or simple paste the following dependency on your `pubspec.yaml` file:

```yaml
dev_dependencies:
  flutter_image_test_utils: ^1.0.0
```

In your widget tests, simple import the library and test function with: `provideMockedNetworkImages()`, for example:

```dart
import ...
import 'package:flutter_image_test_utils/flutter_image_test_utils.dart';

testWidgets('should do something', (tester) async {
  provideMockedNetworkImages(
    () async {
      await tester.pumpWidget(
        MaterialApp(
          home: MyWidget(),
        ),
      );
      ...
    },
  );
});
```

You can also use your own image bytes value, you just need to pass it to the function with the `imageBytes` parameter:

```dart
import ...

testWidgets('should do something', (tester) async {
  provideMockedNetworkImages(
    () async {
      ...
    },
    imageBytes: [ ... ]
  );
});
```
