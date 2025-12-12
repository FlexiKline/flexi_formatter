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

part of 'formatter.dart';

extension FlexiDateTimeExtension on DateTime {
  /// Checks if the DateTime is in the future.
  bool get isFuture => isAfter(DateTime.now());

  /// Checks if the DateTime is in the past.
  bool get isPast => isBefore(DateTime.now());

  /// Checks if the DateTime is today.
  bool get isToday {
    final now = DateTime.now();
    return isSame(now, unit: TimeUnit.day);
  }

  /// Checks if the DateTime is yesterday.
  bool get isYesterday {
    final now = DateTime.now();
    final yesterday = now.subDays(1);
    return isSame(yesterday, unit: TimeUnit.day);
  }

  /// Checks if the DateTime is tomorrow.
  bool get isTomorrow {
    final now = DateTime.now();
    final tomorrow = now.addDays(1);
    return isSame(tomorrow, unit: TimeUnit.day);
  }

  /// Checks if the DateTime is set as local time.
  bool get isLocal => !isUtc;

  /// Checks if the DateTime is a weekday.
  bool get isWeekend => weekday == DateTime.saturday || weekday == DateTime.sunday;

  /// Checks if the year is a leap year.
  bool get isLeapYear {
    return (year % 4 == 0) && ((year % 100 != 0) || (year % 400 == 0));
  }

  /// Gets the day of the week, adjusted for the start of the week.
  int get dayOfWeek {
    final startOfWeek = DateTimeUtils.getStartOfWeek();
    const weekDays = [1, 2, 3, 4, 5, 6, 7, 1, 2];
    var weekDayIndex = weekday - 1;

    switch (startOfWeek) {
      case StartOfWeek.monday:
        break;
      case StartOfWeek.sunday:
        weekDayIndex += 1;
      case StartOfWeek.saturday:
        weekDayIndex += 2;
    }

    return weekDays[weekDayIndex];
  }

  /// Gets the day of the year.
  int get dayOfYear {
    const dayCount = <int>[
      0,
      0,
      31,
      59,
      90,
      120,
      151,
      181,
      212,
      243,
      273,
      304,
      334,
    ];

    final dayOfTheYear = dayCount[month] + day;

    if (isLeapYear && month > 2) {
      return dayOfTheYear + 1;
    }

    return dayOfTheYear;
  }

  /// Gets the number of days in the month.
  int get daysInMonth {
    return DateTime(year, month + 1, 0).day;
  }

  /// Gets the week number of the year
  int get weekOfYear {
    return ((dayOfYear - dayOfWeek + 10) / 7).floor();
  }

  /// Gets the quarter of the year.
  int get quarterOfYear {
    return ((month - 1) / 3).floor() + 1;
  }

  /// Returns the start of the day.
  DateTime get startOfDay => startOf(TimeUnit.day);

  /// Returns the start of the week.
  DateTime get startOfWeek => startOf(TimeUnit.week);

  /// Returns the start of the month.
  DateTime get startOfMonth => startOf(TimeUnit.month);

  /// Returns the start of the year.
  DateTime get startOfYear => startOf(TimeUnit.year);

  /// Returns the start of the quarter.
  DateTime get startOfQuarter {
    final quarter = quarterOfYear;
    return copyWith(month: (quarter - 1) * 3 + 1).startOfMonth;
  }

  /// Returns the end of the day.
  DateTime get endOfDay => endOf(TimeUnit.day);

  /// Returns the end of the week.
  DateTime get endOfWeek => endOf(TimeUnit.week);

  /// Returns the end of the month.
  DateTime get endOfMonth => endOf(TimeUnit.month);

  /// Returns the end of the year.
  DateTime get endOfYear => endOf(TimeUnit.year);

  /// Returns the end of the quarter.
  DateTime get endOfQuarter {
    final quarter = quarterOfYear;
    return copyWith(month: quarter * 3).endOfMonth;
  }

