# Build stage
FROM golang:1.16.6-alpine3.14 AS build-env
ARG PLUGIN_PATH=github.com/nokia/CPU-Pooler

RUN apk add curl git
WORKDIR ${GOPATH}/src/${PLUGIN_PATH}
ADD go.* ./
RUN go mod download
ADD . ./
ENV CGO_ENABLED=0
ENV GOOS=linux
RUN go build -a -ldflags '-extldflags "-static"' -o cpu-device-plugin ${PLUGIN_PATH}/cmd/cpu-device-plugin \
  && go build -a -ldflags '-extldflags "-static"' -o cpusetter ${PLUGIN_PATH}/cmd/cpusetter \
  && go build -a -ldflags '-extldflags "-static"' -o cpu-device-webhook ${PLUGIN_PATH}/cmd/webhook \
  && go build -a -ldflags '-extldflags "-static"' ${PLUGIN_PATH}/cmd/process-starter


# Final image creation
FROM alpine:latest
FROM scratch
ARG PLUGIN_PATH=github.com/nokia/CPU-Pooler

RUN apk add --no-cache util-linux

COPY --from=build-env /go/src/${PLUGIN_PATH}/cpusetter /
COPY --from=build-env /go/src/${PLUGIN_PATH}/cpu-device-plugin /
COPY --from=build-env /go/src/${PLUGIN_PATH}/cpu-device-webhook /
COPY --from=build-env /go/src/${PLUGIN_PATH}/process-starter /
