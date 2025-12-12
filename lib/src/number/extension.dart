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
  Decimal? get d => Decimal.tryParse(this);

  String get ltr => lri;

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
  Decimal get d => Decimal.fromBigInt(this);
}

extension FlexiNumberFormatterDoubleExt on double {
  Decimal get d => Decimal.parse(toString());
}

extension FlexiNumberFormatterIntExt on int {
  Decimal get d => Decimal.fromInt(this);

  /// 将数字转换为下角标形式字符展示.
  String get subscriptNumeral {
    if (isNaN) return '';
    final buffer = StringBuffer(sign < 0 ? subscriptNegative : '');
    final zeroCodeUnit = '0'.codeUnitAt(0);
    for (final int unit in abs().toString().codeUnits) {
      buffer.write(subscriptNumerals[unit - zeroCodeUnit]);
    }
    return buffer.toString();
  }

  /// 将数字转换为上角标形式字符展示.
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
  String get sign => switch (signum) {
        -1 => '-',
        1 => '+',
        _ => '',
      };

  Decimal get half => (this / two).toDecimal(
        scaleOnInfinitePrecision: FlexiFormatter.scaleOnInfinitePrecision,
      );

  Decimal divNum(num num) {
    assert(num != 0, 'divisor cannot be zero');
    if (num is int) return div(Decimal.fromInt(num));
    if (num is double) return div(num.d);
    throw Exception('$num cannot convert to decimal');
  }

  Decimal div(Decimal other) {
    assert(other != Decimal.zero, 'divisor cannot be zero');
    return (this / other).toDecimal(
      scaleOnInfinitePrecision: FlexiFormatter.scaleOnInfinitePrecision,
    );
  }

  /// use [RoundMode] to handling Decimal
  Decimal rounding(RoundMode mode, {int? scale}) {
    scale ??= 0;
    return switch (mode) {
      RoundMode.round => round(scale: scale),
      RoundMode.floor => floor(scale: scale),
      RoundMode.ceil => ceil(scale: scale),
      RoundMode.truncate => truncate(scale: scale),
    };
  }

  /// The rational string that correctly represents this number.
  ///
  /// All [Decimal]s in the range `10^-15` (inclusive) to `10^21` (exclusive)
  /// are converted to their decimal representation with at least one digit
  /// afer the decimal point. For all other decimal, this method returns an
  /// exponential representation (see [toStringAsExponential]).
  ///
  /// [precision] stands for fractionDigits
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

  /// Parsing [Decimal] to percentage [String].
  String get percentage => '${(this * hundred).toStringAsFixed(2).cleaned}%';
}

extension on Decimal {
  /// Format this number with compact converter.
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

  /// Format the integer part of Decimal with grouping configuration
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
  String get cleaned {
    return switch (this) {
      final String value when value.endsWith(defaultDecimalSeparator) => value.substring(0, value.length - 1),
      final String value when value.contains('e') => value.replaceAll(RegExp(r'(?<=\.\d*?)0+(?!\d)'), ''),
      final String value when value.endsWith('0') && contains(defaultDecimalSeparator) =>
        value.substring(0, value.length - 1).cleaned,
      _ => this,
    };
  }

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

  /// 应用显式双向格式
  /// 支持(隔离/嵌入/覆盖)
  String applyExplicitBidiFormatting(ExplicitDirection? direction) {
    direction ??= FlexiFormatter.globalExplicitDirection;
    if (direction == null) return this;

    return direction.apply(this);
  }
}