  /// Get the index of the closest day in the [dates] list.
  int indexOfClosestDay(Iterable<DateTime> dates) {
    if (dates.isEmpty) return -1;

    var closest = dates.first;
    var minDifference = closest.difference(this).inMilliseconds.abs();

    for (final date in dates.skip(1)) {
      final diff = date.difference(this).inMilliseconds.abs();
      if (diff < minDifference) {
        closest = date;
        minDifference = diff;
      }
    }

    // Return the index of the closest date
    return dates.toList().indexOf(closest);
  }

  /// Get the closest day to the current one.
  /// Returns `null` if the list is empty.
  DateTime? closestDayTo(Iterable<DateTime> dates) {
    final index = indexOfClosestDay(dates);
    return index == -1 ? null : dates.elementAt(index);
  }

  /// Returns a copy of the DateTime.
  DateTime clone() => DateTime.fromMillisecondsSinceEpoch(
        millisecondsSinceEpoch,
        isUtc: isUtc,
      );

  /// Returns the start of the specified unit of time.
  DateTime startOf(TimeUnit unit) {
    DateTime newDateTime;

    switch (unit) {
      case TimeUnit.microsecond:
        newDateTime = copyWith();

      case TimeUnit.millisecond:
        newDateTime = copyWith(
          microsecond: 0,
        );
      case TimeUnit.second:
        newDateTime = copyWith(
          millisecond: 0,
          microsecond: 0,
        );
      case TimeUnit.minute:
        newDateTime = copyWith(
          second: 0,
          millisecond: 0,
          microsecond: 0,
        );
      case TimeUnit.hour:
        newDateTime = copyWith(
          minute: 0,
          second: 0,
          millisecond: 0,
          microsecond: 0,
        );
      case TimeUnit.day:
        newDateTime = copyWith(
          hour: 0,
          minute: 0,
          second: 0,
          millisecond: 0,
          microsecond: 0,
        );
      case TimeUnit.week:
        final newDate = subtract(Duration(days: dayOfWeek - 1));
        newDateTime = copyWith(
          year: newDate.year,
          month: newDate.month,
          day: newDate.day,
          hour: 0,
          minute: 0,
          second: 0,
          millisecond: 0,
          microsecond: 0,
        );
      case TimeUnit.month:
        newDateTime = copyWith(
          day: 1,
          hour: 0,
          minute: 0,
          second: 0,
          millisecond: 0,
          microsecond: 0,
        );
      case TimeUnit.year:
        newDateTime = copyWith(
          month: 1,
          day: 1,
          hour: 0,
          minute: 0,
          second: 0,
          millisecond: 0,
          microsecond: 0,
        );
    }

    return newDateTime;
  }

  /// Returns the end of the specified unit of time.
  DateTime endOf(TimeUnit unit) {
    DateTime newDateTime;

    switch (unit) {
      case TimeUnit.microsecond:
        newDateTime = copyWith();
      case TimeUnit.millisecond:
        newDateTime = copyWith(
          microsecond: 999,
        );
      case TimeUnit.second:
        newDateTime = copyWith(
          millisecond: 999,
          microsecond: 999,
        );
      case TimeUnit.minute:
        newDateTime = copyWith(
          second: 59,
          millisecond: 999,
          microsecond: 999,
        );
      case TimeUnit.hour:
        newDateTime = copyWith(
          minute: 59,
          second: 59,
          millisecond: 999,
          microsecond: 999,
        );
      case TimeUnit.day:
        newDateTime = copyWith(
          hour: 23,
          minute: 59,
          second: 59,
          millisecond: 999,
          microsecond: 999,
        );
      case TimeUnit.week:
        final newDate = add(Duration(days: DateTime.daysPerWeek - dayOfWeek));
        newDateTime = copyWith(
          year: newDate.year,
          month: newDate.month,
          day: newDate.day,
          hour: 23,
          minute: 59,
          second: 59,
          millisecond: 999,
          microsecond: 999,
        );
      case TimeUnit.month:
        newDateTime = copyWith(
          day: daysInMonth,
          hour: 23,
          minute: 59,
          second: 59,
          millisecond: 999,
          microsecond: 999,
        );
      case TimeUnit.year:
        newDateTime = copyWith(
          month: 12,
          day: 31,
          hour: 23,
          minute: 59,
          second: 59,
          millisecond: 999,
          microsecond: 999,
        );
    }

    return newDateTime;
  }

