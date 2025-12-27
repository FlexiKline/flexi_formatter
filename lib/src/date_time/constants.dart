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

/// Date format with '-' separator: yyyy-MM-dd
/// 使用-分隔符的日期格式化: yyyy-MM-dd
const yyyyMMdd = 'yyyy-MM-dd';

/// Date format with '-' separator: yyyy-MM
/// 使用-分隔符的日期格式化: yyyy-MM
const yyyyMM = 'yyyy-MM';

/// Date format with '-' separator: MM-dd
/// 使用-分隔符的日期格式化: MM-dd
const MMdd = 'MM-dd';

/// Date and time format with '-' separator: MM-dd HH:mm
/// 使用-分隔符的日期时间格式化: MM-dd HH:mm
const MMddHHmm = 'MM-dd HH:mm';

/// Date and time format with '-' separator: MM-dd HH:mm:ss
/// 使用-分隔符的日期时间格式化: MM-dd HH:mm:ss
const MMddHHmmss = 'MM-dd HH:mm:ss';

/// Date and time format with '-' separator: yyyy-MM-dd HH:mm
/// 使用-分隔符的日期时间格式化: yyyy-MM-dd HH:mm
const yyyyMMDDHHmm = 'yyyy-MM-dd HH:mm';

/// Date and time format with '-' separator: yyyy-MM-dd HH:mm:ss
/// 使用-分隔符的日期时间格式化: yyyy-MM-dd HH:mm:ss
const yyyyMMDDHHmmss = 'yyyy-MM-dd HH:mm:ss';

/// Date and time format with '-' separator: yyyy-MM-dd HH:mm:ss.SSS
/// 使用-分隔符的日期时间格式化: yyyy-MM-dd HH:mm:ss.SSS
const yyyyMMDDHHmmssSSS = 'yyyy-MM-dd HH:mm:ss.SSS';

/// Time format: HH:mm
/// 时间格式: HH:mm
const HHmm = 'HH:mm';

/// Time format: HH:mm:ss
/// 时间格式: HH:mm:ss
const HHmmss = 'HH:mm:ss';

/// Time format: HH:mm:ss.SSS
/// 时间格式: HH:mm:ss.SSS
const HHmmssSSS = 'HH:mm:ss.SSS';

/// Time format: mm:ss.SSS
/// 时间格式: mm:ss.SSS
const mmssSSS = 'mm:ss.SSS';

/// Time unit enumeration
/// 时间单位枚举
enum TimeUnit {
  year(Duration.microsecondsPerDay * 365),
  month(Duration.microsecondsPerDay * 30),
  week(Duration.microsecondsPerDay * 7),
  day(Duration.microsecondsPerDay),
  hour(Duration.microsecondsPerHour),
  minute(Duration.microsecondsPerMinute),
  second(Duration.microsecondsPerSecond),
  millisecond(Duration.microsecondsPerMillisecond),
  microsecond(1);

  final int microseconds;
  const TimeUnit(this.microseconds);
}

/// An enumeration representing the start day of the week
/// 表示一周开始日的枚举
enum StartOfWeek {
  /// Represents Saturday as the start of the week
  /// 表示周六为一周的开始
  saturday,

  /// Represents Sunday as the start of the week
  /// 表示周日为一周的开始
  sunday,

  /// Represents Monday as the start of the week
  /// 表示周一为一周的开始
  monday,
}
