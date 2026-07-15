import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Guards against missing translations: every locale's ARB must define the
/// exact same set of message keys as the `app_en.arb` template.
void main() {
  const arbDir = 'lib/l10n';
  const templateFile = 'app_en.arb';

  Set<String> messageKeys(String path) {
    final content =
        jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>;
    // Drop `@@locale` and `@key` metadata entries — keep only message keys.
    return content.keys.where((key) => !key.startsWith('@')).toSet();
  }

  test('all ARB files share the same message keys as the template', () {
    final templateKeys = messageKeys('$arbDir/$templateFile');

    final arbFiles = Directory(arbDir)
        .listSync()
        .whereType<File>()
        .where((file) => file.path.endsWith('.arb'))
        .toList();

    // Sanity check: we expect the four supported locales.
    expect(arbFiles.length, 4, reason: 'Expected en/pt/es/de ARB files.');

    for (final file in arbFiles) {
      expect(
        messageKeys(file.path),
        templateKeys,
        reason: '${file.path} keys diverge from the $templateFile template.',
      );
    }
  });
}