  /// Subtracts the specified duration from the DateTime.
  DateTime subtractDate({
    int microseconds = 0,
    int milliseconds = 0,
    int seconds = 0,
    int minutes = 0,
    int hours = 0,
    int days = 0,
    int weeks = 0,
    int months = 0,
    int years = 0,
  }) {
    var newDateTime = subtract(
      Duration(
        days: days + (weeks * 7),
        hours: hours,
        minutes: minutes,
        seconds: seconds,
        milliseconds: milliseconds,
        microseconds: microseconds,
      ),
    );
    newDateTime = DateTimeUtils.addMonths(newDateTime, -months);
    newDateTime = DateTimeUtils.addMonths(newDateTime, -years * 12);
    return newDateTime;
  }

  /// Adds an amount of years to this [DateTime]
  DateTime subYears(int amount) => subtractDate(years: amount);

  /// Subtracts an amount of months from this [DateTime]
  DateTime subMonths(int amount) => subtractDate(months: amount);

  /// Subtracts an amount of weeks from this [DateTime]
  DateTime subWeeks(int amount) => subtractDate(weeks: amount);

  /// Subtracts an amount of days from this [DateTime]
  DateTime subDays(int amount) => subtractDate(days: amount);

  /// Subtracts an amount of hours from this [DateTime]
  DateTime subHours(int amount) => subtract(Duration(hours: amount));

  /// Subtracts an amount of minutes from this [DateTime]
  DateTime subMinutes(int amount) => subtract(Duration(minutes: amount));

  /// Subtracts an amount of seconds from this [DateTime]
  DateTime subSeconds(int amount) => subtract(Duration(seconds: amount));

  /// Subtracts an amount of milliseconds from this [DateTime]
  DateTime subMilliseconds(int amount) => subtract(Duration(milliseconds: amount));

  /// Subtracts an amount of microseconds from this [DateTime]
  DateTime subMicroseconds(int amount) => subtract(Duration(microseconds: amount));

  /// Adds the specified duration to the DateTime.
  DateTime addDate({
    int microseconds = 0,
    int milliseconds = 0,
    int seconds = 0,
    int minutes = 0,
    int hours = 0,
    int days = 0,
    int weeks = 0,
    int months = 0,
    int years = 0,
  }) {
    var newDateTime = add(
      Duration(
        days: days + (weeks * 7),
        hours: hours,
        minutes: minutes,
        seconds: seconds,
        milliseconds: milliseconds,
        microseconds: microseconds,
      ),
    );
    newDateTime = DateTimeUtils.addMonths(newDateTime, months);
    newDateTime = DateTimeUtils.addMonths(newDateTime, years * 12);
    return newDateTime;
  }

  /// Adds an amount of years to this [DateTime]
  DateTime addYears(int amount) => addDate(years: amount);

  /// Adds an amount of months to this [DateTime]
  DateTime addMonths(int amount) => addDate(months: amount);

  /// Adds an amount of weeks to this [DateTime]
  DateTime addWeeks(int amount) => addDate(weeks: amount);

  /// Adds an amount of days to this [DateTime]
  DateTime addDays(int amount) => addDate(days: amount);

  /// Adds an amount of hours to this [DateTime]
  DateTime addHours(int amount) => add(Duration(hours: amount));

