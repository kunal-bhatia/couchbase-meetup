# couchbase-meetup
This is a demo application to startup a simple spring boot application connecting to couchbase and exposing few api resources to access the data. 
Application uses spring data couchbase to leverage the CRUD opertions via CRUD respository.

Pre-requisites:-

Only pre-requisite is having docker running on the machine and rest all magic happens :)

Build the application

```mvn clean install```

Build docker image (will be stored in local docker repository)

```docker build -t couchbase-meetup .```

Running couchbase and app (will provision couchbase and start the spring boot app with default data inserted as json documents)

```./runApp.sh```

Access the couchbase admin ui with http://localhost:8091 in the browser with credentials 
as stated in docker-compose for couchbase image with env variables COUCHBASE_ADMINISTRATOR_USERNAME and COUCHBASE_ADMINISTRATOR_PASSWORD

Start up some load

```docker-compose up generator```

Add some chaos

```docker-compose up pumba-corrupt```
