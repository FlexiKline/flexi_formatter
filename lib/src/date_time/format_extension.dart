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

// ignore_for_file: non_constant_identifier_names

part of 'formatter.dart';

extension FlexiDateTimeFormatStringExt on String {
  /// Convert string to DateTime, returns null if parsing fails
  /// 将字符串转换为DateTime, 如果解析失败返回null
  DateTime? toDateTime() => DateTime.tryParse(this);
}

extension FlexiDateTimeFormatterIntExt on int {
  /// Convert int to DateTime from microseconds since epoch
  /// 从微秒时间戳转换为DateTime
  DateTime get dateTimeInMicrosecond => DateTime.fromMicrosecondsSinceEpoch(this);

  /// Convert int to DateTime from milliseconds since epoch
  /// 从毫秒时间戳转换为DateTime
  DateTime get dateTimeInMillisecond => DateTime.fromMillisecondsSinceEpoch(this);

  /// Convert int to DateTime from seconds since epoch
  /// 从秒时间戳转换为DateTime
  DateTime get dateTimeInSecond => DateTime.fromMillisecondsSinceEpoch(this * 1000);

  /// Format int as two digits string, e.g. 5 => "05", 12 => "12"
  /// 将整数格式化为两位数字符串, 例如: 5 => "05", 12 => "12"
  String get twoDigits {
    return this < 10 ? '0$this' : toString();
  }
}

/// DateTime formatting extension
/// DateTime格式化扩展
/// Test date: DateTime(2025, 5, 1, 12, 30, 45)
/// 测试日期: DateTime(2025, 5, 1, 12, 30, 45)
extension FlexiDateTimeFormatterExt on DateTime {
  /// Calculate the difference from current time to specified time as countdown display
  /// 计算当前时间到指定时间的差值作为倒计时展示
  /// If the [other] is not specified, it will use DateTime.now() as the other time
  /// 如果未指定[other], 将使用DateTime.now()作为另一个时间
  String diffAsCountdown([DateTime? other, bool showSign = false]) {
    other ??= DateTime.now();
    final diff = difference(other);
    var microseconds = diff.inMicroseconds;
    var sign = '';
    final negative = microseconds < 0;
    if (negative) {
      microseconds = -microseconds;
      if (showSign) sign = '-';
    }

    if (microseconds >= Duration.microsecondsPerDay) {
      final days = microseconds ~/ Duration.microsecondsPerDay;
      microseconds = microseconds.remainder(Duration.microsecondsPerDay);
      final hours = microseconds ~/ Duration.microsecondsPerHour;
      return '$sign${days}D:${hours.twoDigits}H';
    } else if (microseconds >= Duration.microsecondsPerHour) {
      final hours = microseconds ~/ Duration.microsecondsPerHour;
      microseconds = microseconds.remainder(Duration.microsecondsPerHour);
      final minutes = microseconds ~/ Duration.microsecondsPerMinute;
      microseconds = microseconds.remainder(Duration.microsecondsPerMinute);
      final seconds = microseconds ~/ Duration.microsecondsPerSecond;
      return '$sign${hours.twoDigits}:${minutes.twoDigits}:${seconds.twoDigits}';
    } else {
      final minutes = microseconds ~/ Duration.microsecondsPerMinute;
      microseconds = microseconds.remainder(Duration.microsecondsPerMinute);
      final seconds = microseconds ~/ Duration.microsecondsPerSecond;
      return '$sign${minutes.twoDigits}:${seconds.twoDigits}';
    }
  }

  /// Format current DateTime according to [unit]
  /// 根据[unit]格式化当前DateTime
  /// If [unit] is not specified, returns full format
  /// [unit]如果未指定, 返回完整格式
  /// >=1 day: formats as yMd, e.g. 5/1/2025, 2025年5月1日
  /// >=1 day: 格式化为 yMd, 例如: 5/1/2025, 2025年5月1日
  /// >=1 minute: formats as Md_Hm, e.g. 5/1 12:30, 5月1日 12:30
  /// >=1分钟: 格式化为 Md_Hm, 例如: 5/1 12:30, 5月1日 12:30
  /// <1 minute: formats as Hms, e.g. 12:30:45
  /// <1分钟: 格式化为 Hms, 例如: 12:30:45
  String formatByUnit([TimeUnit? unit]) {
    if (unit == null) {
      // 如未指定单位，则将日期时间格式化为默认格式
      return yMd_Hms;
    } else if (unit.microseconds >= TimeUnit.day.microseconds) {
      return yMd;
    } else if (unit.microseconds >= TimeUnit.minute.microseconds) {
      return Md_Hm;
    } else {
      return Hms;
    }
  }

