// Copyright 2024 Andy.Zhao
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:math';

import 'package:decimal/decimal.dart';
import 'package:flexi_formatter/number.dart';
import 'package:test/test.dart';

void main() {
  /// **Feature: api-naming-fixes, Property 1: groupSeparator 参数功能正确性**
  /// *For any* valid separator string, when passed as `groupSeparator` to
  /// formatNumber with `enableGrouping: true`, the output string should
  /// contain that separator between digit groups.
  /// **Validates: Requirements 1.1**
  group('Property 1: groupSeparator parameter correctness', () {
    final random = Random(42); // Fixed seed for reproducibility

    // Generate random separators that are valid (non-digit, non-decimal)
    // Note: '.' is excluded because it conflicts with the decimal point separator
    // when formatting numbers with decimal parts
    final separators = ['_', '-', ' ', '|', "'", '·', '˙'];

    // Generate random numbers large enough to have grouping
    List<Decimal> generateTestNumbers(int count) {
      final numbers = <Decimal>[];
      for (var i = 0; i < count; i++) {
        // Generate numbers >= 1000 to ensure grouping occurs
        final intPart = 1000 + random.nextInt(999999000);
        final decPart = random.nextInt(1000000);
        numbers.add(Decimal.parse('$intPart.$decPart'));
      }
      return numbers;
    }

    test('groupSeparator appears in output for numbers >= 1000', () {
      final testNumbers = generateTestNumbers(100);

      for (final separator in separators) {
        for (final number in testNumbers) {
          final result = formatNumber(
            number,
            enableGrouping: true,
            groupSeparator: separator,
          );

          // For numbers >= 1000, the separator should appear in the output
          expect(
            result.contains(separator),
            isTrue,
            reason: 'Expected separator "$separator" in result "$result" for number $number',
          );
        }
      }
    });

    test('groupSeparator separates digit groups correctly', () {
      // Test with a known value to verify correct grouping
      final testValue = Decimal.parse('1234567');

      for (final separator in separators) {
        final result = formatNumber(
          testValue,
          enableGrouping: true,
          groupSeparator: separator,
          precision: 0,
        );

        // Should be "1{sep}234{sep}567"
        final expectedPattern = '1${separator}234${separator}567';
        expect(
          result,
          equals(expectedPattern),
          reason: 'Expected "$expectedPattern" but got "$result" for separator "$separator"',
        );
      }
    });

    test('groupSeparator count matches expected groups for any large number', () {
      final testNumbers = generateTestNumbers(100);

      for (final separator in separators) {
        for (final number in testNumbers) {
          final result = formatNumber(
            number,
            enableGrouping: true,
            groupSeparator: separator,
          );

          // Count separators in the integer part only
          final integerPart = result.split('.')[0];
          final separatorCount = separator.allMatches(integerPart).length;

          // Calculate expected separator count based on integer digit count
          final intDigits = number.truncate().toString().length;
          final expectedSeparators = (intDigits - 1) ~/ 3;

          expect(
            separatorCount,
            equals(expectedSeparators),
            reason:
                'Expected $expectedSeparators separators but found $separatorCount in "$result" for number $number with separator "$separator"',
          );
        }
      }
    });

    test('groupSeparator with custom groupCounts', () {
      final testValue = Decimal.parse('12345678');

      // Test with groupCounts of 2, 3, 4
      final groupCountsToTest = [2, 3, 4];

      for (final separator in separators) {
        for (final groupCount in groupCountsToTest) {
          final result = formatNumber(
            testValue,
            enableGrouping: true,
            groupSeparator: separator,
            groupCounts: groupCount,
            precision: 0,
          );

          // Verify separator is present
          expect(
            result.contains(separator),
            isTrue,
            reason: 'Expected separator "$separator" in result "$result" with groupCounts=$groupCount',
          );

          // Verify grouping pattern - each group (except possibly first) should have groupCount digits
          final groups = result.split(separator);
          for (var i = 1; i < groups.length; i++) {
            expect(
              groups[i].length,
              equals(groupCount),
              reason: 'Expected group ${groups[i]} to have $groupCount digits in "$result"',
            );
          }
        }
      }
    });
  });

  /// **Feature: api-naming-fixes, Property 3: 配置参数向后兼容性**
  /// *For any* ShrinkZeroMode value, setting it via either `shrinkMode` or
  /// `shrikMode` in setGlobalConfig should result in the same global state.
  /// **Validates: Requirements 3.1, 3.2**
  group('Property 3: Config parameter backward compatibility', () {
    setUp(() {
      // Reset global config before each test
      FlexiFormatter.restoreGlobalConfig();
    });

    tearDown(() {
      // Clean up after each test
      FlexiFormatter.restoreGlobalConfig();
    });

    test('shrinkMode parameter sets global shrink zero mode correctly', () {
      // Test all ShrinkZeroMode values with the new parameter
      for (final mode in ShrinkZeroMode.values) {
        FlexiFormatter.restoreGlobalConfig();
        FlexiFormatter.setGlobalConfig(shrinkMode: mode);
        expect(
          FlexiFormatter.globalShrinkZeroMode,
          equals(mode),
          reason: 'shrinkMode should set globalShrinkZeroMode to $mode',
        );
      }
    });

    test('deprecated shrikMode parameter sets global shrink zero mode correctly', () {
      // Test all ShrinkZeroMode values with the deprecated parameter
      for (final mode in ShrinkZeroMode.values) {
        FlexiFormatter.restoreGlobalConfig();
        // ignore: deprecated_member_use_from_same_package
        FlexiFormatter.setGlobalConfig(shrikMode: mode);
        expect(
          FlexiFormatter.globalShrinkZeroMode,
          equals(mode),
          reason: 'deprecated shrikMode should set globalShrinkZeroMode to $mode',
        );
      }
    });

    test('shrinkMode and shrikMode produce identical global state', () {
      // For each ShrinkZeroMode value, verify both parameters produce same result
      for (final mode in ShrinkZeroMode.values) {
        // Set using new parameter
        FlexiFormatter.restoreGlobalConfig();
        FlexiFormatter.setGlobalConfig(shrinkMode: mode);
        final stateFromNew = FlexiFormatter.globalShrinkZeroMode;

        // Set using deprecated parameter
        FlexiFormatter.restoreGlobalConfig();
        // ignore: deprecated_member_use_from_same_package
        FlexiFormatter.setGlobalConfig(shrikMode: mode);
        final stateFromDeprecated = FlexiFormatter.globalShrinkZeroMode;

        expect(
          stateFromNew,
          equals(stateFromDeprecated),
          reason: 'Both shrinkMode and shrikMode should produce identical state for $mode',
        );
      }
    });

    test('shrinkMode takes priority when both parameters are provided', () {
      // When both are provided, shrinkMode (new) should take priority
      final newMode = ShrinkZeroMode.subscript;
      final deprecatedMode = ShrinkZeroMode.superscript;

      FlexiFormatter.setGlobalConfig(
        shrinkMode: newMode,
        // ignore: deprecated_member_use_from_same_package
        shrikMode: deprecatedMode,
      );

      expect(
        FlexiFormatter.globalShrinkZeroMode,
        equals(newMode),
        reason: 'shrinkMode should take priority over deprecated shrikMode',
      );
    });

    test('shrinkMode can be set to null to clear global config', () {
      // First set a value
      FlexiFormatter.setGlobalConfig(shrinkMode: ShrinkZeroMode.subscript);
      expect(FlexiFormatter.globalShrinkZeroMode, isNotNull);

      // Then set to null
      FlexiFormatter.setGlobalConfig(shrinkMode: null);
      expect(
        FlexiFormatter.globalShrinkZeroMode,
        isNull,
        reason: 'shrinkMode: null should clear the global shrink zero mode',
      );
    });
  });

  /// **Feature: api-naming-fixes, Property 2: 常量值等价性**
  /// **Validates: Requirements 2.1, 2.2**
  ///
  /// *For any* reference to `defaultPercentSign` or `defaultPrecentSign`,
  /// both constants should return the identical string value '%'.
  group('Constant Equivalence Tests', () {
    test('defaultPercentSign and defaultPrecentSign have identical values', () {
      // ignore: deprecated_member_use_from_same_package
      expect(defaultPrecentSign, equals(defaultPercentSign));
    });

    test('defaultPercentSign has the expected value', () {
      expect(defaultPercentSign, equals('%'));
    });

    test('deprecated defaultPrecentSign has the expected value', () {
      // ignore: deprecated_member_use_from_same_package
      expect(defaultPrecentSign, equals('%'));
    });
  });
}
