FROM centos:7
LABEL maintainer="Nils Knappmeier <nknappmeier@i-views.com>" \
      org.label-schema.vcs-url="${VCS_URL}"

# Install 
# - curl for downloading nodejs 
# - nodejs, because we sometimes use node-easy-rpm
# - rpmbuild for building rpms
# - gosu for changing the users in the entrypoint (see https://github.com/tianon/gosu#gosu for details)
# - yarn as an alternative to npm
# Add user for running the build 
#    (the change-user can be overridden by specifying a custom entrypoint in .gitlab-ci.yml
#     https://docs.gitlab.com/ee/ci/docker/using_docker_images.html#overriding-the-entrypoint-of-an-image)  
RUN yum -y install curl && \ 
        curl --silent --location https://rpm.nodesource.com/setup_8.x | bash - && \ 
        yum -y install nodejs rpm-build && \
        yum clean all && \     
        npm install -g yarn && \
        curl --silent --location -o /usr/local/bin/gosu https://github.com/tianon/gosu/releases/download/1.10/gosu-amd64 && \
        chmod a+x /usr/local/bin/gosu && \ 
        useradd -ms /bin/bash user 

COPY docker/entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh  

ENTRYPOINT ["/entrypoint.sh"]
