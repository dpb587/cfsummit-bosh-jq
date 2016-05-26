FROM alpine

RUN true \
  && apk --no-cache add bash curl \
  && curl -L https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 > /usr/bin/jq \
  && chmod +x /usr/bin/jq
