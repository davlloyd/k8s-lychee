# --------------------------------------------------------------------
# Docker image for the support of the Wavefront Telegraf Agent
# --------------------------------------------------------------------
# Wavefront is a real-time metrics monitoring and streaming analytics platform designed for 
# applications and developers to help optimise their applications that rely on containers and 
# microservices.
#
# This image provides the telegraf collection agent 



# Using Ubuntu as base image initally, will swing to Alpine or PhotonOS in future
FROM telegraf:latest

LABEL maintainer="David Lloyd <davidlloyd0@gmail.com>"
LABEL version="1.0"
LABEL description="To initially support the Lychee Photo Album Application Web Service. This \
enables the collecting of the application aligned metrics"

LABEL EnvVar1="WAVEFRONT_PROXY_HOST=the host name or IP address of the Wavefront proxy"
LABEL EnvVar2="WAVEFRONT_PROXY_PORT=The TCP port for the Wavefront proxy"
LABEL EnvVar3="APP_NAME=the name to add to the app label"
LABEL EnvVar4="APP_TIER=the tier of the service within the application"
LABEL EnvVar5="SERVICES=Service to be monitored e.g. NGINX or MySQL"
LABEL EnvVar6="SERVICE_ACCOUNT=(optional) Account name of service if required"
LABEL EnvVar7="SERVICE_PASSWORD=(optional) Account password of service if required"
LABEL EnvVar8="CLUSTER_NAME=(optional) Kubernetes Cluster Name, if proxy setting to be overwritten"
LABEL EnvVar9="MONITOR_INTERVAL=Frequency of data collection"

# Environment variables for connecting to Wavefront agent
ENV WAVEFRONT_PROXY_HOST=wavefront-proxy
ENV WAVEFRONT_PROXY_PORT=2878
ENV APP_NAME=lychee
ENV APP_TIER=notdefined
ENV SERVICES=mysql
ENV SERVICE_ACCOUNT=user
ENV SERVICE_PASSWORD=password
ENV MONITOR_INTERVAL=60s

# Copy telegraf templates 
RUN mkdir /var/telegraf-templates
COPY files/telegraf/templates/* /var/telegraf-templates/
COPY files/telegraf/telegraf.conf /etc/telegraf
COPY files/telegraf/10-wavefront.conf /etc/telegraf/telegraf.d
COPY files/telegraf/globaltags.conf /etc/telegraf/telegraf.d

# Set entry point
COPY files/entry_point.sh /
RUN chmod 777 /entry_point.sh
ENTRYPOINT [ "/entry_point.sh" ]

# Start Telegraf
CMD [ "telegraf", "-config-directory", "/etc/telegraf/telegraf.d" ]
