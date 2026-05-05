FROM debian:bullseye-slim

RUN set -eux; \
    groupadd -f video; \
    useradd -m -d /home/vlc -s /bin/bash vlc; \
    usermod -aG video,sudo vlc; \
    mkdir -p /etc/sudoers.d; \
    echo "vlc ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/vlc; \
    chmod 0440 /etc/sudoers.d/vlc

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        python3 \
        python3-scapy \
        vlc \
        sudo \
        tcpdump \
        iproute2 \
        iputils-ping \
        firefox-esr \
        chromium \
        curl \

    && rm -rf /var/lib/apt/lists/*

WORKDIR /home/vlc

COPY --chown=vlc:vlc . /home/vlc

RUN mkdir -p /home/vlc/logs && chmod -R +777 /home/vlc/logs && chmod +x /home/vlc/test-sbrc2026.sh

USER vlc

CMD ["/home/vlc/startup.sh"]