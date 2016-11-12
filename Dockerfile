FROM tomcat
MAINTAINER info.inspectit@novatec-gmbh.de

# set Workdir
WORKDIR /opt

# set insepctit env options
ENV INSPECTIT_VERSION 1.7.4.87
ENV INSPECTIT_AGENT_HOME /opt/agent

# get inspectit binary
# set inspectit jvm options
RUN apt-get purge openjdk* -y \
 && echo "deb http://ftp.de.debian.org/debian jessie-backports main" >> /etc/apt/sources.list \
 && apt-get update \
 && apt-get install -y openjdk-7-jre-headless="7u111-2.6.7-2~deb8u1" libcurl3 tar \
 && rm -rf /var/lib/apt/lists/*
RUN  wget --no-check-certificate https://github.com/inspectIT/inspectIT/releases/download/${INSPECTIT_VERSION}/inspectit-agent-java6-${INSPECTIT_VERSION}.zip \
 && unzip inspectit-agent-java6-${INSPECTIT_VERSION}.zip \
 && rm -f inspectit-agent-java6-${INSPECTIT_VERSION}.zip \
 && sed -i '250i\'"export INSPECTIT_JAVA_OPTS=\"-javaagent:${INSPECTIT_AGENT_HOME}/inspectit-agent.jar -Dinspectit.repository=_CMR_ADDRESS_:_CMR_PORT_ -Dinspectit.agent.name=_AGENT_NAME_\"" /usr/local/tomcat/bin/catalina.sh \
 && sed -i '251i\'"export JAVA_OPTS=\"\${INSPECTIT_JAVA_OPTS} \${JAVA_OPTS}\"" /usr/local/tomcat/bin/catalina.sh

RUN apt-get -y remove --purge curl libcurl3

# copy start script
COPY run-with-inspectit.sh /run-with-inspectit.sh

# define default command
CMD ["/run-with-inspectit.sh", "run"]
