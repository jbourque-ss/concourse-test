FROM python:3.11-alpine

RUN apk --no-cache add curl

CMD ["sh", "-c", "while sleep 1; do curl http://component-a:8000; done"]
