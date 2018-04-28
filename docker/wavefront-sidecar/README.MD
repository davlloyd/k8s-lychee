# Wavefront Agent Sidecar

Image designed to run as a sidecar container within a Pod to monitor local services

## Following needs to be added to pod YML to expose Kubernetes details 
      env:
        - name: POD_NAME
          valueFrom:
            fieldRef:
              fieldPath: metadata.name
        - name: POD_NAMESPACE
          valueFrom:
            fieldRef:
              fieldPath: metadata.namespace
