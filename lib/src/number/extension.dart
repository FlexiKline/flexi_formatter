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

part of 'formatter.dart';

extension FlexiNumberFormatStringExt on String {
  /// Convert string to Decimal, returns null if parsing fails
  /// 将字符串转换为Decimal, 如果解析失败返回null
  Decimal? get d => Decimal.tryParse(this);

  /// Left-to-right text direction, same as lri
  /// 左到右文本方向(Left-to-Right), 等同于lri
  String get ltr => lri;

  /// Right-to-left text direction, same as rli
  /// 右到左文本方向(Right-to-Left), 等同于rli
  String get rtl => rli;

  /// https://unicode.org/reports/tr9/
  /// Explicit Directional Isolates
  /// Treat the following text as isolated and left-to-right.
  /// 将以下文本视为孤立的和从左到右的文本。
  String get lri => ExplicitDirection.lri.apply(this);

  /// Treat the following text as isolated and right-to-left.
  /// 将以下文本视为孤立的和从右到左的文本。
  String get rli => ExplicitDirection.rli.apply(this);

  ///Treat the following text as isolated and in the direction of its first strong directional character that is not inside a nested isolate.
  /// 将以下文本视为孤立文本，并沿其第一个强方向字符的方向处理，该字符不在嵌套隔离文本内。
  String get fsi => ExplicitDirection.fsi.apply(this);

  /// Explicit Directional Embeddings
  /// Treat the following text as embedded left-to-right.
  /// 将以下文本视为从左到右嵌入的文本。
  String get lre => ExplicitDirection.lre.apply(this);

  /// Treat the following text as embedded right-to-left.
  /// 将以下文本视为从右到左嵌入的文本。
  String get rle => ExplicitDirection.rle.apply(this);

  /// Explicit Directional Overrides
  /// Force following characters to be treated as strong left-to-right characters.
  /// 强制将跟随字符视为从左到右的强字符。
  String get lro => ExplicitDirection.lro.apply(this);

  /// Force following characters to be treated as strong right-to-left characters.
  /// 强制将跟随字符视为从右到左的强字符。
  String get rlo => ExplicitDirection.rlo.apply(this);
}

extension FlexiNumberFormatterBigIntExt on BigInt {
  /// Convert BigInt to Decimal
  /// 将BigInt转换为Decimal
  Decimal get d => Decimal.fromBigInt(this);
}

extension FlexiNumberFormatterDoubleExt on double {
  /// Convert double to Decimal
  /// 将double转换为Decimal
  Decimal get d => Decimal.parse(toString());
}

extension FlexiNumberFormatterIntExt on int {
  /// Convert int to Decimal
  /// 将int转换为Decimal
  Decimal get d => Decimal.fromInt(this);

  /// Convert number to subscript numeral string, e.g. 4 => "₄"
  /// 将数字转换为下角标形式字符展示, 例如: 4 => "₄"
  String get subscriptNumeral {
    if (isNaN) return '';
    final buffer = StringBuffer(sign < 0 ? subscriptNegative : '');
    final zeroCodeUnit = '0'.codeUnitAt(0);
    for (final int unit in abs().toString().codeUnits) {
      buffer.write(subscriptNumerals[unit - zeroCodeUnit]);
    }
    return buffer.toString();
  }

  /// Convert number to superscript numeral string, e.g. 4 => "⁴"
  /// 将数字转换为上角标形式字符展示, 例如: 4 => "⁴"
  String get superscriptNumeral {
    if (isNaN) return '';
    final buffer = StringBuffer(sign < 0 ? superscriptNegative : '');
    final zeroCodeUnit = '0'.codeUnitAt(0);
    for (final int unit in abs().toString().codeUnits) {
      buffer.write(superscriptNumerals[unit - zeroCodeUnit]);
    }
    return buffer.toString();
  }
}

extension FlexiNumberFormatterDecimalExt on Decimal {
  /// Get sign character: '+' for positive, '-' for negative, '' for zero
  /// 获取符号字符: 正数返回'+', 负数返回'-', 零返回空字符串
  String get signChar => switch (sign) {
        -1 => '-',
        1 => '+',
        _ => '',
      };

