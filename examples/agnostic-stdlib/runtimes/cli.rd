type Command = {
    arguments: List<String>
}

serveCommand((Command) => Number): Void

parseArguments<T>(List<String>, Schema<T>): T

color.x(String): String
