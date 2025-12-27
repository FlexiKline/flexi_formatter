# FlexiFormatter

[![Build Status](https://github.com/FlexiKline/flexi_formatter/actions/workflows/publish.yml/badge.svg)](https://github.com/FlexiKline/flexi_formatter/actions/workflows/publish.yml)

[![pub package](https://img.shields.io/pub/v/flexi_formatter.svg)](https://pub.dev/packages/flexi_formatter)

A flexible and customizable Dart/Flutter library for formatting numbers, dates, and other data types.

For instance :

```dart
/// 987654321.123456789 => '987654321.12345'
print(formatNumber(987654321.123456789.d, precision: 5, roundMode: RoundMode.truncate));

/// 1.00000123000 => '1.0{5}123'
print(formatNumber(
  1.00000123000.d,
  precision: 10,
  cutInvalidZero: true,
  shrinkZeroMode: ShrinkZeroMode.curlyBraces,
));

/// 0.1 => '10%'
print(formatPercentage(0.1.d));

/// 0.1 => '+%10'
print(formatPercentage(0.1.d, showSign: true, percentSignFirst: true));

/// 0.1 => '%+10'
print(formatPercentage(0.1.d, showSign: true, signFirst: false, percentSignFirst: true));

/// 1234567890.12345 => '$1,234,567,890.12'
print(formatPrice(1234567890.12345.d, precision: 2, prefix: '\$'));

/// 9876543210.1 => '9.88B'
print(formatAmount(9876543210.1.d, precision: 2));

/// 9876543210.1 => '9.87B'
print(formatAmount(9876543210.1.d, precision: 2, roundMode: RoundMode.truncate));

/// 9876543210.1 => '98.77亿'
print(formatAmount(
  9876543210.1.d,
  precision: 2,
  compactConverter: simplifiedChineseCompactConverter,
));

/// 1234567890.000000789 => '￥+1_2345_6789.0₆78元'
print(formatNumber(
  '123456789.000000789'.d,
  precision: 8,
  roundMode: RoundMode.truncate,
  cutInvalidZero: true,
  enableGrouping: true,
  groupSeparator: '_',
  groupCounts: 4,
  shrinkZeroMode: ShrinkZeroMode.subscript,
  showSign: true,
  prefix: '￥',
  suffix: '元',
));

/// 123456789.000000789 => '￥+1.2345.6789,0₆78元'
try {
  FlexiFormatter.setGlobalConfig(decimalSeparator: ',', groupSeparator: '.', groupCounts: 4);
  print(formatNumber(
    '123456789.000000789'.d,
    precision: 8,
    roundMode: RoundMode.truncate,
    cutInvalidZero: true,
    enableGrouping: true,
    shrinkZeroMode: ShrinkZeroMode.subscript,
    showSign: true,
    prefix: '￥',
    suffix: '元',
  ));
} finally {
  FlexiFormatter.restoreGlobalConfig();
}
```

```dart
initializeDateFormatting();

/// >>> 2024-05-01 12:30:45.123
print('2024-05-01T12:30:45.123456'.toDateTime()?.format(yyyyMMDDHHmmssSSS));

/// >>> 2025-05-01 12:30:45.000
print(1746073845.dateTimeInSecond.format(yyyyMMDDHHmmssSSS));

/// >>> 2025-05-01 12:30:45.123
print(1746073845123.dateTimeInMillisecond.format(yyyyMMDDHHmmssSSS));
print(1746073845123456.dateTimeInMicrosecond.format(yyyyMMDDHHmmssSSS));

final dateTime = DateTime(2025, 5, 1, 12, 30, 45, 123, 456);
printFormatDateTime(dateTime, 'en-US');
printFormatDateTime(dateTime, 'zh-CN');
printFormatDateTime(dateTime, 'ja-JP');

void printFormatDateTime(DateTime dateTime, [String? locale]) {
  print('-----$locale------');
  FlexiFormatter.setCurrentLocale(locale);
  print('MMMEd \t: ${dateTime.MMMEd}');
  print('QQQQ \t: ${dateTime.QQQQ}');
  print('yMd \t: ${dateTime.yMd}');
  print('yMMMEd \t: ${dateTime.yMMMEd}');
  print('yMMMMEEEEd \t: ${dateTime.yMMMMEEEEd}');
  print('combine(yMMMMEEEEd + jms) \t: ${dateTime.yMMMMEEEEd_jms}');
  print('combine(yMEd + jms) \t: ${dateTime.yMEd_jms}');
  print(
    'combine(yQQQ + MMMd) \t: ${dateTime.combineFormat(DateFormat.YEAR_ABBR_QUARTER, DateFormat.ABBR_MONTH_DAY)}',
  );
  print('format(yMEd) \t: ${dateTime.format(DateFormat.YEAR_NUM_MONTH_WEEKDAY_DAY)}');
  print('format(yyyyMMDDHHmmssSSS) \t: ${dateTime.format(yyyyMMDDHHmmssSSS)}');
}

>>> output :
-----en-US------
MMMEd 	: Thu, May 1
QQQQ 	: 2nd quarter
yMd 	: 5/1/2025
yMMMEd 	: Thu, May 1, 2025
yMMMMEEEEd 	: Thursday, May 1, 2025
combine(yMMMMEEEEd + jms) 	: Thursday, May 1, 2025 12:30:45 PM
combine(yMEd + jms) 	: Thu, 5/1/2025 12:30:45 PM
combine(yQQQ + MMMd) 	: Q2 2025 May 1
format(yMEd) 	: Thu, 5/1/2025
format(yyyyMMDDHHmmssSSS) 	: 2025-05-01 12:30:45.123
-----zh-CN------
MMMEd 	: 5月1日周四
QQQQ 	: 第二季度
yMd 	: 2025/5/1
yMMMEd 	: 2025年5月1日周四
yMMMMEEEEd 	: 2025年5月1日星期四
combine(yMMMMEEEEd + jms) 	: 2025年5月1日星期四 12:30:45
combine(yMEd + jms) 	: 2025/5/1周四 12:30:45
combine(yQQQ + MMMd) 	: 2025年第2季度 5月1日
format(yMEd) 	: 2025/5/1周四
format(yyyyMMDDHHmmssSSS) 	: 2025-05-01 12:30:45.123
-----ja-JP------
MMMEd 	: 5月1日(木)
QQQQ 	: 第2四半期
yMd 	: 2025/5/1
yMMMEd 	: 2025年5月1日(木)
yMMMMEEEEd 	: 2025年5月1日木曜日
combine(yMMMMEEEEd + jms) 	: 2025年5月1日木曜日 12:30:45
combine(yMEd + jms) 	: 2025/5/1(木) 12:30:45
combine(yQQQ + MMMd) 	: 2025/Q2 5月1日
format(yMEd) 	: 2025/5/1(木)
format(yyyyMMDDHHmmssSSS) 	: 2025-05-01 12:30:45.123
```

## Usage
To use this library in your code :
* add a dependency in your `pubspec.yaml` :

```yaml
dependencies:
  flexi_formatter:
```

* add import in your `dart` code :

```dart
import 'package:flexi_formatter/flexi_formatter.dart';
```

* Start number formatting using `formatNumber('987654321.0123456789'.d, precision: 5)`.
* Start date formatting using `dateTime.now().format(yyyyMMDDHHmmss)`.

## License
Apache 2.0
