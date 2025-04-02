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

part 'formatter_config.dart';
part 'decimal_ext.dart';

String formatNumber(
  Decimal? val, {
  int precision = 0, // 展示精度
  bool showSign = false, // 是否展示符号位+
  RoundMode? roundMode,
  bool cutInvalidZero = false, // 删除尾部零
  bool enableCompact = false, // 是否启用精简转换器转换大数展示, 优先于千分位展示
  CompactConverter? compactConverter, // 自定义整数部分的精简转换器
  bool enableGrouping = false, // 是否启用分组, 主要是针对千分位展示.
  String? groupSepartor, // 定制分组分隔符, 默认','.
  int? groupCounts, // 定制分组数量, 默认3.
  ShrinkZeroMode? shrinkZeroMode, // 小数部分多零情况下, 进行收缩展示模式.
  ShrinkZeroConverter? shrinkZeroConverter, // 自定义多零收缩转换器.
  UnicodeDirection? direction, // 如果不为空, 则对结果进行ltr或rtl
  String prefix = '', // 前缀
  String suffix = '', // 后缀
  String? defIfZero, // 如果为0时的默认展示
  String defIfNull = '--', // 如果为空或无效值时的默认展示
}) {
  // 处理数据为空的情况
  if (val == null) {
    return '$prefix$defIfNull$suffix'.unicodeDirection(direction);
  }

  // 处理数据为0的情况
  if (val == Decimal.zero && defIfZero != null) {
    return '$prefix$defIfZero$suffix'.unicodeDirection(direction);
  }

  if (showSign && val >= Decimal.zero) prefix += '+';

  String ret;
  if (enableCompact) {
    final (result, unit) = val._compact(
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
    var (integerPart, decimalPart) = val._group(
      precision,
      roundMode: roundMode,
      isClean: cutInvalidZero,
      groupCounts: groupCounts,
      groupSeparator: groupSepartor,
    );
    decimalPart = decimalPart.shrinkZero(
      shrinkMode: shrinkZeroMode,
      shrinkConverter: shrinkZeroConverter,
    );
    ret = integerPart + decimalPart;
  } else {
    ret = val.formatAsString(
      precision,
      roundMode: roundMode,
      isClean: cutInvalidZero,
    );
    ret = ret.shrinkZero(
      shrinkMode: shrinkZeroMode,
      shrinkConverter: shrinkZeroConverter,
    );
  }

  return '$prefix$ret$suffix'.unicodeDirection(direction);
}

/// 百分比
String formatPercentage(
  Decimal? val, {
  bool expandHundred = true,
  int precision = 2,
  bool showSign = false,
  RoundMode roundMode = RoundMode.floor,
  bool cutInvalidZero = false,
  UnicodeDirection? direction,
  String suffix = '%',
  String defIfNull = '--', // 如果为空或无效值时的默认展示.
}) {
  return formatNumber(
    val == null ? null : (expandHundred ? val * hundred : val),
    precision: precision,
    roundMode: roundMode,
    showSign: showSign,
    cutInvalidZero: cutInvalidZero,
    direction: direction,
    suffix: suffix,
    defIfNull: defIfNull,
  );
}

/// 格式化价钱
String formatPrice(
  Decimal? val, {
  int precision = 2,
  bool showSign = false,
  RoundMode roundMode = RoundMode.floor,
  bool cutInvalidZero = true,
  bool enableGrouping = true,
  ShrinkZeroMode? shrinkZeroMode,
  ShrinkZeroConverter? shrinkZeroConverter,
  UnicodeDirection? direction,
  String prefix = '',
  String suffix = '',
  String? defIfZero,
  String defIfNull = '--',
}) {
  return formatNumber(
    val,
    precision: precision,
    showSign: showSign,
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

/// 格式化数量
String formatAmount(
  Decimal? val, {
  int precision = 2,
  bool showSign = false,
  RoundMode? roundMode,
  bool enableCompact = true,
  CompactConverter? compactConverter,
  bool cutInvalidZero = true,
  ShrinkZeroMode? shrinkZeroMode,
  ShrinkZeroConverter? shrinkZeroConverter,
  UnicodeDirection? direction,
  String prefix = '',
  String suffix = '',
  String? defIfZero,
  String defIfNull = '--',
}) {
  return formatNumber(
    val,
    precision: precision,
    showSign: showSign,
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