  /// Get current locale for formatting
  /// 获取用于格式化的当前语言环境
  String get formatLocale {
    return FlexiFormatter.currentLocale;
  }

  /// Format date using DateFormat.d internationalized format, e.g. 1
  /// 使用 DateFormat.d 的国际化格式格式化日期, 例如: 1
  String get d => DateFormat.d(formatLocale).format(this);

  /// Format date using DateFormat.E internationalized format, e.g. Thu, 周四
  /// 使用 DateFormat.E 的国际化格式格式化日期, 例如: Thu, 周四
  String get E => DateFormat.E(formatLocale).format(this);

  /// Format date using DateFormat.EEEE internationalized format, e.g. Thursday, 星期四
  /// 使用 DateFormat.EEEE 的国际化格式格式化日期, 例如: Thursday, 星期四
  String get EEEE => DateFormat.EEEE(formatLocale).format(this);

  /// Format date using DateFormat.EEEEE internationalized format, e.g. T, 四
  /// 使用 DateFormat.EEEEE 的国际化格式格式化日期, 例如: T, 四
  String get EEEEE => DateFormat.EEEEE(formatLocale).format(this);

  /// Format date using DateFormat.LLL internationalized format, e.g. May, 5月
  /// 使用 DateFormat.LLL 的国际化格式格式化日期, 例如: May, 5月
  String get LLL => DateFormat.LLL(formatLocale).format(this);

  /// Format date using DateFormat.LLLL internationalized format, e.g. May, 5月
  /// 使用 DateFormat.LLLL 的国际化格式格式化日期, 例如: May, 5月
  String get LLLL => DateFormat.LLLL(formatLocale).format(this);

  /// Format date using DateFormat.M internationalized format, e.g. 5月
  /// 使用 DateFormat.M 的国际化格式格式化日期, 例如: 5月
  String get M => DateFormat.M(formatLocale).format(this);

  /// Format date using DateFormat.Md internationalized format, e.g. 5/1, 5月1日
  /// 使用 DateFormat.Md 的国际化格式格式化日期, 例如: 5/1, 5月1日
  String get Md => DateFormat.Md(formatLocale).format(this);

  /// Format date using DateFormat.MEd internationalized format, e.g. Thu, 5/1, 5月1日, 周四
  /// 使用 DateFormat.MEd 的国际化格式格式化日期, 例如: Thu, 5/1, 5月1日, 周四
  String get MEd => DateFormat.MEd(formatLocale).format(this);

  /// Format date using DateFormat.MMM internationalized format, e.g. May, 5月
  /// 使用 DateFormat.MMM 的国际化格式格式化日期, 例如: May, 5月
  String get MMM => DateFormat.MMM(formatLocale).format(this);

  /// Format date using DateFormat.MMMd internationalized format, e.g. May 1, 5月1日
  /// 使用 DateFormat.MMMd 的国际化格式格式化日期, 例如: May 1, 5月1日
  String get MMMd => DateFormat.MMMd(formatLocale).format(this);

  /// Format date using DateFormat.MMMEd internationalized format, e.g. Thu, 5/1, 5月1日, 周四
  /// 使用 DateFormat.MMMEd 的国际化格式格式化日期, 例如: Thu, 5/1, 5月1日, 周四
  String get MMMEd => DateFormat.MMMEd(formatLocale).format(this);

  /// Format date using DateFormat.MMMM internationalized format, e.g. May, 5月
  /// 使用 DateFormat.MMMM 的国际化格式格式化日期, 例如: May, 5月
  String get MMMM => DateFormat.MMMM(formatLocale).format(this);

  /// Format date using DateFormat.MMMMd internationalized format, e.g. May 1, 5月1日
  /// 使用 DateFormat.MMMMd 的国际化格式格式化日期, 例如: May 1, 5月1日
  String get MMMMd => DateFormat.MMMMd(formatLocale).format(this);

  // cSpell: ignore MMMMEEEEd
  /// Format date using DateFormat.MMMMEEEEd internationalized format, e.g. Thursday, May 1, 5月1日, 周四
  /// 使用 DateFormat.MMMMEEEEd 的国际化格式格式化日期, 例如: Thursday, May 1, 5月1日, 周四
  String get MMMMEEEEd => DateFormat.MMMMEEEEd(formatLocale).format(this);

