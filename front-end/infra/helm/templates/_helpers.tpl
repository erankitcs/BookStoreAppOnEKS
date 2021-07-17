{{/*
Expand the name of the chart.
*/}}
{{- define "booksotre-front-end.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "booksotre-front-end.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "booksotre-front-end.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "booksotre-front-end.labels" -}}
booksotre-front-end.sh/chart: {{ include "booksotre-front-end.chart" . }}
{{ include "booksotre-front-end.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "booksotre-front-end.selectorLabels" -}}
app.kubernetes.io/name: {{ include "booksotre-front-end.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "booksotre-front-end.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "booksotre-front-end.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Common labels - Proxy
*/}}
{{- define "booksotre-front-end-proxy.labels" -}}
booksotre-front-end.sh/chart: {{ include "booksotre-front-end.chart" . }}-proxy
{{ include "booksotre-front-end-proxy.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}-proxy
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}-proxy
{{- end }}

{{/*
Selector labels - Proxy
*/}}
{{- define "booksotre-front-end-proxy.selectorLabels" -}}
app.kubernetes.io/name: {{ include "booksotre-front-end.name" . }}-proxy
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
