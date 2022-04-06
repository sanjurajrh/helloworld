FROM registry.access.redhat.com/ubi8/ubi
LABEL description="Custom image fo web"
ENV DOCROOT /var/www/html
RUN yum -y install httpd && yum clean all -y && echo "APACHE rocks" > ${DOCROOT}/index.html
RUN sed -i 's/Listen 80/Listen 8080/g' /etc/httpd/conf/httpd.conf 
EXPOSE 8080
COPY files/do180.html  ${DOCROOT}/do180.html
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
