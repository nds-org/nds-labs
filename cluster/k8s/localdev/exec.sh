kubectl exec `kubectl get pods | grep $1 | awk '{print $1}'` -c $1 -- $2
