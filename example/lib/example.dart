import 'package:flexi_formatter/flexi_formatter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

void main() {
  print('\n-----Number Formatter-----');
  printFormatNumber();

  print('\n-----Explicit Direction-----');
  printExplicitDirection();

  print('\n-----DateTime Formatter-----');
  initializeDateFormatting();
  convertToDateTime();
  final dateTime = DateTime(2025, 5, 1, 12, 30, 45, 123, 456);
  printFormatDateTime(dateTime, 'en-US');
  printFormatDateTime(dateTime, 'zh-CN');
  printFormatDateTime(dateTime, 'zh-TW');
  printFormatDateTime(dateTime, 'ja-JP');
  printFormatDateTime(dateTime, 'ko-KR');
}

void printFormatNumber() {
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

  /// 1234567890.000000789 => '￥-1_2345_6789.0₆78元'
  print(formatNumber(
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
  ));

  /// 123456789.000000789 => '+￥1.2345.6789,0₆78元'
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
      signFirst: true,
      prefix: '￥',
      suffix: '元',
    ));
  } finally {
    FlexiFormatter.restoreGlobalConfig();
  }
}

void printExplicitDirection() {
  print('>>>>Isolates>>>>');
  print('￥+123456.0₆789元'.fsi); // ￥+123456.0₆789元
  print('￥+123456.0₆789元'.lri); // ￥+123456.0₆789元
  print('￥+123456.0₆789元'.rli); // 123456.0₆789元+￥

  print('>>>>Embeddings>>>>');
  print('￥+123456.0₆789元'.lre); // ￥+123456.0₆789元
  print('￥+123456.0₆789元'.rle); // 123456.0₆789元+￥

  print('>>>>Overrides>>>>');
  print('￥+123456.0₆789元'.lro); // ￥+123456.0₆789元
  print('￥+123456.0₆789元'.rlo); // 元987₆0.654321+￥

  print('>>>> rtl directions');
  // 阿拉伯语（RTL） + 英语（LTR）
  print('مرحباHello world 1234!?'.rli);
  print('مرحباHello world 1234!?'.rle);
  print('مرحباHello world 1234!?'.rlo);

  print('>>> rtl url');
  print('مرحبا: ${'http://example.com'}'.rlo);
  print('مرحبا: ${'http://example.com'.fsi}'.rlo);
  print('مرحبا: ${uniLRI}http://example.com'.rle);
  print('مرحبا: ${uniLRE}http://example.com'.rli);
}

void convertToDateTime() {
  /// >>> 2024-05-01 12:30:45.123
  print('2024-05-01T12:30:45.123456'.toDateTime()?.format(yyyyMMDDHHmmssSSS));

  /// >>> 2025-05-01 12:30:45.000
  print(1746073845.dateTimeInSecond.format(yyyyMMDDHHmmssSSS));

  /// >>> 2025-05-01 12:30:45.123
  print(1746073845123.dateTimeInMillisecond.format(yyyyMMDDHHmmssSSS));
  print(1746073845123456.dateTimeInMicrosecond.format(yyyyMMDDHHmmssSSS));
}

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
