type Level = 
  Trace
  Debug
  Info
  Warn
  Error
  Fatal

trace(String, Unknown): Void
debug(String, Unknown): Void
info(String, Unknown): Void
warn(String, Unknown): Void
error(String, Unknown): Void
fatal(String, Unknow): Void

type Log {
  message: String
  data: Unknown
  time: DateTime
}

type Logger {
  trace(String, Unknown): Void
  debug(String, Unknown): Void
  info(String, Unknown): Void
  warn(String, Unknown): Void
  error(String, Unknown): Void
  fatal(String, Unknow): Void
  log(Log): Void
}

type LogFormatter(Log): String
type LogFilter(Log): Boolean
type LogHandler(Log, LogFormatter): Void

makeLogger(
  handler: LogHandler
  filters: List<LogFilter>
  formatter: LogFormatter
): Logger
combineLoggers(loggers: List<Logger>): Logger
setDefaultLogger(Logger): Void

fileLogHandler(filePath: String): (Log, LogFormatter) => Void
stdoutLogHandler(Log, LogFormatter) => Void

jsonLogFormatter(Log): String
logfmtLogFormatter(Log): String
prettyLogFormatter(Log): String

levelLogFilter(Level): (Log) => Boolean


