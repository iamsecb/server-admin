# SSL Cheat Sheet

### Get the leaf certificate from a certificate chain

In most cases, certificate chains are ordered as:

1. Leaf (end-entity/FQDN) certificate first
2. Intermediate CA(s)
3. Root CA (sometimes omitted)

To check a cert do:

```
# Increment the number to get the desired cert in the chain
awk 'BEGIN{c=0} /-----BEGIN CERTIFICATE-----/{c++} c=='"full_chain.txt" "1"| openssl x509 -noout -subject -issuer -enddate
```

To extract the leaf certificate from a full chain file:


```bash
awk '/-----BEGIN CERTIFICATE-----/ {f=1} f; /-----END CERTIFICATE-----/ {if(f){exit}}' full_chain.crt > leaf.crt
```

Explanation:

- When it sees the line `-----BEGIN CERTIFICATE-----`, it sets a flag `f=1`.
- While f is set, it prints every line (so it starts printing at the first cert).
- When it sees `-----END CERTIFICATE-----` **and** `f` is set, it exits immediately (so it stops after the first cert block).

The result: only the first certificate (the leaf) is written to `leaf.crt`, and nothing else from the file is included.