# --------------------------------------------------------------------
# Docker image for the support of the Wavefront Telegraf Agent
# --------------------------------------------------------------------
# Wavefront is a real-time metrics monitoring and streaming analytics platform designed for 
# applications and developers to help optimise their applications that rely on containers and 
# microservices.
#
# This image provides the telegraf collection agent 



# Using Ubuntu as base image initally
FROM ubuntu:17.10

LABEL maintainer="David Lloyd <davidlloyd0@gmail.com>"
LABEL version="1.0"
LABEL description="To initially support the Lychee Photo Album Application Web Service. This \
enables the collecting of the application aligned metrics"

LABEL EnvVar1="WAVEFRONT_PROXY_HOST=the host name or IP address of the Wavefront proxy"
LABEL EnvVar2="WAVEFRONT_PROXY_PORT=The TCP port for the Wavefront proxy"
LABEL EnvVar3="APP_NAME=the name to add to the app label"
LABEL EnvVar4="PKS_API_HOST=DNS name for the PKS management server"
LABEL EnvVar5="PKS_USER=PKS user account"
LABEL EnvVar6="PKS_PASSWORD=PKS user account password"


# Environment variables for connecting to Wavefront agent
ENV WAVEFRONT_PROXY_HOST localhost
ENV WAVEFRONT_PROXY_PORT 2878
ENV APP_NAME lychee
ENV PKS_API pks-api.somewhere.local
ENV PKS_USER pksuser
ENV PKS_PASSWORD password


# Get the Core installed 
RUN apt-get update

# Base install set to support monitoring apps such as MySQL and NGINX
RUN apt-get -yq install git curl mysql-client vim nfs-common python3.6

RUN bash -c "$(curl -sL https://wavefront.com/install)" -- install \
    --agent \
    --proxy-address localhost \
    --proxy-port 2878

# Install Python Script for configuring of Wavefront app monitors
COPY script/

# Set entry point
COPY files/entry_point.sh /
RUN chmod 777 /entry_point.sh
ENTRYPOINT [ "/entry_point.sh" ]

CMD [ "bash"]
