.DEFAULT_GOAL=gateway
install:
	kubectl apply -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper/master/deploy/gatekeeper.yaml
	kubectl apply -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper/master/demo/basic/templates/k8srequiredlabels_template.yaml
	kubectl apply -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper/master/demo/basic/constraints/all_ns_must_have_gatekeeper.yaml
	kubectl apply -f ./istio-replication.yaml

	sleep 2
	kubectl delete ns test-a --ignore-not-found=true;
	kubectl create ns test-a;

gateway:
	kubectl delete K8sDenyAllGateway --ignore-not-found=true  --all 2>&1 || true
	kubectl delete gateway -l testing=gateway --ignore-not-found=true
	kubectl delete gateways.networking.istio.io --all -n default
	@echo -----
	kubectl get gateways -A
	@echo -----
	kubectl apply -f istio-replication.yaml
	kubectl apply -f sample.gateway.yaml
	kubectl apply -f constraint-gateway.yaml
	sleep 2
	@echo -----
	kubectl get gateways -A
	@echo -----
	echo SAMPLE A
	sed 's/-a/-a/g' gateway.yaml.tpl | kubectl apply -f -
	echo SAMPLE B
	sed 's/-a/-b/g' gateway.yaml.tpl | kubectl apply -f -

