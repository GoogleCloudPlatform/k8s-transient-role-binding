# The kubernetes `TransientRoleBinding` and `TransientClusterRoleBinding` controllers

These controllers provide limited lifetime RoleBinding and ClusterRoleBinding mechanism for Kubernetes.

## Why "transient" resources

Sometimes, a user may want to apply for a privilege which only makes effect during a limited period of time. 

However, the Kubernetes' default RBAC objects `RoleBinding` and `ClusterRoleBindingx` are used to grant user privileges, the privileges granted will make effect until deleted. 

## How these "transient" resources work

The `TransientRoleBinding` and `TransientClusterRoleBinding` controllers look similar to `RoleBinding` and `ClusterRoleBindingx` only except that the "transient" objects have two extra fields:

- "validUntil" which indicates these rolebindings only effect before the specified time
- "validFrom" which indicates these rolebindings only effect after the specified time

## Usage

These objects has four fields:

    - validUntil
      timestamp in `rfc3339` format. The rolebinding(or clusterrolebinding) will only be in effect before this time.
    - validFrom
      timestamp in `rfc3339` format. The rolebinding(or clusterrolebinding) will only be in effect after this time.
    - roleRef
      the same as in RoleBinding and ClusterRoleBinding
    - subjects
      the same as in RoleBinding and ClusterRoleBinding

See also the examples directory

## Deploy

### Install MetaController first

Follow the instructions in this [doc](https://metacontroller.github.io/metacontroller/guide/install.html) or run this command:

```sh
kubectl apply -k https://github.com/metacontroller/metacontroller/manifests/production?base=ref=v2.1.3
```

### OPA webhook

In the `controller/opa-webhook` directory, use the following command to regenerate a configmap:

```sh
kubectl create -n kube-system  configmap transientcontroller --from-file rules/controller.rego   --dry-run=client -o yaml | tee configmap.yaml
```

Apply the configmap, deployment and service to the Kubernetes cluster:

```sh
# cd controller/opa-webhook
# configmap.yaml controller-deployment.yaml controller-svc.yaml
kubectl apply -f .
```

### The transient controllers and metacontrollers

In the `controller` directory, apply the yaml files:

```sh
# cd controller
# transient-clusterrolebinding-metacontroller.yaml transient-clusterrolebinding.yaml transient-rolebinding-metacontroller.yaml transient-rolebinding.yaml
kubectl apply -f .
```

## Test

You will need the `opa` cli tool to run the examples. Download the tool from [here](https://github.com/open-policy-agent/opa). 

The `generate-valid-example.sh` in the `examples` directory can be used to generate a valid transient rolebinding from the `transient-clusterrolebinding-example.yaml` or `transient-rolebinding-example.yaml`. The generated objects valid for 6 minutes.

For example, in the `examples` directory, run the following command

```sh
./generate-valid-example.sh transient-rolebinding-example.yaml |kubectl apply -f -
```

