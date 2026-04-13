{{- define "hello-chart.name" -}}
{{- .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{- define "hello-chart.fullname" -}}
{{- printf "%s-%s" .Release.Name (include "hello-chart.name" .) | trunc 63 | trimSuffix "-" -}}
{{- end }}
