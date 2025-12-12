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

import 'package:decimal/decimal.dart';
import 'package:intl/intl.dart';

import 'number/formatter.dart';

abstract final class FlexiFormatter {
  static String? _currentLocale;
  static String get currentLocale => _currentLocale ?? Intl.getCurrentLocale();

  /// 全局设置DataFormat的[locale]
  /// 注意: 调用前需要先调用[initializeDateFormatting]初始化Intl本地化库
  static void setCurrentLocale([String? locale]) {
    var localeTag = Intl.canonicalizedLocale(locale);
    if (DateFormat.localeExists(localeTag)) {
      _currentLocale = localeTag;
      return;
    }

    localeTag = Intl.shortLocale(localeTag);
    if (DateFormat.localeExists(localeTag)) {
      _currentLocale = localeTag;
      return;
    }

    _currentLocale = null;
  }

  /// Global configuration for scale on infinite precision, default [defaultScaleOnInfinitePrecision].
  static int _scaleOnInfinitePrecision = defaultScaleOnInfinitePrecision;
  static int get scaleOnInfinitePrecision => _scaleOnInfinitePrecision;

  /// Global configuration for whether the percentage sign is displayed first, default false.
  static bool _percentSignFirst = false;
  static bool get percentSignFirst => _percentSignFirst;

  /// Global configuration for round mode, default null.
  static RoundMode? _globalRoundMode;
  static RoundMode? get globalRoundMode => _globalRoundMode;

  /// Global configuration for explicit direction, default null.
  static ExplicitDirection? _globalExplicitDirection;
  static ExplicitDirection? get globalExplicitDirection => _globalExplicitDirection;

  /// Global configuration for shrink zero mode, default null.
  static ShrinkZeroMode? _globalShrinkZeroMode;
  static ShrinkZeroMode? get globalShrinkZeroMode => _globalShrinkZeroMode;

  /// Global configuration for shrink zero custom converter, default null.
  static ShrinkZeroConverter? _globalShrinkZeroConverter;
  static ShrinkZeroConverter? get globalShrinkZeroConverter => _globalShrinkZeroConverter;

  /// Global configuration for decimal point, default [defaultDecimalSeparator].
  static String _globalDecimalSeparator = defaultDecimalSeparator;
  static String get globalDecimalSeparator => _globalDecimalSeparator;

  /// Global configuration for separator of grouping integer parts, default [defaultGroupIntegerSeparator].
  static String _globalGroupIntegerSeparator = defaultGroupIntegerSeparator;
  static String get globalGroupIntegerSeparator => _globalGroupIntegerSeparator;

  /// Global configuration for count of grouping integer parts, default [defaultGroupIntegerCounts].
  static int _globalGroupIntegerCounts = defaultGroupIntegerCounts;
  static int get globalGroupIntegerCounts => _globalGroupIntegerCounts;

  /// Global configuration for compact formatting. default [thousandCompactConverter] will be used
  static CompactConverter _globalCompactConverter = thousandCompactConverter;
  static CompactConverter get globalCompactConverter => _globalCompactConverter;

  /// Global configuration for displayed as the minimum boundary value of the exponent.
  static Decimal _exponentMinDecimal = defaultExponentMinDecimal;
  static Decimal get exponentMinDecimal => _exponentMinDecimal;

  /// Global configuration for displayed as the maximum boundary value of the exponent
  static Decimal _exponentMaxDecimal = defaultExponentMaxDecimal;
  static Decimal get exponentMaxDecimal => _exponentMaxDecimal;

  /// Restore the global default configuration
  static void restoreGlobalConfig() {
    _percentSignFirst = false;
    _globalRoundMode = null;
    _globalExplicitDirection = null;
    _globalShrinkZeroMode = null;
    _globalShrinkZeroConverter = null;
    _globalDecimalSeparator = defaultDecimalSeparator;
    _globalGroupIntegerSeparator = defaultGroupIntegerSeparator;
    _globalGroupIntegerCounts = defaultGroupIntegerCounts;
    _globalCompactConverter = thousandCompactConverter;
    _exponentMinDecimal = defaultExponentMinDecimal;
    _exponentMaxDecimal = defaultExponentMaxDecimal;
    _scaleOnInfinitePrecision = defaultScaleOnInfinitePrecision;
  }

  /// Configure global settings
  static FlexiFormatter get setGlobalConfig => const _$FlexiFormatterConfigurator();

