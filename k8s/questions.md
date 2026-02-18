# K8s Follow Up Questions

### How do you find the version that should be used in a CR via a CRD?

- what is the command to look it up?
`kubectl get crd <crd-name> -o yaml` and look for `spec.versions`
- what if there are many versions?
Look for the version that is marked as `served: true` and `storage: true`.
- Give me the command via yq to filter this to server: true?

```
kubectl get crd <CRD-NAME> -o yaml | yq e '.spec.versions[] | select(.served == true) | .name
```