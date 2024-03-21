FROM ubuntu:24.04

RUN apt-get update \
  && apt-get -y install bash curl iptables ca-certificates make net-tools iproute2 docker.io docker-buildx vim rsync \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /shared

COPY entrypoint.sh /bin/entrypoint.sh
RUN chmod +x /bin/entrypoint.sh

# Fix to avoid following error when entrypoint.sh starts dockerd:
# iptables v1.8.10 (nf_tables):  CHAIN_ADD failed (No such file or directory): chain POSTROUTING
RUN update-alternatives --set iptables /usr/sbin/iptables-legacy

ENTRYPOINT ["entrypoint.sh"]
