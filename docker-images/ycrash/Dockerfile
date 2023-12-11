FROM adoptopenjdk/openjdk8:debian-slim

RUN apt-get update \
  && apt-get upgrade -y \
  && apt-get install -y gpg unzip tini \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /opt/workspace/yc
WORKDIR /opt/workspace/yc

RUN curl -fsSL https://tier1app.com/dist/ycrash/yc-latest.zip -o yc-latest.zip && unzip yc-latest.zip && rm yc-latest.zip

EXPOSE 8080

ENTRYPOINT ["/usr/bin/tini", "--", "java", "-Xms2g", "-Xmx4g", "-Dapp=yc", "-DlogDir=.", "-DuploadDir=.", "-jar", "webapp-runner.jar", "-AconnectionTimeout=3600000", "--port", "8080", "yc.war"]


