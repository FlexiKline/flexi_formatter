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

import 'package:flexi_formatter/date_time.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:test/test.dart';

void main() {
  setUp(() {
    Intl.defaultLocale = 'en_US';
    initializeDateFormatting();
  });
  // 测试用的日期 2025-05-01 12:30:45 星期四
  final testDate = DateTime(2025, 5, 1, 12, 30, 45);

  group('DateTime check', () {
    test('isFuture 方法测试', () {
      expect(testDate.isFuture, isFalse);
    });

    test('isPast 方法测试', () {
      expect(testDate.isPast, isTrue);
    });

    test('isToday 方法测试', () {
      expect(testDate.isToday, isFalse);
      expect(DateTime.now().isToday, isTrue);
    });

    test('isYesterday 方法测试', () {
      expect(testDate.isYesterday, isFalse);
      expect(DateTime.now().subtract(Duration(days: 1)).isYesterday, isTrue);
    });

    test('isTomorrow 方法测试', () {
      expect(testDate.isTomorrow, isFalse);
      expect(DateTime.now().add(Duration(days: 1)).isTomorrow, isTrue);
    });

    test('isWeekend 方法测试', () {
      expect(testDate.isWeekend, isFalse);
      expect(testDate.add(Duration(days: 2)).isWeekend, isTrue);
    });

    test('isLeapYear 方法测试', () {
      expect(testDate.isLeapYear, isFalse);
      expect(DateTime(2000, 1, 1).isLeapYear, isTrue);
      expect(DateTime(3000, 1, 1).isLeapYear, isFalse);
    });
  });

  group('Diff 方法测试', () {
    final other = DateTime(2025, 4, 1, 12, 30, 45);
    test('year 方法测试', () {
      final result = testDate.diff(other, unit: TimeUnit.year);
      print('year: $result');
      expect(result, isA<num>());
    });
    test('month 方法测试', () {
      final result = testDate.diff(other, unit: TimeUnit.month);
      print('month: $result');
      expect(result, isA<num>());
    });
    test('week 方法测试', () {
      final result = testDate.diff(other, unit: TimeUnit.week);
      print('week: $result');
      expect(result, isA<num>());
    });
    test('day 方法测试', () {
      final result = testDate.diff(other, unit: TimeUnit.day);
      print('day: $result');
      expect(result, isA<num>());
    });
    test('hour 方法测试', () {
      final result = testDate.diff(other, unit: TimeUnit.hour);
      print('hour: $result');
      expect(result, isA<num>());
    });
    test('minute 方法测试', () {
      final result = testDate.diff(other, unit: TimeUnit.minute);
      print('minute: $result');
      expect(result, isA<num>());
    });
    test('second 方法测试', () {
      final result = testDate.diff(other, unit: TimeUnit.second);
      print('second: $result');
      expect(result, isA<num>());
    });
    test('millisecond 方法测试', () {
      final result = testDate.diff(other, unit: TimeUnit.millisecond);
      print('millisecond: $result');
      expect(result, isA<num>());
    });
    test('microsecond 方法测试', () {
      final result = testDate.diff(other, unit: TimeUnit.microsecond);
      print('microsecond: $result');
      expect(result, isA<num>());
    });
  });

  group('xxxOf/InXXX 方法测试', () {
    test('dayOfWeek 方法测试', () {
      Intl.defaultLocale = 'en_US';
      expect(testDate.dayOfWeek, 5);
      Intl.defaultLocale = 'zh_CN';
      expect(testDate.dayOfWeek, 4);
      Intl.defaultLocale = 'en_US';
    });

    test('dayOfYear 方法测试', () {
      expect(testDate.dayOfYear, 121);
      expect(DateTime(2025, 1, 2).dayOfYear, 2);
      expect(DateTime(2025, 12, 31).dayOfYear, 365);
    });

    test('daysInMonth 方法测试', () {
      expect(testDate.daysInMonth, 31);
      expect(DateTime(2025, 2, 1).daysInMonth, 28);
    });

    test('weekOfYear 方法测试', () {
      expect(testDate.weekOfYear, 18);
      expect(DateTime(2025, 1, 1).weekOfYear, 1);
    });

    test('quarterOfYear 方法测试', () {
      expect(testDate.quarterOfYear, 2);
    });
  });

  group('startXXX, endXXX', () {
    test('startOfDay 方法测试', () {
      expect(testDate.startOfDay, DateTime(2025, 5, 1));
    });

    test('endOfDay 方法测试', () {
      expect(testDate.endOfDay, DateTime(2025, 5, 1, 23, 59, 59, 999, 999));
    });

    test('startOfWeek 方法测试', () {
      Intl.defaultLocale = 'en_US';
      expect(testDate.startOfWeek, DateTime(2025, 4, 27));
      Intl.defaultLocale = 'zh_CN';
      expect(testDate.startOfWeek, DateTime(2025, 4, 28));
      Intl.defaultLocale = 'en_US';
    });

    test('endOfWeek 方法测试', () {
      Intl.defaultLocale = 'en_US';
      expect(testDate.endOfWeek, DateTime(2025, 5, 3, 23, 59, 59, 999, 999));
      Intl.defaultLocale = 'zh_CN';
      expect(testDate.endOfWeek, DateTime(2025, 5, 4, 23, 59, 59, 999, 999));
      Intl.defaultLocale = 'en_US';
    });

    test('startOfMonth 方法测试', () {
      expect(testDate.startOfMonth, DateTime(2025, 5, 1));
    });

    test('endOfMonth 方法测试', () {
      expect(testDate.endOfMonth, DateTime(2025, 5, 31, 23, 59, 59, 999, 999));
    });

    test('startOfYear 方法测试', () {
      expect(testDate.startOfYear, DateTime(2025, 1, 1));
    });

    test('endOfYear 方法测试', () {
      expect(testDate.endOfYear, DateTime(2025, 12, 31, 23, 59, 59, 999, 999));
    });

    test('startOfQuarter 方法测试', () {
      expect(testDate.startOfQuarter, DateTime(2025, 4, 1));
    });

    test('endOfQuarter 方法测试', () {
      expect(testDate.endOfQuarter, DateTime(2025, 6, 30, 23, 59, 59, 999, 999));
    });
  });

  group('extension method', () {
    test('indexOfClosestDay', () {
      final dates = [
        DateTime(2025, 3, 8),
        DateTime(2025, 3, 9),
        DateTime(2025, 3, 10),
      ];
      final date = DateTime(2025, 3, 9, 12);
      expect(date.indexOfClosestDay(dates), 1);
    });

    test('closestDayTo', () {
      final dates = [
        DateTime(2025, 3, 8),
        DateTime(2025, 3, 9),
        DateTime(2025, 3, 10),
      ];
      final date = DateTime(2025, 3, 9, 12);
      expect(date.closestDayTo(dates), DateTime(2025, 3, 9));
    });

    test('clone', () {
      expect(testDate.clone(), testDate);
    });

    test('startOf', () {
      expect(testDate.startOf(TimeUnit.day), DateTime(2025, 5, 1));
    });

    test('endOf', () {
      expect(testDate.endOf(TimeUnit.day), DateTime(2025, 5, 1, 23, 59, 59, 999, 999));
    });
  });

  group('subXXXX 方法测试', () {
    test('subYears 方法测试', () {
      expect(testDate.subYears(1), DateTime(2024, 5, 1, 12, 30, 45));
    });

    test('addYears 方法测试', () {
      expect(testDate.addYears(1), DateTime(2026, 5, 1, 12, 30, 45));
    });

    test('subMonths 方法测试', () {
      expect(testDate.subMonths(1), DateTime(2025, 4, 1, 12, 30, 45));
    });

    test('addMonths 方法测试', () {
      expect(testDate.addMonths(1), DateTime(2025, 6, 1, 12, 30, 45));
    });

    test('subWeeks 方法测试', () {
      expect(testDate.subWeeks(1), DateTime(2025, 4, 24, 12, 30, 45));
    });

    test('addWeeks 方法测试', () {
      expect(testDate.addWeeks(1), DateTime(2025, 5, 8, 12, 30, 45));
    });

    test('subDays 方法测试', () {
      expect(testDate.subDays(1), DateTime(2025, 4, 30, 12, 30, 45));
    });

    test('addDays 方法测试', () {
      expect(testDate.addDays(1), DateTime(2025, 5, 2, 12, 30, 45));
    });

    test('subHours 方法测试', () {
      expect(testDate.subHours(1), DateTime(2025, 5, 1, 11, 30, 45));
    });

    test('addHours 方法测试', () {
      expect(testDate.addHours(1), DateTime(2025, 5, 1, 13, 30, 45));
    });

    test('subMinutes 方法测试', () {
      expect(testDate.subMinutes(1), DateTime(2025, 5, 1, 12, 29, 45));
    });

    test('addMinutes 方法测试', () {
      expect(testDate.addMinutes(1), DateTime(2025, 5, 1, 12, 31, 45));
    });

    test('subSeconds 方法测试', () {
      expect(testDate.subSeconds(1), DateTime(2025, 5, 1, 12, 30, 44));
    });

    test('addSeconds 方法测试', () {
      expect(testDate.addSeconds(1), DateTime(2025, 5, 1, 12, 30, 46));
    });

    test('subMilliseconds 方法测试', () {
      expect(testDate.subMilliseconds(1), DateTime(2025, 5, 1, 12, 30, 44, 999));
    });

    test('addMilliseconds 方法测试', () {
      expect(testDate.addMilliseconds(1), DateTime(2025, 5, 1, 12, 30, 45, 1));
    });

    test('subMicroseconds 方法测试', () {
      expect(testDate.subMicroseconds(1), DateTime(2025, 5, 1, 12, 30, 44, 999, 999));
    });

    test('addMicroseconds 方法测试', () {
      expect(testDate.addMicroseconds(1), DateTime(2025, 5, 1, 12, 30, 45, 0, 1));
    });
  });

  group('differXXXX 方法测试', () {
    test('diffInYears 方法测试', () {
      expect(testDate.diffInYears(DateTime(2024, 5, 1)), 1);
    });

    test('diffInMonths 方法测试', () {
      expect(testDate.diffInMonths(DateTime(2025, 4, 1)), 1);
    });

    test('diffInWeeks 方法测试', () {
      expect(testDate.diffInWeeks(DateTime(2025, 4, 24)), 1);
    });

    test('diffInDays 方法测试', () {
      expect(testDate.diffInDays(DateTime(2025, 4, 30)), 1);
    });

    test('diffInHours 方法测试', () {
      expect(testDate.diffInHours(DateTime(2025, 5, 1, 11)), 1);
    });

    test('diffInMinutes 方法测试', () {
      expect(testDate.diffInMinutes(DateTime(2025, 5, 1, 12, 29)), 1);
    });

    test('diffInSeconds 方法测试', () {
      expect(testDate.diffInSeconds(DateTime(2025, 5, 1, 12, 30, 44)), 1);
    });

    test('diffInMilliseconds 方法测试', () {
      expect(testDate.diffInMilliseconds(DateTime(2025, 5, 1, 12, 30, 44, 999)), 1);
    });
  });

  group('before after between same 方法测试', () {
    test('isBeforeDate 方法测试', () {
      expect(testDate.isBeforeDate(DateTime(2025, 5, 2)), true);
    });

    test('isAfterDate 方法测试', () {
      expect(testDate.isAfterDate(DateTime(2025, 4, 30)), true);
    });

    test('isBetween 方法测试', () {
      expect(testDate.isBetween(DateTime(2025, 4, 29), DateTime(2025, 5, 3)), true);
    });

    test('isSame 方法测试', () {
      expect(testDate.isSame(DateTime(2025, 5, 1, 12, 30), unit: TimeUnit.minute), true);
    });

    test('isSameYear 方法测试', () {
      expect(testDate.isSameYear(DateTime(2025, 5, 1)), true);
    });

    test('isSameMonth 方法测试', () {
      expect(testDate.isSameMonth(DateTime(2025, 5, 1)), true);
    });

    test('isSameWeek 方法测试', () {
      expect(testDate.isSameWeek(DateTime(2025, 5, 1)), true);
    });

    test('isSameDay 方法测试', () {
      expect(testDate.isSameDay(DateTime(2025, 5, 1, 12, 30)), true);
    });

    test('isSameHour 方法测试', () {
      expect(testDate.isSameHour(DateTime(2025, 5, 1, 12)), true);
    });

    test('isSameMinute 方法测试', () {
      expect(testDate.isSameMinute(DateTime(2025, 5, 1, 12, 30)), true);
    });

    test('isSameSecond 方法测试', () {
      expect(testDate.isSameSecond(DateTime(2025, 5, 1, 12, 30, 45)), true);
    });

    test('isSameOrBefore 方法测试', () {
      expect(testDate.isSameOrBefore(DateTime(2025, 5, 2)), true);
    });

    test('isSameOrAfter 方法测试', () {
      expect(testDate.isSameOrAfter(DateTime(2025, 4, 30)), true);
    });
  });
}
