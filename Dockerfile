from java:8

ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000

ENV TINI_VERSION=v0.10.0
ENV AQW_PROFILE=production
ENV AQW_THREAD_NUMBER=1
ENV MAVEN_HOME=/apache-maven-3.3.9
ENV PATH=$PATH:$MAVEN_HOME/bin

# install Sox with its libs
RUN \
  apt-get update && \
  apt-get -y install \
          sox libsox-fmt-all

# Install maven
RUN wget http://apache.mindstudios.com/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz && \
    tar -xzf apache-maven-3.3.9-bin.tar.gz

# Jenkins is run with user `jenkins`, uid = 1000
# If you bind mount a volume from the host or a data container, 
# ensure you use the same uid
RUN addgroup --gid ${gid} ${group}
RUN adduser --uid ${uid} --gid ${gid} --shell /bin/bash ${user}

VOLUME /workspace

ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

ADD scripts/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/tini", "--", "/entrypoint.sh"]

