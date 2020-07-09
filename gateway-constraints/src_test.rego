package k8sdenyallgateway

test_no_data {
    input := {"review": review(gateway("my-gateway", "prod", my_rules1, "extensions/v1beta1"), "extensions")}
    results := violation with input as input
    count(results) == 0
}

#test_identical {
#    input := {"review": review(gateway("my-gateway", "prod", my_rules1, "extensions/v1beta1"), "extensions")}
#    inv := inventory_data([gateway("my-gateway", "prod", my_rules1, "extensions/v1beta1")])
#            trace(sprintf("%v", [inv]))
#
#    results := violation with input as input with data.inventory as inv
#                trace(sprintf("%v", [results]))
#
#    count(results) == 0
#}

review(ing, group) = output {
  output = {
    "kind": {
      "kind": "Gateway",
      "version": "v1beta1",
      "group": group,
    },
    "namespace": ing.metadata.namespace,
    "name": ing.metadata.name,
    "object": ing,
  }
}
my_rule(host) = {
  "host": host, 
}
my_rules1 = [
    my_rule("a.abc.com")
]

gateway(name, ns, rules, apiversion) = out {
  out = {
    "kind": "Gateway",
    "apiVersion": apiversion,
    "metadata": {
      "name": name,
      "namespace": ns,
    },
    "spec": {
    }
  }
}

inventory_data(ingresses) = out {
  namespaces := {ns | ns = ingresses[_].metadata.namespace}
  out = {
    "namespace": {
      ns: {
        "extensions/v1beta1": {
          "Ingress": {}
        }
      } | ns := namespaces[_]
    }
  }
}
