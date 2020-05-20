FROM alpine:latest
RUN apk add --no-cache bash curl jq gettext
RUN curl -L https://storage.googleapis.com/kubernetes-release/release/v1.18.3/bin/linux/amd64/kubectl \
    -o /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl
COPY dj-controller /
COPY template/ /template/
ENTRYPOINT ["/dj-controller"]
