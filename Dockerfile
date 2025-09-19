# --- build stage ---
FROM golang:1.22-alpine AS builder
WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /bot main.go

# --- run stage ---
FROM gcr.io/distroless/base-debian12
ENV TELEGRAM_TOKEN=""
USER nonroot:nonroot
COPY --from=builder /bot /bot
ENTRYPOINT ["/bot"]