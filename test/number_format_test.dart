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
import 'package:flexi_formatter/number.dart';
import 'package:test/test.dart' show test, expect;

void main() {
  test('test ShrinkZeroMode', () {
    const list = <String>[
      '100000',
      '1.123',
      '1.0123',
      '1.00123',
      '1.000123',
      '1.0000123',
      '1.00000123',
      '1.0000000',
    ];
    for (final str in list) {
      print('$str\t=>\t${formatNumber(
        str.d,
        precision: 10,
        cutInvalidZero: true,
        shrinkZeroMode: ShrinkZeroMode.curlyBraces,
      )}');
    }
  });

  test('test ShrinkZeroMode multiple places are zeroes', () {
    print('=====ShrinkZeroMode multiple places are zeroes=====');
    const value = '123456789.000001230000012300';
    var result = formatNumber(
      value.d,
      precision: 13,
      shrinkZeroMode: ShrinkZeroMode.curlyBraces,
      cutInvalidZero: true,
    );
    print(result);
    expect(result, '123456789.0{5}123');

    result = formatNumber(
      value.d,
      precision: 13,
      shrinkZeroMode: ShrinkZeroMode.curlyBraces,
      cutInvalidZero: false,
    );
    print(result);
    expect(result, '123456789.0{5}1230{5}');

    try {
      FlexiFormatter.setGlobalConfig(decimalSeparator: ',', groupSeparator: '.', groupCounts: 2);
      result = formatNumber(
        value.d,
        precision: 16,
        enableGrouping: true,
        shrinkZeroMode: ShrinkZeroMode.curlyBraces,
        cutInvalidZero: false,
      );
      print(result);
      expect(result, '1.23.45.67.89,0{5}1230{5}123');

      result = formatNumber(
        value.d,
        precision: 18,
        enableGrouping: true,
        shrinkZeroMode: ShrinkZeroMode.curlyBraces,
        cutInvalidZero: false,
      );
      print(result);
      expect(result, '1.23.45.67.89,0{5}1230{5}12300');
    } finally {
      FlexiFormatter.restoreGlobalConfig();
    }
  });

  test('test ShrinkZeroMode ', () {
    print('=====ShrinkZeroMode=====');
    var result = formatNumber(
      '88.00'.d,
      precision: 2,
      shrinkZeroMode: ShrinkZeroMode.curlyBraces,
      cutInvalidZero: false,
    );
    print(result);
    expect(result, '88.00');

    try {
      FlexiFormatter.setGlobalConfig(shrikMode: ShrinkZeroMode.curlyBraces);
      result = formatPercentage(
        '88.00'.d,
        expandHundred: false,
        precision: 2,
        cutInvalidZero: true,
      );
      print(result);
      expect(result, '88%');
    } finally {
      FlexiFormatter.restoreGlobalConfig();
    }
  });

  test('test formatPercentage', () {
    print('=====formatPercentage=====');

    var result = formatPercentage(0.1.d, precision: 2, cutInvalidZero: false);
    print(result);
    expect(result, '10.00%');

    result = formatPercentage(0.1.d, cutInvalidZero: true);
    print(result);
    expect(result, '10%');

    result = formatPercentage(0.98765.d, precision: 2, cutInvalidZero: false);
    print(result);
    expect(result, '98.76%');

    result = formatPercentage(0.98765.d, cutInvalidZero: true);
    print(result);
    expect(result, '98.765%');

    result = formatPercentage(10.56.d, cutInvalidZero: true);
    print(result);
    expect(result, '1,056%');

    result = formatPercentage(0.56.d, showSign: true);
    print(result);
    expect(result, '+56%');

    result = formatPercentage(0.56.d, showSign: true, percentSignFirst: true);
    print(result);
    expect(result, '+%56');

    result = formatPercentage(0.56.d, showSign: true, signFirst: false, percentSignFirst: true);
    print(result);
    expect(result, '%+56');
  });

  test('test formatPrice', () {
    print('=====formatPrice=====');

    var result = formatPrice(0.1.d, precision: 2, cutInvalidZero: false, prefix: '\$');
    print(result);
    expect(result, '\$0.10');

    result = formatPrice(0.1.d, precision: 2, cutInvalidZero: true, prefix: '\$');
    print(result);
    expect(result, '\$0.1');

    result = formatPrice(123456.789.d, precision: 2, prefix: '\$');
    print(result);
    expect(result, '\$123,456.78');

    result = formatPrice(
      123456.000000789.d,
      precision: 9,
      prefix: '\$',
      shrinkZeroMode: ShrinkZeroMode.curlyBraces,
    );
    print(result);
    expect(result, '\$123,456.0{6}789');
  });

  test('test formatAmount', () {
    print('=====formatAmount=====');

    var result = formatAmount(12345.1.d, precision: 2);
    print(result);
    expect(result, '12.35K');

    result = formatAmount(123456789.d, precision: 3);
    print(result);
    expect(result, '123.457M');

    result = formatAmount(
      123456789.d,
      precision: 3,
      compactConverter: simplifiedChineseCompactConverter,
    );
    print(result);
    expect(result, '1.235亿');
  });

  test('test formatNumber', () {
    print('=====formatNumber=====');

    final result = formatNumber(
      '-123456789.000000789'.d,
      precision: 8,
      roundMode: RoundMode.truncate,
      cutInvalidZero: true,
      enableGrouping: true,
      groupSepartor: '_',
      groupCounts: 4,
      shrinkZeroMode: ShrinkZeroMode.subscript,
      showSign: true,
      signFirst: false,
      prefix: '￥',
      suffix: '元',
    );
    print(result);
    expect(result, '￥-1_2345_6789.0₆78元');
  });

  test('test global configuration', () {
    print('=====global configuration=====');

    /// 123456789.000000789 => '￥-1.2345.6789,0₆78元'
    try {
      FlexiFormatter.setGlobalConfig(decimalSeparator: ',', groupSeparator: '.', groupCounts: 4);
      var result = formatNumber(
        '-123456789.000000789'.d,
        precision: 8,
        roundMode: RoundMode.truncate,
        cutInvalidZero: true,
        enableGrouping: true,
        shrinkZeroMode: ShrinkZeroMode.subscript,
        showSign: true,
        prefix: '￥',
        suffix: '元',
      );
      print(result);
      expect(result, '￥-1.2345.6789,0₆78元');

      FlexiFormatter.setGlobalConfig(decimalSeparator: ',', groupSeparator: '.', groupCounts: 3);
      result = formatPrice(
        '123456789.000000789'.d,
        precision: 8,
        showSign: true,
        signFirst: true,
        prefix: '￥',
        suffix: '元',
      );
      print(result);
      expect(result, '+￥123.456.789,00000078元');
    } finally {
      FlexiFormatter.restoreGlobalConfig();
    }
  });

  test('test custom shrin zero converter', () {
    print('=====custom shrin zero converter=====');

    /// 123456789.000000789 => '￥+123,456,789.0<₆>78元'
    final result = formatNumber(
      '123456789.000000789'.d,
      precision: 8,
      roundMode: RoundMode.truncate,
      cutInvalidZero: true,
      enableGrouping: true,
      shrinkZeroMode: ShrinkZeroMode.custom,
      shrinkZeroConverter: (zeroCounts) {
        return '0<${zeroCounts.subscriptNumeral}>';
      },
      showSign: true,
      prefix: '￥',
      suffix: '元',
    );
    print(result);
    expect(result, '￥+123,456,789.0<₆>78元');
  });

  test('test format exceeding the exponent limit value', () {
    print('=====exceeding the exponent limit value=====');
    final minimum = Decimal.ten.pow(-16).toDecimal();

    var result = formatNumber(
      minimum,
      precision: 18,
      shrinkZeroMode: ShrinkZeroMode.curlyBraces,
      cutInvalidZero: true,
    );
    print(result);
    expect(result, '1.e-16');

    final maximum = Decimal.ten.pow(22).toDecimal();
    result = formatNumber(
      maximum,
      precision: 18,
      shrinkZeroMode: ShrinkZeroMode.curlyBraces,
      cutInvalidZero: true,
    );
    print(result);
    expect(result, '1.e+22');
  });

  test('test setting exponent limit and scaleOnInfinitePrecision', () {
    print('=====setting exponent limit and scaleOnInfinitePrecision=====');
    try {
      FlexiFormatter.setGlobalConfig(
        exponentMinDecimal: Decimal.ten.pow(-35).toDecimal(),
        exponentMaxDecimal: Decimal.ten.pow(30).toDecimal(),
        scaleOnInfinitePrecision: 35,
      );

      final dividend = Decimal.fromInt(10).pow(35).toDecimal();
      final value = (23237.84.d / dividend).toDecimal(
        scaleOnInfinitePrecision: FlexiFormatter.scaleOnInfinitePrecision,
      );
      var result = formatNumber(
        value,
        shrinkZeroMode: ShrinkZeroMode.curlyBraces,
        cutInvalidZero: true,
      );
      print(result);
      expect(result, '0.0{30}2323784');

      result = formatNumber(
        value,
        precision: 35,
        roundMode: RoundMode.floor,
        shrinkZeroMode: ShrinkZeroMode.curlyBraces,
        cutInvalidZero: true,
      );
      print(result);
      expect(result, '0.0{30}23237');
    } finally {
      FlexiFormatter.restoreGlobalConfig();
    }
  });

  test('test precentSignFirst', () {
    print('=====precentSignFirst=====');
    var result = formatPercentage(
      0.1.d,
      precision: 2,
      cutInvalidZero: true,
    );
    print(result);
    expect(result, '10%');

    result = formatPercentage(
      0.1.d,
      precision: 2,
      cutInvalidZero: true,
      percentSignFirst: true,
    );
    print(result);
    expect(result, '%10');

    try {
      FlexiFormatter.setGlobalConfig(percentSignFirst: true);
      result = formatPercentage(
        0.1.d,
        precision: 2,
        cutInvalidZero: true,
        prefix: 'Current: ',
        suffix: '%',
      );
      print(result);
      expect(result, 'Current: %10');
    } finally {
      FlexiFormatter.restoreGlobalConfig();
    }

    result = formatPercentage(
      0.1.d,
      precision: 2,
      cutInvalidZero: true,
      prefix: 'Current: %',
      suffix: ' count',
    );
    print(result);
    expect(result, 'Current: 10% count');

    result = formatPercentage(
      0.1.d,
      precision: 2,
      cutInvalidZero: true,
      percentSignFirst: true,
      prefix: 'Current: ',
      suffix: '% count',
    );
    print(result);
    expect(result, 'Current: %10 count');
  });

  test('test customCompact', () {
    print('=====customCompact=====');
    (Decimal, String) customCompact(Decimal value) {
      final val = value.abs();
      if (val >= trillion) {
        return (
          (value / trillion).toDecimal().floor(scale: 2),
          'T',
        );
      } else if (val >= billion) {
        return (
          (value / billion).toDecimal().floor(scale: 2),
          'B',
        );
      } else if (val >= million) {
        return (
          (value / million).toDecimal().floor(scale: 2),
          'M',
        );
      } else if (val >= tenThousand) {
        return (
          (value / thousand).toDecimal().floor(scale: 2),
          'K',
        );
      } else {
        return (value, '');
      }
    }

    var result = formatAmount(
      123456.d,
      precision: 2,
      compactConverter: customCompact,
    );
    print(result);
    expect(result, '123.45K');

    result = formatAmount(
      1234.2.d,
      precision: 2,
      cutInvalidZero: false,
      compactConverter: customCompact,
    );
    print(result);
    expect(result, '1234.20');

    result = formatAmount(
      123.23.d,
      precision: 2,
      compactConverter: customCompact,
    );
    print(result);
    expect(result, '123.23');

    result = formatAmount(
      123.234.d,
      compactConverter: customCompact,
    );
    print(result);
    expect(result, '123.234');
  });

  test('test formatAmount for extreme values (极大值)', () {
    // 极大值测试
    var result = formatAmount(
      '999999999999999999999999999999'.d,
    );
    print(result);
    expect(result, '999999999999999999.999999999999T');

    // 正常大数分界, 万亿
    result = formatAmount(
      '1000000000000'.d,
    );
    print(result);
    expect(result, '1T');

    // 过界最小T
    result = formatAmount(
      '1000000000001'.d,
      precision: 2,
    );
    print(result);
    // precision=2，但 cutInvalidZero=true（默认），所以 '1.00T' 会被清理为 '1T'
    expect(result, '1T');

    // T单位边界再下, B边界
    result = formatAmount(
      '999999999999'.d,
      roundMode: RoundMode.round,
      precision: 3,
    );
    print(result);
    expect(result, '1000B');

    // B单位下界
    result = formatAmount(
      '1000000000'.d,
    );
    print(result);
    expect(result, '1B');
  });

  test('test formatAmount for extreme values (极小值)', () {
    // 极小正数
    var result = formatAmount(
      '0.00000000000000000001'.d,
    );
    print(result);
    expect(result, '1.e-20');

    // 精度测试，避免四舍五入出现极值问题
    result = formatAmount(
      '0.0000001'.d,
      precision: 10,
    );
    print(result);
    expect(result, '0.0000001');

    // 负极小值
    result = formatAmount(
      '-0.00000000000000001'.d,
    );
    print(result);
    expect(result, '-1.e-17');

    // 0值
    result = formatAmount(
      Decimal.zero,
    );
    print(result);
    expect(result, '0');
  });
}
