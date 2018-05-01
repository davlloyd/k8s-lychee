# Wavefront Agent Sidecar

Image designed to run as a sidecar container within a Pod to monitor local services using Telegraf as a metric collector to be passed to a Wavefront proxy agent


![Lychee Kubernetes Manifests](/images/lychee-wavefront-sidecar.gif)

The sidecar image will dynamically create telegraf configuration files to enable metric collection of services specified in the envirionment variable 'SERVICES'. The configuration files will utilise environment variable to determine the Wavefront proxy through which the metrics will be passed through, associated lables for function identification and any details neeed to access application.

## Image Delivery Requirements

### Values
Following needs to be added to pod YML to expose Kubernetes details 
      env:
        - name: POD_NAME
          valueFrom:
            fieldRef:
              fieldPath: metadata.name
        - name: POD_NAMESPACE
          valueFrom:
            fieldRef:
              fieldPath: metadata.namespace

### Variables

* WAVEFRONT_PROXY_HOST: Service name or IP address of Wavefront proxy
* WAVEFRONT_PROXY_PORT: (default=2878) Port of proxy service
* APP_NAME: Name to associate with K8 Pod app label (also can be provided by file)
* APP_TIER: Service tier to associate with K8 Pod tier label (also can be provided by file)
* SERVICES: Service to collection metrics from (currently supported values mysql or nginx)
* SERVICE_ACCOUNT: (optional) Account name to access service e.g. MySQL account name
* SERVICE_PASSWORD: (optional) Account password to access service
* MONITOR_INTERVAL: Frequency of metric collection e.g. '60s' for 60 seconds or '5m' for 5 minutes

 
