// postgresProvider.rd
require Postgres
require PostgresConfig as config

type PostgresConfig{
  username: String
  password: String
  host: String
  port: Number
}

bind instanceof Postgres to Postgres(config)

// appConfig.rd
require config show {resolveDefinition, getHelpText}

getDefinition() =>
  return {
    postgres = {
      username = "my_user",
      password = "my_pass",
      host = "fj48jdw0.aws.postgres.aws.com",
      port = 9090
    }
  }

getConfig() => getDefinition()->resolveDefinition()

getHelpText() => getDefinition()->getHelpText()

// postgresLogger.rd
logQuery(query: PostgresQuery) => print(query.payload)

// main.rd
bind all in args, environment, config
import ./appConfig as appConfig
import ./postgresLogger as postgresLogger
bind dependency in ./postgresProvider(config = appConfig.getConfig().postgres)
bind listener postgresLogger.logQuery