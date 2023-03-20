
// A spec is of type Spec
spec: Spec = {
  kind = "Homo Sapiens" // error, misspelled field

  name.first = "Jane"
  name.last =  "Doe"
}

--private

type Spec {
  kind: String

  name: {
    first: String & @MinLength(1)  # must be specified and non-empty
    middle?: String & @MinLength(1)  # optional, but must be non-empty when specified
    last: String & @MinLength(1)
  }

  # The minimum must be strictly smaller than the maximum and vice versa.
  minimum?: Integer & @Validate((minimum, {maximum}) => minimum < maximum)
  maximum?: Integer & @Validate((maximum, {minimum}) => minimum < maximum)
}

# VS

#Spec: {
  kind: string

  name: {
    first:   !=""  // must be specified and non-empty
    middle?: !=""  // optional, but must be non-empty when specified
    last:    !=""
  }

  // The minimum must be strictly smaller than the maximum and vice versa.
  minimum?: int & <maximum
  maximum?: int & >minimum
}

// A spec is of type #Spec
spec: #Spec
spec: {
  knid: "Homo Sapiens" // error, misspelled field

  name: first: "Jane"
  name: last:  "Doe"
}
