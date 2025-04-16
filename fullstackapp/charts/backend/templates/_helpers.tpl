{{- define "backend.fullname" -}}
{{ .Release.Name }}-backend
{{- end }}

{{- define "backend.name" -}}
{{ .Chart.Name }}
{{- end }}

{{- define "backend.labels" -}}
app.kubernetes.io/name: {{ include "backend.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
app.kubernetes.io/component: {{ .Chart.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}