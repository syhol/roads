name = "Project example"

tools = {
  roads = "https://github.com/roads/roads/tree/v1"
}

dependencies = {
  nyc = "npm15.1.0",
}

tasks = {
  test = "roads test ."
  dev = "roads dev ."
}

compilerOptions = {
  outDir = "./dist/",
  experimentalDecorators = True,
  emitDecoratorMetadata = True,
  allowJs = True,
  typeRoots = ["./node_modules/@types", "./typings"],
  removeComments = True,
  lib = ["dom", "ES2022"]
},

mkDocs = {
  siteName = "SA Ads Server"
  siteDescription = "SA Ads Server"
  nav = {
    Overview = "README.md"
    Auth = "auth.md"
    Infrastructure = "infrastructure.md"
    Storage = {
      "Http Endpoint - Epic Data Router" = "storage/http-endpoint-epic-data-router.md",
      "Kafka - AA Events" = "storage/kafka-aa-events.md",
      "Memcached - Delivery Cache" = "storage/memcached-delivery-cache.md",
      "Redis - Install And Frequency Cap Store" = "storage/redis-install-and-frequency-cap-store.md",
      "Redis - Reach Store" = "storage/redis-reach-store.md",
    }
    Analytics = {
      Datadog: analytics/datadog.md
    }
  }
  plugins = ["techdocs-core"]
  markdown_extensions = ["fenced_code"]
}

