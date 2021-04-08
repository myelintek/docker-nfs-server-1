FROM alpine:latest
LABEL maintainer "Simon Chuang <simon@myelintek.com>"
LABEL source "https://github.com/myelintek/docker-nfs-server-1"

RUN apk add --no-cache --update --verbose bash iproute2 nfs-utils && \
    rm -rf /etc/idmapd.conf /etc/exports && \
    mkdir -p /var/lib/nfs/rpc_pipefs && \
    mkdir -p /var/lib/nfs/v4recovery && \
    echo "rpc_pipefs  /var/lib/nfs/rpc_pipefs  rpc_pipefs  defaults  0  0" >> /etc/fstab && \
    echo "nfsd        /proc/fs/nfsd            nfsd        defaults  0  0" >> /etc/fstab

EXPOSE 2049
VOLUME ["/mnt", "/srv"]

COPY ./nfsd.sh /usr/local/bin
ADD etc/exports.txt /etc/exports
ADD etc/exports.txt /etc/exports.txt

RUN chmod +x /usr/local/bin/nfsd.sh

ENTRYPOINT ["/usr/local/bin/nfsd.sh"]
