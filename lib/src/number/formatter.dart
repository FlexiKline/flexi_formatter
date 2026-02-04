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

import '../formatter_config.dart';

part 'constants.dart';
part 'extension.dart';

/// Format number with various options
/// 格式化数字, 支持多种选项
///
/// Parameters:
/// - [val]: The decimal value to format, null will use [defIfNull]
/// - [precision]: Precision, if null, use original data precision / 精度, 如果为null, 则使用原始数据的精度
/// - [showSign]: Whether to display sign (+/-) / 是否展示符号位+/-
/// - [signFirst]: Sign (+/-) before [prefix] / 符号位+/-在[prefix]前面
/// - [roundMode]: Rounding mode / 舍入模式
/// - [cutInvalidZero]: Remove trailing zeros / 删除尾部零
/// - [enableCompact]: Enable compact converter for large numbers, takes priority over grouping / 是否启用精简转换器转换大数展示, 优先于千分位展示
/// - [compactConverter]: Custom compact converter for integer part / 自定义整数部分的精简转换器
/// - [enableGrouping]: Enable grouping, mainly for thousand separator / 是否启用分组, 主要是针对千分位展示
/// - [groupSeparator]: Custom group separator, default ',' / 定制分组分隔符, 默认','
/// - [groupCounts]: Custom group count, default 3 / 定制分组数量, 默认3
/// - [shrinkZeroMode]: Shrink zero mode for multiple zeros in decimal part / 小数部分多零情况下, 进行收缩展示模式
/// - [shrinkZeroConverter]: Custom shrink zero converter / 自定义多零收缩转换器
/// - [direction]: Apply explicit bidirectional formatting if not null / 如果不为空, 则对结果应用显式双向格式
/// - [prefix]: Prefix / 前缀
/// - [suffix]: Suffix / 后缀
/// - [defIfZero]: Default display when value is zero / 如果为0时的默认展示
/// - [defIfNull]: Default display when value is null or invalid / 如果为空或无效值时的默认展示
String formatNumber(
  Decimal? val, {
  int? precision,
  bool showSign = false,
  bool signFirst = false,
  RoundMode? roundMode,
  bool cutInvalidZero = false,
  bool enableCompact = false,
  CompactConverter? compactConverter,
  bool enableGrouping = false,
  String? groupSeparator,
  int? groupCounts,
  ShrinkZeroMode? shrinkZeroMode,
  ShrinkZeroConverter? shrinkZeroConverter,
  ExplicitDirection? direction,
  String prefix = '',
  String suffix = '',
  String? defIfZero,
  String defIfNull = '--',
}) {
  // Handle null value / 处理数据为空的情况
  if (val == null) {
    return '$prefix$defIfNull$suffix'.applyExplicitBidiFormatting(direction);
  }

  // Handle zero value / 处理数据为0的情况
  if (val == Decimal.zero && defIfZero != null) {
    return '$prefix$defIfZero$suffix'.applyExplicitBidiFormatting(direction);
  }

  if (showSign) {
    if (signFirst) {
      final sign = val.signChar;
      val = val.abs();
      prefix = '$sign$prefix';
    } else if (val > Decimal.zero) {
      prefix += '+';
    }
  }

  String ret;
  if (enableCompact) {
    final (result, unit) = val.compact(
      precision: precision,
      roundMode: roundMode,
      isClean: cutInvalidZero,
      converter: compactConverter,
    );
    ret = result.shrinkZero(
      shrinkMode: shrinkZeroMode,
      shrinkConverter: shrinkZeroConverter,
    );
    suffix = unit + suffix;
  } else if (enableGrouping) {
    var (integerPart, decimalPart) = val.group(
      precision ?? val.scale,
      roundMode: roundMode,
      isClean: cutInvalidZero,
      groupCounts: groupCounts,
      groupSeparator: groupSeparator,
    );
    decimalPart = decimalPart.shrinkZero(
      shrinkMode: shrinkZeroMode,
      shrinkConverter: shrinkZeroConverter,
    );
    ret = integerPart + decimalPart;
  } else {
    ret = val.formatAsString(
      precision ?? val.scale,
      roundMode: roundMode,
      isClean: cutInvalidZero,
    );
    ret = ret.shrinkZero(
      shrinkMode: shrinkZeroMode,
      shrinkConverter: shrinkZeroConverter,
    );
  }

  return '$prefix$ret$suffix'.applyExplicitBidiFormatting(direction);
}

