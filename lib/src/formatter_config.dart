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

/// Global formatter configuration class
/// 全局格式化器配置类
abstract final class FlexiFormatter {
  static String? _currentLocale;

  /// Get current locale, defaults to system locale if not set
  /// 获取当前语言环境, 如果未设置则默认为系统语言环境
  static String get currentLocale => _currentLocale ?? Intl.getCurrentLocale();

  /// Set global locale for DateFormat
  /// 全局设置DateFormat的[locale]
  /// Note: Call [initializeDateFormatting] to initialize Intl localization library before calling this
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

  /// Global configuration for whether to use system locale to format date, default false
  /// 是否使用系统语言环境的全局配置来格式化日期, 默认 false
  static bool _useSystemLocale = false;
  static bool get useSystemLocale => _useSystemLocale;

  /// Global configuration for scale on infinite precision, default [defaultScaleOnInfinitePrecision]
  /// 无限精度除法的全局配置精度, 默认 [defaultScaleOnInfinitePrecision]
  static int _scaleOnInfinitePrecision = defaultScaleOnInfinitePrecision;
  static int get scaleOnInfinitePrecision => _scaleOnInfinitePrecision;

  /// Global configuration for whether the percentage sign is displayed first, default false
  /// 百分号是否在前的全局配置, 默认 false
  static bool _percentSignFirst = false;
  static bool get percentSignFirst => _percentSignFirst;

  /// Global configuration for round mode, default null
  /// 舍入模式的全局配置, 默认 null
  static RoundMode? _globalRoundMode;
  static RoundMode? get globalRoundMode => _globalRoundMode;

  /// Global configuration for explicit direction, default null
  /// 显式双向格式的全局配置, 默认 null
  static ExplicitDirection? _globalExplicitDirection;
  static ExplicitDirection? get globalExplicitDirection => _globalExplicitDirection;

  /// Global configuration for shrink zero mode, default null
  /// 零收缩模式的全局配置, 默认 null
  static ShrinkZeroMode? _globalShrinkZeroMode;
  static ShrinkZeroMode? get globalShrinkZeroMode => _globalShrinkZeroMode;

  /// Global configuration for shrink zero custom converter, default null
  /// 零收缩自定义转换器的全局配置, 默认 null
  static ShrinkZeroConverter? _globalShrinkZeroConverter;
  static ShrinkZeroConverter? get globalShrinkZeroConverter => _globalShrinkZeroConverter;

  /// Global configuration for decimal point, default [defaultDecimalSeparator]
  /// 小数点的全局配置, 默认 [defaultDecimalSeparator]
  static String _globalDecimalSeparator = defaultDecimalSeparator;
  static String get globalDecimalSeparator => _globalDecimalSeparator;

  /// Global configuration for separator of grouping integer parts, default [defaultGroupIntegerSeparator]
  /// 整数部分分组分隔符的全局配置, 默认 [defaultGroupIntegerSeparator]
  static String _globalGroupIntegerSeparator = defaultGroupIntegerSeparator;
  static String get globalGroupIntegerSeparator => _globalGroupIntegerSeparator;

  /// Global configuration for count of grouping integer parts, default [defaultGroupIntegerCounts]
  /// 整数部分分组数量的全局配置, 默认 [defaultGroupIntegerCounts]
  static int _globalGroupIntegerCounts = defaultGroupIntegerCounts;
  static int get globalGroupIntegerCounts => _globalGroupIntegerCounts;

  /// Global configuration for compact formatting, default [thousandCompactConverter] will be used
  /// 精简转换器的全局配置, 默认使用 [thousandCompactConverter]
  static CompactConverter _globalCompactConverter = thousandCompactConverter;
  static CompactConverter get globalCompactConverter => _globalCompactConverter;

  /// Global configuration for displayed as the minimum boundary value of the exponent
  /// 指数显示最小边界值的全局配置
  static Decimal _exponentMinDecimal = defaultExponentMinDecimal;
  static Decimal get exponentMinDecimal => _exponentMinDecimal;

  /// Global configuration for displayed as the maximum boundary value of the exponent
  /// 指数显示最大边界值的全局配置
  static Decimal _exponentMaxDecimal = defaultExponentMaxDecimal;
  static Decimal get exponentMaxDecimal => _exponentMaxDecimal;

  /// Restore the global default configuration
  /// 恢复全局默认配置
  static void restoreGlobalConfig() {
    _useSystemLocale = false;
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
  /// 配置全局设置
  static FlexiFormatter get setGlobalConfig => const _$FlexiFormatterConfigurator();

  void call({
    bool useSystemLocale,
    bool percentSignFirst,
    RoundMode? roundMode,
    ExplicitDirection? direction,
    ShrinkZeroMode? shrinkMode,
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
    Object? useSystemLocale = _placeHolder,
    Object? percentSignFirst = _placeHolder,
    Object? roundMode = _placeHolder,
    Object? direction = _placeHolder,
    Object? shrinkMode = _placeHolder,
    Object? decimalSeparator = _placeHolder,
    Object? groupSeparator = _placeHolder,
    Object? groupCounts = _placeHolder,
    Object? compactConverter = _placeHolder,
    Object? shrinkZeroConverter = _placeHolder,
    Object? exponentMinDecimal = _placeHolder,
    Object? exponentMaxDecimal = _placeHolder,
    Object? scaleOnInfinitePrecision = _placeHolder,
  }) {
    if (useSystemLocale != _placeHolder && useSystemLocale is bool) {
      FlexiFormatter._useSystemLocale = useSystemLocale;
    }

    if (percentSignFirst != _placeHolder && percentSignFirst is bool) {
      FlexiFormatter._percentSignFirst = percentSignFirst;
    }

    if (roundMode != _placeHolder && (roundMode == null || roundMode is RoundMode)) {
      FlexiFormatter._globalRoundMode = roundMode as RoundMode?;
    }

    if (direction != _placeHolder && (direction == null || direction is ExplicitDirection)) {
      FlexiFormatter._globalExplicitDirection = direction as ExplicitDirection?;
    }

    if (shrinkMode != _placeHolder && (shrinkMode == null || shrinkMode is ShrinkZeroMode)) {
      FlexiFormatter._globalShrinkZeroMode = shrinkMode as ShrinkZeroMode?;
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
