FROM gfunk/centos7:latest

#################
# ENV SETTINGS  #
#################
ENV MONGODB_VERSION 3.4.10
ENV MONGODB_URL https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-rhel70-${MONGODB_VERSION}.tgz
ENV MONGODB_GUEST_ID app-user
ENV MONGODB_GUEST_PASS app-pwd
ENV MONGODB_GUEST_DB testdb
ENV MONGODB_ADMIN_ID app-admin
ENV MONGODB_ADMIN_PASS app-admin-pwd
ENV MONGODB_ADMIN_DB admin

##################################################
# - Update system                                #
# - Install system packages [net-tools/tar/wget] #
##################################################
RUN yum -y update && yum -y install \
    epel-release \
    net-tools \
    wget \
    tar && \
    yum clean all

######################################
# - Download and install supervisord #
######################################
RUN yum -y install python-pip && /usr/bin/pip install supervisor && \
    mkdir -p /etc/supervisor/conf.d && mkdir -p /var/log/supervisor

##################################
# - Download and install MongoDB #
##################################
RUN wget ${MONGODB_URL} && \
    tar xzvf mongodb-linux-x86_64-rhel70-${MONGODB_VERSION}.tgz && \
    mv mongodb-linux-x86_64-rhel70-${MONGODB_VERSION}/ /mongodb && \
    mkdir -p /data/db && mkdir -p /data/scripts

######################################
# - Copy required configuration file #
######################################
ADD conf/supervisord.conf /etc/supervisord.conf
ADD scripts/ /data/scripts/
RUN chmod +x /data/scripts/init-mongodb.sh

########################################################
# - Mount required volumes for [supervisor && mongodb] #
########################################################
VOLUME ["/var/log/supervisor"]
VOLUME ["/data"]

##################
# - Init MongoDB #
##################
RUN /data/scripts/init-mongodb.sh

###########################
# - Expose MongoDB ports  #
###########################
EXPOSE 27017 28017

###################
# Run supervisord #
###################
CMD ["/usr/bin/supervisord"]
