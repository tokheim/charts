{{/*
Expand the name of the chart.
*/}}
{{- define "stdapp.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "stdapp.fullname" -}}
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
{{- define "stdapp.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
The name used for serviceaccount
*/}}
{{- define "stdapp.saname" -}}
{{- if .Values.serviceAccount.name }}
{{- .Values.serviceAccount.name | quote }}
{{- else }}
{{- include "stdapp.fullname" . }}
{{- end }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "stdapp.labels" -}}
helm.sh/chart: {{ include "stdapp.chart" . }}
{{ include "stdapp.selectorLabels" . }}
{{- if .Values.container.image.tag }}
app.kubernetes.io/version: {{ .Values.container.image.tag | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "stdapp.selectorLabels" -}}
app.kubernetes.io/name: {{ include "stdapp.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Check if any kv is enabled
*/}}
{{- define "stdapp.kv.enabled" -}}
{{- range $k, $v := . -}}
{{- if $v.enabled -}}
"true"
{{- end -}}
{{- end -}}
{{- end -}}


{{/*
Render image
*/}}
{{- define "stdapp.image" -}}
{{- $tag := .Values.container.image.tag | default .Values.global.image.tag -}}
{{- $repository := .Values.container.image.repository | default .Values.global.image.repository -}}
{{- $registry := .Values.container.image.registry | default .Values.global.image.registry -}}
{{- printf "%s/%s:%s" 
    (required "You must specify container.image.registry, e.g. domain.azurecr.io" $registry)
    (required "You must specify container.image.repository, e.g. mydomain/myservice" $repository) 
    (required "You must specify container.image.tag" $tag) 
-}}
{{- end }}

{{/*
Render probe config
*/}}
{{- define "stdapp.probeconfig" -}}
httpGet:
  path: {{ .path }}
  port: {{ .port }}
  httpHeaders: {{ .httpHeaders | toJson }}
initialDelaySeconds: {{ .initialDelaySeconds }}
periodSeconds: {{ .periodSeconds }}
timeoutSeconds: {{ .timeoutSeconds }}
failureThreshold: {{ .failureThreshold }}
{{- end }}
