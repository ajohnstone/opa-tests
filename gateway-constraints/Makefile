.DEFAULT_GOAL=gateway
install:
	kubectl apply -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper/master/deploy/gatekeeper.yaml
	kubectl apply -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper/master/demo/basic/templates/k8srequiredlabels_template.yaml
	kubectl apply -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper/master/demo/basic/constraints/all_ns_must_have_gatekeeper.yaml
	kubectl apply -f sync.yaml

	sleep 2
	kubectl delete ns test-a --ignore-not-found=true;
	kubectl create ns test-a;

gateway:
	kubectl delete pods -n gatekeeper-system --all
	sleep 5
	kubectl delete K8sDenyAllGateway --ignore-not-found=true  --all 2>&1 || true
	kubectl delete gateway -l testing=gateway --ignore-not-found=true
	kubectl delete gateways.networking.istio.io --all -n default
	@echo -----
	kubectl get gateways -A
	@echo -----
	kubectl apply -f sync.yaml
	kubectl apply -f same.gateway.yaml
	kubectl apply -f constraint-gateway.yaml
	sleep 2
	kubectl apply -f constraint-gateway-i.yaml
	sleep 2
	@echo -----
	kubectl get gateways -A
	@echo -----
	echo SAMPLE A
	sed 's/-a/-a/g' gateway.yaml.tpl | kubectl apply -f -
	echo SAMPLE B
	sed 's/-a/-b/g' gateway.yaml.tpl | kubectl apply -f -
	echo SAMPLE C
	sed 's/-a/-c/g' gateway.yaml.tpl | kubectl apply -f -

	@echo -----
	echo INVALID DUPLICATE HOSTS
	kubectl get gateway -A -o json | jq '.items[].spec.servers[].hosts[]' -r | sort | uniq -c | sort -gr
	sed 's/name: gateway-a/name: gateway-dupe/g' gateway.yaml.tpl | kubectl apply -f - || true
	kubectl get gateway -A -o json | jq '.items[].spec.servers[].hosts[]' -r | sort | uniq -c | sort -gr
