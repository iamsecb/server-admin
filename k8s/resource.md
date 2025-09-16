# Kubernetes Resource Management

> If two pods are running in Burstable QoS (where memory requests are less than limits), for example, Pod A with a 1m memory request and Pod B with a 2m memory request, and Pod A is using 90% of its request while Pod B is using 60%, which pod will Kubernetes evict first if the node runs out of memory? Even though Pod B is using more actual memory, explain why Pod A would be terminated first.



In Kubernetes, when the node is under memory pressure and needs to evict pods, it prioritizes eviction based on the pod's QoS class and then by how much the pod exceeds its memory request (the "excess usage").

- Both Pod A and Pod B are in Burstable QoS (since they have memory requests set, but not equal to their limits).
- If the node is out of memory, Kubernetes will evict pods that are exceeding their requests by the largest percentage.
- Pod A is using 90% of its requested memory (0.9m), Pod B is using 60% of its requested memory (1.2m).
- So, the pod that is most over its request (relative to its request) is more likely to be terminated, even if another pod is using more actual memory. This is to protect pods that are closer to their requested resources.