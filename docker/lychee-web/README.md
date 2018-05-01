# Lychee Web Service Container

For this build I am using the ubuntu core image and then installing the neccessary components to support the Lychee web services including remote database connectivity. This includes:

* PHP
* NGINX
* MySQL Client


![Lychee Kubernetes Manifests](/images/lychee-web-image.gif)

To enable the Lychee services a connection to an external MySQL service is required. The cionnection is established through the assignment of environment variables containing required connectivity information

Variables supported include the following:

* DB_HOST - Name of the service used to expose the MySQL Services
* DB_NAME - Name of the database schema created
* DB_USER - MySQL User account with required permissions to database 
* DB_PASSWORD - MySQL User Account password 
* DB_PREFIX - Optional prefix to add to each table name

For persistance volume mount points are supported for the /Photos directory for image storage and /Config for configuration information

