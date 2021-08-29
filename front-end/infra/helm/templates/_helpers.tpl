{{/*
Expand the name of the chart.
*/}}
{{- define "bookstore-front-end.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "bookstore-front-end.fullname" -}}
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
{{- define "bookstore-front-end.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "bookstore-front-end.labels" -}}
bookstore-front-end.sh/chart: {{ include "bookstore-front-end.chart" . }}
{{ include "bookstore-front-end.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "bookstore-front-end.selectorLabels" -}}
app.kubernetes.io/name: {{ include "bookstore-front-end.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/role: {{ .Values.appRole }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "bookstore-front-end.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- $saname := default (include "bookstore-front-end.name" .) .Values.serviceAccount.name }}
{{- printf "%s-%s" $saname "service-account" | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Common labels - Proxy
*/}}
{{- define "bookstore-front-end-proxy.labels" -}}
bookstore-front-end.sh/chart: {{ include "bookstore-front-end.chart" . }}-proxy
{{ include "bookstore-front-end-proxy.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}-proxy
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}-proxy
{{- end }}

{{/*
Selector labels - Proxy
*/}}
{{- define "bookstore-front-end-proxy.selectorLabels" -}}
app.kubernetes.io/name: {{ include "bookstore-front-end.name" . }}-proxy
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/role: {{ .Values.appRole }}-proxy
{{- end }}