  /// Get half of current value
  /// 获取当前值的一半
  Decimal get half => (this / two).toDecimal(
        scaleOnInfinitePrecision: FlexiFormatter.scaleOnInfinitePrecision,
      );

  /// Divide by num type value
  /// 使用num类型值进行除法运算
  Decimal divNum(num value) {
    assert(value != 0, 'divisor cannot be zero');
    if (value is int) return div(Decimal.fromInt(value));
    if (value is double) return div(value.d);
    throw Exception('$value cannot convert to decimal');
  }

  /// Divide by Decimal with global scale configuration
  /// 使用全局配置的无限精度除法精度执行Decimal除法运算
  Decimal div(Decimal other) {
    assert(other != Decimal.zero, 'divisor cannot be zero');
    return (this / other).toDecimal(
      scaleOnInfinitePrecision: FlexiFormatter.scaleOnInfinitePrecision,
    );
  }

  /// Round Decimal using [RoundMode]
  /// 使用[RoundMode]对Decimal进行舍入处理
  Decimal rounding(RoundMode mode, {int? scale}) {
    scale ??= 0;
    return switch (mode) {
      RoundMode.round => round(scale: scale),
      RoundMode.floor => floor(scale: scale),
      RoundMode.ceil => ceil(scale: scale),
      RoundMode.truncate => truncate(scale: scale),
    };
  }

  /// Format Decimal to string representation
  /// 将Decimal格式化为字符串表示
  ///
  /// All [Decimal]s in the range [FlexiFormatter.exponentMinDecimal] (inclusive) to [FlexiFormatter.exponentMaxDecimal] (exclusive)
  /// are converted to their decimal representation with at least one digit
  /// after the decimal point. For all other decimal, this method returns an
  /// exponential representation (see [toStringAsExponential]).
  /// 在范围 [FlexiFormatter.exponentMinDecimal] (包含) 到 [FlexiFormatter.exponentMaxDecimal] (不包含) 内的所有[Decimal]值将被转换为至少包含一位小数点的十进制表示。
  /// 对于其他所有Decimal值，此方法返回指数表示形式(参见 [toStringAsExponential])。
  ///
  /// [precision] stands for fractionDigits
  /// [precision] 表示小数位数
  String formatAsString(
    int precision, {
    RoundMode? roundMode,
    bool isClean = true,
  }) {
    Decimal value = this;
    roundMode ??= FlexiFormatter.globalRoundMode;
    if (roundMode != null) value = rounding(roundMode, scale: precision);
    String result;
    if (value != Decimal.zero &&
        (value.abs() <= FlexiFormatter.exponentMinDecimal || value.abs() > FlexiFormatter.exponentMaxDecimal)) {
      result = value.toStringAsExponential(precision);
    } else {
      result = value.toStringAsFixed(precision);
    }
    if (isClean) result = result.cleaned;
    return result;
  }

  /// Convert [Decimal] to percentage [String]
  /// 将[Decimal]转换为百分比[String]格式, 例如: 0.1 => "10%"
  String get percentage => '${(this * hundred).toStringAsFixed(2).cleaned}%';
}

extension on Decimal {
  /// Format number with compact converter, returns (formatted value string, unit string)
  /// 使用精简转换器格式化数字, 返回(格式化后的数值字符串, 单位字符串)
  (String, String) compact({
    int? precision,
    bool isClean = true,
    RoundMode? roundMode,
    CompactConverter? converter,
  }) {
    converter ??= FlexiFormatter.globalCompactConverter;
    final (value, unit) = converter(this);
    precision ??= value.scale;
    final result = value.formatAsString(
      precision,
      roundMode: roundMode,
      isClean: isClean,
    );
    return (result, unit);
  }

