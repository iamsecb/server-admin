# Bitnami Sealed Secrets

### Merge into an existing sealed secret

```
# gitlab-token should be the name of the sealed secret
# --from-file "password" is the data key in the sealed secret
echo -n <password> | kubectl create secret generic gitlab-token --dry-run=client --from-file=password=/dev/stdin -o yaml  | kubeseal  --controller-namespace=bitnami -o yaml --merge-into gitlab-token-sealed.yaml
```

