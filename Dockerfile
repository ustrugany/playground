FROM golang:1.14-alpine

WORKDIR /usr/src/app

ENV CGO_ENABLED 0
ENV GO111MODULE on
ENV GOFLAGS -mod=vendor

# install certificates when needed
RUN apk update && apk add --no-cache curl \
    && apk add --no-cache busybox-extras \
    && apk add --no-cache ca-certificates

RUN go get -u -t github.com/volatiletech/sqlboiler \
    && go get github.com/volatiletech/sqlboiler/drivers/sqlboiler-psql

RUN adduser -D -g '' appuser
RUN mkdir -p /usr/src/app
RUN chown -R appuser:appuser /usr/src/app

COPY . /usr/src/app

USER appuser

CMD ["go", "main.go"]
