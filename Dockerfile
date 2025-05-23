# Set Initial Arguments
ARG VERSION
ARG DATI

# Set base image
FROM debian:bookworm-slim

# Set container label
LABEL org.opencontainers.image.title="MotionEye Docker Image" \
      org.opencontainers.image.description="Docker image for MotionEye" \
      org.opencontainers.image.documentation="https://github.com/dontobi/MotionEye.rpi#readme" \
      org.opencontainers.image.authors="Tobias Schug <github@myhome.zone>" \
      org.opencontainers.image.url="https://github.com/dontobi/MotionEye.rpi" \
      org.opencontainers.image.source="https://github.com/dontobi/MotionEye.rpi" \
      org.opencontainers.image.base.name="docker.io/library/debian:bookworm-slim" \
      org.opencontainers.image.version="${VERSION}" \
      org.opencontainers.image.created="${DATI}"

# Set Arguments
ARG RUN_UID=0
ARG RUN_GID=0

# Set Variables
ENV TZ="Europe/Berlin"

# Building
WORKDIR /tmp
RUN printf '%b' '[global]\nbreak-system-packages=true\n' > /etc/pip.conf && \
    case "$(dpkg --print-architecture)" in \
      'armhf') PACKAGES='python3-dev gcc libjpeg62-turbo-dev'; printf '%b' 'extra-index-url=https://www.piwheels.org/simple/\n' >> /etc/pip.conf;; \
      *) PACKAGES='python3-dev gcc libcurl4-openssl-dev libssl-dev';; \
    esac \
    && apt-get -q update && DEBIAN_FRONTEND="noninteractive" apt-get -qq --option Dpkg::Options::="--force-confnew" --no-install-recommends install \
      ca-certificates curl fdisk ffmpeg git python3 samba samba-common-bin tzdata v4l-utils $PACKAGES \
    && git clone -b beta https://github.com/motioneye-project/motioneye \
    && cp /tmp/motioneye/docker/entrypoint.sh /entrypoint.sh \
    && curl -sSfO 'https://bootstrap.pypa.io/get-pip.py' \
    && python3 get-pip.py \
    && python3 -m pip install --no-cache-dir --upgrade pip setuptools wheel \
    && python3 -m pip install --no-cache-dir /tmp/motioneye \
    && motioneye_init --skip-systemd --skip-apt-update \
    && sed -i "s/^\(motion:[^:]*\):[0-9]*:[0-9]*:\(.*\)/\1:${RUN_UID}:${RUN_GID}:\2/" /etc/passwd \
    && sed -i "s/^\(motion:[^:]*\):[0-9]*:\(.*\)/\1:${RUN_GID}:\2/" /etc/group \
    && mv /etc/motioneye/motioneye.conf /etc/motioneye.conf.sample \
    && mkdir /var/log/motioneye /var/lib/motioneye \
    && chown motion:motion /var/log/motioneye /var/lib/motioneye \
    && python3 -m pip uninstall -y pip setuptools wheel \
    && DEBIAN_FRONTEND="noninteractive" apt-get -qq autopurge $PACKAGES \
    && apt-get autoremove --yes && apt-get --yes clean \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/*.bin /tmp/* /tmp/.[!.]* get-pip.py /root/.cache

# Set Volumes
VOLUME [ "/etc/motioneye", "/var/lib/motioneye" ]

# Set Ports
EXPOSE 8765

# Entrypoint
ENTRYPOINT ["/entrypoint.sh"]