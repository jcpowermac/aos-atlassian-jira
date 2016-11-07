### docker build --pull -t acme/starter-nsswrapper -t acme/starter-nsswrapper:v3.2 .
FROM registry.access.redhat.com/rhel7
MAINTAINER Red Hat Systems Engineering <refarch-feedback@redhat.com>

ENV APPLICATION jira
ENV APPLICATION_HOME /var/atlassian/${APPLICATION}
ENV APPLICATION_INSTALL  /opt/atlassian/${APPLICATION}
ENV APPLICATION_VERSION  7.1.9

### Atomic Labels
### https://github.com/projectatomic/ContainerApplicationGenericLabels
LABEL Name="Jira" \
      Vendor="Atlassian" \
      Version="7.1.9" \
      Release="7" \
      build-date="" \
      url="https://www.atlassian.com/software/jira" \
      summary="Project Management" \
      description="Project Management" \
      RUN='docker run -tdi --name ${NAME} \
      -u 123456 \
      ${IMAGE}' \
      STOP='docker stop ${NAME}'

### OpenShift labels
LABEL io.k8s.description="Starter App will do ....." \
      io.k8s.display-name="Atlassian Jira" \
      io.openshift.expose-services="8080:http,8092:http" \
      io.openshift.tags="jira,AtlassianJira"

### Atomic Help File - Write in Markdown, it will be converted to man format at build time.
### https://github.com/projectatomic/container-best-practices/blob/master/creating/help.adoc
#COPY help.md /

COPY response.varfile  init.yml /tmp/


RUN yum clean all && \
    yum-config-manager --disable \* && \
    yum-config-manager --enable rhel-7-server-rpms && \
    yum-config-manager --enable rhel-7-server-optional-rpms && \
### Add additional Red Hat repos
#    yum-config-manager --enable rhel-server-rhscl-7-rpms && \
    yum -y update-minimal --security --sec-severity=Important --sec-severity=Critical --setopt=tsflags=nodocs && \
### NSS_WRAPPER for arbitrary uid recognition
    yum-config-manager --enable rhel-7-server-ose-3.3-rpms && yum -y install --setopt=tsflags=nodocs nss_wrapper gettext && \
### Add your package needs to this installation line
#    yum -y install --setopt=tsflags=nodocs httpd && \
### help.md conversion
#    yum -y install golang-github-cpuguy83-go-md2man && go-md2man -in help.md -out help.1 && \
#    yum -y remove golang-github-cpuguy83-go-md2man && rm -f help.md && \
### EPEL packages can be installed if necessary but, install non-epel packages before
### adding the EPEL repo so that supported bits are used wherever possible.
#    curl -o epel-release-latest-7.noarch.rpm -SL https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
#            --retry 999 --retry-max-time 0 -C - && \
#    rpm -ivh epel-release-latest-7.noarch.rpm && rm epel-release-latest-7.noarch.rpm && \
#    yum -y install --setopt=tsflags=nodocs jq && \
#    yum-config-manager --disable epel && \
    yum -y install ansible && \
    ansible-playbook /tmp/init.yml -c local -i localhost, \
    --extra-vars "application_install=${APPLICATION_INSTALL} application_version=${APPLICATION_VERSION}" && \
    yum -y erase ansible && \ 
    yum clean all

### Setup the user that is used for the build execution and for the application runtime execution by default.
ENV APP_ROOT=${APPLICATION_HOME} \
    USER_NAME=jira \
    USER_UID=1000
ENV APP_HOME=${APP_ROOT}/src \
    PATH=$PATH:${APP_ROOT}/bin


RUN mkdir -p ${APP_HOME} ${APP_ROOT}/bin && \
#    useradd -l -u ${USER_UID} -r -g 0 -d ${APP_ROOT} -s /sbin/nologin \
#            -c "${USER_NAME} application user" ${USER_NAME} && \

### NSS_WRAPPER for arbitrary uid recognition
    sed "s@${USER_NAME}:x:${USER_UID}:0@${USER_NAME}:x:\${USER_ID}:\${GROUP_ID}@g" /etc/passwd > ${APP_ROOT}/passwd.template && \
    echo $'#!/bin/sh\n\
### nss_wrapper\n\
export USER_ID=$(id -u)\n\
export GROUP_ID=$(id -g)\n\
envsubst < ${APP_ROOT}/passwd.template > /tmp/passwd\n\
export LD_PRELOAD=/usr/lib64/libnss_wrapper.so\n\
export NSS_WRAPPER_PASSWD=/tmp/passwd\n\
export NSS_WRAPPER_GROUP=/etc/group\n\
exec "$@"' > ${APP_ROOT}/bin/nss_entrypoint.sh && \
    cp ${APP_ROOT}/bin/nss_entrypoint.sh ${APP_ROOT}/.profile && \ 
    chmod ug+x ${APP_ROOT}/bin/nss_entrypoint.sh && \
    chown -R ${USER_UID}:0 ${APP_ROOT} && \
    chmod -R g+rw ${APP_ROOT} && \
    find ${APP_ROOT} -type d -exec chmod g+x {} +

### Containers should NOT run as root as a best practice
USER ${USER_UID}
WORKDIR ${APP_ROOT}

RUN echo $'#!/bin/sh\n\
id\n\
whoami\n\
tail -f /dev/null' > ${APP_ROOT}/bin/run.sh && \
    chmod ug+x ${APP_ROOT}/bin/run.sh

VOLUME ${APPLICATION_HOME} ${APPLICATION_INSTALL}/logs
### NSS_WRAPPER for arbitrary uid recognition
ENTRYPOINT [ "nss_entrypoint.sh" ]
EXPOSE 8080 8443
CMD ${APPLICATION_INSTALL}/bin/catalina.sh run 