  /// Format integer part of Decimal with grouping configuration, returns (formatted integer part, decimal part)
  /// 使用分组配置格式化Decimal的整数部分, 返回(格式化后的整数部分, 小数部分)
  (String, String) group(
    int precision, {
    RoundMode? roundMode,
    bool isClean = true,
    int? groupCounts,
    String? groupSeparator,
  }) {
    return formatAsString(
      precision,
      roundMode: roundMode,
      isClean: isClean,
    ).grouping(groupSeparator, groupCounts);
  }

  /// Convert Decimal to thousand compact format, returns (converted value, unit), e.g. 1000000 => (1, "M")
  /// 将Decimal转换为千分位精简格式, 返回(转换后的值, 单位), 例如: 1000000 => (1, "M")
  (Decimal, String) get toThousandCompact {
    final val = abs();
    if (val >= trillion) {
      return (
        (this / trillion).toDecimal(
          scaleOnInfinitePrecision: FlexiFormatter.scaleOnInfinitePrecision,
        ),
        'T',
      );
    } else if (val >= billion) {
      return (
        (this / billion).toDecimal(
          scaleOnInfinitePrecision: FlexiFormatter.scaleOnInfinitePrecision,
        ),
        'B',
      );
    } else if (val >= million) {
      return (
        (this / million).toDecimal(
          scaleOnInfinitePrecision: FlexiFormatter.scaleOnInfinitePrecision,
        ),
        'M',
      );
    } else if (val >= thousand) {
      return (
        (this / thousand).toDecimal(
          scaleOnInfinitePrecision: FlexiFormatter.scaleOnInfinitePrecision,
        ),
        'K',
      );
    } else {
      return (this, '');
    }
  }

  /// Convert Decimal to simplified Chinese compact format, returns (converted value, unit), e.g. 100000000 => (1, "亿")
  /// 将Decimal转换为简体中文精简格式, 返回(转换后的值, 单位), 例如: 100000000 => (1, "亿")
  (Decimal, String) get toSimplifiedChineseCompact {
    final val = abs();
    if (val > trillion) {
      return (
        (this / trillion).toDecimal(
          scaleOnInfinitePrecision: FlexiFormatter.scaleOnInfinitePrecision,
        ),
        '兆',
      );
    } else if (val > hundredMillion) {
      return (
        (this / hundredMillion).toDecimal(
          scaleOnInfinitePrecision: FlexiFormatter.scaleOnInfinitePrecision,
        ),
        '亿',
      );
    } else if (val > tenThousand) {
      return (
        (this / tenThousand).toDecimal(
          scaleOnInfinitePrecision: FlexiFormatter.scaleOnInfinitePrecision,
        ),
        '万',
      );
    } else {
      return (this, '');
    }
  }

  /// Convert Decimal to traditional Chinese compact format, returns (converted value, unit), e.g. 100000000 => (1, "億")
  /// 将Decimal转换为繁体中文精简格式, 返回(转换后的值, 单位), 例如: 100000000 => (1, "億")
  (Decimal, String) get toTraditionalChineseCompact {
    final val = abs();
    if (val > trillion) {
      return (
        (this / trillion).toDecimal(
          scaleOnInfinitePrecision: FlexiFormatter.scaleOnInfinitePrecision,
        ),
        '兆',
      );
    } else if (val > hundredMillion) {
      return (
        (this / hundredMillion).toDecimal(
          scaleOnInfinitePrecision: FlexiFormatter.scaleOnInfinitePrecision,
        ),
        '億',
      );
    } else if (val > tenThousand) {
      return (
        (this / tenThousand).toDecimal(
          scaleOnInfinitePrecision: FlexiFormatter.scaleOnInfinitePrecision,
        ),
        '萬',
      );
    } else {
      return (this, '');
    }
  }
}

