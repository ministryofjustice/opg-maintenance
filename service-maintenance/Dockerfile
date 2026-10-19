FROM node:24-alpine@sha256:c921b97d4b74f51744057454b306b418cf693865e73b8100559189605f6955b8 AS asset-env

WORKDIR /app

COPY web/assets web/assets
COPY webpack.config.js .
COPY package.json package-lock.json ./

RUN npm ci && node_modules/.bin/webpack --mode="production"

# Build Go app
FROM golang:1.26-alpine@sha256:c95332c2af86b6d89b91bd0500f4b9529ccbd090a0d1855c6d1ceaa142ae8615 AS build-env

WORKDIR /app

COPY go.mod go.sum ./

RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -o maintenance cmd/maintenance/main.go

# Bundle all
FROM alpine:3.24@sha256:294b683cb724975bec92580e1e685676bd4b50bda910ddb8c51d4cabeaec77e6 AS production

WORKDIR /go/bin

RUN apk --update --no-cache add \
  ca-certificates \
  zlib==1.3.2-r1 \
  && rm -rf /var/cache/apk/*
RUN apk --no-cache add tzdata

COPY --from=build-env /app/maintenance maintenance
COPY --from=build-env /app/web/templates web/templates
COPY --from=asset-env /app/web/static web/static
ENTRYPOINT ["./maintenance"]