/// Format percentage value
/// 格式化百分比值
///
/// This is a convenience function that wraps [formatNumber] with percentage-specific defaults:
/// - Multiplies value by 100 by default ([expandHundred] = true)
/// - Sign appears before prefix by default ([signFirst] = true)
/// - Grouping enabled by default ([enableGrouping] = true)
/// - Truncate rounding mode by default ([roundMode] = [RoundMode.truncate])
/// - Automatically adds percent sign based on [percentSignFirst]
///
/// 这是一个便捷函数，使用百分比特定的默认值包装 [formatNumber]：
/// - 默认将值乘以100 ([expandHundred] = true)
/// - 默认符号在前缀前 ([signFirst] = true)
/// - 默认启用分组 ([enableGrouping] = true)
/// - 默认截断舍入模式 ([roundMode] = [RoundMode.truncate])
/// - 根据 [percentSignFirst] 自动添加百分号
///
/// Parameters:
/// - [expandHundred]: Whether to multiply value by 100, default true / 是否将值乘以100, 默认true
/// - [percentSignFirst]: Whether percent sign appears before value, null uses global config / 百分号是否在数值前, null时使用全局配置
String formatPercentage(
  Decimal? val, {
  bool expandHundred = true,
  int? precision,
  bool showSign = false,
  bool signFirst = true,
  RoundMode roundMode = RoundMode.truncate,
  bool cutInvalidZero = false,
  bool enableGrouping = true,
  ShrinkZeroMode? shrinkZeroMode,
  ShrinkZeroConverter? shrinkZeroConverter,
  ExplicitDirection? direction,
  bool? percentSignFirst,
  String prefix = '',
  String suffix = '',
  String? defIfZero,
  String defIfNull = '--',
}) {
  percentSignFirst ??= FlexiFormatter.percentSignFirst;
  if (percentSignFirst) {
    prefix = prefix.contains(defaultPercentSign) ? prefix : '$prefix$defaultPercentSign';
    suffix = suffix.isNotEmpty ? suffix.replaceAll(defaultPercentSign, '') : '';
  } else {
    prefix = prefix.isNotEmpty ? prefix.replaceAll(defaultPercentSign, '') : '';
    suffix = suffix.contains(defaultPercentSign) ? suffix : '$defaultPercentSign$suffix';
  }

  return formatNumber(
    val == null ? null : (expandHundred ? val * hundred : val),
    precision: precision,
    showSign: showSign,
    signFirst: signFirst,
    roundMode: roundMode,
    cutInvalidZero: cutInvalidZero,
    enableGrouping: enableGrouping,
    shrinkZeroMode: shrinkZeroMode,
    shrinkZeroConverter: shrinkZeroConverter,
    direction: direction,
    prefix: prefix,
    suffix: suffix,
    defIfZero: defIfZero,
    defIfNull: defIfNull,
  );
}

/// Format price value
/// 格式化价格值
///
/// This is a convenience function that wraps [formatNumber] with price-specific defaults:
/// - Trailing zeros removed by default ([cutInvalidZero] = true)
/// - Grouping enabled by default ([enableGrouping] = true)
/// - Truncate rounding mode by default ([roundMode] = [RoundMode.truncate])
///
/// 这是一个便捷函数，使用价格特定的默认值包装 [formatNumber]：
/// - 默认删除尾部零 ([cutInvalidZero] = true)
/// - 默认启用分组 ([enableGrouping] = true)
/// - 默认截断舍入模式 ([roundMode] = [RoundMode.truncate])
String formatPrice(
  Decimal? val, {
  int? precision,
  bool showSign = false,
  bool signFirst = false,
  RoundMode roundMode = RoundMode.truncate,
  bool cutInvalidZero = true,
  bool enableGrouping = true,
  ShrinkZeroMode? shrinkZeroMode,
  ShrinkZeroConverter? shrinkZeroConverter,
  ExplicitDirection? direction,
  String prefix = '',
  String suffix = '',
  String? defIfZero,
  String defIfNull = '--',
}) {
  return formatNumber(
    val,
    precision: precision,
    showSign: showSign,
    signFirst: signFirst,
    roundMode: roundMode,
    cutInvalidZero: cutInvalidZero,
    enableGrouping: enableGrouping,
    shrinkZeroMode: shrinkZeroMode,
    shrinkZeroConverter: shrinkZeroConverter,
    direction: direction,
    prefix: prefix,
    suffix: suffix,
    defIfZero: defIfZero,
    defIfNull: defIfNull,
  );
}

/// Format amount value
/// 格式化数量值
///
/// This is a convenience function that wraps [formatNumber] with amount-specific defaults:
/// - Compact converter enabled by default ([enableCompact] = true)
/// - Trailing zeros removed by default ([cutInvalidZero] = true)
///
/// 这是一个便捷函数，使用数量特定的默认值包装 [formatNumber]：
/// - 默认启用精简转换器 ([enableCompact] = true)
/// - 默认删除尾部零 ([cutInvalidZero] = true)
String formatAmount(
  Decimal? val, {
  int? precision,
  bool showSign = false,
  bool signFirst = false,
  RoundMode? roundMode,
  bool enableCompact = true,
  CompactConverter? compactConverter,
  bool cutInvalidZero = true,
  ShrinkZeroMode? shrinkZeroMode,
  ShrinkZeroConverter? shrinkZeroConverter,
  ExplicitDirection? direction,
  String prefix = '',
  String suffix = '',
  String? defIfZero,
  String defIfNull = '--',
}) {
  return formatNumber(
    val,
    precision: precision,
    showSign: showSign,
    signFirst: signFirst,
    roundMode: roundMode,
    enableCompact: enableCompact,
    compactConverter: compactConverter,
    cutInvalidZero: cutInvalidZero,
    shrinkZeroMode: shrinkZeroMode,
    shrinkZeroConverter: shrinkZeroConverter,
    direction: direction,
    prefix: prefix,
    suffix: suffix,
    defIfZero: defIfZero,
    defIfNull: defIfNull,
  );
}

/// Non-shrink zero converter
/// 不进行零收缩转换器
String nonShrinkZeroConverter(int zeroCounts) => '0' * zeroCounts;

/// Thousand compact converter
/// 千分位精简转换器
(Decimal, String) thousandCompactConverter(Decimal val) {
  return val.toThousandCompact;
}

/// Simplified Chinese compact converter
/// 简体中文精简转换器
(Decimal, String) simplifiedChineseCompactConverter(Decimal val) {
  return val.toSimplifiedChineseCompact;
}

/// Traditional Chinese compact converter
/// 繁体中文精简转换器
(Decimal, String) traditionalChineseCompactConverter(Decimal val) {
  return val.toTraditionalChineseCompact;
}
