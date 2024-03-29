
# Definitions.

# Info describes...
type Info {
    # Name of the adapter.
    name: String

    # Templates.
    templates?: String[]

    # Max is the limit.
    max?: Integer @Min(0) @ExclusiveMax(100)
}

# VS

// Definitions.

// Info describes...
Info: {
    // Name of the adapter.
    name: string

    // Templates.
    templates?: [...string]

    // Max is the limit.
    max?: uint & <100
}

# VS

{
  "openapi": "3.0.0",
  "info": {
    "title": "Definitions.",
    "version": "v1beta1"
  },
  "components": {
    "schemas": {
      "Info": {
        "description": "Info describes...",
        "type": "object",
        "required": [
            "name"
        ],
        "properties": {
          "name": {
            "description": "Name of the adapter.",
            "type": "string",
            "format": "string"
          },
          "templates": {
            "description": "Templates.",
            "type": "array",
            "items": {
              "type": "string",
              "format": "string"
            }
          },
          "max": {
            "description": "Max is the limit",
            "type": "integer",
            "minimum": 0,
            "exclusiveMaximum": 100
          }
        }
      }
    }
  }
}
