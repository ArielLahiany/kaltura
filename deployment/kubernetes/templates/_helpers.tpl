{{/*
    Expand the name of the chart.
*/}}
{{- define "summarizer.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
    Create a default fully qualified app name.
    We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
    If release name contains chart name it will be used as a full name.
*/}}
{{- define "summarizer.fullname" -}}
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
{{- define "summarizer.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
    Common labels.
*/}}
{{- define "summarizer.labels" -}}
helm.sh/chart: "{{ include "summarizer.chart" . }}"
{{ include "summarizer.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: "{{ .Chart.AppVersion }}"
{{- end }}
app.kubernetes.io/managed-by: "{{ .Release.Service }}"
{{- end }}

{{/*
    Selector labels.
*/}}
{{- define "summarizer.selectorLabels" -}}
app.kubernetes.io/name: "{{ include "summarizer.name" . }}"
app.kubernetes.io/instance: "{{ .Release.Name }}"
app.kubernetes.io/component: "{{ .Values.global.component }}"
app.kubernetes.io/part-of: "{{ .Release.Name }}"
{{- end }}
