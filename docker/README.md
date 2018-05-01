# Lychee Aligned Docker Images

## Images

- lychee-web
- wavefront-agent
- wavefront-sidecar


## Image Functions

### lychee-web
Core docker image to provide the Lychee frontend web and application services. The Image has been created to support the use of environment variables to determine the configuration state. Symbolic links are also created to the mount points /photos and /config to support the presentation of volumes to replace local disk. 

### wavefront-sidecar
Container image to include within the application services to provide Wavefront monitoring services to the aligned application container within the Pod. Uses the telegraf metric collection service

### wavefront-agent
Central docker image to support a centralised service for creating Wavefront monitoring tasks across PKS and K8s applications/
