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
  /// Convert string to DateTime.
  DateTime? toDateTime() => DateTime.tryParse(this);
}

extension FlexiDateTimeFormatterIntExt on int {
  DateTime get dateTimeInMicrosecond => DateTime.fromMicrosecondsSinceEpoch(this);

  DateTime get dateTimeInMillisecond => DateTime.fromMillisecondsSinceEpoch(this);

  DateTime get dateTimeInSecond => DateTime.fromMillisecondsSinceEpoch(this * 1000);

  String get twoDigits {
    return this < 10 ? '0$this' : toString();
  }
}

/// 日期时间扩展
/// 测试日期: DateTime(2025, 5, 1, 12, 30, 45);
extension FlexiDateTimeFormatterExt on DateTime {
  /// 计算当前时间到指定时间的差值作为倒计时展示
  /// if the [other] is not specified, it will use DateTime.now() as the other time.
  String diffAsCountdown([DateTime? other, showSign = false]) {
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

  /// 根据[unit]格式化当前DateTime
  /// [unit] 如果未指定, 返回完整格式
  /// >=1天: 格式化为 yMd: 5/1/2025; 2025年5月1日
  /// >=1分钟: 格式化为 Md_Hm 5/1 12:30; 5月1日 12:30
  /// <1分钟: 格式化为 Hms 12:30:45
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

  String get formatLocale {
    return FlexiFormatter.currentLocale;
  }

  /// 使用 DateFormat.d 的国际化格式格式化日期
  /// >>> 1
  String get d => DateFormat.d(formatLocale).format(this);

  /// 使用 DateFormat.E 的国际化格式格式化日期
  /// >>> Thu, 周四
  String get E => DateFormat.E(formatLocale).format(this);

  /// 使用 DateFormat.EEEE 的国际化格式格式化日期
  /// >>> Thursday, 星期四
  String get EEEE => DateFormat.EEEE(formatLocale).format(this);

  /// 使用 DateFormat.EEEE 的国际化格式格式化日期
  /// >>> T, 四
  String get EEEEE => DateFormat.EEEEE(formatLocale).format(this);

  /// 使用 DateFormat.LLL 的国际化格式格式化日期
  /// >>> May, 5月
  String get LLL => DateFormat.LLL(formatLocale).format(this);

  /// 使用 DateFormat.LLLL 的国际化格式格式化日期
  /// >>> May, 5月
  String get LLLL => DateFormat.LLLL(formatLocale).format(this);

  /// 使用 DateFormat.M 的国际化格式格式化日期
  /// >>> 5月
  String get M => DateFormat.M(formatLocale).format(this);

  /// 使用 DateFormat.Md 的国际化格式格式化日期
  /// >>> 5/1, 5月1日
  String get Md => DateFormat.Md(formatLocale).format(this);

  /// 使用 DateFormat.MEd 的国际化格式格式化日期
  /// >>> Thu, 5/1, 5月1日, 周四
  String get MEd => DateFormat.MEd(formatLocale).format(this);

  /// 使用 DateFormat.MMM 的国际化格式格式化日期
  /// >>> May, 5月
  String get MMM => DateFormat.MMM(formatLocale).format(this);

  /// 使用 DateFormat.MMMd 的国际化格式格式化日期
  /// >>> May 1, 5月1日
  String get MMMd => DateFormat.MMMd(formatLocale).format(this);

  /// 使用 DateFormat.MMMEd 的国际化格式格式化日期
  /// >>> Thu, 5/1, 5月1日, 周四
  String get MMMEd => DateFormat.MMMEd(formatLocale).format(this);

  /// 使用 DateFormat.MMMM 的国际化格式格式化日期
  /// >>> May, 5月
  String get MMMM => DateFormat.MMMM(formatLocale).format(this);

  /// 使用 DateFormat.MMMMd 的国际化格式格式化日期
  /// >>> May 1, 5月1日
  String get MMMMd => DateFormat.MMMMd(formatLocale).format(this);

  // cSpell: ignore MMMMEEEEd
  /// 使用 DateFormat.MMMMEEEEd 的国际化格式格式化日期
  /// >>> Thursday, May 1, 5月1日, 周四
  String get MMMMEEEEd => DateFormat.MMMMEEEEd(formatLocale).format(this);

  /// 使用 DateFormat.QQQ 的国际化格式格式化日期
  /// >>> Q2, 第二季度
  String get QQQ => DateFormat.QQQ(formatLocale).format(this);

  /// 使用 DateFormat.QQQQ 的国际化格式格式化日期
  /// >>> 2nd quarter, 2025年第二季度
  String get QQQQ => DateFormat.QQQQ(formatLocale).format(this);

  /// 使用 DateFormat.y 的国际化格式格式化日期
  /// >>> 2025
  String get y => DateFormat.y(formatLocale).format(this);

  /// 使用 DateFormat.yM 的国际化格式格式化日期
  /// >>> 5/2025, 2025年5月
  String get yM => DateFormat.yM(formatLocale).format(this);

  /// 使用 DateFormat.yMd 的国际化格式格式化日期
  /// >>> 5/1/2025, 2025年5月1日
  String get yMd => DateFormat.yMd(formatLocale).format(this);

  /// 使用 DateFormat.yMEd 的国际化格式格式化日期
  /// >>> Thu, 5/1/2025, 2025年5月1日, 周四
  String get yMEd => DateFormat.yMEd(formatLocale).format(this);

  /// 使用 DateFormat.yMMM 的国际化格式格式化日期
  /// >>> May 2025, 2025年5月
  String get yMMM => DateFormat.yMMM(formatLocale).format(this);

  /// 使用 DateFormat.yMMMd 的国际化格式格式化日期
  /// >>> May 1, 2025, 2025年5月1日
  String get yMMMd => DateFormat.yMMMd(formatLocale).format(this);

  /// 使用 DateFormat.yMMMEd 的国际化格式格式化日期
  /// >>> Thu, May 1, 2025, 2025年5月1日, 周四
  String get yMMMEd => DateFormat.yMMMEd(formatLocale).format(this);

  /// 使用 DateFormat.yMMMM 的国际化格式格式化日期
  /// >>> May 2025, 2025年5月
  String get yMMMM => DateFormat.yMMMM(formatLocale).format(this);

  /// 使用 DateFormat.yMMMMd 的国际化格式格式化日期
  /// >>> May 1, 2025, 2025年5月1日
  /// >>> 2025年5月1日
  String get yMMMMd => DateFormat.yMMMMd(formatLocale).format(this);

  /// 使用 DateFormat.yMMMMEEEEd 的国际化格式格式化日期
  /// >>> Thursday, May 1, 2025, 2025年5月1日, 周四
  String get yMMMMEEEEd => DateFormat.yMMMMEEEEd(formatLocale).format(this);

  /// 使用 DateFormat.yQQQ 的国际化格式格式化日期
  /// >>> Q2 2025, 2025年第二季度
  String get yQQQ => DateFormat.yQQQ(formatLocale).format(this);

  /// 使用 DateFormat.yQQQQ 的国际化格式格式化日期
  /// >>> 2nd quarter 2025, 2025年第二季度
  String get yQQQQ => DateFormat.yQQQQ(formatLocale).format(this);

  /// 使用 DateFormat.H 的国际化格式格式化日期
  /// >>> 12
  String get H => DateFormat.H(formatLocale).format(this);

  /// 使用 DateFormat.Hm 的国际化格式格式化日期
  /// >>> 12:30
  String get Hm => DateFormat.Hm(formatLocale).format(this);

  /// 使用 DateFormat.Hms 的国际化格式格式化日期
  /// >>> 12:30:45
  String get Hms => DateFormat.Hms(formatLocale).format(this);

  /// 使用 DateFormat.j 的国际化格式格式化日期
  /// >>> 12 PM
  String get j => DateFormat.j(formatLocale).format(this);

  /// 使用 DateFormat.jm 的国际化格式格式化日期
  /// >>> 12:30 PM
  String get jm => DateFormat.jm(formatLocale).format(this);

  /// 使用 DateFormat.jms 的国际化格式格式化日期
  /// >>> 12:30:45 PM
  String get jms => DateFormat.jms(formatLocale).format(this);

  /// 使用 DateFormat.m 的国际化格式格式化日期
  /// >>> 30
  String get m => DateFormat.m(formatLocale).format(this);

  /// 使用 DateFormat.ms 的国际化格式格式化日期
  /// >>> 30:45
  String get ms => DateFormat.ms(formatLocale).format(this);

  /// 使用 DateFormat.s 的国际化格式格式化日期
  /// >>> 45
  String get s => DateFormat.s(formatLocale).format(this);

  /// 使用 DateFormat组合(yMMMMd + jms) 的国际化格式格式化日期
  /// >>> Thursday, May 1, 2025 12:30:45 PM
  /// >>> 2025年5月1日星期四 12:30:45 PM
  String get yMMMMEEEEd_jms => DateFormat.yMMMMEEEEd(formatLocale).add_jms().format(this);

  /// 使用 DateFormat组合(yMMMMd + jm) 的国际化格式格式化日期
  /// >>> May 1, 2025 12:30 PM
  /// >>> 2025年5月1日 12:30
  String get yMMMMd_jm => DateFormat.yMMMMd(formatLocale).add_jm().format(this);

  /// 使用 DateFormat组合(yMMMMd + jms) 的国际化格式格式化日期
  /// >>> May 1, 2025 12:30:45 PM
  /// >>> 2025年5月1日 12:30:45
  String get yMMMMd_jms => DateFormat.yMMMMd(formatLocale).add_jms().format(this);

  /// 使用 DateFormat组合(MMMd + jm) 的国际化格式格式化日期
  /// >>> May 1 12:30 PM
  /// >>> 5月1日 12:30
  String get MMMMd_jm => DateFormat.MMMMd(formatLocale).add_jm().format(this);

  /// 使用 DateFormat组合(MMMd + jms) 的国际化格式格式化日期
  /// >>> May 1 12:30:45 PM
  /// >>> 5月1日 12:30:45
  String get MMMMd_jms => DateFormat.MMMMd(formatLocale).add_jms().format(this);

  /// 使用 DateFormat组合(yMEd + jms) 的国际化格式格式化日期
  /// >>> Thu, 5/1/2025 12:30:45 PM
  /// >>> 2025/5/1周四 12:30:45
  String get yMEd_jms => DateFormat.yMEd(formatLocale).add_jms().format(this);

  /// 使用 DateFormat组合(yMd + jm) 的国际化格式格式化日期
  /// >>> 5/1/2025 12:30 PM
  /// >>> 2025/5/1 12:30
  String get yMd_jm => DateFormat.yMd(formatLocale).add_jm().format(this);

  /// 使用 DateFormat组合(yMd + jms) 的国际化格式格式化日期
  /// >>> 5/1/2025 12:30:45 PM
  /// >>> 2025/5/1 12:30:45
  String get yMd_jms => DateFormat.yMd(formatLocale).add_jms().format(this);

  /// 使用 DateFormat组合(Md + jms) 的国际化格式格式化日期
  /// >>> 5/1 12:30 PM
  /// >>> 5/1 12:30
  String get Md_jm => DateFormat.Md(formatLocale).add_jm().format(this);

  /// 使用 DateFormat组合(Md + jms) 的国际化格式格式化日期
  /// >>> 5/1 12:30:45 PM
  /// >>> 5/1 12:30:45
  String get Md_jms => DateFormat.Md(formatLocale).add_jms().format(this);

  /// 使用 DateFormat组合(yMd + Hms) 的国际化格式格式化日期
  /// >>> Thursday, May 1, 2025 12:30:45
  /// >>> 2025年5月1日星期四 12:30:45
  String get yMMMMEEEEd_Hms => DateFormat.yMMMMEEEEd(formatLocale).add_Hms().format(this);

  /// 使用 DateFormat组合(yMd + Hms) 的国际化格式格式化日期
  /// >>> May 1, 2025 12:30
  /// >>> 2025年5月1日 12:30
  String get yMMMMd_Hm => DateFormat.yMMMMd(formatLocale).add_Hm().format(this);

  /// 使用 DateFormat组合(yMd + Hms) 的国际化格式格式化日期
  /// >>> May 1, 2025 12:30:45
  /// >>> 2025年5月1日 12:30:45
  String get yMMMMd_Hms => DateFormat.yMMMMd(formatLocale).add_Hms().format(this);

  /// 使用 DateFormat组合(Md + Hm) 的国际化格式格式化日期
  /// >>> May 1 12:30
  /// >>> 5月1日 12:30
  String get MMMMd_Hm => DateFormat.MMMMd(formatLocale).add_Hm().format(this);

  /// 使用 DateFormat组合(Md + Hms) 的国际化格式格式化日期
  /// >>> May 1 12:30:45
  /// >>> 5月1日 12:30:45
  String get MMMMd_Hms => DateFormat.MMMMd(formatLocale).add_Hms().format(this);

  /// 使用 DateFormat组合(yMd + Hms) 的国际化格式格式化日期
  /// >>> Thu, 5/1/2025 12:30:45
  /// >>> 2025/5/1周四 12:30:45
  String get yMEd_Hms => DateFormat.yMEd(formatLocale).add_Hms().format(this);

  /// 使用 DateFormat组合(yMd + Hms) 的国际化格式格式化日期
  /// >>> 5/1/2025 12:30
  /// >>> 2025/5/1 12:30
  String get yMd_Hm => DateFormat.yMd(formatLocale).add_Hm().format(this);

  /// 使用 DateFormat组合(yMd + Hms) 的国际化格式格式化日期
  /// >>> 5/1/2025 12:30:45
  /// >>> 2025/5/1 12:30:45
  String get yMd_Hms => DateFormat.yMd(formatLocale).add_Hms().format(this);

  /// 使用 DateFormat组合(Md + Hm) 的国际化格式格式化日期
  /// >>> 5/1 12:30
  /// >>> 5月1日 12:30
  String get Md_Hm => DateFormat.Md(formatLocale).add_Hm().format(this);

  /// 使用 DateFormat组合(Md + Hms) 的国际化格式格式化日期
  /// >>> 5/1 12:30:45
  /// >>> 5月1日 12:30:45
  String get Md_Hms => DateFormat.Md(formatLocale).add_Hms().format(this);

  /// 组合DateFormat的通用方法
  /// [pattern] 要使用的模式
  /// [inputPattern] 要组合的模式
  /// [locale] 语言环境，默认由[FlexiFormatter]配置中的[currentLocale]指定.
  /// [separator] 分隔符，默认为空字符串
  /// [useSystemLocale] 是否使用系统语言环境(en_US)，默认为false
  /// 例如: combineFormat('yQQQ', 'MMMd')
  /// >>> Q2 2025 May 1
  /// >>> 2025年第2季度 5月1日
  String combineFormat(
    String pattern,
    String? inputPattern, {
    String? locale,
    String separator = ' ',
    bool useSystemLocale = false,
  }) {
    final dateFormat = DateFormat(
      pattern,
      useSystemLocale ? Intl.systemLocale : locale ?? formatLocale,
    );
    if (inputPattern == null) return dateFormat.format(this);
    return dateFormat.addPattern(inputPattern, separator).format(this);
  }

  /// 使用指定模式的国际化格式格式化日期
  /// [pattern] 要使用的模式
  /// [locale] 语言环境，默认由[FlexiFormatter]配置中的[currentLocale]指定.
  /// [useSystemLocale] 是否使用系统语言环境(en_US)，默认为false
  /// 'yyyy-MM-dd' >>> 2025-05-01, 2025年5月1日
  /// 'yyyy-MM-dd HH:mm:ss' >>> 2025-05-01 12:30:45, 2025年5月1日 12:30:45
  String format(
    String pattern, {
    String? locale,
    bool useSystemLocale = false,
  }) {
    return DateFormat(
      pattern,
      useSystemLocale ? Intl.systemLocale : locale ?? formatLocale,
    ).format(this);
  }
}
