{{/*
Template to render Tailscale addon
*/}}
{{- define "common.addon.tailscale" -}}
  {{/* Append the tailscale container to the additionalContainers */}}
  {{- $container := include "common.addon.tailscale.container" . | fromYaml -}}
  {{- if $container -}}
    {{- $_ := set .Values.additionalContainers "addon-tailscale" $container -}}
  {{- end -}}

  {{- include "common.addon.tailscale.role" . -}}

  {{/* Include the secret if not empty */}}
  {{- $secret := include "common.addon.tailscale.secret" . -}}
  {{- if $secret -}}
    {{- $secret | nindent 0 -}}
  {{- end -}}
{{- end -}}