extension on String {
  /// Clean invalid trailing zeros and decimal point, e.g. "1.00" => "1", "1.0" => "1"
  /// 清理字符串中无效的尾随零和小数点, 例如: "1.00" => "1", "1.0" => "1"
  String get cleaned {
    return switch (this) {
      final String value when value.endsWith(defaultDecimalSeparator) => value.substring(0, value.length - 1),
      final String value when value.contains('e') => value.replaceAll(RegExp(r'(?<=\.\d*?)0+(?!\d)'), ''),
      final String value when value.endsWith('0') && contains(defaultDecimalSeparator) =>
        value.substring(0, value.length - 1).cleaned,
      _ => this,
    };
  }

  /// Group string formatting (mainly for thousand separator), returns (formatted integer part, decimal part)
  /// 对字符串进行分组格式化(主要用于千分位), 返回(格式化后的整数部分, 小数部分)
  (String, String) grouping(String? separator, int? groupCounts) {
    separator ??= FlexiFormatter.globalGroupIntegerSeparator;
    groupCounts ??= FlexiFormatter.globalGroupIntegerCounts;
    groupCounts = groupCounts.clamp(1, maxGroupIntegerCounts);

    final dotIndex = indexOf(defaultDecimalSeparator);
    String integerPart, decimalPart;
    if (dotIndex == -1) {
      integerPart = this;
      decimalPart = '';
    } else {
      integerPart = substring(0, dotIndex);
      decimalPart = substring(dotIndex, length);
    }
    final formattedInteger = integerPart.replaceAllMapped(
      RegExp('(\\d)(?=(\\d{$groupCounts})+(?!\\d))'),
      (Match match) => '${match[1]}$separator',
    );

    return (formattedInteger, decimalPart);
  }

  /// Shrink multiple consecutive zeros in decimal part, format according to [shrinkMode]
  /// 收缩小数部分中的多个连续零, 根据[shrinkMode]选择不同的收缩格式
  String shrinkZero({
    ShrinkZeroMode? shrinkMode,
    ShrinkZeroConverter? shrinkConverter,
  }) {
    shrinkMode ??= FlexiFormatter.globalShrinkZeroMode;
    shrinkConverter ??= FlexiFormatter.globalShrinkZeroConverter;

    final dotIndex = lastIndexOf(defaultDecimalSeparator);
    if (dotIndex == -1) return this;

    final decimalSeparator = FlexiFormatter.globalDecimalSeparator;

    // 如果未指定[shrinkMode] 或 指定了自定义模式, 但[shrinkConverter]未指定, 则无需进行零收缩
    if (shrinkMode == null || (shrinkMode == ShrinkZeroMode.custom && shrinkConverter == null)) {
      if (decimalSeparator.isNotEmpty && decimalSeparator != defaultDecimalSeparator) {
        return '${substring(0, dotIndex)}$decimalSeparator${substring(dotIndex + 1)}';
      }
      return this;
    }

    final decimalPart = substring(dotIndex + 1);
    final formattedDecimal = decimalPart.replaceAllMapped(
      RegExp(r'(0{4,})(?=[1-9]|$)'),
      (Match match) {
        final zeroPart = match[1] ?? '';
        final zeroCounts = zeroPart.length;
        if (zeroCounts < 1) return zeroPart;
        return switch (shrinkMode) {
          ShrinkZeroMode.subscript => '0${zeroCounts.subscriptNumeral}',
          ShrinkZeroMode.superscript => '0${zeroCounts.superscriptNumeral}',
          ShrinkZeroMode.curlyBraces => '0{$zeroCounts}',
          ShrinkZeroMode.parentheses => '0($zeroCounts)',
          ShrinkZeroMode.squareBrackets => '0[$zeroCounts]',
          _ => shrinkConverter?.call(zeroCounts) ?? zeroPart,
        };
      },
    );

    return '${substring(0, dotIndex)}$decimalSeparator$formattedDecimal';
  }

  /// Apply explicit bidirectional formatting, supports (isolates/embeddings/overrides)
  /// 应用显式双向格式, 支持(隔离/嵌入/覆盖)
  String applyExplicitBidiFormatting(ExplicitDirection? direction) {
    direction ??= FlexiFormatter.globalExplicitDirection;
    if (direction == null) return this;

    return direction.apply(this);
  }
}
