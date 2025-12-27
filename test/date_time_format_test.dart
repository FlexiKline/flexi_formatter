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
    initializeDateFormatting();
  });
  // 测试用的日期
  final testDate = DateTime(2025, 5, 1, 12, 30, 45);

  group('DateTime Convert Tests', () {
    test('dateTimeInMicrosecond 方法测试', () {
      final result = testDate.microsecondsSinceEpoch.dateTimeInMicrosecond;
      print('toDateTimeInMicrosecond: $result');
      expect(result, isA<DateTime>());
    });

    test('dateTimeInMillisecond 方法测试', () {
      final result = testDate.millisecondsSinceEpoch.dateTimeInMillisecond;
      print('toDateTimeInMillisecond: $result');
      expect(result, isA<DateTime>());
    });

    test('dateTimeInSecond 方法测试', () {
      final result = (testDate.millisecondsSinceEpoch / 1000).toInt().dateTimeInSecond;
      print('toDateTimeInSecond: $result');
      expect(result, isA<DateTime>());
    });

    test('toDateTime() 方法测试', () {
      // print('toDecimal: ${testDate.toIso8601String()}');
      var result = '2025-05-01T12:30:45.000'.toDateTime();
      print('toDateTime: $result');
      expect(result, isA<DateTime>());
      result = '2025-05-01 12:30:45.000'.toDateTime();
      print('toDateTime: $result');
      expect(result, isA<DateTime>());
    });

    test('toDateTime() UTC+Iso8601 方法测试', () {
      // print('toDecimal: ${testDate.toUtc().toIso8601String()}');
      var result = '2025-05-01T12:30:45.000Z'.toDateTime();
      print('toDateTime: $result');
      expect(result, isA<DateTime>());
      result = '2025-05-01 12:30:45.000Z'.toDateTime();
      print('toDateTime: $result');
      expect(result, isA<DateTime>());
    });
  });

  group('DateTimeFormatterExt diffAsCountdown Tests', () {
    test('diffAsCountdown month', () {
      final result = testDate.diffAsCountdown(DateTime(2025, 6, 1, 13, 35, 50));
      print('diffToString day: $result');
      expect(result, '31D:01H');
    });
    test('diffAsCountdown day', () {
      final result = testDate.diffAsCountdown(DateTime(2025, 4, 29, 17, 20, 30));
      print('diffToString day: $result');
      expect(result, '1D:19H');
    });

    test('diffAsCountdown hour', () {
      final result = testDate.diffAsCountdown(DateTime(2025, 5, 1, 17, 35, 55, 125), true);
      print('diffToString hour: $result');
      expect(result, '-05:05:10');
    });

    test('diffAsCountdown minute', () {
      final result = testDate.diffAsCountdown(DateTime(2025, 5, 1, 12, 40, 54, 125));
      print('diffToString minute: $result');
      expect(result, '10:09');
    });
  });

  group('DateTimeFormatterExt formatByUnit', () {
    setUp(() {
      FlexiFormatter.setCurrentLocale('zh-CN');
    });

    tearDown(() {
      FlexiFormatter.setCurrentLocale();
    });

    test('formatByUnit day', () {
      final result = testDate.formatByUnit(TimeUnit.day);
      print('formatByUnit day: $result');
      expect(result, '2025/5/1');
    });
    test('formatByUnit hour', () {
      final result = testDate.formatByUnit(TimeUnit.hour);
      print('formatByUnit hour: $result');
      expect(result, '5/1 12:30');
    });
    test('formatByUnit seconds', () {
      final result = testDate.formatByUnit(TimeUnit.second);
      print('formatByUnit minute: $result');
      expect(result, '12:30:45');
    });
  });

  group('DateTimeFormatterExt Format Tests', () {
    test('d 方法测试', () {
      final result = testDate.d;
      print('d: $result');
      expect(result, isNotEmpty);
    });

    test('E 方法测试', () {
      final result = testDate.E;
      print('E: $result');
      expect(result, isNotEmpty);
    });

    test('EEEE 方法测试', () {
      final result = testDate.EEEE;
      print('EEEE: $result');
      expect(result, isNotEmpty);
    });

    test('LLL 方法测试', () {
      final result = testDate.LLL;
      print('LLL: $result');
      expect(result, isNotEmpty);
    });

    test('LLLL 方法测试', () {
      final result = testDate.LLLL;
      print('LLLL: $result');
      expect(result, isNotEmpty);
    });

    test('M 方法测试', () {
      final result = testDate.M;
      print('M: $result');
      expect(result, isNotEmpty);
    });

    test('Md 方法测试', () {
      final result = testDate.Md;
      print('Md: $result');
      expect(result, isNotEmpty);
    });

    test('MEd 方法测试', () {
      final result = testDate.MEd;
      print('MEd: $result');
      expect(result, isNotEmpty);
    });

    test('MMM 方法测试', () {
      final result = testDate.MMM;
      print('MMM: $result');
      expect(result, isNotEmpty);
    });

    test('MMMd 方法测试', () {
      final result = testDate.MMMd;
      print('MMMd: $result');
      expect(result, isNotEmpty);
    });

    test('MMMEd 方法测试', () {
      final result = testDate.MMMEd;
      print('MMMEd: $result');
      expect(result, isNotEmpty);
    });

    test('MMMM 方法测试', () {
      final result = testDate.MMMM;
      print('MMMM: $result');
      expect(result, isNotEmpty);
    });

    test('MMMMd 方法测试', () {
      final result = testDate.MMMMd;
      print('MMMMd: $result');
      expect(result, isNotEmpty);
    });

    test('MMMMEEEEd 方法测试', () {
      final result = testDate.MMMMEEEEd;
      print('MMMMEEEEd: $result');
      expect(result, isNotEmpty);
    });

    test('QQQ 方法测试', () {
      final result = testDate.QQQ;
      print('QQQ: $result');
      expect(result, isNotEmpty);
    });

    test('QQQQ 方法测试', () {
      final result = testDate.QQQQ;
      print('QQQQ: $result');
      expect(result, isNotEmpty);
    });

    test('y 方法测试', () {
      final result = testDate.y;
      print('y: $result');
      expect(result, isNotEmpty);
    });

    test('yM 方法测试', () {
      final result = testDate.yM;
      print('yM: $result');
      expect(result, isNotEmpty);
    });

    test('yMd 方法测试', () {
      final result = testDate.yMd;
      print('yMd: $result');
      expect(result, isNotEmpty);
    });

    test('yMEd 方法测试', () {
      final result = testDate.yMEd;
      print('yMEd: $result');
      expect(result, isNotEmpty);
    });

    test('yMMM 方法测试', () {
      final result = testDate.yMMM;
      print('yMMM: $result');
      expect(result, isNotEmpty);
    });

    test('yMMMd 方法测试', () {
      final result = testDate.yMMMd;
      print('yMMMd: $result');
      expect(result, isNotEmpty);
    });

    test('yMMMEd 方法测试', () {
      final result = testDate.yMMMEd;
      print('yMMMEd: $result');
      expect(result, isNotEmpty);
    });

    test('yMMMM 方法测试', () {
      final result = testDate.yMMMM;
      print('yMMMM: $result');
      expect(result, isNotEmpty);
    });

    test('yMMMMd 方法测试', () {
      final result = testDate.yMMMMd;
      print('yMMMMd: $result');
      expect(result, isNotEmpty);
    });

    test('yMMMMEEEEd 方法测试', () {
      final result = testDate.yMMMMEEEEd;
      print('yMMMMEEEEd: $result');
      expect(result, isNotEmpty);
    });

    test('yQQQ 方法测试', () {
      final result = testDate.yQQQ;
      print('yQQQ: $result');
      expect(result, isNotEmpty);
    });

    test('yQQQQ 方法测试', () {
      final result = testDate.yQQQQ;
      print('yQQQQ: $result');
      expect(result, isNotEmpty);
    });

    test('H 方法测试', () {
      final result = testDate.H;
      print('H: $result');
      expect(result, isNotEmpty);
    });

    test('Hm 方法测试', () {
      final result = testDate.Hm;
      print('Hm: $result');
      expect(result, isNotEmpty);
    });

    test('Hms 方法测试', () {
      final result = testDate.Hms;
      print('Hms: $result');
      expect(result, isNotEmpty);
    });

    test('j 方法测试', () {
      final result = testDate.j;
      print('j: $result');
      expect(result, isNotEmpty);
    });

    test('jm 方法测试', () {
      final result = testDate.jm;
      print('jm: $result');
      expect(result, isNotEmpty);
    });

    test('jms 方法测试', () {
      final result = testDate.jms;
      print('jms: $result');
      expect(result, isNotEmpty);
    });

    test('m 方法测试', () {
      final result = testDate.m;
      print('m: $result');
      expect(result, isNotEmpty);
    });

    test('ms 方法测试', () {
      final result = testDate.ms;
      print('ms: $result');
      expect(result, isNotEmpty);
    });

    test('s 方法测试', () {
      final result = testDate.s;
      print('s: $result');
      expect(result, isNotEmpty);
    });
  });

  group('DateTimeFormatterExt combine Tests', () {
    test('yMMMMEEEEd_jms 方法测试', () {
      final result = testDate.yMMMMEEEEd_jms;
      print('yMMMMEEEEd_jms: $result');
      expect(result, isNotEmpty);
    });

    test('yMMMMd_jms 方法测试', () {
      final result = testDate.yMMMMd_jms;
      print('yMMMMd_jms: $result');
      expect(result, isNotEmpty);
    });

    test('MMMd_jms 方法测试', () {
      final result = testDate.MMMMd_jms;
      print('MMMd_jms: $result');
      expect(result, isNotEmpty);
    });

    test('yMMMMd_jm 方法测试', () {
      final result = testDate.yMMMMd_jm;
      print('yMMMMd_jm: $result');
      expect(result, isNotEmpty);
    });

    test('yMEd_jms 方法测试', () {
      final result = testDate.yMEd_jms;
      print('yMEd_jms: $result');
      expect(result, isNotEmpty);
    });

    test('yMd_jms 方法测试', () {
      final result = testDate.yMd_jms;
      print('yMd_jms: $result');
      expect(result, isNotEmpty);
    });
    test('yMd_jm 方法测试', () {
      final result = testDate.yMd_jm;
      print('yMd_jm: $result');
      expect(result, isNotEmpty);
    });

    test('Md_jms 方法测试', () {
      final result = testDate.Md_jms;
      print('Md_jms: $result');
      expect(result, isNotEmpty);
    });
  });

  group('DateTimeFormatterExt format(pattern?, locale?) Tests', () {
    test('combineFormat 方法测试', () {
      final result = testDate.combineFormat(
        DateFormat.YEAR_ABBR_QUARTER,
        DateFormat.ABBR_MONTH_DAY,
      );
      print('combineFormat: $result');
      expect(result, isNotEmpty);
    });

    test('format 方法测试', () {
      final result = testDate.format(yyyyMMdd);
      print('format: $result');
      expect(result, '2025-05-01');
    });

    test('format 方法测试2', () {
      final result = testDate.format(yyyyMMDDHHmmss);
      print('format: $result');
      expect(result, '2025-05-01 12:30:45');
    });
  });

  group('DateTimeFormat useSystem', () {
    setUp(() {
      FlexiFormatter.setGlobalConfig(useSystemLocale: false);
    });

    tearDown(() {
      FlexiFormatter.restoreGlobalConfig();
    });

    test('useSystem(false) 方法测试', () {
      FlexiFormatter.setCurrentLocale('zh-CN');
      var result = testDate.format(yyyyMMDDHHmmss);
      print('useSystem(false): $result');
      FlexiFormatter.setCurrentLocale('ar-SA');
      result = testDate.format(yyyyMMDDHHmmss);
      print('useSystem(false): $result');
    });

    test('useSystem(true) 方法测试', () {
      FlexiFormatter.setCurrentLocale('zh-CN');
      var result = testDate.format(yyyyMMDDHHmmss, useSystemLocale: true);
      print('useSystem(true): $result');
      FlexiFormatter.setCurrentLocale('ar-SA');
      result = testDate.format(yyyyMMDDHHmmss, useSystemLocale: true);
      print('useSystem(true): $result');
    });
  });
}
