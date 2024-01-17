
type UuidVersion = V1 | V3 | V4 | V5 | V6 | V7 | V8 | Ulid

Uuid.generateV1() => Bytes
Uuid.generateV3() => Bytes
Uuid.generateV4() => Bytes
Uuid.generateV5() => Bytes
Uuid.generateV6() => Bytes
Uuid.generateV7() => Bytes
Uuid.generateV8() => Bytes
Uuid.generateUlid() => Bytes
Uuid.detectVersion(Bytes) => Result<UuidVersion>

Uuid.encode(String) => Bytes
Uuid.decode(Bytes) => String