  /// Adds an amount of minutes to this [DateTime]
  DateTime addMinutes(int amount) => add(Duration(minutes: amount));

  /// Adds an amount of seconds to this [DateTime]
  DateTime addSeconds(int amount) => add(Duration(seconds: amount));

  /// Adds an amount of milliseconds to this [DateTime]
  DateTime addMilliseconds(int amount) => add(Duration(milliseconds: amount));

  /// Adds an amount of microseconds to this [DateTime]
  DateTime addMicroseconds(int amount) => add(Duration(microseconds: amount));

  /// Returns the difference between two DateTime objects in the specified
  /// unit of time.
  num diff(
    DateTime other, {
    TimeUnit unit = TimeUnit.microsecond,
    bool asFloat = false,
  }) {
    final firstMicroseconds = microsecondsSinceEpoch;
    final secondMicroseconds = other.microsecondsSinceEpoch;
    final diffMicroseconds = firstMicroseconds - secondMicroseconds;

    num diff;

    switch (unit) {
      case TimeUnit.microsecond:
        diff = diffMicroseconds;

      case TimeUnit.millisecond:
        diff = diffMicroseconds / Duration.microsecondsPerMillisecond;

      case TimeUnit.second:
        diff = diffMicroseconds / Duration.microsecondsPerSecond;

      case TimeUnit.minute:
        diff = diffMicroseconds / Duration.microsecondsPerMinute;

      case TimeUnit.hour:
        diff = diffMicroseconds / Duration.microsecondsPerHour;

      case TimeUnit.day:
        diff = diffMicroseconds / Duration.microsecondsPerDay;

      case TimeUnit.week:
        diff = (diffMicroseconds / Duration.microsecondsPerDay) / 7;

      case TimeUnit.month:
        diff = DateTimeUtils.monthDiff(this, other);

      case TimeUnit.year:
        diff = DateTimeUtils.monthDiff(this, other) / 12;
    }

    return asFloat
        ? diff
        : diff < 0
            ? diff.ceil()
            : diff.floor();
  }

  /// Returns the difference between two DateTime objects in years.
  num diffInYears(DateTime other, {bool asFloat = false}) {
    return diff(other, unit: TimeUnit.year, asFloat: asFloat);
  }

  /// Returns the difference between two DateTime objects in months.
  num diffInMonths(DateTime other, {bool asFloat = false}) {
    return diff(other, unit: TimeUnit.month, asFloat: asFloat);
  }

  /// Returns the difference between two DateTime objects in weeks.
  num diffInWeeks(DateTime other, {bool asFloat = false}) {
    return diff(other, unit: TimeUnit.week, asFloat: asFloat);
  }

  /// Returns the difference between two DateTime objects in days.
  num diffInDays(DateTime other, {bool asFloat = false}) {
    return diff(other, unit: TimeUnit.day, asFloat: asFloat);
  }

  /// Returns the difference between two DateTime objects in hours.
  num diffInHours(DateTime other, {bool asFloat = false}) {
    return diff(other, unit: TimeUnit.hour, asFloat: asFloat);
  }

  /// Returns the difference between two DateTime objects in minutes.
  num diffInMinutes(DateTime other, {bool asFloat = false}) {
    return diff(other, unit: TimeUnit.minute, asFloat: asFloat);
  }

  ///
  num diffInSeconds(DateTime other, {bool asFloat = false}) {
    return diff(other, unit: TimeUnit.second, asFloat: asFloat);
  }

  /// Returns the difference between two DateTime objects in milliseconds.
  num diffInMilliseconds(DateTime other, {bool asFloat = false}) {
    return diff(other, unit: TimeUnit.millisecond, asFloat: asFloat);
  }

