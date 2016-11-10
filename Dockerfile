### docker build --pull -t acme/starter-nsswrapper -t acme/starter-nsswrapper:v3.2 .
FROM registry.access.redhat.com/rhel7
MAINTAINER Red Hat Systems Engineering <refarch-feedback@redhat.com>

ENV APPLICATION jira 
ENV APPLICATION_HOME=/var/atlassian/${APPLICATION} \
    APPLICATION_INSTALL=/opt/atlassian/${APPLICATION} \
    APPLICATION_VERSION=7.1.9

### Atomic Labels
### https://github.com/projectatomic/ContainerApplicationGenericLabels
LABEL Name="Jira" \
      Vendor="Atlassian" \
      Version="7.1.9" \
      Release="7" \
      build-date="" \
      url="https://www.atlassian.com/software/jira" \
      summary="Agile Project Management Software" \
      description="Agile Project Management Software" \
      RUN='docker run -tdi --name ${NAME} \
      -u 123456 \
      ${IMAGE}' \
      STOP='docker stop ${NAME}'\
      io.k8s.description="Agile Project Management Software" \
      io.k8s.display-name="Atlassian Jira" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="jira,AtlassianJira"

### Atomic Help File - Write in Markdown, it will be converted to man format at build time.
### https://github.com/projectatomic/container-best-practices/blob/master/creating/help.adoc

COPY help.md user_setup response.varfile init.yml /tmp/
COPY nss_entrypoint /

### This is just an example of using Ansible within a Dockerfile.  This is not meant to be a best
### practice.

RUN yum clean all && \
    yum -y install --disablerepo "*" \
                   --enablerepo rhel-7-server-rpms,rhel-7-server-optional-rpms,rhel-7-server-ose-3.3-rpms \
                   --setopt=tsflags=nodocs ansible && \
    ansible-playbook /tmp/init.yml -c local -i localhost, \
                   --extra-vars "application_install=${APPLICATION_INSTALL} application_version=${APPLICATION_VERSION}" && \
    yum -y erase ansible && \ 
    yum -y autoremove && \
    yum clean all

### Setup the user that is used for the build execution and for the application runtime execution by default.
ENV APP_ROOT=${APPLICATION_INSTALL} \
    USER_NAME=jira \
    USER_UID=1000
ENV APP_HOME=${APPLICATION_HOME} PATH=$PATH:${APP_ROOT}/bin
RUN mkdir -p ${APP_ROOT}/etc
COPY bin/ ${APP_ROOT}/bin/
RUN chmod -R ug+x ${APP_ROOT}/bin ${APP_ROOT}/etc/ /tmp/user_setup && \
    /tmp/user_setup


### NSS_WRAPPER for arbitrary uid recognition

### Containers should NOT run as root as a best practice
USER ${USER_UID}
WORKDIR ${APP_ROOT}

RUN sed "s@${USER_NAME}:x:${USER_UID}:0@${USER_NAME}:x:\${USER_ID}:\${GROUP_ID}@g" /etc/passwd > ${APP_ROOT}/etc/passwd.template
VOLUME ${APPLICATION_HOME} ${APPLICATION_INSTALL}/logs
### NSS_WRAPPER for arbitrary uid recognition
ENTRYPOINT [ "nss_entrypoint" ]
EXPOSE 8080
CMD ${APPLICATION_INSTALL}/bin/catalina.sh run 