  /// Format date using DateFormat.QQQ internationalized format, e.g. Q2, 第二季度
  /// 使用 DateFormat.QQQ 的国际化格式格式化日期, 例如: Q2, 第二季度
  String get QQQ => DateFormat.QQQ(formatLocale).format(this);

  /// Format date using DateFormat.QQQQ internationalized format, e.g. 2nd quarter, 2025年第二季度
  /// 使用 DateFormat.QQQQ 的国际化格式格式化日期, 例如: 2nd quarter, 2025年第二季度
  String get QQQQ => DateFormat.QQQQ(formatLocale).format(this);

  /// Format date using DateFormat.y internationalized format, e.g. 2025
  /// 使用 DateFormat.y 的国际化格式格式化日期, 例如: 2025
  String get y => DateFormat.y(formatLocale).format(this);

  /// Format date using DateFormat.yM internationalized format, e.g. 5/2025, 2025年5月
  /// 使用 DateFormat.yM 的国际化格式格式化日期, 例如: 5/2025, 2025年5月
  String get yM => DateFormat.yM(formatLocale).format(this);

  /// Format date using DateFormat.yMd internationalized format, e.g. 5/1/2025, 2025年5月1日
  /// 使用 DateFormat.yMd 的国际化格式格式化日期, 例如: 5/1/2025, 2025年5月1日
  String get yMd => DateFormat.yMd(formatLocale).format(this);

  /// Format date using DateFormat.yMEd internationalized format, e.g. Thu, 5/1/2025, 2025年5月1日, 周四
  /// 使用 DateFormat.yMEd 的国际化格式格式化日期, 例如: Thu, 5/1/2025, 2025年5月1日, 周四
  String get yMEd => DateFormat.yMEd(formatLocale).format(this);

  /// Format date using DateFormat.yMMM internationalized format, e.g. May 2025, 2025年5月
  /// 使用 DateFormat.yMMM 的国际化格式格式化日期, 例如: May 2025, 2025年5月
  String get yMMM => DateFormat.yMMM(formatLocale).format(this);

  /// Format date using DateFormat.yMMMd internationalized format, e.g. May 1, 2025, 2025年5月1日
  /// 使用 DateFormat.yMMMd 的国际化格式格式化日期, 例如: May 1, 2025, 2025年5月1日
  String get yMMMd => DateFormat.yMMMd(formatLocale).format(this);

  /// Format date using DateFormat.yMMMEd internationalized format, e.g. Thu, May 1, 2025, 2025年5月1日, 周四
  /// 使用 DateFormat.yMMMEd 的国际化格式格式化日期, 例如: Thu, May 1, 2025, 2025年5月1日, 周四
  String get yMMMEd => DateFormat.yMMMEd(formatLocale).format(this);

  /// Format date using DateFormat.yMMMM internationalized format, e.g. May 2025, 2025年5月
  /// 使用 DateFormat.yMMMM 的国际化格式格式化日期, 例如: May 2025, 2025年5月
  String get yMMMM => DateFormat.yMMMM(formatLocale).format(this);

  /// Format date using DateFormat.yMMMMd internationalized format, e.g. May 1, 2025, 2025年5月1日
  /// 使用 DateFormat.yMMMMd 的国际化格式格式化日期, 例如: May 1, 2025, 2025年5月1日
  String get yMMMMd => DateFormat.yMMMMd(formatLocale).format(this);

  /// Format date using DateFormat.yMMMMEEEEd internationalized format, e.g. Thursday, May 1, 2025, 2025年5月1日, 周四
  /// 使用 DateFormat.yMMMMEEEEd 的国际化格式格式化日期, 例如: Thursday, May 1, 2025, 2025年5月1日, 周四
  String get yMMMMEEEEd => DateFormat.yMMMMEEEEd(formatLocale).format(this);

  /// Format date using DateFormat.yQQQ internationalized format, e.g. Q2 2025, 2025年第二季度
  /// 使用 DateFormat.yQQQ 的国际化格式格式化日期, 例如: Q2 2025, 2025年第二季度
  String get yQQQ => DateFormat.yQQQ(formatLocale).format(this);

  /// Format date using DateFormat.yQQQQ internationalized format, e.g. 2nd quarter 2025, 2025年第二季度
  /// 使用 DateFormat.yQQQQ 的国际化格式格式化日期, 例如: 2nd quarter 2025, 2025年第二季度
  String get yQQQQ => DateFormat.yQQQQ(formatLocale).format(this);