  /// Checks if the DateTime is before the specified DateTime in the given
  /// unit of time.
  bool isBeforeDate(DateTime other, {TimeUnit unit = TimeUnit.microsecond}) {
    final firstMicroseconds = microsecondsSinceEpoch;
    final secondMicroseconds = other.microsecondsSinceEpoch;

    if (unit == TimeUnit.microsecond) {
      return firstMicroseconds < secondMicroseconds;
    }

    final endOfFirstMicroseconds = endOf(unit).microsecondsSinceEpoch;

    return endOfFirstMicroseconds < secondMicroseconds;
  }

  /// Checks if the DateTime is after the specified DateTime in the given
  /// unit of time.
  bool isAfterDate(DateTime other, {TimeUnit unit = TimeUnit.microsecond}) {
    final firstMicroseconds = microsecondsSinceEpoch;
    final secondMicroseconds = other.microsecondsSinceEpoch;

    if (unit == TimeUnit.microsecond) {
      return firstMicroseconds > secondMicroseconds;
    }

    final startOfFirstMicroseconds = startOf(unit).microsecondsSinceEpoch;

    return secondMicroseconds < startOfFirstMicroseconds;
  }

  /// Checks if the DateTime is the same as the specified DateTime in the given
  /// unit of time.
  bool isSame(DateTime other, {TimeUnit unit = TimeUnit.microsecond}) {
    final firstMicroseconds = microsecondsSinceEpoch;
    final secondMicroseconds = other.microsecondsSinceEpoch;

    if (unit == TimeUnit.microsecond) {
      return firstMicroseconds == secondMicroseconds;
    }

    final startOfFirstMicroseconds = startOf(unit).microsecondsSinceEpoch;
    final endOfFirstMicroseconds = endOf(unit).microsecondsSinceEpoch;

    return startOfFirstMicroseconds <= secondMicroseconds && secondMicroseconds <= endOfFirstMicroseconds;
  }

  /// Checks if the DateTime is in the same year as the specified DateTime.
  bool isSameYear(DateTime other) {
    return isSame(other, unit: TimeUnit.year);
  }

  /// Checks if the DateTime is in the same month as the specified DateTime.
  bool isSameMonth(DateTime other) {
    return isSame(other, unit: TimeUnit.month);
  }

  /// Checks if the DateTime is in the same week as the specified DateTime.
  bool isSameWeek(DateTime other) {
    return isSame(other, unit: TimeUnit.week);
  }

  /// Checks if the DateTime is in the same day as the specified DateTime.
  bool isSameDay(DateTime other) {
    return isSame(other, unit: TimeUnit.day);
  }

  /// Checks if the DateTime is in the same hour as the specified DateTime.
  bool isSameHour(DateTime other) {
    return isSame(other, unit: TimeUnit.hour);
  }

  /// Checks if the DateTime is in the same minute as the specified DateTime.
  bool isSameMinute(DateTime other) {
    return isSame(other, unit: TimeUnit.minute);
  }

  /// Checks if the DateTime is in the same second as the specified DateTime.
  bool isSameSecond(DateTime other) {
    return isSame(other, unit: TimeUnit.second);
  }

  /// Checks if the DateTime is the same or before the specified DateTime
  /// in the given unit of time.
  bool isSameOrBefore(DateTime other, {TimeUnit unit = TimeUnit.microsecond}) {
    return isSame(other, unit: unit) || isBeforeDate(other, unit: unit);
  }

  /// Checks if the DateTime is the same or after the specified DateTime
  /// in the given unit of time.
  bool isSameOrAfter(DateTime other, {TimeUnit unit = TimeUnit.microsecond}) {
    return isSame(other, unit: unit) || isAfterDate(other, unit: unit);
  }

  /// Checks if the DateTime is between the specified start and end DateTime
  /// in the given unit of time.
  bool isBetween(
    DateTime startDateTime,
    DateTime endDateTime, {
    TimeUnit unit = TimeUnit.microsecond,
  }) {
    return isAfterDate(startDateTime, unit: unit) && isBeforeDate(endDateTime, unit: unit);
  }
}
