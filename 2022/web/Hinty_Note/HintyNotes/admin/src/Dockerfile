FROM golang:1.16-alpine

RUN apk add build-base

WORKDIR /app

COPY app/ ./

RUN go mod download

EXPOSE 2222

CMD ["go","run","note_app.go"]