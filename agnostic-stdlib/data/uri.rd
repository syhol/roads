interface CastToURI<T>
  toURL: (T) => Result<URI>
  
interface CastToURL<T>
  toURL: (T) => Result<URL>

implement CastToString for URI
implement CastToString for URL
implement CastToURL for URI
implement CastToURI for URL

type URI{
    scheme: String
    userinfo: String
    host: String
    port: String
    path: String
    query: String
    fragment: String
}

type URL{
    scheme: String
    userinfo: String
    host: String
    port: Integer
    path: String
    query: MultiMap<String, String>
    fragment: String
}