  void call({
    bool percentSignFirst,
    RoundMode? roundMode,
    ExplicitDirection? direction,
    ShrinkZeroMode? shrinkMode,
    @Deprecated('Use shrinkMode instead. Will be removed in v2.0.0') ShrinkZeroMode? shrikMode,
    String decimalSeparator,
    String groupSeparator,
    int groupCounts,
    CompactConverter compactConverter,
    ShrinkZeroConverter? shrinkZeroConverter,
    Decimal exponentMinDecimal,
    Decimal exponentMaxDecimal,
    int scaleOnInfinitePrecision,
  });
}

final class _$FlexiFormatterConfigurator implements FlexiFormatter {
  const _$FlexiFormatterConfigurator();

  @override
  void call({
    Object? percentSignFirst = _placeHolder,
    Object? roundMode = _placeHolder,
    Object? direction = _placeHolder,
    Object? shrinkMode = _placeHolder,
    @Deprecated('Use shrinkMode instead. Will be removed in v2.0.0') Object? shrikMode = _placeHolder,
    Object? decimalSeparator = _placeHolder,
    Object? groupSeparator = _placeHolder,
    Object? groupCounts = _placeHolder,
    Object? compactConverter = _placeHolder,
    Object? shrinkZeroConverter = _placeHolder,
    Object? exponentMinDecimal = _placeHolder,
    Object? exponentMaxDecimal = _placeHolder,
    Object? scaleOnInfinitePrecision = _placeHolder,
  }) {
    if (percentSignFirst != _placeHolder && percentSignFirst is bool) {
      FlexiFormatter._percentSignFirst = percentSignFirst;
    }

    if (roundMode != _placeHolder && (roundMode == null || roundMode is RoundMode)) {
      FlexiFormatter._globalRoundMode = roundMode as RoundMode?;
    }

    if (direction != _placeHolder && (direction == null || direction is ExplicitDirection)) {
      FlexiFormatter._globalExplicitDirection = direction as ExplicitDirection?;
    }

    // Priority: shrinkMode (new) > shrikMode (deprecated)
    final effectiveShrinkMode = shrinkMode != _placeHolder ? shrinkMode : shrikMode;
    if (effectiveShrinkMode != _placeHolder && (effectiveShrinkMode == null || effectiveShrinkMode is ShrinkZeroMode)) {
      FlexiFormatter._globalShrinkZeroMode = effectiveShrinkMode as ShrinkZeroMode?;
    }

    if (shrinkZeroConverter != _placeHolder &&
        (shrinkZeroConverter == null || shrinkZeroConverter is ShrinkZeroConverter)) {
      FlexiFormatter._globalShrinkZeroConverter = shrinkZeroConverter as ShrinkZeroConverter?;
    }

    if (decimalSeparator != _placeHolder && decimalSeparator is String && decimalSeparator.isNotEmpty) {
      FlexiFormatter._globalDecimalSeparator = decimalSeparator;
    }

    if (groupSeparator != _placeHolder && groupSeparator is String && groupSeparator.isNotEmpty) {
      FlexiFormatter._globalGroupIntegerSeparator = groupSeparator;
    }

    if (groupCounts != _placeHolder && groupCounts is int) {
      FlexiFormatter._globalGroupIntegerCounts = groupCounts.clamp(1, maxGroupIntegerCounts);
    }

    if (compactConverter != _placeHolder && compactConverter is CompactConverter) {
      FlexiFormatter._globalCompactConverter = compactConverter;
    }

    if (exponentMinDecimal != _placeHolder &&
        exponentMinDecimal is Decimal &&
        exponentMinDecimal < defaultExponentMinDecimal) {
      FlexiFormatter._exponentMinDecimal = exponentMinDecimal;
      FlexiFormatter._scaleOnInfinitePrecision = exponentMinDecimal.scale;
    }

    if (exponentMaxDecimal != _placeHolder &&
        exponentMaxDecimal is Decimal &&
        exponentMaxDecimal > defaultExponentMaxDecimal) {
      FlexiFormatter._exponentMaxDecimal = exponentMaxDecimal;
    }

    if (scaleOnInfinitePrecision != _placeHolder &&
        scaleOnInfinitePrecision is int &&
        scaleOnInfinitePrecision > defaultExponentMinDecimal.scale) {
      FlexiFormatter._scaleOnInfinitePrecision = scaleOnInfinitePrecision;
    }
  }
}

const _placeHolder = _$FlexiFormatterPlaceholder();

final class _$FlexiFormatterPlaceholder {
  const _$FlexiFormatterPlaceholder();
}