  /// Format date using DateFormat.H internationalized format, e.g. 12
  /// 使用 DateFormat.H 的国际化格式格式化日期, 例如: 12
  String get H => DateFormat.H(formatLocale).format(this);

  /// Format date using DateFormat.Hm internationalized format, e.g. 12:30
  /// 使用 DateFormat.Hm 的国际化格式格式化日期, 例如: 12:30
  String get Hm => DateFormat.Hm(formatLocale).format(this);

  /// Format date using DateFormat.Hms internationalized format, e.g. 12:30:45
  /// 使用 DateFormat.Hms 的国际化格式格式化日期, 例如: 12:30:45
  String get Hms => DateFormat.Hms(formatLocale).format(this);

  /// Format date using DateFormat.j internationalized format, e.g. 12 PM
  /// 使用 DateFormat.j 的国际化格式格式化日期, 例如: 12 PM
  String get j => DateFormat.j(formatLocale).format(this);

  /// Format date using DateFormat.jm internationalized format, e.g. 12:30 PM
  /// 使用 DateFormat.jm 的国际化格式格式化日期, 例如: 12:30 PM
  String get jm => DateFormat.jm(formatLocale).format(this);

  /// Format date using DateFormat.jms internationalized format, e.g. 12:30:45 PM
  /// 使用 DateFormat.jms 的国际化格式格式化日期, 例如: 12:30:45 PM
  String get jms => DateFormat.jms(formatLocale).format(this);

  /// Format date using DateFormat.m internationalized format, e.g. 30
  /// 使用 DateFormat.m 的国际化格式格式化日期, 例如: 30
  String get m => DateFormat.m(formatLocale).format(this);

  /// Format date using DateFormat.ms internationalized format, e.g. 30:45
  /// 使用 DateFormat.ms 的国际化格式格式化日期, 例如: 30:45
  String get ms => DateFormat.ms(formatLocale).format(this);

  /// Format date using DateFormat.s internationalized format, e.g. 45
  /// 使用 DateFormat.s 的国际化格式格式化日期, 例如: 45
  String get s => DateFormat.s(formatLocale).format(this);

  /// Format date using DateFormat combination (yMMMMEEEEd + jms) internationalized format, e.g. Thursday, May 1, 2025 12:30:45 PM, 2025年5月1日星期四 12:30:45 PM
  /// 使用 DateFormat组合(yMMMMEEEEd + jms) 的国际化格式格式化日期, 例如: Thursday, May 1, 2025 12:30:45 PM, 2025年5月1日星期四 12:30:45 PM
  String get yMMMMEEEEd_jms => DateFormat.yMMMMEEEEd(formatLocale).add_jms().format(this);

  /// Format date using DateFormat combination (yMMMMd + jm) internationalized format, e.g. May 1, 2025 12:30 PM, 2025年5月1日 12:30 PM
  /// 使用 DateFormat组合(yMMMMd + jm) 的国际化格式格式化日期, 例如: May 1, 2025 12:30 PM, 2025年5月1日 12:30 PM
  String get yMMMMd_jm => DateFormat.yMMMMd(formatLocale).add_jm().format(this);

  /// Format date using DateFormat combination (yMMMMd + jms) internationalized format, e.g. May 1, 2025 12:30:45 PM, 2025年5月1日 12:30:45 PM
  /// 使用 DateFormat组合(yMMMMd + jms) 的国际化格式格式化日期, 例如: May 1, 2025 12:30:45 PM, 2025年5月1日 12:30:45 PM
  String get yMMMMd_jms => DateFormat.yMMMMd(formatLocale).add_jms().format(this);

  /// Format date using DateFormat combination (MMMMd + jm) internationalized format, e.g. May 1 12:30 PM, 5月1日 12:30 PM
  /// 使用 DateFormat组合(MMMMd + jm) 的国际化格式格式化日期, 例如: May 1 12:30 PM, 5月1日 12:30 PM
  String get MMMMd_jm => DateFormat.MMMMd(formatLocale).add_jm().format(this);

  /// Format date using DateFormat combination (MMMMd + jms) internationalized format, e.g. May 1 12:30:45 PM, 5月1日 12:30:45 PM
  /// 使用 DateFormat组合(MMMMd + jms) 的国际化格式格式化日期, 例如: May 1 12:30:45 PM, 5月1日 12:30:45 PM
  String get MMMMd_jms => DateFormat.MMMMd(formatLocale).add_jms().format(this);

