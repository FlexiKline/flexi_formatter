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

import 'dart:math' as math;

import 'package:intl/date_symbol_data_local.dart' as date_intl;
import 'package:intl/intl.dart';

import '../formatter_config.dart';

part 'constants.dart';
part 'extension.dart';
part 'format_extension.dart';

/// A utility class for DateTime operations
/// DateTime操作的实用工具类
class DateTimeUtils {
  DateTimeUtils._();

  /// Adds the specified number of months to the given [dateTime]
  /// 将指定的月数添加到给定的[dateTime]
  ///
  /// The [months] parameter specifies the number of months to add.
  /// If the resulting month has fewer days than the original day,
  /// the day will be adjusted to the last day of the resulting month.
  /// [months]参数指定要添加的月数。如果结果月份的天数少于原始天数，日期将调整为结果月份的最后一天。
  ///
  /// Returns a new [DateTime] object with the added months
  /// 返回添加了月份的新[DateTime]对象
  static DateTime addMonths(DateTime dateTime, int months) {
    final modMonths = months % 12;
    var newYear = dateTime.year + ((months - modMonths) ~/ 12);
    var newMonth = dateTime.month + modMonths;
    if (newMonth > 12) {
      newYear++;
      newMonth -= 12;
    }
    final newDay = math.min(dateTime.day, DateTime(newYear, newMonth).daysInMonth);
    return dateTime.copyWith(
      year: newYear,
      month: newMonth,
      day: newDay,
      hour: dateTime.hour,
      minute: dateTime.minute,
      second: dateTime.second,
      millisecond: dateTime.millisecond,
      microsecond: dateTime.microsecond,
    );
  }

  /// Gets the start day of the week based on the locale
  /// 根据语言环境获取一周的开始日
  ///
  /// Returns a [StartOfWeek] enum value representing the start day of the week.
  /// Throws an [Exception] if the locale is not supported.
  /// 返回表示一周开始日的[StartOfWeek]枚举值。如果语言环境不受支持，则抛出[Exception]。
  static StartOfWeek getStartOfWeek() {
    final locale = FlexiFormatter.currentLocale;
    final supportedLocale = date_intl.dateTimeSymbolMap()[locale];

    if (supportedLocale == null) {
      throw Exception("The specified locale '$locale' is not supported.");
    }

    return switch (supportedLocale.FIRSTDAYOFWEEK) {
      0 => StartOfWeek.monday,
      5 => StartOfWeek.saturday,
      6 => StartOfWeek.sunday,
      _ => throw Exception(
          'Start of week with index ${supportedLocale.FIRSTDAYOFWEEK} not supported',
        ),
    };
  }

  /// Calculates the difference in months between two [DateTime] objects
  /// 计算两个[DateTime]对象之间的月份差
  ///
  /// The [first] and [second] parameters specify the two dates to compare.
  /// [first]和[second]参数指定要比较的两个日期。
  ///
  /// Returns the difference in months as a [num]
  /// 返回以[num]表示的月份差
  static num monthDiff(DateTime first, DateTime second) {
    if (first.day < second.day) {
      return -DateTimeUtils.monthDiff(second, first);
    }

    final monthDifference = ((second.year - first.year) * 12) + (second.month - first.month);

    final thirdDateTime = addMonths(first, monthDifference);
    final thirdMicroseconds = thirdDateTime.microsecondsSinceEpoch;

    final diffMicroseconds = second.microsecondsSinceEpoch - thirdMicroseconds;

    double offset;
    if (diffMicroseconds < 0) {
      final fifthDateTime = addMonths(first, monthDifference - 1);
      offset = diffMicroseconds / (thirdMicroseconds - fifthDateTime.microsecondsSinceEpoch);
    } else {
      final fifthDateTime = addMonths(first, monthDifference + 1);
      offset = diffMicroseconds / (fifthDateTime.microsecondsSinceEpoch - thirdMicroseconds);
    }

    return -(monthDifference + offset);
  }
}
