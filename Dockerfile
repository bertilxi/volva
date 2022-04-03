FROM thevlang/vlang:alpine AS builder

WORKDIR /app

COPY . .

RUN v -prod main.v


FROM alpine

COPY --from=builder /app/main /

CMD ["/main"]
