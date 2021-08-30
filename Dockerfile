FROM debian:bullseye-slim
MAINTAINER dontobi <github@myhome.zone>
LABEL org.opencontainers.image.title="MotionEye Docker Image" \
      org.opencontainers.image.description="Docker image for MotionEye" \
      org.opencontainers.image.authors="github@myhome.zone" \
      org.opencontainers.image.url="https://github.com/dontobi/MotionEye.rpi" \
      org.opencontainers.image.version="${VERSION}"

# Set Volumes
VOLUME [ "/etc/motioneye", "/var/lib/motioneye" ]

# Set Variables
ENV TZ="Europe/Berlin" \
    UID="1000" \
    GID="1000"

# Building
ARG MOTIONEYE_VERSION=0.42.1
WORKDIR /tmp
RUN echo "deb http://http.us.debian.org/debian sid main contrib non-free" >>/etc/apt/sources.list \
    && apt-get update && apt-get upgrade -y \
    && apt-get --yes --option Dpkg::Options::="--force-confnew" --no-install-recommends install \
    curl libmicrohttpd12 libpq5 lsb-release mosquitto-clients python3-jinja2 python3-pil python3-pip \
    python3-pycurl python3-setuptools python3-six python3-tornado python3-tz python3-wheel tzdata \
    && apt-get -t sid --yes --option Dpkg::Options::="--force-confnew" --no-install-recommends install \
    ffmpeg libmysqlclient21 motion samba samba-common-bin v4l-utils \
    && sed -i -e "s/^\(motion:[^:]*\):[0-9]*:[0-9]*:\(.*\)/\1:${UID}:${GID}:\2/" /etc/passwd \
    && sed -i -e "s/^\(motion:[^:]*\):[0-9]*:\(.*\)/\1:${GID}:\2/" /etc/group \
    && pip install "motioneye==${MOTIONEYE_VERSION}" \
    && mkdir -p /etc/motioneye && mkdir -p /var/lib/motioneye \
    && cp /usr/local/share/motioneye/extra/motioneye.conf.sample /etc/motioneye/motioneye.conf \
    && cp /usr/local/share/motioneye/extra/motioneye.systemd-unit-local /etc/systemd/system/motioneye.service \
    && apt-get purge --yes python3-pip python3-setuptools python3-wheel \
    && apt-get autoremove --yes && apt-get --yes clean \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/*.bin /tmp/* /tmp/.[!.]*

# Set Ports
EXPOSE 8765

# Entrypoint
CMD test -e /etc/motioneye/motioneye.conf || \
    cp /usr/local/share/motioneye/extra/motioneye.conf.sample /etc/motioneye/motioneye.conf ; \
    chown motion:motion /var/run /var/log /etc/motioneye /var/lib/motioneye /usr/local/share/motioneye/extra ; \
    su -g motion motion -s /bin/bash -c "/usr/local/bin/meyectl startserver -c /etc/motioneye/motioneye.conf"
