# Auth

### User Auth

User auth can be done via mTLS certs.

The sequence of operations is as follows:

1. As the user create a key pair (private and public key)

	```
	openssl genrsa -out jane.key 2048
	```

2. Create a CSR (Certificate Signing Request) using the private key

	```
	openssl req -new -key jane.key -subj "/CN=jane.citizen@team.telstra.com" -out jane.csr
	```

3. Send the CSR to the cluster admin
4. The cluster admin signs the CSR using the cluster's CA and returns a signed certificate

	```
	kubectl create -f - <<EOF
	apiVersion: certificates.k8s.io/v1
	kind: CertificateSigningRequest
	metadata:
		name: jane-01-01-2025
	spec:
		request: $(cat jane.csr | base64 | tr -d '\n')
		expirationSeconds: 31556952 # 1 year
		signerName: kubernetes.io/kube-apiserver-client
		usages:
		- client auth
	EOF


	kubectl certificate approve jane-01-01-2025
	```
	
6. Assign a cluster role 

	```
	kubectl create clusterrolebinding user:jane-citizen --clusterrole=system:aggregate-to-view --user="jane.citizen@team.telstra.com"
	```

7. Provide the signed certificate to the user

	```
	kubectl get csr jane-01-01-2025 -o jsonpath='{.status.certificate}' | base64 --decode > jane.crt
	```

8. Provide the CA cert to the user (can be obtained from the cluster admin)

	```
	kubectl config view --raw -o jsonpath='{.clusters[?(@.name=="kubernetes")].cluster.certificate-authority-data}' | base64 --decode > ca.crt
	```

9. User configures kubectl to use the certs

	```
	# Setup cluster details
	kubectl config set-cluster dev --server=https://<api-server-endpoint> --certificate-authority=ca.crt --embed-certs=true
	# Setup user details
	kubectl config set-credentials jane.citizen --client-certificate=jane.crt --client-key=jane.key --embed-certs=true
	# Setup context details and use the context; cluster and auth info are linked to the context
	kubectl config set-context jane.citizen@dev --cluster=dev --user=jane.citizen
	kubectl config use-context jane.citizen@dev
	```