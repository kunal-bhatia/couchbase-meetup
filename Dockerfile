FROM gcr.io/distroless/java17-debian11:latest
ARG DEPENDENCY=target
COPY ${DEPENDENCY}/dependency /app/lib
COPY ${DEPENDENCY}/classes /app
ENTRYPOINT ["java","-cp","app:app/lib/*","com.meetup.couchbase.demo.MeetupApplication"]
