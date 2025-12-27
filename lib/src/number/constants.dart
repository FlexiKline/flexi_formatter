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

/// Default percent sign
/// 默认百分比符号
const defaultPercentSign = '%';

/// Default decimal separator
/// 默认小数点分隔符
const defaultDecimalSeparator = '.';

/// Default group separator for integer part (thousand separator)
/// 默认整数部分分组(千分位)分隔符
const defaultGroupIntegerSeparator = ',';

/// Default group count for integer part
/// 默认整数部分分组数量计数
const defaultGroupIntegerCounts = 3;

/// Maximum group count
/// 最大可分组计数
const maxGroupIntegerCounts = 10;

/// Superscript numerals: 12345⁰¹²³⁴⁵⁶⁷⁸⁹⁺⁻
/// 上角标的数字符号12345⁰¹²³⁴⁵⁶⁷⁸⁹⁺⁻
/// Note: Due to Unicode standard design, ¹²³ (U+00B9, U+00B2, U+00B3) are from Latin-1 Supplement,
/// while ⁰⁴⁵⁶⁷⁸⁹ (U+2070, U+2074-U+2079) are from Superscripts and Subscripts block.
/// Some fonts may render them with slightly different baselines. This is expected behavior.
/// 注意: 由于Unicode标准设计，¹²³ (U+00B9, U+00B2, U+00B3) 来自Latin-1 Supplement块，
/// 而⁰⁴⁵⁶⁷⁸⁹ (U+2070, U+2074-U+2079) 来自Superscripts and Subscripts块。
/// 某些字体可能以略微不同的基线渲染它们，这是预期的行为。
const superscriptNumerals = ['⁰', '¹', '²', '³', '⁴', '⁵', '⁶', '⁷', '⁸', '⁹'];

/// Superscript positive sign
/// 上角标的正号
const superscriptPositive = '⁺';

/// Superscript negative sign
/// 上角标的负号
const superscriptNegative = '⁻';

/// Subscript numerals: 12345₀₁₂₃₄₅₆₇₈₉₊₋
/// 下角标的数字符号12345₀₁₂₃₄₅₆₇₈₉₊₋
const subscriptNumerals = ['₀', '₁', '₂', '₃', '₄', '₅', '₆', '₇', '₈', '₉'];

/// Subscript positive sign
/// 下角标的正号
const subscriptPositive = '₊';

/// Subscript negative sign
/// 下角标的负号
const subscriptNegative = '₋';

/// Default scale for infinite precision Decimal division
/// 无限精度Decimal的除法精度
const int defaultScaleOnInfinitePrecision = 17;

/// Compact converter function type, returns (converted value, unit)
/// 精简转换器函数类型, 返回(转换后的值, 单位)
typedef CompactConverter = (Decimal, String) Function(Decimal value);

/// Shrink zero converter function type, converts zero count to string
/// 零收缩转换器函数类型, 将零的数量转换为字符串
typedef ShrinkZeroConverter = String Function(int zeroCounts);

/// Rounding mode
/// 舍入模式
enum RoundMode {
  /// Round to nearest
  /// 四舍五入
  round,

  /// Round down (floor)
  /// 向下舍入(地板)
  floor,

  /// Round up (ceiling)
  /// 向上舍入(天花板)
  ceil,

  /// Truncate (remove decimal part)
  /// 截断(移除小数部分)
  truncate,
}

/// Explicit directional isolate format characters (Isolates)
/// 显式定向隔离格式字符（Isolates）
const uniLRI = '\u2066';
const uniRLI = '\u2067';
const uniFSI = '\u2068';

/// Pop directional isolate (end isolate)
/// 结束隔离区
const uniPDI = '\u2069';

/// Explicit directional embedding and override format characters (Embeddings & Overrides)
/// 显式定向嵌入和覆盖格式字符（Embeddings & Overrides）
const uniLRE = '\u202A';
const uniRLE = '\u202B';
const uniLRO = '\u202D';
const uniRLO = '\u202E';

/// Pop directional formatting (end embedding/override)
/// 嵌套/覆盖结束符
const uniPDF = '\u202C';

/// https://unicode.org/reports/tr9
/// 为何建议使用隔离字符？
/// 1. 避免嵌套问题
///   隔离字符无需严格匹配起始和结束标记，而嵌入字符必须通过 PDF 精确关闭，否则可能导致文本混乱。
/// 2. 安全性
///   隔离字符的独立作用域可有效防御双向文本攻击（如利用 RLO 反转文件名欺骗用户）。
/// 3. 兼容性与简洁性
///   隔离字符是 Unicode 标准推荐的现代方法，而嵌入字符是遗留方法，未来可能被废弃。
///
/// 使用注意事项:
/// 1. 优先使用隔离字符（LRI/RLI/FSI + PDI）：安全、简单、无嵌套风险。
/// 2. 仅在特殊需求时使用覆盖字符（如必须反转数字方向）。
/// 3. 避免使用嵌入字符（LRE/RLE + PDF）：存在安全性和复杂性隐患。
enum ExplicitDirection {
  /// Explicit Directional Isolates
  /// Treat the following text as isolated and left-to-right.
  /// 将以下文本视为孤立的和从左到右的文本。
  lri(uniLRI, uniPDI),

