interface CastToUri<T>
  toUri: (T) => Result<Uri>

implement CastToString for Uri

type Uri {
    scheme: String
    userinfo: String
    host: String
    port: String
    path: String
    query: String
    fragment: String
}

QueryString.encode(Map) => String
QueryString.decode(String) => Map