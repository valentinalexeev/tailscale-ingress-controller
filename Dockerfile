FROM golang:1.24-alpine as builder

RUN apk add --update \
    ca-certificates \
    git \
  && rm -rf /var/cache/apk/*

ENV CGO_ENABLED=0
WORKDIR /go/src/github.com/valentinalexeev/tailscale-ingress-controller
COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN go install .

FROM scratch

COPY --from=builder /go/bin/tailscale-ingress-controller /bin/tailscale-ingress-controller
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt

CMD ["/bin/tailscale-ingress-controller"]
