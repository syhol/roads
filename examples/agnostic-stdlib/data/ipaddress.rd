type IPv4Address = String
type IPv6Address = String

IPv4Address(String) => Result<IPv4Address>
IPv4Address.parse(String) => Result<IPv4Address>
IPv4Address.toBytes(IPv4Address) => Bytes
IPv4Address.fromBytes(Bytes) => Result<IPv4Address>
