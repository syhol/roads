
service = (id: String) => {
  apiVersion = "v1"
  kind = "Service"
  metadata = {
    name = id
    labels = {
      app = id # by convention
      domain = "prod" # always the same in the given files
      component = String # varies per directory
    }
  }
  spec = {
    # Any port has the following properties.
    ports = {
      port = Integer
      protocol: x"TCP" or "UDP" = "TCP"
      name = Default("client")
    }[]
    selector = metadata.labels # we want those to be the same
  }
}

Property<T> = {
  name = String
  default = Optional<T>
  validators =
}

Default<T> = (property: Property<T>, default: T): Property<T> =>
  return property & { default = Some(default) }

type Deployment {
  apiVersion: "apps/v1" = "apps/v1"
  kind: "Deployment" = "Deployment"
  spec: {
    replicas: Integer @Min(1) = 1
    template: {
      metadata.labels = {
        app: String
        domain: String = "prod"
        component: String
      }
      spec.containers: {
        name: String
      }[] @MinLength(1)
    }
  }

}

deployment = (id: String, component: String) => Deployment{
  metadata.name = id
  spec.template = {
    metadata.labels = {
      app = id
      component = component
    }
    spec.containers[].name = id
  }
}

deployment.foo = deployment("foo", "comp"){ spec.template.metadata.labels.component = "thing" }
deployment.bar = {}
service.foo = {}
service.bar = {}

# VS

package kube

service: [ID=_]: {
  apiVersion: "v1"
  kind:    "Service"
  metadata: {
    name: ID
    labels: {
      app:    ID  // by convention
      domain:  "prod" // always the same in the given files
      component: string // varies per directory
    }
  }
  spec: {
    // Any port has the following properties.
    ports: [...{
      port:    int
      protocol:  *"TCP" | "UDP"   // from the Kubernetes definition
      name:    string | *"client"
    }]
    selector: metadata.labels // we want those to be the same
  }
}

deployment: [ID=_]: {
  apiVersion: "apps/v1"
  kind:    "Deployment"
  metadata: name: ID
  spec: {
    // 1 is the default, but we allow any number
    replicas: *1 | int
    template: {
      metadata: labels: {
        app:    ID
        domain:  "prod"
        component: string
      }
      // we always have one namesake container
      spec: containers: [{ name: ID }]
    }
  }
}

deployment.foo = {}
deployment.bar = {}
service.foo = {}
service.bar = {}