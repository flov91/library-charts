{{/*
The Tailscale container configurations to be inserted into additionalContainers.
*/}}
{{- define "common.addon.tailscale.container" -}}
name: tailscale
image: "{{ .Values.addons.vpn.tailscale.image.repository }}:{{ .Values.addons.vpn.tailscale.image.tag }}"
imagePullPolicy: {{ .Values.addons.vpn.tailscale.image.pullPolicy }}
env:
  # Store the state in a k8s secret
  - name: TS_KUBE_SECRET
    value: {{ include "common.names.fullname" . }}-tailscale-auth
  - name: TS_USERSPACE
  {{- if and (hasKey .Values.addons.vpn.tailscale "userspace") (not .Values.addons.vpn.tailscale.userspace) }}
    value: false
  {{- else }}
    value: true
  {{- end }}
#   - name: TS_DEBUG_FIREWALL_MODE
#     value: {{ .Values.addons.vpn.tailscale.firewallMode | default "auto" }}
  - name: TS_HOSTNAME
    value: {{ tpl (printf "%s" (default (include "common.names.fullname" .) .Values.addons.vpn.tailscale.hostname)) . }}

  {{- if .Values.addons.vpn.tailscale.authKey }}
  - name: TS_AUTHKEY
    valueFrom:
      secretKeyRef:
        name: {{ include "common.names.fullname" . }}-tailscale-auth
        key: TS_AUTHKEY
  {{- end }}
  - name: POD_NAME
    valueFrom:
      fieldRef:
        fieldPath: metadata.name
  - name: POD_UID
    valueFrom:
      fieldRef:
        fieldPath: metadata.uid
  {{- with .Values.addons.vpn.tailscale.additionalEnv }}
    {{- toYaml . | nindent 2 }}
  {{- end }}
# serviceAccountName: {{ .Release.Name }}-tailscale-sa
securityContext:
{{- if and (hasKey .Values.addons.vpn.tailscale "userspace") (not .Values.addons.vpn.tailscale.userspace) }}
  privileged: true
  capabilities:
    add:
      - NET_ADMIN
      - NET_RAW
  fsGroup: 0
  runAsGroup: 0
  runAsUser: 0
{{- else }}
  privileged: false
{{- end }}
  {{- with .Values.addons.vpn.tailscale.securityContext }}
    {{- toYaml . | nindent 2 }}
  {{- end }}
{{- with .Values.addons.vpn.tailscale.resources }}
resources:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end -}}