#! /bin/bash

# Append Environment Variables to global tags
if [ ! -z $CLUSTER_NAME ]; then
    echo "cluster = \"\$CLUSTER_NAME\"" >> /etc/telegraf/telegraf.d/globaltags.conf
fi

if [ ! -z $NAMESPACE_NAME ]; then
    echo "namespace = \"\$NAMESPACE_NAME\"" >> /etc/telegraf/telegraf.d/globaltags.conf
fi

# Add labels to global tags 
if [ -f /var/podinfo/labels ]; then
    cat /var/podinfo/labels  >> /etc/telegraf/telegraf.d/globaltags.conf
else
    if [ ! -z $APP_NAME ]; then
        echo "app = \"\$APP_NAME\"" >> /etc/telegraf/telegraf.d/globaltags.conf
    fi

    if [ ! -z $APP_TIER ]; then
        echo "tier = \"\$APP_TIER\"" >> /etc/telegraf/telegraf.d/globaltags.conf
    fi
fi

for service in ${SERVICES}; 
do

    case $service in
        mysql)      
            if [ ! -f /etc/telegraf/telegraf.d/mysql.conf ]; then
                echo "enabling ${service}"
                cp /var/telegraf-templates/mysql.conf /etc/telegraf/telegraf.d
            fi
            ;;
        nginx)      
            if [ ! -f /etc/telegraf/telegraf.d/nginx.conf ]; then
                echo "enabling ${service}"
                cp /var/telegraf-templates/nginx.conf /etc/telegraf/telegraf.d
            fi
            ;;
        *)
            echo "${service} is unknown"
            ;;
    esac

done

# Pause for 30 seconds to give the web services time to start
sleep 30

exec "$@"
