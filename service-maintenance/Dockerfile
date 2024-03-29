FROM node:20-alpine as asset-env

WORKDIR /app

COPY web/assets web/assets
COPY webpack.config.js .
COPY package.json package-lock.json ./

RUN npm ci && node_modules/.bin/webpack -p

# Build Go app
FROM golang:1.18-alpine as build-env

WORKDIR /app

COPY go.mod go.sum ./

RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -o maintenance cmd/maintenance/main.go

# Bundle all
FROM alpine:3 as production

WORKDIR /go/bin

RUN apk --update --no-cache add \
  ca-certificates \
  && rm -rf /var/cache/apk/*
RUN apk --no-cache add tzdata

COPY --from=build-env /app/maintenance maintenance
COPY --from=build-env /app/web/templates web/templates
COPY --from=asset-env /app/web/static web/static
ENTRYPOINT ["./maintenance"]
