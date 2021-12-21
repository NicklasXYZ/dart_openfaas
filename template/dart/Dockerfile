# Use latest stable channel Dart SDK
FROM dart:stable AS build

MAINTAINER NicklasXYZ

# Resolve app dependencies
WORKDIR /app

# Copy app source code (except anything in .dockerignore) and AOT compile app
COPY . .
RUN dart pub get && dart compile exe bin/server.dart -o bin/server

FROM openfaas/of-watchdog:0.8.2 as watchdog

# Final build stage
FROM alpine:3.15 AS app

# Copy in the function watchdog
COPY --from=watchdog /fwatchdog /usr/bin/fwatchdog

COPY --from=build /runtime/ /
COPY --from=build /app/bin/server /app/bin/

# Make the function watchdog executable
RUN chmod +x /usr/bin/fwatchdog && chmod +x /app/bin

# Add non root user
RUN addgroup -S app && adduser -S -g app app \
    && mkdir -p /app \
    && chown -R app /app

USER app

ENV PORT 8000
EXPOSE 8080

ENV fprocess="/app/bin/server"
ENV mode="http"
ENV upstream_url="http://127.0.0.1:8000"

HEALTHCHECK --interval=3s CMD [ -e /tmp/.lock ] || exit 1

CMD ["fwatchdog"]