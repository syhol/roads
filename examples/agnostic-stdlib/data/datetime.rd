// Needs reworking

type Time{hour: Integer, minute: Integer, second: Interger, nanoseconds: Interger}
type Date{year: Integer, month: Integer, day: Interger}
type DateTime{secondsSinceEpoch: Integer, nanoseconds: Integer, timezone: Timezone}

type Timezone = String
type Duration =
  CompoundDuration{Duration, Duration}
  Nanoseconds{Integer}
  Milliseconds{Integer}
  Microseconds{Integer}
  Seconds{Integer}
  Minutes{Integer}
  Hours{Integer}
  Days{Integer}
  Weeks{Integer}
  Months{Integer}
  Years{Integer}

toIso8601(DateTime) => String

getNanosecond(DateTime) => Integer
getMicrosecond(DateTime) => Integer
getMillisecond(DateTime) => Integer
getSecond(DateTime) => Integer
getMinute(DateTime) => Integer
getHour(DateTime) => Integer
getDay(DateTime) => Integer
getMonth(DateTime) => Integer
getYear(DateTime) => Integer

getWeekday(DateTime) => Integer
timeZoneName(DateTime) => String
timeZoneOffset(DateTime) => String

isUtc(DateTime) => Integer

inNanoseconds(DateTime) => Integer
inMicroseconds(DateTime) => Integer
inMilliseconds(DateTime) => Integer
inSeconds(DateTime) => Integer
inMinutes(DateTime) => Integer
inHours(DateTime) => Integer
inDays(DateTime) => Integer
inMonths(DateTime) => Integer
inYears(DateTime) => Integer

add(DateTime, Duration) => DateTime
subtract(DateTime, Duration) => DateTime
difference(DateTime, DateTime) => Duration
compare(DateTime, DateTime) => Integer

isAfter(DateTime) => Boolean
isAtSameMomentAs(DateTime) => Boolean
isBefore(DateTime) => Boolean

toLocal(DateTime) => DateTime
toUtc(DateTime) => DateTime
