FROM centos:centos7

MAINTAINER Jeff Manning

USER root

#install the basic packages
RUN yum clean all && \
    yum -y update && \
    yum clean all
RUN yum install -y tar curl net-tools build-essential git wget zip unzip vim && \
    yum clean all


### Install Java 8
#### Per version variables (Need to find out from http://java.oracle.com site for every update)
ARG JAVA_MAJOR_VERSION=8
ARG JAVA_UPDATE_VERSION=141
ARG JAVA_BUILD_NUMBER=15
ARG JAVA_TOKEN=336fa29ff2bb4ef291e347e091f7f4a7
ARG UPDATE_VERSION=${JAVA_MAJOR_VERSION}u${JAVA_UPDATE_VERSION}
ARG BUILD_VERSION=b${JAVA_BUILD_NUMBER}
ARG JAVA_JDK_HREF_ROOT="http://download.oracle.com/otn-pub/java/jdk/${UPDATE_VERSION}-${BUILD_VERSION}/${JAVA_TOKEN}"

#jdk
ARG JAVA_JDK_DOWNLOAD=jdk-${UPDATE_VERSION}-linux-x64.tar.gz

#jre
ARG JAVA_JRE_DOWNLOAD=server-jre-${UPDATE_VERSION}-linux-x64.tar.gz


ENV JAVA_HOME /usr/jdk1.${JAVA_MAJOR_VERSION}.0_${JAVA_UPDATE_VERSION}

ENV PATH $PATH:$JAVA_HOME/bin

# currently set for jre install
ENV INSTALL_DIR /usr
RUN curl -sL --retry 3 --insecure \
  --header "Cookie: oraclelicense=accept-securebackup-cookie;" \
  "${JAVA_JDK_HREF_ROOT}/${JAVA_JRE_DOWNLOAD}" \
  | gunzip \
  | tar x -C $INSTALL_DIR/ \
  && ln -s $JAVA_HOME $INSTALL_DIR/java \
  && rm -rf $JAVA_HOME/man

#### Install Maven 3
ARG MVN_MAJOR=3
ARG MVN_MINOR=5
ARG MVN_BLD=0
ARG MAVEN_VERSION=${MVN_MAJOR}.${MVN_MINOR}.${MVN_BLD}
ARG MAVEN_REPO=http://archive.apache.org/dist/maven/maven-${MVN_MAJOR}
ENV MAVEN_HOME /usr/apache-maven-${MAVEN_VERSION}
ENV PATH $PATH:$MAVEN_HOME/bin
RUN curl -sL ${MAVEN_REPO}/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
  | gunzip \
  | tar x -C /usr/ \
  && ln -s $MAVEN_HOME /usr/maven

#### define working directory.
RUN mkdir -p /data
COPY . /data

VOLUME "/data"

WORKDIR /data

#### Define default command.
#CMD ["bash"]

