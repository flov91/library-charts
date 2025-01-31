{{/*
The Tailscale secrets to be included
*/}}
{{- define "common.addon.tailscale.secret" -}}
{{- if .Values.addons.vpn.tailscale.authKey }}
---
apiVersion: v1
kind: Secret
metadata:
  name: {{ include "common.names.fullname" . }}-tailscale-auth
  labels: {{- include "common.labels" $ | nindent 4 }}
  annotations: {{- include "common.annotations" $ | nindent 4 }}
type: Opaque
data:
  TS_AUTHKEY: {{ .Values.addons.vpn.tailscale.authKey | b64enc }}
{{- end -}}
{{- end -}}