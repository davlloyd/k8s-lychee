# Lychee's Journey To Cloud Native

## Overview
Kubernetes demo using Tobias Reich's pretty Lychee photo app  [Lychee Site](https://github.com/electerious/Lychee)

### Purpose
The core goal of this project is to demonstrate the transitioning of an application from a monolith to one aligned to Cloud Native principles (well as close as we can get anyway). The app in its simplest form comprises a web service (NGINX), application runtime (PHP) and database (MySQL) which by default are all  hosted within the same installation. 
At the conclusion of the exercise the end state needs to be supportative of a true scale-out, resilient service structure. Any service state needs to be removed from the instances themselves ensuring that any failure or scale (in or out) based operations do not impact the service operations.

This process is occuring in mulitple phases as listed below:

* Step 1: Service repackaging, the repackaging of the application into a container image and provide the seperation of the frontend (web) and backend (database) services. It will also be supportive of external definition of configuration services troug supporting configuration through environment variables as requird. Package is contained in the /docker directory

* Step 2: Create manifests to create the service within a Kubernetes environment (focused on Pivotal Container Services / PKS) to support the hosting of the service, provide scaling, update, resilience and configuration management

* Step 3: Identify constraints in current application architecture

* Step 4: Application refactoring for web front end to cater for changes to support scale-out. This will require the moving of the photo image repository from a local based storage model

* Step 5: Applicatioom refactoring to support scale-out data services as alternate to MySQL


### Lychee Web Server
Lychee friont end uses local based storage for image storing. with the use of PVCs in K8s this has been seperated from the image so that it can be shared between containers but need to look at externalising the repository with a file or object store

### Lychee Database
Current support is for MySQL but under review to ascetain effort to bring in support of a scale-out data service. Preference is towards MongoDB but Cassandra maybe closer to the current SQL syntax defined within the PHP code in /php/Modules/database.php and /php/database/*
Currently as a place holder the MySQL K8s section uses a deployment manifest to create a ReplicaSet for the  MySQL container. Going forward with either MoingoDb or Cassandra this will be changed to a StatefulSet to ensure indentity retention and predicatability as is required when creating a cluster service automatically

## K8s Configuration
The various components have been broken up to support the hosting of Lychee in Kubernetes with a favourtism towards the services of PKS. This is notable in configuration points such as:

* Services uses type 'LoadBalancer' with the expetation NSX-T will provide the session pinning for web service access
* Pods are pinned via labelling to particular nodes due to the PVS support of acceess type *ReadWriteOnce* wic only allows one node to ave bot read and write access to PersistantVolume at a time (e.g. Photo storage volume)
* Storage Class needs to be created and defined in PVCs to reflect storage capability required


![Lychee Kubernetes Manifests](/images/lychee-k8s-structure.png)


When applying manifests apply in a bottom up order with *kubectl create -f <filename>* for inital creation and with _kubectl apply -f <filename>_ for any updates to be applied such as for instance changes

**ConfigMap/Secret -> PVCs -> Database Deployment -> Database Service -> Web Deployment -> Web Service**