  /// Treat the following text as isolated and right-to-left.
  /// 将以下文本视为孤立的和从右到左的文本。
  rli(uniRLI, uniPDI),

  ///Treat the following text as isolated and in the direction of its first strong directional character that is not inside a nested isolate.
  /// 将以下文本视为孤立文本，并沿其第一个强方向字符的方向处理，该字符不在嵌套隔离文本内。
  fsi(uniFSI, uniPDI),

  /// Explicit Directional Embeddings
  /// Treat the following text as embedded left-to-right.
  /// 将以下文本视为从左到右嵌入的文本。
  lre(uniLRE, uniPDF),

  /// Treat the following text as embedded right-to-left.
  /// 将以下文本视为从右到左嵌入的文本。
  rle(uniRLE, uniPDF),

  /// Explicit Directional Overrides
  /// Force following characters to be treated as strong left-to-right characters.
  /// 强制将跟随字符视为从左到右的强字符。
  lro(uniLRO, uniPDF),

  /// Force following characters to be treated as strong right-to-left characters.
  /// 强制将跟随字符视为从右到左的强字符。
  rlo(uniRLO, uniPDF);

  final String startCode;
  final String endCode;

  const ExplicitDirection(this.startCode, this.endCode);

  String apply(String content) {
    return '$startCode$content$endCode';
  }
}

/// Shrink zero mode for multiple consecutive zeros
/// 多零收缩模式
enum ShrinkZeroMode {
  /// Subscript mode, e.g. 0.0000123 => 0.0₄123
  /// 下角标模式, 例如: 0.0000123 => 0.0₄123
  subscript,

  /// Superscript mode, e.g. 0.0000123 => 0.0⁴123
  /// 上角标模式, 例如: 0.0000123 => 0.0⁴123
  superscript,

  /// Curly braces mode, e.g. 0.0000123 => 0.0{4}123
  /// 大括号模式, 例如: 0.0000123 => 0.0{4}123
  curlyBraces,

  /// Parentheses mode, e.g. 0.0000123 => 0.0(4)123
  /// 圆括号模式, 例如: 0.0000123 => 0.0(4)123
  parentheses,

  /// Square brackets mode, e.g. 0.0000123 => 0.0[4]123
  /// 方括号模式, 例如: 0.0000123 => 0.0[4]123
  squareBrackets,

  /// Custom mode, requires custom converter
  /// 自定义模式, 需要自定义转换器
  custom;
}

/// Decimal constant: 1
/// Decimal常量: 1
final one = Decimal.one;

/// Decimal constant: 2
/// Decimal常量: 2
final two = Decimal.fromInt(2);

/// Decimal constant: 3
/// Decimal常量: 3
final three = Decimal.fromInt(3);

/// Decimal constant: 1/20
/// Decimal常量: 1/20
final twentieth = (Decimal.one / Decimal.fromInt(20)).toDecimal();

/// Decimal constant: 50
/// Decimal常量: 50
final fifty = Decimal.fromInt(50);

/// Decimal constant: 100
/// Decimal常量: 100
final hundred = Decimal.ten.pow(2).toDecimal();

/// Decimal constant: 1,000
/// Decimal常量: 1,000
final thousand = Decimal.ten.pow(3).toDecimal();

/// Decimal constant: 10,000
/// Decimal常量: 10,000
final tenThousand = Decimal.ten.pow(4).toDecimal();

/// Decimal constant: 1,000,000
/// Decimal常量: 1,000,000
final million = Decimal.ten.pow(6).toDecimal();

/// Decimal constant: 100,000,000
/// Decimal常量: 100,000,000
final hundredMillion = Decimal.ten.pow(8).toDecimal();

/// Decimal constant: 1,000,000,000
/// Decimal常量: 1,000,000,000
final billion = Decimal.ten.pow(9).toDecimal();

/// Decimal constant: 10,000,000,000
/// Decimal常量: 10,000,000,000
final tenBillion = Decimal.ten.pow(10).toDecimal();

/// Decimal constant: 1,000,000,000,000
/// Decimal常量: 1,000,000,000,000
final trillion = Decimal.ten.pow(12).toDecimal();

/// Default minimum exponent decimal: 10^-15
/// 默认最小指数Decimal: 10^-15
final defaultExponentMinDecimal = Decimal.ten.pow(-15).toDecimal();

/// Default maximum exponent decimal: 10^21
/// 默认最大指数Decimal: 10^21
final defaultExponentMaxDecimal = Decimal.ten.pow(21).toDecimal();
