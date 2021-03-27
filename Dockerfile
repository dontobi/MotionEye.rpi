FROM balenalib/armv7hf-debian:buster-run
MAINTAINER dontobi <github@myhome.zone>

# QEMU for ARM to build ARM image on X86 machine
RUN ["cross-build-start"]

# Set Volumes
VOLUME [ "/etc/motioneye", "/var/lib/motioneye" ]

# Set Variables
ENV TZ="Europe/Berlin" \
    UID="1000" \
    GID="1000"

# Building
ARG MOTIONEYE_VERSION=0.42.1
WORKDIR /tmp
RUN echo "deb http://snapshot.debian.org/archive/debian/$(date +%Y%m%d) sid main contrib non-free" >>/etc/apt/sources.list \
    && apt-get update && apt-get upgrade -y \
    && apt-get -t stable --yes --option Dpkg::Options::="--force-confnew" --no-install-recommends install \
    curl libmicrohttpd12 libpq5 lsb-release mosquitto-clients python-jinja2 python-pil python-pip python-pip-whl python-pycurl python-setuptools python-tornado python-tz python-wheel tzdata \
    && apt-get -t sid --yes --option Dpkg::Options::="--force-confnew" --no-install-recommends install \
    ffmpeg libmysqlclient21 motion v4l-utils \
    && sed -i -e "s/^\(motion:[^:]*\):[0-9]*:[0-9]*:\(.*\)/\1:${UID}:${GID}:\2/" /etc/passwd \
    && sed -i -e "s/^\(motion:[^:]*\):[0-9]*:\(.*\)/\1:${GID}:\2/" /etc/group \
    && pip install "motioneye==${MOTIONEYE_VERSION}"  \
	&& mkdir -p /etc/motioneye && mkdir -p /var/lib/motioneye \
	&& cp /usr/local/share/motioneye/extra/motioneye.conf.sample /etc/motioneye/motioneye.conf \
	&& cp /usr/local/share/motioneye/extra/motioneye.systemd-unit-local /etc/systemd/system/motioneye.service \
    && apt-get purge --yes python-setuptools python-wheel && apt-get autoremove --yes && apt-get --yes clean \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/*.bin /tmp/* /tmp/.[!.]*

# Healthcheck
HEALTHCHECK --interval=1m --timeout=10s CMD nc -z localhost 8765 || exit 1

# Set Ports
EXPOSE 8765

# Entrypoint
CMD test -e /etc/motioneye/motioneye.conf || \
    cp /usr/local/share/motioneye/extra/motioneye.conf.sample /etc/motioneye/motioneye.conf ; \
    chown motion:motion /var/run /var/log /etc/motioneye /var/lib/motioneye /usr/local/share/motioneye/extra ; \
    su -g motion motion -s /bin/bash -c "/usr/local/bin/meyectl startserver -c /etc/motioneye/motioneye.conf"

# QEMU for ARM to build ARM image on X86 machine
RUN ["cross-build-end"]