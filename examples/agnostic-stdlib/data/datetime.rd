type Time{hour: Integer, minute: Integer, second: Interger, microsecond: Interger}
type Date{year: Integer, month: Integer, day: Interger}
type DateTime{microseconds: Integer, timezone: Timezone}

type Timezone = String
type Duration =
  CompoundDuration{Duration, Duration}
  Microseconds{Integer}
  Seconds{Integer}
  Minutes{Integer}
  Hours{Integer}
  Days{Integer}
  Weeks{Integer}
  Months{Integer}
  Years{Integer}

