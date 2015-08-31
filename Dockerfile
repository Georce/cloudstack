FROM centos:6

ADD cloud.repo /etc/yum.repos.d/cloud.repo

RUN yum install -y cloudstack-management

RUN cd /etc/cloudstack/management;     ln -s tomcat6-nonssl.conf tomcat6.conf;     ln -s server-nonssl.xml server.xml;     ln -s log4j-cloud.xml log4j.xml

COPY init.sh /root/init.sh

RUN chmod 755 /root/init.sh

RUN yum clean all

RUN sed -i "s/cluster.node.IP=.*/cluster.node.IP=localhost/" /etc/cloudstack/management/db.properties

EXPOSE 8080 8250 8096 45219 9090 8787

CMD ["/root/init.sh"]
