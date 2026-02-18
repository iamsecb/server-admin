# CRD 

#### How do you find the version that should be used in a CR via a CRD?

- *What is the command to look it up?*

	`kubectl get crd <crd-name> -o yaml` and look for `spec.versions`

- *What if there are many versions?*

	Look for the version that is marked as `served: true` and `storage: true`.
- *What is served and storage?*

	`served: true` means the version is available via the API server. `storage: true` means this version is used to store the resource in etcd.

- *Give me the command via yq to filter this to served: true?*

	```
	kubectl get crd <name> -o yaml | yq e '.spec.versions[] | select(.served == true) | .name'
	```