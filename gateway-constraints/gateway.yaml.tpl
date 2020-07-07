apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: gateway-a
  labels:
    testing: "gateway"
spec:
  selector:
    app: my-gateway-controller
  servers:
  - port:
      number: 80
      name: http
      protocol: HTTP
    hosts:
    - "foo.bar.com"
