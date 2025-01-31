{{/*
The Tailscale role to be included
*/}}
{{- define "common.addon.tailscale.role" -}}
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: "{{ include "common.names.fullname" . }}-tailscale-role"
  namespace: '{{ .Release.Namespace }}'
rules:
  - apiGroups: [""] # "" indicates the core API group
    resources: ["secrets"]
    # Create can not be restricted to a resource name.
    verbs: ["create"]
  - apiGroups: [""] # "" indicates the core API group
    resourceNames: ["{{ include "common.names.fullname" . }}-tailscale-auth"]
    resources: ["secrets"]
    verbs: ["get", "update", "patch"]
  - apiGroups: [""] # "" indicates the core API group
    resources: ["events"]
    verbs: ["get", "create", "patch"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: "{{ include "common.names.fullname" . }}-tailscale-binding"
  namespace: '{{ .Release.Namespace }}'
subjects:
  - kind: ServiceAccount
    # name: '{{ .Release.Name }}-tailscale-sa'
    name: default
roleRef:
  kind: Role
  name: "{{ include "common.names.fullname" . }}-tailscale-role"
  apiGroup: rbac.authorization.k8s.io
---
# apiVersion: v1
# kind: ServiceAccount
# # automountServiceAccountToken: true
# metadata:
#   name: '{{ .Release.Name }}-tailscale-sa'

{{- end -}}
