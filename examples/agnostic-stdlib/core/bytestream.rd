

interface Reader
  readBytes(Array<Byte>) => Result<Number>
  readAllBytes() => Result<Array<Byte>>
  readString() => Result<String>

interface Writer
  writeBytes(Array<Byte>) => Result<Number>
  writeAllBytes(Array<Byte>) => Result<Number>
  writeString(String) => Result<Number>
  flush() => Result<Boolean>

interface Seeker
  seekFromStart(Number) => Result<Number>
  seekFromEnd(Number) => Result<Number>
  seekFromCurrent(Number) => Result<Number>

copy(Reader, Writer) => Result<Number>
readLines(Reader) => Generator<String>

