ARG KUBECTL_VERSION="v1.30.3"
ARG ADNANH_WEBHOOK_VERSION="2.8.1"


FROM ubuntu:22.04

# this sets again as env var and falls back to values defined above
ARG KUBECTL_VERSION
ARG ADNANH_WEBHOOK_VERSION

WORKDIR /tmp
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
    && curl -LO https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl \
    && mv kubectl /usr/bin \
    && chmod +x /usr/bin/kubectl \
    && kubectl version --client=true \
    && curl -LO https://github.com/adnanh/webhook/releases/download/${ADNANH_WEBHOOK_VERSION}/webhook-linux-amd64.tar.gz \
    && tar -zxf webhook-linux-amd64.tar.gz \
    && mv webhook-linux-amd64/webhook /usr/bin/webhook \
    && chmod +x /usr/bin/webhook \
    && webhook --version \
    && rm -rf /var/cache/apt

ENTRYPOINT [ "webhook" ]