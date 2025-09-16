# CLI Commands


### Get assigned Private IPs in a Subnet
```
aws ec2 describe-network-interfaces --filters Name=subnet-id,Values=subnet-0666afef5d7dd8e94 |jq -r '.NetworkInterfaces[].PrivateIpAddress' |sort
```