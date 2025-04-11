type HttpRequest {
  version: String
  url: Url
  method: String
  headers: MultiMap<String, String>
  body: Readable
}

type HttpResponse {
  status: String
  headers: MultiMap<String, String>
  body: Readable
}