  /// Format date using DateFormat combination (yMEd + jms) internationalized format, e.g. Thu, 5/1/2025 12:30:45 PM, 2025/5/1周四 12:30:45 PM
  /// 使用 DateFormat组合(yMEd + jms) 的国际化格式格式化日期, 例如: Thu, 5/1/2025 12:30:45 PM, 2025/5/1周四 12:30:45 PM
  String get yMEd_jms => DateFormat.yMEd(formatLocale).add_jms().format(this);

  /// Format date using DateFormat combination (yMd + jm) internationalized format, e.g. 5/1/2025 12:30 PM, 2025/5/1 12:30 PM
  /// 使用 DateFormat组合(yMd + jm) 的国际化格式格式化日期, 例如: 5/1/2025 12:30 PM, 2025/5/1 12:30 PM
  String get yMd_jm => DateFormat.yMd(formatLocale).add_jm().format(this);

  /// Format date using DateFormat combination (yMd + jms) internationalized format, e.g. 5/1/2025 12:30:45 PM, 2025/5/1 12:30:45 PM
  /// 使用 DateFormat组合(yMd + jms) 的国际化格式格式化日期, 例如: 5/1/2025 12:30:45 PM, 2025/5/1 12:30:45 PM
  String get yMd_jms => DateFormat.yMd(formatLocale).add_jms().format(this);

  /// Format date using DateFormat combination (Md + jm) internationalized format, e.g. 5/1 12:30 PM, 5/1 12:30 PM
  /// 使用 DateFormat组合(Md + jm) 的国际化格式格式化日期, 例如: 5/1 12:30 PM, 5/1 12:30 PM
  String get Md_jm => DateFormat.Md(formatLocale).add_jm().format(this);

  /// Format date using DateFormat combination (Md + jms) internationalized format, e.g. 5/1 12:30:45 PM, 5/1 12:30:45 PM
  /// 使用 DateFormat组合(Md + jms) 的国际化格式格式化日期, 例如: 5/1 12:30:45 PM, 5/1 12:30:45 PM
  String get Md_jms => DateFormat.Md(formatLocale).add_jms().format(this);

  /// Format date using DateFormat combination (yMMMMEEEEd + Hms) internationalized format, e.g. Thursday, May 1, 2025 12:30:45, 2025年5月1日星期四 12:30:45
  /// 使用 DateFormat组合(yMMMMEEEEd + Hms) 的国际化格式格式化日期, 例如: Thursday, May 1, 2025 12:30:45, 2025年5月1日星期四 12:30:45
  String get yMMMMEEEEd_Hms => DateFormat.yMMMMEEEEd(formatLocale).add_Hms().format(this);

  /// Format date using DateFormat combination (yMMMMd + Hm) internationalized format, e.g. May 1, 2025 12:30, 2025年5月1日 12:30
  /// 使用 DateFormat组合(yMMMMd + Hm) 的国际化格式格式化日期, 例如: May 1, 2025 12:30, 2025年5月1日 12:30
  String get yMMMMd_Hm => DateFormat.yMMMMd(formatLocale).add_Hm().format(this);

  /// Format date using DateFormat combination (yMMMMd + Hms) internationalized format, e.g. May 1, 2025 12:30:45, 2025年5月1日 12:30:45
  /// 使用 DateFormat组合(yMMMMd + Hms) 的国际化格式格式化日期, 例如: May 1, 2025 12:30:45, 2025年5月1日 12:30:45
  String get yMMMMd_Hms => DateFormat.yMMMMd(formatLocale).add_Hms().format(this);

  /// Format date using DateFormat combination (MMMMd + Hm) internationalized format, e.g. May 1 12:30, 5月1日 12:30
  /// 使用 DateFormat组合(MMMMd + Hm) 的国际化格式格式化日期, 例如: May 1 12:30, 5月1日 12:30
  String get MMMMd_Hm => DateFormat.MMMMd(formatLocale).add_Hm().format(this);

  /// Format date using DateFormat combination (MMMMd + Hms) internationalized format, e.g. May 1 12:30:45, 5月1日 12:30:45
  /// 使用 DateFormat组合(MMMMd + Hms) 的国际化格式格式化日期, 例如: May 1 12:30:45, 5月1日 12:30:45
  String get MMMMd_Hms => DateFormat.MMMMd(formatLocale).add_Hms().format(this);

