FROM adoptopenjdk/openjdk11:debian

# Setup s6-overlay for container init to supervise multi processes.
ADD https://github.com/just-containers/s6-overlay/releases/download/v2.2.0.1/s6-overlay-amd64-installer /tmp/
RUN chmod +x /tmp/s6-overlay-amd64-installer && /tmp/s6-overlay-amd64-installer /

RUN apt-get update \
  && apt-get upgrade -y \
  && apt-get install -y gpg unzip tini \
  && apt-get install -y procps net-tools \
  && rm -rf /var/lib/apt/lists/*

# Setup yc-agent
RUN mkdir -p /opt/workspace/yc
RUN cd /opt/workspace/yc \
  && curl -fsSL https://tier1app.com/dist/ycrash/yc-agent-latest.zip -o yc-agent-latest.zip \
  && unzip yc-agent-latest.zip \
  && rm yc-agent-latest.zip \
  && chmod +x yc

# Setup buggyapp
RUN mkdir -p /opt/workspace/buggyapp
WORKDIR /opt/workspace/buggyapp

COPY ./services.d /etc/services.d

RUN curl -fsSL https://tier1app.com/dist/buggyapp/buggyapp-latest.zip -o buggyapp-latest.zip \
  && unzip buggyapp-latest.zip \
  && rm buggyapp-latest.zip

# buggyapp
EXPOSE 9010

# yc-agent
EXPOSE 8085

ENTRYPOINT ["/init"]


