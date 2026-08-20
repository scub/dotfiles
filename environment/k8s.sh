# Watch: pods in a namespace
kgpw() {
  namespace=$1
  args="${@:2}"
  watch -n 3 "kubectl get pods -n $namespace $args"
}

# Watch: image tag in use by pods on a namespace
kgpwi() {
  namespace=$1
  args="${@:2}"
  watch -n 3 "kubectl get pods -n $namespace -o custom-columns=\"POD:.metadata.name,IMAGE:.spec.containers[*].image,PHASE:status.phase\" $args"
}

# List all ingress' host and path information 
kgli() {
  kubectl get ingress -A -o json \
    | jq '
        .items[]
        | .metadata.namespace as $ns
        | .metadata.name as $svc
        | .spec.rules[] as $r
        | .spec.ingressClassName as $icn
        | $r.http.paths[]
        | {
            namespace: $ns,
            service: $svc,
            ingress: $icn,
            host: $r.host,
            path: .path,
            full_uri: ($r.host + .path),
            logql: "{namespace=\"\($ns)\", job=\"\($ns)/\($svc)\"}"
          }
      '
}

# Search all ingresses for a path
kgsi() {
  SEARCH_PATH="${1:-/}"
  kubectl get ingress -A -o json \
    | jq -c '
        .items[]
        | .metadata.namespace as $ns
        | .metadata.name as $svc
        | .spec.rules[] as $r
        | .spec.ingressClassName as $icn
        | $r.http.paths[]
        | {
            namespace: $ns,
            service: $svc,
            ingress: $icn,
            host: $r.host,
            path: .path,
            full_uri: ($r.host + .path),
            logql: "{namespace=\"\($ns)\", job=\"\($ns)/\($svc)\"}"
          }
      ' \
    | jq --arg path "$SEARCH_PATH" 'select(.path == $path)'
}

# Kube aliases
alias kg='kubectl get'
alias kgp='kubectl get pod'

# Kube config
export KUBECONFIG=${HOME?}/.kube/config