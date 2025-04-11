stderr: Writer
stdout: Writer
stdin: Reader

say(String): Void
print(String): Void
printError(String): Void

readLine(Reader): Generator<String>
