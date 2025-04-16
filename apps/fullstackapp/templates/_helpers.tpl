{{- define "fullstackapp.fullname" -}}
{{ .Release.Name }}
{{- end }}

{{- define "fullstackapp.labels" -}}
app.kubernetes.io/name: {{ include "fullstackapp.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}