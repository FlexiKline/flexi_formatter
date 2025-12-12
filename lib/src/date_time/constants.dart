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

// ignore_for_file: constant_identifier_names

part of 'formatter.dart';

/// 使用-分隔符的日期格式化
const yyyyMMdd = 'yyyy-MM-dd';
const yyyyMM = 'yyyy-MM';
const MMdd = 'MM-dd';
const MMddHHmm = 'MM-dd HH:mm';
const MMddHHmmss = 'MM-dd HH:mm:ss';
const yyyyMMDDHHmm = 'yyyy-MM-dd HH:mm';
const yyyyMMDDHHmmss = 'yyyy-MM-dd HH:mm:ss';
const yyyyMMDDHHmmssSSS = 'yyyy-MM-dd HH:mm:ss.SSS';

const HHmm = 'HH:mm';
const HHmmss = 'HH:mm:ss';
const HHmmssSSS = 'HH:mm:ss.SSS';
const mmssSSS = 'mm:ss.SSS';

enum TimeUnit {
  /// 年
  year(Duration.microsecondsPerDay * 365),

  /// 月
  month(Duration.microsecondsPerDay * 30),

  /// 周
  week(Duration.microsecondsPerDay * 7),

  /// 天
  day(Duration.microsecondsPerDay),

  /// 小时
  hour(Duration.microsecondsPerHour),

  /// 分钟
  minute(Duration.microsecondsPerMinute),

  /// 秒
  second(Duration.microsecondsPerSecond),

  /// 毫秒
  millisecond(Duration.microsecondsPerMillisecond),

  /// 微秒
  microsecond(1);

  final int microseconds;
  const TimeUnit(this.microseconds);
}

/// An enumeration representing the start day of the week.
enum StartOfWeek {
  /// Represents Saturday as the start of the week.
  saturday,

  /// Represents Sunday as the start of the week.
  sunday,

  /// Represents Monday as the start of the week.
  monday,
}