  /// Format date using DateFormat combination (yMEd + Hms) internationalized format, e.g. Thu, 5/1/2025 12:30:45, 2025/5/1周四 12:30:45
  /// 使用 DateFormat组合(yMEd + Hms) 的国际化格式格式化日期, 例如: Thu, 5/1/2025 12:30:45, 2025/5/1周四 12:30:45
  String get yMEd_Hms => DateFormat.yMEd(formatLocale).add_Hms().format(this);

  /// Format date using DateFormat combination (yMd + Hm) internationalized format, e.g. 5/1/2025 12:30, 2025/5/1 12:30
  /// 使用 DateFormat组合(yMd + Hm) 的国际化格式格式化日期, 例如: 5/1/2025 12:30, 2025/5/1 12:30
  String get yMd_Hm => DateFormat.yMd(formatLocale).add_Hm().format(this);

  /// Format date using DateFormat combination (yMd + Hms) internationalized format, e.g. 5/1/2025 12:30:45, 2025/5/1 12:30:45
  /// 使用 DateFormat组合(yMd + Hms) 的国际化格式格式化日期, 例如: 5/1/2025 12:30:45, 2025/5/1 12:30:45
  String get yMd_Hms => DateFormat.yMd(formatLocale).add_Hms().format(this);

  /// Format date using DateFormat combination (Md + Hm) internationalized format, e.g. 5/1 12:30, 5月1日 12:30
  /// 使用 DateFormat组合(Md + Hm) 的国际化格式格式化日期, 例如: 5/1 12:30, 5月1日 12:30
  String get Md_Hm => DateFormat.Md(formatLocale).add_Hm().format(this);

  /// Format date using DateFormat combination (Md + Hms) internationalized format, e.g. 5/1 12:30:45, 5月1日 12:30:45
  /// 使用 DateFormat组合(Md + Hms) 的国际化格式格式化日期, 例如: 5/1 12:30:45, 5月1日 12:30:45
  String get Md_Hms => DateFormat.Md(formatLocale).add_Hms().format(this);

  /// Generic method to combine DateFormat patterns
  /// 组合DateFormat的通用方法
  ///
  /// [pattern] The pattern to use / 要使用的模式
  /// [inputPattern] The pattern to combine / 要组合的模式
  /// [locale] Locale, defaults to [FlexiFormatter.currentLocale] / 语言环境，默认由[FlexiFormatter]配置中的[currentLocale]指定
  /// [separator] Separator, defaults to empty string / 分隔符，默认为空字符串
  /// [useSystemLocale] Whether to use system locale to format date, defaults to [FlexiFormatter.useSystemLocale] / 是否使用系统语言环境来格式化日期，默认由[FlexiFormatter]配置中的[useSystemLocale]指定
  ///
  /// Example: combineFormat('yQQQ', 'MMMd')
  /// 例如: combineFormat('yQQQ', 'MMMd')
  /// >>> Q2 2025 May 1
  /// >>> 2025年第2季度 5月1日
  String combineFormat(
    String pattern,
    String? inputPattern, {
    String? locale,
    String separator = ' ',
    bool? useSystemLocale,
  }) {
    useSystemLocale ??= FlexiFormatter.useSystemLocale;
    final dateFormat = DateFormat(
      pattern,
      useSystemLocale ? Intl.systemLocale : locale ?? formatLocale,
    );
    if (inputPattern == null) return dateFormat.format(this);
    return dateFormat.addPattern(inputPattern, separator).format(this);
  }

  /// Format date using specified pattern with internationalized format
  /// 使用指定模式的国际化格式格式化日期
  ///
  /// [pattern] The pattern to use / 要使用的模式
  /// [locale] Locale, defaults to [FlexiFormatter.currentLocale] / 语言环境，默认由[FlexiFormatter]配置中的[currentLocale]指定
  /// [useSystemLocale] Whether to use system locale to format date, defaults to [FlexiFormatter.useSystemLocale] / 是否使用系统语言环境来格式化日期，默认由[FlexiFormatter]配置中的[useSystemLocale]指定
  ///
  /// Examples:
  /// 示例:
  /// 'yyyy-MM-dd' >>> 2025-05-01, 2025年5月1日
  /// 'yyyy-MM-dd HH:mm:ss' >>> 2025-05-01 12:30:45, 2025年5月1日 12:30:45
  String format(
    String pattern, {
    String? locale,
    bool? useSystemLocale,
  }) {
    useSystemLocale ??= FlexiFormatter.useSystemLocale;
    return DateFormat(
      pattern,
      useSystemLocale ? Intl.systemLocale : locale ?? formatLocale,
    ).format(this);
  }
}
