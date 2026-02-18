# Bitnami Sealed Secrets

### Merge into an existing sealed secret

```
# gitlab-token should be the name of the sealed secret
# --from-file "password" is the data key in the sealed secret
echo -n <password> | kubectl create secret generic gitlab-token --dry-run=client --from-file=password=/dev/stdin -o yaml | kubeseal --controller-namespace=kube-system --controller-name=sealed-secrets-controller -o yaml --merge-into gitlab-token-sealed.yaml
```

### Backup private keys 

https://www.eksworkshop.com/docs/security/secrets-management/sealed-secrets/managing-sealing-keys

### Decrypt a file to verify secret 

```
kubectl get secret -n bitnami -l sealedsecrets.bitnami.com/sealed-secrets-key -o yaml > /tmp/sealed-key.yaml
```

```
kubeseal --controller-name=bitnami --controller-namespace=bitbami < gitlab-token-sealed.yaml  --recovery-unseal --recovery-private-key sealed-key.yaml -o yaml
```

