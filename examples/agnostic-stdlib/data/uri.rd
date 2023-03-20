interface CastToURI<T>
  toURI: (T) => Result<URI>

implement CastToString for URI

type URI {
    scheme: String
    userinfo: String
    host: String
    port: String
    path: String
    query: String
    fragment: String
}
