package k8sdenyallgateway

operations = {"CREATE", "UPDATE"}

identical(obj, review) {
	obj.metadata.namespace == review.object.metadata.namespace
	obj.metadata.name == review.object.metadata.name
}


violation[{"msg": msg}] {
	re_match("^(networking.istio.io)$", input.review.kind.group)
	input.review.kind.kind == "Gateway"
	other := data.inventory.namespace[ns][otherapiversion][resourcetype][resourcename].spec.servers[_].hosts
#	operations[input.review.operation]
#	not identical(other, input.review)
	msg := sprintf("REVIEW OBJECT: %v", ["xxx"])
}
